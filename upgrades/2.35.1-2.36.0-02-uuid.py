#!/usr/bin/env python
import psycopg2
import argparse
import logging
import time
import datetime
import multiprocessing

def add_uuid_column_impl(dsn, table_name, chunk, log):
    log.info('migration started')

    conn = psycopg2.connect(dsn=dsn)
    conn.autocommit = True
    cursor = conn.cursor()

    cursor.execute('ALTER TABLE {table} ADD COLUMN IF NOT EXISTS uuid UUID'.format(table=table_name))
    log.info('uuid column created')
    cursor.execute('CREATE UNIQUE INDEX CONCURRENTLY IF NOT EXISTS {table}_uuid_idx ON {table} (uuid)'.format(table=table_name))
    log.info('uuid unique index created')

    cursor.execute('SELECT count(*) FROM {table} WHERE uuid IS NULL'.format(table=table_name))
    # this can change during migration - just for estimate
    rows_todo = long(cursor.fetchone()[0])

    chunk = 2000
    rows_done = 0
    time_done = datetime.timedelta(seconds=0)
    while True:
        iter_start = time.time()
        cursor.execute(
            'UPDATE {table} SET uuid = gen_random_uuid()' \
            ' WHERE id IN (SELECT id FROM {table} WHERE uuid IS NULL' \
            ' LIMIT {limit} FOR UPDATE SKIP LOCKED)'.format(table=table_name, limit=chunk)
        )
        if cursor.rowcount == 0:
            break
        rows_done += cursor.rowcount

        iter_took = datetime.timedelta(seconds=(time.time() - iter_start))
        time_done += iter_took
        if rows_done % (10 * chunk) == 0:
            time_estimate = ((rows_todo - rows_done) / chunk) * (time_done / (rows_done / chunk))
            percent_done = (rows_done * 100) / float(rows_todo)
            log.info('update at {:.2f}% -- elapsed: {}  estimated: {}  (rows: {:,}/{:,})'.format(
                percent_done, str(time_done).split('.')[0], str(time_estimate).split('.')[0], rows_done, rows_todo
            ))

    cursor.execute('ALTER TABLE {table} ALTER COLUMN uuid SET DEFAULT gen_random_uuid()'.format(table=table_name))
    cursor.execute('UPDATE {table} SET uuid = gen_random_uuid() WHERE uuid IS NULL'.format(table=table_name))
    cursor.execute('ALTER TABLE {table} ALTER COLUMN uuid SET NOT NULL'.format(table=table_name))

    log.info('migration finished')


def run_parallel(dsn):
    multiprocessing.log_to_stderr()
    log = multiprocessing.get_logger()
    log.setLevel(logging.DEBUG)

    p1 = multiprocessing.Process(
        name='table::object_registry', target=add_uuid_column_impl, args=(dsn, 'object_registry', 2000, log)
    )
    p1.daemon = True
    p1.start()

    p2 = multiprocessing.Process(
        name='table::history', target=add_uuid_column_impl, args=(dsn, 'history', 2000, log)
    )
    p2.daemon = True
    p2.start()

    p1.join()
    p2.join()


def run(dsn):
    logging.basicConfig(level=logging.DEBUG)

    add_uuid_column_impl(dsn, 'object_registry', 2000, logging.getLogger('table::object_registry'))
    add_uuid_column_impl(dsn, 'history', 2000, logging.getLogger('table::history'))


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--db-host', required=True, help='database hostname')
    parser.add_argument('--db-user', default='fred', help='database user')
    parser.add_argument('--db-name', default='fred', help='database name')
    parser.add_argument('--db-pass', default=None, help='database password')

    args = parser.parse_args()

    db_params = {
        'host': args.db_host,
        'user': args.db_user,
        'dbname': args.db_name,
        'password': args.db_pass
    }

    dsn = ' '.join(['='.join((key, value)) for key, value in db_params.items() if value])

    try:
        run(dsn)
        # run_parallel(dsn)
    except KeyboardInterrupt:
        pass
