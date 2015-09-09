DROP RULE request_object_ref_insert_function on request_object_ref;

ALTER TABLE request_object_ref ALTER COLUMN object_id TYPE bigint;

CREATE OR REPLACE FUNCTION tr_request_object_ref(
        id BIGINT,
        request_time_begin TIMESTAMP WITHOUT TIME ZONE,
        request_service_id INTEGER,
        request_monitoring BOOLEAN,
        request_id BIGINT,
        object_type_id INTEGER,
        object_id BIGINT
) RETURNS VOID AS
$tr_request_object_ref$
DECLARE
        table_name VARCHAR(50);
        stmt TEXT;
BEGIN
        table_name := quote_ident('request_object_ref_' || partition_postfix(request_time_begin, request_service_id, request_monitoring));
        stmt := 'INSERT INTO ' || table_name || ' (id, request_time_begin, request_service_id, request_monitoring, request_id, object_type_id, object_id) VALUES ('
            || COALESCE(id::TEXT, 'NULL')                       || ', '
            || COALESCE(quote_literal(request_time_begin), 'NULL') || ', '
            || COALESCE(request_service_id::TEXT, 'NULL')       || ', '
            || '''' || bool_to_str(request_monitoring)          || ''', '
            || COALESCE(request_id::TEXT, 'NULL')               || ', '
            || COALESCE(object_type_id::TEXT, 'NULL')           || ', '
            || COALESCE(object_id::TEXT, 'NULL')
            || ') ';

        raise notice 'generated SQL: %', stmt;
        EXECUTE stmt;
EXCEPTION
        WHEN undefined_table THEN
        BEGIN
                raise notice 'In exception handler..... ';
                PERFORM create_tbl_request_object_ref(request_time_begin, request_service_id, request_monitoring);
                EXECUTE stmt;
        END;
END;
$tr_request_object_ref$ LANGUAGE plpgsql;

CREATE OR REPLACE RULE request_object_ref_insert_function AS ON INSERT TO request_object_ref
    DO INSTEAD SELECT tr_request_object_ref (
        NEW.id, NEW.request_time_begin,
        NEW.request_service_id,
        NEW.request_monitoring,
        NEW.request_id,
        NEW.object_type_id,
        NEW.object_id
    );
