-- CREATE OR REPLACE FUNCTION tr_request RETURNS trigger AS $tr_request$

/*
functions for each table: 
 - tr_* 'trigger' 
 - create_* creating a new partition
 - create_indexes_* which CREATE indexes (used by create_*)

*/

CREATE OR REPLACE FUNCTION bool_to_str(b BOOLEAN) RETURNS CHAR
AS $bool_to_str$
BEGIN
	RETURN (SELECT CASE WHEN b THEN 't' ELSE 'f' END);
END;
$bool_to_str$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION tr_request(id INTEGER, time_begin TIMESTAMP WITHOUT TIME ZONE, time_end TIMESTAMP WITHOUT TIME ZONE, source_ip INET, service INTEGER, action_type INTEGER, session_id INTEGER, user_name VARCHAR(255), is_monitoring BOOLEAN ) RETURNS VOID AS $tr_request$
DECLARE 
	table_name VARCHAR(50);
	stmt 	   TEXT;
BEGIN

	stmt := 'INSERT INTO request_' || partition_postfix(time_begin, service, is_monitoring) || ' (id, time_begin, time_end, source_ip, service, action_type, session_id, user_name, is_monitoring) VALUES (' || id || ', ' || quote_literal(time_begin) || ', ';
	
	IF (time_end IS NULL) THEN
		stmt := stmt || 'null, ';
	ELSE 
		stmt := stmt || quote_literal(time_end) || ', ';
	END IF;

	IF (source_ip IS NULL) THEN 
		stmt := stmt || 'null, ';
	ELSE 
		stmt := stmt || quote_literal(host(source_ip)) || ', ';
	END IF;
	
	stmt := stmt || service || ', ';

	IF (action_type IS NULL) THEN
		stmt := stmt || 'null, ';
	ELSE 
		stmt := stmt || action_type || ', ';
	END IF;

	IF (session_id IS NULL) THEN 	
		stmt := stmt || 'null, ';
	ELSE 
		stmt := stmt || session_id || ', ';
	END IF;

        IF (user_name IS NULL) THEN
                stmt := stmt || 'null, ';
        ELSE 
                stmt := stmt || quote_literal(user_name) || ', ';
        END IF;

	stmt := stmt || '''' || bool_to_str(is_monitoring) || ''') ';

	-- raise notice 'request Generated insert: %', stmt;
	EXECUTE stmt;

EXCEPTION
	WHEN undefined_table THEN
	BEGIN
		PERFORM create_tbl_request(time_begin, service, is_monitoring);
	
		EXECUTE stmt;
	END;
END;
$tr_request$ LANGUAGE plpgsql;


-- session is partitioned according to date only
CREATE OR REPLACE FUNCTION tr_session(id INTEGER, name VARCHAR(255), login_date timestamp, logout_date timestamp, lang VARCHAR(2)) RETURNS VOID AS $tr_session$
DECLARE 
	stmt  TEXT;
BEGIN
	stmt := 'INSERT INTO session_' || partition_postfix(login_date, -1, false) || ' (id, name, login_date, logout_date, lang) VALUES (' || id || ', ' || quote_literal(name) || ', ';
	
	IF (login_date IS NULL) THEN
		stmt := stmt || 'null, ';
	ELSE 
		stmt := stmt || quote_literal(login_date)  || ', ';
	END IF;

	IF (logout_date IS NULL) THEN
		stmt := stmt || 'null, ';
	ELSE 
		stmt := stmt || quote_literal(logout_date) || ', ';
	END IF;

	stmt := stmt || quote_literal(lang) || ')';

	-- raise notice 'session Generated insert: %', stmt;
	EXECUTE stmt;

EXCEPTION
	WHEN undefined_table THEN
	BEGIN
		PERFORM create_tbl_session(login_date);
	
		EXECUTE stmt;
	END;
END;
$tr_session$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION tr_request_data(entry_time_begin timestamp, entry_service INTEGER,  entry_monitoring BOOLEAN, entry_id INTEGER, content TEXT, is_response BOOLEAN) RETURNS VOID AS $tr_request_data$
DECLARE 
	stmt  TEXT;
