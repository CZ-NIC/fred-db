#!/usr/bin/env python
import psycopg2
import argparse
import logging
import time
import datetime
import multiprocessing

def add_uuid_column_impl(dsn, table_name, chunk, log, no_vacuum, no_final_constraint):
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

    if not no_vacuum:
        operation_start = time.time()
        log.info('{table} vacuum - started at {now}'.format(table=table_name, now=datetime.datetime.now()))
        cursor.execute('VACUUM {table}'.format(table=table_name))
        log.info('{table} vacuum - took {delta}'.format(table=table_name, delta=datetime.timedelta(seconds=time.time() - operation_start)))

    if not no_final_constraint:
        operation_start = time.time()
        log.info('{table}.uuid set default - started at {now}'.format(table=table_name, now=datetime.datetime.now()))
        cursor.execute('ALTER TABLE {table} ALTER COLUMN uuid SET DEFAULT gen_random_uuid()'.format(table=table_name))
        log.info('{table}.uuid set default - took {delta}'.format(table=table_name, delta=datetime.timedelta(seconds=time.time() - operation_start)))

        operation_start = time.time()
        log.info('update {table} leftovers - started at {now}'.format(table=table_name, now=datetime.datetime.now()))
        cursor.execute('UPDATE {table} SET uuid = gen_random_uuid() WHERE uuid IS NULL'.format(table=table_name))
        log.info('update {table} leftovers - took {delta}'.format(table=table_name, delta=datetime.timedelta(seconds=time.time() - operation_start)))

        operation_start = time.time()
        log.info('{table}.uuid set not null - started at {now}'.format(table=table_name, now=datetime.datetime.now()))
        cursor.execute('ALTER TABLE {table} ALTER COLUMN uuid SET NOT NULL'.format(table=table_name))
        log.info('{table}.uuid set not null - took {delta}'.format(table=table_name, delta=datetime.timedelta(seconds=time.time() - operation_start)))

    log.info('migration finished')


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
