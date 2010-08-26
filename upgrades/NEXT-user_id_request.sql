--- THIS SCRIPT could be MERGED with that to ticket #4327

--- don't forget to update database schema version
---
---

-- UPDATE enum_parameters SET val = '<insert version here>' WHERE id = 1;

---


ALTER TABLE request ADD COLUMN user_id INTEGER;



CREATE OR REPLACE FUNCTION tr_request(id INTEGER, time_begin TIMESTAMP WITHOUT TIME ZONE, time_end TIMESTAMP WITHOUT TIME ZONE, source_ip INET, service_id INTEGER, request_type_id INTEGER, session_id INTEGER, user_name VARCHAR(255), user_id INTEGER, is_monitoring BOOLEAN ) RETURNS VOID AS $tr_request$
DECLARE 
        table_name VARCHAR(50);
        stmt       TEXT;
BEGIN
        table_name = quote_ident('request_' || partition_postfix(time_begin, service_id, is_monitoring));

        stmt := 'INSERT INTO ' || table_name || ' (id, time_begin, time_end, source_ip, service_id, request_type_id, session_id, user_name, user_id, is_monitoring) VALUES (' 
                || COALESCE(id::TEXT, 'NULL')           || ', ' 
                || COALESCE(quote_literal(time_begin), 'NULL')           || ', '
                || COALESCE(quote_literal(time_end), 'NULL')             || ', '
                || COALESCE(quote_literal(host(source_ip)), 'NULL')      || ', '
                || COALESCE(service_id::TEXT, 'NULL')      || ', '
                || COALESCE(request_type_id::TEXT, 'NULL')  || ', '
                || COALESCE(session_id::TEXT, 'NULL')   || ', '
                || COALESCE(quote_literal(user_name), 'NULL')            || ', '
                || COALESCE(user_id::TEXT, 'NULL')                       || ', '
                || '''' || bool_to_str(is_monitoring)   || ''') ';
        
        -- raise notice 'request Generated insert: %', stmt;
        EXECUTE stmt;

EXCEPTION
        WHEN undefined_table THEN
        BEGIN
                PERFORM create_tbl_request(time_begin, service_id, is_monitoring);
        
                EXECUTE stmt;
        END;
END;
$tr_request$ LANGUAGE plpgsql;

/** parameter table_name must already be processed by quote_ident
*/
CREATE OR REPLACE FUNCTION create_indexes_request(table_name VARCHAR(50)) RETURNS VOID AS $create_indexes_request$
DECLARE 
        create_indexes TEXT;
BEGIN
        create_indexes := 'CREATE INDEX ' || table_name || '_time_begin_idx ON ' || table_name || '(time_begin);'
                       || 'CREATE INDEX ' || table_name || '_time_end_idx ON ' || table_name || '(time_end);'
                       || 'CREATE INDEX ' || table_name || '_source_ip_idx ON ' || table_name || '(source_ip);'         
                       || 'CREATE INDEX ' || table_name || '_service_idx ON ' || table_name || '(service_id);'  
                       || 'CREATE INDEX ' || table_name || '_action_type_idx ON ' || table_name || '(request_type_id);' 
                       || 'CREATE INDEX ' || table_name || '_monitoring_idx ON ' || table_name || '(is_monitoring);'
                       || 'CREATE INDEX ' || table_name || '_user_name_idx ON ' || table_name || '(user_name);'
                       || 'CREATE INDEX ' || table_name || '_user_id_idx ON ' || table_name || '(user_id);';
        EXECUTE create_indexes;
END;
$create_indexes_request$ LANGUAGE plpgsql;


CREATE OR REPLACE RULE request_insert_function AS ON INSERT TO request DO INSTEAD SELECT tr_request ( NEW.id, NEW.time_begin, NEW.time_end, NEW.source_ip, NEW.service_id, NEW.request_type_id, NEW.session_id, NEW.user_name, NEW.user_id, NEW.is_monitoring); 
