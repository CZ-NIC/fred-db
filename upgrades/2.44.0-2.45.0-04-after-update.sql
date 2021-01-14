BEGIN;

-- drop old column
DROP RULE IF EXISTS request_object_ref_insert_function ON request_object_ref;
ALTER TABLE request_object_ref DROP COLUMN object_id;

-- rename new column
ALTER TABLE request_object_ref RENAME COLUMN object_bigid TO object_id;

-- revert insert trigger
CREATE OR REPLACE FUNCTION tr_request_object_ref(
        id BIGINT,
        request_time_begin TIMESTAMP WITHOUT TIME ZONE,
        request_service_id INTEGER,
        request_monitoring BOOLEAN,
        request_id BIGINT,
        object_type_id INTEGER,
        object_id BIGINT,
        object_ident TEXT)
RETURNS VOID
LANGUAGE plpgsql
AS $tr_request_object_ref$
DECLARE
        table_name VARCHAR(50);
        stmt TEXT;
BEGIN
        table_name := quote_ident('request_object_ref_' || partition_postfix(request_time_begin, request_service_id, request_monitoring));
        stmt := 'INSERT INTO ' || table_name || ' (id, request_time_begin, request_service_id, request_monitoring, request_id, object_type_id, object_id, object_ident) VALUES ('
            || COALESCE(id::TEXT, 'NULL') || ', '
            || COALESCE(quote_literal(request_time_begin), 'NULL') || ', '
            || COALESCE(request_service_id::TEXT, 'NULL') || ', '
            || '''' || bool_to_str(request_monitoring) || ''', '
            || COALESCE(request_id::TEXT, 'NULL') || ', '
            || COALESCE(object_type_id::TEXT, 'NULL') || ', '
            || COALESCE(object_id::TEXT, 'NULL') || ', '
            || COALESCE(quote_literal(object_ident), 'NULL')
            || ') ';

        -- RAISE NOTICE 'generated SQL: %', stmt;
        EXECUTE stmt;
EXCEPTION
        WHEN undefined_table THEN
        BEGIN
                RAISE NOTICE 'In exception handler..... ';
                PERFORM create_tbl_request_object_ref(request_time_begin, request_service_id, request_monitoring);
                EXECUTE stmt;
        END;
END;
$tr_request_object_ref$;

CREATE OR REPLACE RULE request_object_ref_insert_function AS ON INSERT TO request_object_ref
    DO INSTEAD SELECT tr_request_object_ref(
        NEW.id,
        NEW.request_time_begin,
        NEW.request_service_id,
        NEW.request_monitoring,
        NEW.request_id,
        NEW.object_type_id,
        NEW.object_id,
        NEW.object_ident);

-- rename indexes
DO
$$
DECLARE
    child record;
BEGIN
    FOR child IN (
        SELECT pgcch.relname
          FROM pg_inherits pgi
          JOIN pg_class AS pgcch
            ON inhrelid = pgcch.oid
          JOIN pg_class AS pgcp
            ON inhparent = pgcp.oid
         WHERE pgcp.relname = 'request_object_ref')
    LOOP
        EXECUTE 'ALTER INDEX ' || quote_ident(child.relname || '_object_bigid_idx') || ' RENAME TO ' || quote_ident(child.relname || '_object_id_idx');
    END LOOP;
END;
$$;

-- revert function creating indexes
CREATE OR REPLACE FUNCTION create_indexes_request_object_ref(table_name VARCHAR(50)) RETURNS VOID as $create_indexes_request_object_ref$
DECLARE
        create_indexes TEXT;
BEGIN
        create_indexes :=
       'CREATE INDEX ' || table_name || '_id_idx ON ' || table_name || '(request_id);' ||
       'CREATE INDEX ' || table_name || '_time_begin_idx ON ' || table_name || '(request_time_begin); ' ||
       'CREATE INDEX ' || table_name || '_service_id_idx ON ' || table_name || '(request_service_id);' ||
       'CREATE INDEX ' || table_name || '_object_type_id_idx ON ' || table_name || '(object_type_id);' ||
       'CREATE INDEX ' || table_name || '_object_id_idx ON ' || table_name || '(object_id);' ||
       'CREATE INDEX ' || table_name || '_object_ident_idx ON ' || table_name || '(object_ident);'
        EXECUTE create_indexes;
END;
$create_indexes_request_object_ref$ LANGUAGE plpgsql;


COMMIT;
