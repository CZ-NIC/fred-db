CREATE OR REPLACE FUNCTION create_tbl_request_data(time_begin TIMESTAMP WITHOUT TIME ZONE, service_id INTEGER, monitoring BOOLEAN) RETURNS VOID AS $create_tbl_request_data$
DECLARE
        table_name VARCHAR(60);
        table_postfix VARCHAR(40);
        create_table    TEXT;
        spec_alter_table TEXT;
        month INTEGER;
        lower TIMESTAMP WITHOUT TIME ZONE;
        upper  TIMESTAMP WITHOUT TIME ZONE;
BEGIN
        table_postfix := partition_postfix(time_begin, service_id, monitoring);
        table_name := quote_ident('request_data_' || table_postfix);

        LOCK TABLE request_data IN SHARE UPDATE EXCLUSIVE MODE;

        lower := to_char(date_trunc('month', time_begin), 'YYYY-MM-DD');
        upper := to_char(date_trunc('month', time_begin + interval '1 month'), 'YYYY-MM-DD');

        IF monitoring = true THEN
                create_table  =  'CREATE TABLE ' || table_name || ' (CHECK (request_time_begin >= TIMESTAMP ''' || lower || ''' AND request_time_begin < TIMESTAMP ''' || upper || ''' AND request_monitoring = ''' || bool_to_str(monitoring) || ''') ) INHERITS (request_data) ';
        ELSE
                create_table  =  'CREATE TABLE ' || table_name || ' (CHECK (request_time_begin >= TIMESTAMP ''' || lower || ''' AND request_time_begin < TIMESTAMP ''' || upper || ''' AND request_service_id = ' || service_id || ' AND request_monitoring = ''' || bool_to_str(monitoring) || ''') ) INHERITS (request_data) ';
        END IF;

        spec_alter_table = 'ALTER TABLE ' || table_name || ' ADD PRIMARY KEY (id); '
             || 'ALTER TABLE ' || table_name || ' ADD CONSTRAINT ' || table_name || '_entry_id_fkey FOREIGN KEY (request_id) REFERENCES request_' || table_postfix || '(id); ';

        EXECUTE create_table;
        EXECUTE spec_alter_table;

        PERFORM create_indexes_request_data(table_name);

EXCEPTION
    WHEN duplicate_table THEN
        NULL;
END;
$create_tbl_request_data$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_tbl_request_property_value(time_begin TIMESTAMP WITHOUT TIME ZONE, service_id INTEGER, monitoring BOOLEAN) RETURNS VOID AS $create_tbl_request_property_value$
DECLARE
        table_name VARCHAR(60);
        table_postfix VARCHAR (40);
        create_table    TEXT;
        spec_alter_table TEXT;
        month INTEGER;
        lower TIMESTAMP WITHOUT TIME ZONE;
        upper  TIMESTAMP WITHOUT TIME ZONE;
BEGIN
        table_postfix := partition_postfix(time_begin, service_id, monitoring);
        table_name := quote_ident('request_property_value_' || table_postfix);

        LOCK TABLE request_property_value IN SHARE UPDATE EXCLUSIVE MODE;

        lower := to_char(date_trunc('month', time_begin), 'YYYY-MM-DD');
        upper := to_char(date_trunc('month', time_begin + interval '1 month'), 'YYYY-MM-DD');

        IF monitoring = true THEN
                create_table  =  'CREATE TABLE ' || table_name || ' (CHECK (request_time_begin >= TIMESTAMP ''' || lower || ''' AND request_time_begin < TIMESTAMP ''' || upper || '''  AND request_monitoring = ''' || bool_to_str(monitoring) || ''') ) INHERITS (request_property_value) ';
        ELSE
                create_table  =  'CREATE TABLE ' || table_name || ' (CHECK (request_time_begin >= TIMESTAMP ''' || lower || ''' AND request_time_begin < TIMESTAMP ''' || upper || '''  AND request_service_id = ' || service_id || ' AND request_monitoring = ''' || bool_to_str(monitoring) || ''') ) INHERITS (request_property_value) ';
        END IF;

        spec_alter_table = 'ALTER TABLE ' || table_name || ' ADD PRIMARY KEY (id); ALTER TABLE ' || table_name || ' ADD CONSTRAINT ' || table_name || '_entry_id_fkey FOREIGN KEY (request_id) REFERENCES request_' || table_postfix || '(id); ALTER TABLE ' || table_name || ' ADD CONSTRAINT ' || table_name || '_name_id_fkey FOREIGN KEY (property_name_id) REFERENCES request_property_name(id); ALTER TABLE ' || table_name || ' ADD CONSTRAINT ' || table_name || '_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES ' || table_name || '(id); ';

        EXECUTE create_table;
        EXECUTE spec_alter_table;
        PERFORM create_indexes_request_property_value(table_name);
EXCEPTION
    WHEN duplicate_table THEN
        NULL;

END;
$create_tbl_request_property_value$ LANGUAGE plpgsql;

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
        table_postfix := partition_postfix(time_begin, service_id, monitoring);
        table_name := quote_ident('request_object_ref_' || table_postfix);

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
