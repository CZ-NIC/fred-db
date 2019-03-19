#!/usr/bin/env python
import psycopg2
import argparse
import logging
import time
import datetime
import multiprocessing

class Progress(object):
    def __init__(self, rows_done, rows_todo):
        self.rows_done = rows_done
        self.rows_total = rows_todo + rows_done
        self.last_recalculation = self.percent_done

    @property
    def rows_todo(self):
        return self.rows_total - self.rows_done

    @property
    def percent_done(self):
        return (self.rows_done * 100) / float(self.rows_total)


def recalculate(cursor, table_name, log):
    log.info('rows todo recalculation...')
    cursor.execute('SELECT uuid IS NOT NULL AS is_done, count(*) FROM {table} GROUP BY 1'.format(table=table_name))
    log.info('...done')
    rows_done = rows_todo = 0
    for row in cursor.fetchall():
        is_done, count = row
        if is_done:
            rows_done = count
        else:
            rows_todo = count
    return Progress(rows_done, rows_todo)


class TimeEstimate(object):
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


class TimeMeasureCursor(object):
    def __init__(self, cursor, log=None):
        self.cursor = cursor
        self.log = log
        self.last_query_took = datetime.timedelta(seconds=0)

    def execute(self, sql, msg=None):
        start = time.time()
        if self.log and msg:
            self.log.info('{msg} - started at {now}'.format(msg=msg, now=datetime.datetime.now()))
        self.cursor.execute(sql)
        self.last_query_took = datetime.timedelta(seconds=time.time() - start)
        if self.log and msg:
            self.log.info('{msg} - took {duration}'.format(msg=msg, duration=self.last_query_took))


def add_uuid_column_impl(dsn, table_name, chunk, log, no_vacuum, no_final_constraint):
    log.info('migration started')

    conn = psycopg2.connect(dsn=dsn)
    conn.autocommit = True
    cursor = conn.cursor()

    cursor.execute('ALTER TABLE {table} ADD COLUMN IF NOT EXISTS uuid UUID'.format(table=table_name))
    log.info('uuid column created')
    cursor.execute('CREATE UNIQUE INDEX CONCURRENTLY IF NOT EXISTS {table}_uuid_idx ON {table} (uuid)'.format(table=table_name))
    log.info('uuid unique index created')

    progress = recalculate(cursor, table_name, log)

    time_est = TimeEstimate()
    time_cursor = TimeMeasureCursor(cursor, log)
    while True:
        time_cursor.execute(
            'UPDATE {table} SET uuid = gen_random_uuid()' \
            ' WHERE id IN (SELECT id FROM {table} WHERE uuid IS NULL' \
            ' LIMIT {limit} FOR UPDATE SKIP LOCKED)'.format(table=table_name, limit=chunk)
        )
        if cursor.rowcount < chunk:
            break

        progress.rows_done += cursor.rowcount
        time_est.add(time_cursor.last_query_took)

        if progress.rows_done % (10 * chunk) == 0:
            log.info('update at {:.2f}% -- elapsed: {}  estimated: {}  (rows: {:,}/{:,})'.format(
                progress.percent_done,
                str(time_est.time_done).split('.')[0],
                str(time_est.time_left(progress, chunk)).split('.')[0],
                progress.rows_done, progress.rows_total
            ))

        if (progress.last_recalculation + 5 < progress.percent_done) or progress.percent_done > 100:
            progress = recalculate(cursor, table_name, log)

    if not no_vacuum:
        time_cursor.execute('VACUUM {table}'.format(table=table_name), msg='{table} vacuum'.format(table=table_name))

    if not no_final_constraint:
        time_cursor.execute(
            'ALTER TABLE {table} ALTER COLUMN uuid SET DEFAULT gen_random_uuid()'.format(table=table_name),
            msg='{table}.uuid set default'.format(table=table_name)
        )
        time_cursor.execute(
            'UPDATE {table} SET uuid = gen_random_uuid() WHERE uuid IS NULL'.format(table=table_name),
            msg='update {table} leftovers'.format(table=table_name)
        )
        time_cursor.execute(
            'ALTER TABLE {table} ALTER COLUMN uuid SET NOT NULL'.format(table=table_name),
            msg='{table}.uuid set not null'.format(table=table_name)
        )
        log.info('migration finished')
    else:
        log.info('migration finished without creating final column contraints - rerun without this option to finalize')


def run_parallel(dsn, args):
    multiprocessing.log_to_stderr()
    log = multiprocessing.get_logger()
    log.setLevel(logging.DEBUG)

    p1 = multiprocessing.Process(
        name='table::object_registry', target=add_uuid_column_impl, args=(dsn, 'object_registry', 2000, log,
        args.no_vacuum, args.no_final_constraint)
    )
    p1.daemon = True
    p1.start()

    p2 = multiprocessing.Process(
        name='table::history', target=add_uuid_column_impl, args=(dsn, 'history', 2000, log,
        args.no_vacuum, args.no_final_constraint)
    )
    p2.daemon = True
    p2.start()

    p1.join()
    p2.join()


def run(dsn, args):
    logging.basicConfig(level=logging.DEBUG)

    add_uuid_column_impl(
        dsn, 'object_registry', 2000, logging.getLogger('table::object_registry'),
        no_vacuum=args.no_vacuum, no_final_constraint=args.no_final_constraint
    )
    add_uuid_column_impl(
        dsn, 'history', 2000, logging.getLogger('table::history'),
        no_vacuum=args.no_vacuum, no_final_constraint=args.no_final_constraint
    )


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--db-host', required=True, help='database hostname')
    parser.add_argument('--db-user', default='fred', help='database user')
    parser.add_argument('--db-name', default='fred', help='database name')
    parser.add_argument('--db-pass', default=None, help='database password')
    parser.add_argument('--no-vacuum', default=False, action='store_true',
        help='Do not run VACUUM command after table chunked UPDATE')
    parser.add_argument('--no-final-constraint', default=False, action='store_true',
        help='Do not create final uuid column constraint - NOT NULL and DEFAULT value')

    args = parser.parse_args()

    db_params = {
        'host': args.db_host,
        'user': args.db_user,
        'dbname': args.db_name,
        'password': args.db_pass
    }

    dsn = ' '.join(['='.join((key, value)) for key, value in db_params.items() if value])

    try:
        run(dsn, args)
        # run_parallel(dsn, args)
    except KeyboardInterrupt:
        pass