BEGIN
	stmt := 'INSERT INTO request_data_' || partition_postfix(entry_time_begin, entry_service, entry_monitoring) || '(entry_time_begin, entry_service, entry_monitoring, entry_id,  content, is_response) VALUES (' || quote_literal(entry_time_begin) || ', ' ||
		entry_service    || ', ''' ||
		bool_to_str(entry_monitoring) || ''', ' || 
		entry_id || ', ' ||
		quote_literal(content) || ', ';
		
	IF (is_response IS NULL) THEN 
		stmt := stmt || 'null) ';
	ELSE 
		stmt := stmt || '''' || bool_to_str(is_response) || ''') ';
	END IF;

	-- raise notice 'request_data Generated insert: %', stmt;
	EXECUTE stmt;

EXCEPTION
	WHEN undefined_table THEN
	BEGIN
		PERFORM create_tbl_request_data(entry_time_begin, entry_service, entry_monitoring);
	
		EXECUTE stmt;
	END;
END;
$tr_request_data$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION tr_request_property_value(entry_time_begin TIMESTAMP WITHOUT TIME ZONE, entry_service INTEGER, entry_monitoring BOOLEAN, id INTEGER, entry_id INTEGER, name_id INTEGER, value TEXT, output BOOLEAN, parent_id INTEGER) RETURNS VOID AS $tr_request_property_value$
DECLARE 
	stmt  TEXT;
BEGIN
	stmt := 'INSERT INTO request_property_value_' || partition_postfix(entry_time_begin, entry_service, entry_monitoring) || '(entry_time_begin, entry_service, entry_monitoring, id, entry_id, name_id, value, output, parent_id) VALUES (' || quote_literal(entry_time_begin) || ', ' || entry_service || ', ''' || bool_to_str(entry_monitoring) || ''', ';

	IF (id IS NULL) THEN
		stmt := stmt || ' null, ';
	ELSE 
		stmt := stmt || id || ', '; 
	END IF;

	stmt := stmt || entry_id || ', ' || name_id || ', ' || quote_literal(value) || ', ';	

	IF (output IS NULL) THEN 
		stmt := stmt || 'null, ';
	ELSE 
		stmt := stmt || '''' || bool_to_str(output) || ''', ';
	END IF;

	IF (parent_id IS NULL) THEN
		stmt := stmt || 'null)';
	ELSE 
		stmt := stmt || parent_id || ')';
	END IF;

	-- raise notice 'request_property_value Generated insert: %', stmt;
	EXECUTE stmt;

EXCEPTION
	WHEN undefined_table THEN
	BEGIN
		PERFORM create_tbl_request_property_value(entry_time_begin, entry_service, entry_monitoring);
	
		EXECUTE stmt;
	END;
END;
$tr_request_property_value$ LANGUAGE plpgsql;

-- can handle years from 2000 to 2099
-- this dependes on LogServiceType in log_impl.h AND in _dataTypes.idl
-- but slightly faster than the latter version
/*
CREATE OR REPLACE FUNCTION partition_postfix(rec_time TIMESTAMP WITHOUT TIME ZONE, service INTEGER, is_monitoring BOOLEAN ) RETURNS VARCHAR(40) AS 
$partition_postfix$
DECLARE 
	date_part VARCHAR(5);
BEGIN
	date_part := to_char(date_trunc('month', rec_time), 'YY_MM');

	IF (service = -1) THEN
		-- for session which is not partitioned by service
		RETURN date_part;
	elsif (is_monitoring) THEN
		RETURN 'mon_' || date_part;	
		-- separate partition for monitoring requests
	elsif (service = 0) THEN
		RETURN 'whois_' || date_part;
	elsif (service = 1) THEN		 
		RETURN 'webwhois_' || date_part;
	elsif (service = 2) THEN		 
		RETURN 'pubreq_' || date_part;
	elsif (service = 3) THEN		 
		RETURN 'epp_' || date_part;
	elsif (service = 4) THEN		 
		RETURN 'webadmin_' || date_part;
	elsif (service = 5) THEN 
		RETURN 'intranet_' || date_part;
	END IF;
	
	raise exception 'Unknown service type number: % ', service;

END;
$partition_postfix$ LANGUAGE plpgsql;
*/


