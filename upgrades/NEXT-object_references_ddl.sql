--- don't forget to update database schema version
---
---



-- UPDATE enum_parameters SET val = '<insert version here>' WHERE id = 1;

-- Ticket #4392

CREATE TABLE request_object_type (
    id SERIAL PRIMARY KEY,
    name VARCHAR(64)
);

CREATE TABLE request_object_ref (
    id SERIAL PRIMARY KEY, 
    request_time_begin TIMESTAMP NOT NULL,
    request_service_id INTEGER  NOT NULL,                                     
    request_monitoring BOOLEAN NOT NULL,                                      
    request_id INTEGER NOT NULL REFERENCES request(id),                       
    object_type_id INTEGER  NOT NULL REFERENCES request_object_type(id),
    object_id INTEGER NOT NULL
);

CREATE INDEX request_object_ref_id_idx ON request_object_ref(request_id);
CREATE INDEX request_object_ref_time_begin_idx ON request_object_ref(request_time_begin);
CREATE INDEX request_object_ref_service_id_idx ON request_object_ref(request_service_id);
CREATE INDEX request_object_ref_object_type_id_idx ON request_object_ref(object_type_id);
CREATE INDEX request_object_ref_object_id_idx ON request_object_ref(object_id);


-- reuqest_object_ref trigger
CREATE OR REPLACE FUNCTION tr_request_object_ref(id INTEGER, request_time_begin TIMESTAMP WITHOUT TIME ZONE, request_service_id INTEGER, request_monitoring BOOLEAN, request_id INTEGER, object_type_id INTEGER, object_id INTEGER) RETURNS VOID AS $tr_request_object_ref$
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


CREATE OR REPLACE FUNCTION create_tbl_request_object_ref(time_begin TIMESTAMP WITHOUT TIME ZONE, service_id INTEGER, monitoring BOOLEAN) RETURNS VOID AS $create_tbl_request_object_ref$
DECLARE 
        table_name VARCHAR(60);
        table_postfix VARCHAR (40);
        create_table    TEXT;
        spec_alter_table TEXT;
        month INTEGER;
        lower TIMESTAMP WITHOUT TIME ZONE;
        upper  TIMESTAMP WITHOUT TIME ZONE;
BEGIN
        table_postfix := quote_ident(partition_postfix(time_begin, service_id, monitoring));
        table_name := 'request_object_ref_' || table_postfix; 

        LOCK TABLE request_property_value IN SHARE UPDATE EXCLUSIVE MODE;

        lower := to_char(date_trunc('month', time_begin), 'YYYY-MM-DD');
        upper := to_char(date_trunc('month', time_begin + interval '1 month'), 'YYYY-MM-DD');

        IF monitoring = true THEN
                create_table  =  'CREATE TABLE ' || table_name || ' (CHECK (request_time_begin >= TIMESTAMP ''' || lower || ''' AND request_time_begin < TIMESTAMP ''' || upper || '''  AND request_monitoring = ''' || bool_to_str(monitoring) || ''') ) INHERITS (request_object_ref) ';
        ELSE 
                create_table  =  'CREATE TABLE ' || table_name || ' (CHECK (request_time_begin >= TIMESTAMP ''' || lower || ''' AND request_time_begin < TIMESTAMP ''' || upper || '''  AND request_service_id = ' || service_id || ' AND request_monitoring = ''' || bool_to_str(monitoring) || ''') ) INHERITS (request_object_ref) ';
        END IF;         

        spec_alter_table = 'ALTER TABLE ' || table_name || ' ADD PRIMARY KEY (id); ALTER TABLE ' || table_name || ' ADD CONSTRAINT ' || table_name || '_entry_id_fkey FOREIGN KEY (request_id) REFERENCES request_' || table_postfix || '(id); ALTER TABLE ' || table_name || ' ADD CONSTRAINT ' || table_name || '_object_type_id_fkey FOREIGN KEY (object_type_id) REFERENCES request_object_type(id); ';

        EXECUTE create_table;
        EXECUTE spec_alter_table;
        PERFORM create_indexes_request_object_ref(table_name);
EXCEPTION
    WHEN duplicate_table THEN
        NULL;

END;
$create_tbl_request_object_ref$ LANGUAGE plpgsql; 


CREATE OR REPLACE FUNCTION create_indexes_request_object_ref(table_name VARCHAR(50)) RETURNS VOID as $create_indexes_request_object_ref$ 
DECLARE
        create_indexes TEXT;
BEGIN
        create_indexes := 
       'CREATE INDEX ' || table_name || '_id_idx ON ' || table_name || '(request_id);'
       || 'CREATE INDEX ' || table_name || '_time_begin_idx ON ' || table_name || '(request_time_begin); '
       || 'CREATE INDEX ' || table_name || '_service_id_idx ON ' || table_name || '(request_service_id);'
       || 'CREATE INDEX ' || table_name || '_object_type_id_idx ON ' || table_name || '(object_type_id);'
       || 'CREATE INDEX ' || table_name || '_object_id_idx ON ' || table_name || '(object_id);';
        EXECUTE create_indexes;
END;
$create_indexes_request_object_ref$ LANGUAGE plpgsql;

CREATE OR REPLACE RULE request_object_ref_insert_function AS ON INSERT TO request_object_ref 
DO INSTEAD SELECT tr_request_object_ref (NEW.id, NEW.request_time_begin, NEW.request_service_id, NEW.request_monitoring, NEW.request_id, NEW.object_type_id, NEW.object_id);

