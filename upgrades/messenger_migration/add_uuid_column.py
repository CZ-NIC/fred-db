#!/usr/bin/env python3
import psycopg2
import argparse
import logging
import time
import datetime
import multiprocessing

class Progress:
    def __init__(self, rows_done, rows_total):
        self.rows_done = rows_done
        self._rows_total = rows_total
        self._last_recalculation = self.percent_done

    @property
    def rows_total(self):
        return self._rows_total

    @property
    def rows_todo(self):
        return self.rows_total - self.rows_done

    @property
    def last_recalculation(self):
        return self._last_recalculation

    @property
    def percent_done(self):
        return (self.rows_done * 100) / float(self.rows_total)


def recalculate(cursor, table_name, column_name, log):
    log.info('rows todo recalculation...')
    cursor.execute('SELECT {column} IS NOT NULL AS is_done, count(*) FROM {table} GROUP BY 1'.format(table=table_name, column=column_name))
    log.info('...done')
    rows_done = rows_todo = 0
    for row in cursor.fetchall():
        is_done, count = row
        if is_done:
            rows_done = count
        else:
            rows_todo = count
    return Progress(rows_done, rows_done + rows_todo)


class TimeEstimate:
    def __init__(self):
        self._time_done = datetime.timedelta(seconds=0)
        self._iterations = 0

    @property
    def time_done(self):
        return self._time_done

    def add(self, seconds):
        self._time_done += seconds
        self._iterations += 1

    def time_left(self, progress, chunk):
        return (progress.rows_todo / chunk) * (self._time_done / self._iterations)


class TimeMeasureCursor:
    def __init__(self, cursor, log=None):
        self.cursor = cursor
        self.log = log
        self.last_query_took = datetime.timedelta(seconds=0)

    def execute(self, sql, msg=None):
        start = time.time()
        if self.log and msg:
            self.log.info('%s - started at %s', msg, datetime.datetime.now())
        self.cursor.execute(sql)
        self.last_query_took = datetime.timedelta(seconds=time.time() - start)
        if self.log and msg:
            self.log.info('%s - took %s', msg, self.last_query_took)


def add_uuid_column_impl(dsn, table_name, column_name, chunk_size, log, no_vacuum, no_final_constraint):
    log.info('migration started')

    conn = psycopg2.connect(dsn=dsn)
    conn.autocommit = True
    cursor = conn.cursor()

    cursor.execute('ALTER TABLE {table} ADD COLUMN IF NOT EXISTS {column} UUID'.format(table=table_name, column=column_name))
    log.info('uuid column created')
    cursor.execute('CREATE UNIQUE INDEX CONCURRENTLY IF NOT EXISTS {table}_{column}_idx ON {table} ({column})'.format(table=table_name, column=column_name))
    log.info('uuid unique index created')

    progress = recalculate(cursor, table_name, column_name, log)

    time_est = TimeEstimate()
    time_cursor = TimeMeasureCursor(cursor, log)
    while True:
        time_cursor.execute(
            'UPDATE {table} SET {column} = gen_random_uuid()' \
            ' WHERE id IN (SELECT id FROM {table} WHERE {column} IS NULL' \
            ' LIMIT {limit} FOR UPDATE SKIP LOCKED)'.format(table=table_name, column=column_name, limit=chunk_size)
        )
        if cursor.rowcount < chunk_size:
            break

        progress.rows_done += cursor.rowcount
        time_est.add(time_cursor.last_query_took)

        if progress.rows_done % (10 * chunk_size) == 0:
            log.info('update at {:.2f}% -- elapsed: {}  estimated: {}  (rows: {:,}/{:,})'.format(
                progress.percent_done,
                str(time_est.time_done).split('.')[0],
                str(time_est.time_left(progress, chunk_size)).split('.')[0],
                progress.rows_done, progress.rows_total
            ))

        if (progress.last_recalculation + 5 < progress.percent_done) or progress.percent_done > 100:
            progress = recalculate(cursor, table_name, column_name, log)

    if not no_vacuum:
        time_cursor.execute('VACUUM {table}'.format(table=table_name), msg='{table} vacuum'.format(table=table_name))

    if not no_final_constraint:
        time_cursor.execute(
            'ALTER TABLE {table} ALTER COLUMN {column} SET DEFAULT gen_random_uuid()'.format(table=table_name, column=column_name),
            msg='{table}.{column} set default'.format(table=table_name, column=column_name)
        )

        conn.autocommit = False
        tx_cursor = TimeMeasureCursor(conn.cursor(), log)
        tx_cursor.execute(
            'UPDATE {table} SET {column} = gen_random_uuid() WHERE {column} IS NULL'.format(table=table_name, column=column_name),
            msg='update {table} leftovers'.format(table=table_name)
        )
        tx_cursor.execute(
            'ALTER TABLE {table} ALTER COLUMN {column} SET NOT NULL'.format(table=table_name, column=column_name),
            msg='{table}.{column} set not null'.format(table=table_name, column=column_name)
        )
        conn.commit()
        log.info('migration finished')
    else:
        log.info('migration finished without creating final column contraints - rerun without this option to finalize')


def run():
    try:
        logging.basicConfig(level=logging.DEBUG)

        parser = argparse.ArgumentParser(description="Add uuid column to table without full table lock (new uuid values are done by chunk updates)")
        parser.add_argument('--db-host', required=True, help='database hostname')
        parser.add_argument('--db-port', default=5432, type=int, help='database port')
        parser.add_argument('--db-user', default='fred', help='database user')
        parser.add_argument('--db-name', default='fred', help='database name')
        parser.add_argument('--db-pass', default=None, help='database password')
        parser.add_argument('--table-name', required=True, action='append', help='table name where to add uuid column')
        parser.add_argument('--column-name', required=True, action='append', help='name of column to add')
        parser.add_argument('--chunk-size', default=2000, type=int, help='number of rows to update in one chunk')
        parser.add_argument('--no-vacuum', default=False, action='store_true',
            help='Do not run VACUUM command after table chunked UPDATE')
        parser.add_argument('--no-final-constraint', default=False, action='store_true',
            help='Do not create final uuid column constraint - NOT NULL and DEFAULT value')

        args = parser.parse_args()

        if len(args.table_name) > 1:
            parser.error("--table-name can be specified only once")
        if len(args.column_name) > 1:
            parser.error("--column-name can be specified only once")

        args.table_name = args.table_name.pop()
        args.column_name = args.column_name.pop()

        db_params = {
            'host': args.db_host,
            'port': args.db_port,
            'user': args.db_user,
            'dbname': args.db_name,
            'password': args.db_pass
        }

        dsn = ' '.join(['='.join((key, str(value))) for key, value in db_params.items() if value])

        add_uuid_column_impl(
            dsn, args.table_name, args.column_name, args.chunk_size, logging.getLogger('table::{}'.format(args.table_name)),
            no_vacuum=args.no_vacuum, no_final_constraint=args.no_final_constraint
        )
    except KeyboardInterrupt:
        pass


if __name__ == '__main__':
    run()