CREATE OR REPLACE FUNCTION partition_postfix(rec_time TIMESTAMP WITHOUT TIME ZONE, serv INTEGER, is_monitoring BOOLEAN ) RETURNS VARCHAR(40) AS 
$partition_postfix_alt$
DECLARE 
	date_part VARCHAR(5);
	service_postfix VARCHAR(10);
BEGIN
	date_part := to_char(date_trunc('month', rec_time), 'YY_MM');

	IF (serv = -1) THEN
		RETURN date_part;
	elsif (is_monitoring) THEN
		RETURN 'mon_' || date_part;	
	ELSE
		SELECT partition_postfix into service_postfix from service where id = serv;
		RETURN service_postfix || date_part;
	END IF;
END;
$partition_postfix_alt$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION create_tbl_request(time_begin TIMESTAMP WITHOUT TIME ZONE, service INTEGER, monitoring BOOLEAN) RETURNS VOID AS $create_tbl_request$
DECLARE 
	table_name VARCHAR(60);
	table_base VARCHAR(60);
	create_table 	TEXT;
	spec_alter_table TEXT;
	month INTEGER;
	lower TIMESTAMP WITHOUT TIME ZONE;
	upper  TIMESTAMP WITHOUT TIME ZONE;

BEGIN
	table_base := 'request';
	table_name := table_base || '_' || partition_postfix(time_begin, service, monitoring);

	lower := to_char(date_trunc('month', time_begin), 'YYYY-MM-DD');
	upper := to_char(date_trunc('month', time_begin + interval '1 month'), 'YYYY-MM-DD');

-- CREATE table
	IF monitoring = true THEN
		-- special constraints for monitoring table
		create_table := 'CREATE TABLE ' || table_name || '    (CHECK (time_begin >= TIMESTAMP ''' || lower || ''' AND time_begin < TIMESTAMP ''' 
		|| upper || ''' AND is_monitoring = ''' || bool_to_str(monitoring) || ''') ) INHERITS (' || table_base || ')';
	ELSE
		create_table := 'CREATE TABLE ' || table_name || '    (CHECK (time_begin >= TIMESTAMP ''' || lower || ''' AND time_begin < TIMESTAMP ''' 
		|| upper || ''' AND service = ' || service || ' AND is_monitoring = ''' || bool_to_str(monitoring) || ''') ) INHERITS (' || table_base || ')';  	
	END IF; 
	 
	
	spec_alter_table := 'ALTER TABLE ' || table_name || ' ADD PRIMARY KEY (id); ';

	EXECUTE create_table;
	EXECUTE spec_alter_table;

	PERFORM create_indexes_request(table_name);

END;
$create_tbl_request$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_indexes_request(table_name VARCHAR(50)) RETURNS VOID AS $create_indexes_request$
DECLARE 
	create_indexes TEXT;
BEGIN
	create_indexes := 'CREATE INDEX ' || table_name || '_time_begin_idx ON ' || table_name || '(time_begin); CREATE INDEX ' 
					|| table_name || '_time_end_idx ON ' || table_name || '(time_end); CREATE INDEX ' 
					|| table_name || '_source_ip_idx ON ' || table_name || '(source_ip); CREATE INDEX ' 
					|| table_name || '_service_idx ON ' || table_name || '(service); CREATE INDEX ' 
					|| table_name || '_action_type_idx ON ' || table_name || '(action_type); CREATE INDEX '
					|| table_name || '_monitoring_idx ON ' || table_name || '(is_monitoring);';
	EXECUTE create_indexes;
END;
$create_indexes_request$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_tbl_request_data(time_begin TIMESTAMP WITHOUT TIME ZONE, service INTEGER, monitoring BOOLEAN) RETURNS VOID AS $create_tbl_request_data$
DECLARE 
	table_name VARCHAR(60);
	table_base VARCHAR(60);
	table_postfix VARCHAR(40);
	create_table 	TEXT;
	spec_alter_table TEXT;
	month INTEGER;
	lower TIMESTAMP WITHOUT TIME ZONE;
	upper  TIMESTAMP WITHOUT TIME ZONE;
BEGIN
	table_base := 'request_data';
	table_postfix := partition_postfix(time_begin, service, monitoring);
	table_name := table_base || '_' || table_postfix;

	lower := to_char(date_trunc('month', time_begin), 'YYYY-MM-DD');
	upper := to_char(date_trunc('month', time_begin + interval '1 month'), 'YYYY-MM-DD');

	IF monitoring = true THEN
		create_table  =  'CREATE TABLE ' || table_name || ' (CHECK (entry_time_begin >= TIMESTAMP ''' || lower || ''' AND entry_time_begin < TIMESTAMP ''' || upper || ''' AND entry_monitoring = ''' || bool_to_str(monitoring) || ''') ) INHERITS (' || table_base || ') ';	
	ELSE 
		create_table  =  'CREATE TABLE ' || table_name || ' (CHECK (entry_time_begin >= TIMESTAMP ''' || lower || ''' AND entry_time_begin < TIMESTAMP ''' || upper || ''' AND entry_service = ' || service || ' AND entry_monitoring = ''' || bool_to_str(monitoring) || ''') ) INHERITS (' || table_base || ') ';
	END IF;
	
	spec_alter_table = 'ALTER TABLE ' || table_name || ' ADD CONSTRAINT ' || table_name || '_entry_id_fkey FOREIGN KEY (entry_id) REFERENCES request_' || table_postfix || '(id); ';


	EXECUTE create_table;
	EXECUTE spec_alter_table;
	
	PERFORM create_indexes_request_data(table_name);

END;
$create_tbl_request_data$ LANGUAGE plpgsql;

-- CREATE index on content removed (too large rows)
CREATE OR REPLACE FUNCTION create_indexes_request_data(table_name VARCHAR(50)) RETURNS VOID AS $create_indexes_request_data$
DECLARE 
	create_indexes TEXT;
BEGIN
	create_indexes = 'CREATE INDEX ' || table_name || '_entry_time_begin_idx ON ' || table_name || '(entry_time_begin); CREATE INDEX ' || table_name || '_entry_id_idx ON ' || table_name || '(entry_id); CREATE INDEX ' || table_name || '_is_response_idx ON ' || table_name || '(is_response);';
	EXECUTE create_indexes;
END;
$create_indexes_request_data$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_tbl_request_property_value(time_begin TIMESTAMP WITHOUT TIME ZONE, service INTEGER, monitoring BOOLEAN) RETURNS VOID AS $create_tbl_request_property_value$
DECLARE 
	table_name VARCHAR(60);
	table_base VARCHAR(60);
	table_postfix VARCHAR (40);
	create_table 	TEXT;
	spec_alter_table TEXT;
	month INTEGER;
	lower TIMESTAMP WITHOUT TIME ZONE;
	upper  TIMESTAMP WITHOUT TIME ZONE;
BEGIN
	table_base := 'request_property_value';
	table_postfix := partition_postfix(time_begin, service, monitoring);
	table_name := table_base || '_' || table_postfix; 


	lower := to_char(date_trunc('month', time_begin), 'YYYY-MM-DD');
	upper := to_char(date_trunc('month', time_begin + interval '1 month'), 'YYYY-MM-DD');

	IF monitoring = true THEN
		create_table  =  'CREATE TABLE ' || table_name || ' (CHECK (entry_time_begin >= TIMESTAMP ''' || lower || ''' AND entry_time_begin < TIMESTAMP ''' || upper || '''  AND entry_monitoring = ''' || bool_to_str(monitoring) || ''') ) INHERITS (' || table_base || ') ';
	ELSE 
		create_table  =  'CREATE TABLE ' || table_name || ' (CHECK (entry_time_begin >= TIMESTAMP ''' || lower || ''' AND entry_time_begin < TIMESTAMP ''' || upper || '''  AND entry_service = ' || service || ' AND entry_monitoring = ''' || bool_to_str(monitoring) || ''') ) INHERITS (' || table_base || ') ';
	END IF;		

	spec_alter_table = 'ALTER TABLE ' || table_name || ' ADD PRIMARY KEY (id); ALTER TABLE ' || table_name || ' ADD CONSTRAINT ' || table_name || '_entry_id_fkey FOREIGN KEY (entry_id) REFERENCES request_' || table_postfix || '(id); ALTER TABLE ' || table_name || ' ADD CONSTRAINT ' || table_name || '_name_id_fkey FOREIGN KEY (name_id) REFERENCES request_property(id); ALTER TABLE ' || table_name || ' ADD CONSTRAINT ' || table_name || '_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES ' || table_name || '(id); ';



	EXECUTE create_table;
	EXECUTE spec_alter_table;
	PERFORM create_indexes_request_property_value(table_name);

END;
$create_tbl_request_property_value$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION create_indexes_request_property_value(table_name VARCHAR(50)) RETURNS VOID AS $create_indexes_request_property_value$
DECLARE 
	create_indexes TEXT;
BEGIN
	create_indexes = 'CREATE INDEX ' || table_name || '_entry_time_begin_idx ON ' || table_name || '(entry_time_begin); CREATE INDEX ' || table_name || '_entry_id_idx ON ' || table_name || '(entry_id); CREATE INDEX ' || table_name || '_name_id_idx ON ' || table_name || '(name_id); CREATE INDEX ' || table_name || '_value_idx ON ' || table_name || '(value); CREATE INDEX ' || table_name || '_output_idx ON ' || table_name || '(output); CREATE INDEX ' || table_name || '_parent_id_idx ON ' || table_name || '(parent_id);';
	EXECUTE create_indexes;

END;
$create_indexes_request_property_value$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION create_tbl_session(time_begin TIMESTAMP WITHOUT TIME ZONE) RETURNS VOID AS $create_tbl_session$
DECLARE 
	table_name VARCHAR(60);
	table_base VARCHAR(60);
	create_table 	TEXT;
	spec_alter_table TEXT;
	month INTEGER;
	lower TIMESTAMP WITHOUT TIME ZONE;
	upper  TIMESTAMP WITHOUT TIME ZONE;

BEGIN
	table_base := 'session';
	table_name := table_base || '_' || partition_postfix(time_begin, -1, false);

	lower := to_char(date_trunc('month', time_begin), 'YYYY-MM-DD');
	upper := to_char(date_trunc('month', time_begin + interval '1 month'), 'YYYY-MM-DD');

	create_table =  'CREATE TABLE ' || table_name || '    (CHECK (login_date >= TIMESTAMP ''' || lower || ''' AND login_date < TIMESTAMP ''' || upper || ''') ) INHERITS (' || table_base || ') ';

	spec_alter_table = 'ALTER TABLE ' || table_name || ' ADD PRIMARY KEY (id); ';


	EXECUTE create_table;
	EXECUTE spec_alter_table;

	PERFORM create_indexes_session(table_name);

END;
$create_tbl_session$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_indexes_session(table_name VARCHAR(50)) RETURNS VOID AS $create_indexes_session$
DECLARE 
	create_indexes TEXT;
BEGIN

	create_indexes = 'CREATE INDEX ' || table_name || '_name_idx ON ' || table_name || '(name); CREATE INDEX ' || table_name || '_login_date_idx ON ' || table_name || '(login_date); CREATE INDEX ' || table_name || '_lang_idx ON ' || table_name || '(lang);';
	EXECUTE create_indexes;

END;
$create_indexes_session$ LANGUAGE plpgsql;




CREATE OR REPLACE RULE request_insert_function AS ON INSERT TO request DO INSTEAD SELECT tr_request ( NEW.id, NEW.time_begin, NEW.time_end, NEW.source_ip, NEW.service, NEW.action_type, NEW.session_id, NEW.user_name, NEW.is_monitoring); 

CREATE OR REPLACE RULE request_data_insert_function AS ON INSERT TO request_data DO INSTEAD SELECT tr_request_data ( NEW.entry_time_begin, NEW.entry_service, NEW.entry_monitoring, NEW.entry_id, NEW.content, NEW.is_response); 

CREATE OR REPLACE RULE request_property_value_insert_function AS ON INSERT TO request_property_value DO INSTEAD SELECT tr_request_property_value ( NEW.entry_time_begin, NEW.entry_service, NEW.entry_monitoring, NEW.id, NEW.entry_id, NEW.name_id, NEW.value, NEW.output, NEW.parent_id);

CREATE OR REPLACE RULE session_insert_function AS ON INSERT TO session
DO INSTEAD SELECT tr_session ( NEW.id, NEW.name, NEW.login_date, NEW.logout_date, NEW.lang); 



