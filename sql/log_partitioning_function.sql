-- create or replace function tr_request returns trigger as $tr_request$

/*
functions for each table: 
 - tr_* 'trigger' 
 - create_* creating a new partition
 - create_indexes_* which create indexes (used by create_*)

*/

create or replace function bool_to_str(b boolean) returns char
as $bool_to_str$
begin
	return (select case when b then 't' else 'f' end);
end;
$bool_to_str$ language plpgsql;


create or replace function tr_request(id integer, time_begin timestamp without time zone, time_end timestamp without time zone, source_ip inet, service integer, action_type integer, session_id integer, is_monitoring boolean ) returns void as $tr_request$
DECLARE 
	table_name varchar(50);
	stmt 	   text;
BEGIN

	stmt := 'INSERT INTO request_' || partition_postfix(time_begin, service, is_monitoring) || ' (id, time_begin, time_end, source_ip, service, action_type, session_id, is_monitoring) VALUES (' || id || ', ' || quote_literal(time_begin) || ', ';
	
	if (time_end is null) then
		stmt := stmt || 'null, ';
	else 
		stmt := stmt || quote_literal(time_end) || ', ';
	end if;

	if (source_ip is null) then 
		stmt := stmt || 'null, ';
	else 
		stmt := stmt || quote_literal(host(source_ip)) || ', ';
	end if;
	
	stmt := stmt || service || ', ';

	if (action_type is null) then
		stmt := stmt || 'null, ';
	else 
		stmt := stmt || action_type || ', ';
	end if;

	if (session_id is null) then 	
		stmt := stmt || 'null, ';
	else 
		stmt := stmt || session_id || ', ';
	end if;

	stmt := stmt || '''' || bool_to_str(is_monitoring) || ''') ';

	-- raise notice 'request Generated insert: %', stmt;
	execute stmt;

EXCEPTION
	WHEN undefined_table THEN
	BEGIN
		perform create_tbl_request(time_begin, service, is_monitoring);
	
		execute stmt;
	END;
END;
$tr_request$ language plpgsql;


-- session is partitioned according to date only
create or replace function tr_session(id integer, name varchar(255), login_date timestamp, logout_date timestamp, lang varchar(2)) returns void as $tr_session$
DECLARE 
	stmt  text;
BEGIN
	stmt := 'INSERT INTO session_' || partition_postfix(login_date, -1, false) || ' (id, name, login_date, logout_date, lang) VALUES (' || id || ', ' || quote_literal(name) || ', ';
	
	if (login_date is null) then
		stmt := stmt || 'null, ';
	else 
		stmt := stmt || quote_literal(login_date)  || ', ';
	end if;

	if (logout_date is null) then
		stmt := stmt || 'null, ';
	else 
		stmt := stmt || quote_literal(logout_date) || ', ';
	end if;

	stmt := stmt || quote_literal(lang) || ')';

	-- raise notice 'session Generated insert: %', stmt;
	execute stmt;

EXCEPTION
	WHEN undefined_table THEN
	BEGIN
		perform create_tbl_session(login_date);
	
		execute stmt;
	END;
END;
$tr_session$ language plpgsql;

create or replace function tr_request_data(entry_time_begin timestamp, entry_service integer,  entry_monitoring boolean, entry_id integer, content text, is_response boolean) returns void as $tr_request_data$
DECLARE 
	stmt  text;
BEGIN
	stmt := 'INSERT INTO request_data_' || partition_postfix(entry_time_begin, entry_service, entry_monitoring) || '(entry_time_begin, entry_service, entry_monitoring, entry_id,  content, is_response) VALUES (' || quote_literal(entry_time_begin) || ', ' ||
		entry_service    || ', ''' ||
		bool_to_str(entry_monitoring) || ''', ' || 
		entry_id || ', ' ||
		quote_literal(content) || ', ';
		
	if (is_response is null) then 
		stmt := stmt || 'null) ';
	else 
		stmt := stmt || '''' || bool_to_str(is_response) || ''') ';
	end if;

	-- raise notice 'request_data Generated insert: %', stmt;
	execute stmt;

EXCEPTION
	WHEN undefined_table THEN
	BEGIN
		perform create_tbl_request_data(entry_time_begin, entry_service, entry_monitoring);
	
		execute stmt;
	END;
END;
$tr_request_data$ language plpgsql;


create or replace function tr_request_property_value(entry_time_begin timestamp without time zone, entry_service integer, entry_monitoring boolean, id integer, entry_id integer, name_id integer, value text, output boolean, parent_id integer) returns void as $tr_request_property_value$
DECLARE 
	stmt  text;
BEGIN
	stmt := 'INSERT INTO request_property_value_' || partition_postfix(entry_time_begin, entry_service, entry_monitoring) || '(entry_time_begin, entry_service, entry_monitoring, id, entry_id, name_id, value, output, parent_id) VALUES (' || quote_literal(entry_time_begin) || ', ' || entry_service || ', ''' || bool_to_str(entry_monitoring) || ''', ';

	if (id is null) then
		stmt := stmt || ' null, ';
	else 
		stmt := stmt || id || ', '; 
	end if;

	stmt := stmt || entry_id || ', ' || name_id || ', ' || quote_literal(value) || ', ';	

	if (output is null) then 
		stmt := stmt || 'null, ';
	else 
		stmt := stmt || '''' || bool_to_str(output) || ''', ';
	end if;

	if (parent_id is null) then
		stmt := stmt || 'null)';
	else 
		stmt := stmt || parent_id || ')';
	end if;

	-- raise notice 'request_property_value Generated insert: %', stmt;
	execute stmt;

EXCEPTION
	WHEN undefined_table THEN
	BEGIN
		perform create_tbl_request_property_value(entry_time_begin, entry_service, entry_monitoring);
	
		execute stmt;
	END;
END;
$tr_request_property_value$ language plpgsql;

-- can handle years from 2000 to 2099
-- this dependes on LogServiceType in log_impl.h and in _dataTypes.idl
-- but slightly faster than the latter version
/*
create or replace function partition_postfix(rec_time timestamp without time zone, service integer, is_monitoring boolean ) returns varchar(40) as 
$partition_postfix$
declare 
	date_part varchar(5);
begin
	date_part := to_char(date_trunc('month', rec_time), 'YY_MM');

	if (service = -1) then
		-- for session which is not partitioned by service
		return date_part;
	elsif (is_monitoring) then
		return 'mon_' || date_part;	
		-- separate partition for monitoring requests
	elsif (service = 0) then
		return 'whois_' || date_part;
	elsif (service = 1) then		 
		return 'webwhois_' || date_part;
	elsif (service = 2) then		 
		return 'pubreq_' || date_part;
	elsif (service = 3) then		 
		return 'epp_' || date_part;
	elsif (service = 4) then		 
		return 'webadmin_' || date_part;
	elsif (service = 5) then 
		return 'intranet_' || date_part;
	end if;
	
	raise exception 'Unknown service type number: % ', service;

end;
$partition_postfix$ language plpgsql;
*/


create or replace function partition_postfix(rec_time timestamp without time zone, serv integer, is_monitoring boolean ) returns varchar(40) as 
$partition_postfix_alt$
declare 
	date_part varchar(5);
	service_postfix varchar(10);
begin
	date_part := to_char(date_trunc('month', rec_time), 'YY_MM');

	if (serv = -1) then
		return date_part;
	elsif (is_monitoring) then
		return 'mon_' || date_part;	
	else
		select partition_postfix into service_postfix from service where id = serv;
		return service_postfix || date_part;
	end if;
end;
$partition_postfix_alt$ language plpgsql;


create or replace function create_tbl_request(time_begin timestamp without time zone, service integer, monitoring boolean) returns void as $create_tbl_request$
declare 
	table_name varchar(60);
	table_base varchar(60);
	create_table 	text;
	spec_alter_table text;
	alter_table 	text;
	month integer;
	lower timestamp without time zone;
	upper  timestamp without time zone;

begin
	table_base := 'request';
	table_name := table_base || '_' || partition_postfix(time_begin, service, monitoring);

	lower := to_char(date_trunc('month', time_begin), 'YYYY-MM-DD');
	upper := to_char(date_trunc('month', time_begin + interval '1 month'), 'YYYY-MM-DD');

-- create table
	if monitoring = true then
		-- special constraints for monitoring table
		create_table := 'CREATE TABLE ' || table_name || '    (CHECK (time_begin >= TIMESTAMP ''' || lower || ''' and time_begin < TIMESTAMP ''' 
		|| upper || ''' AND is_monitoring = ''' || bool_to_str(monitoring) || ''') ) INHERITS (' || table_base || ')';
	else
		create_table := 'CREATE TABLE ' || table_name || '    (CHECK (time_begin >= TIMESTAMP ''' || lower || ''' and time_begin < TIMESTAMP ''' 
		|| upper || ''' AND service = ' || service || ' AND is_monitoring = ''' || bool_to_str(monitoring) || ''') ) INHERITS (' || table_base || ')';  	
	end if; 
	 
	
	spec_alter_table := 'ALTER TABLE ' || table_name || ' ADD PRIMARY KEY (id); ';
	alter_table := 'ALTER TABLE ' || table_name || ' DROP CONSTRAINT ' || table_base || '_no_insert_root';

	execute create_table;
	execute spec_alter_table;
	execute alter_table;

	perform create_indexes_request(table_name);

end;
$create_tbl_request$ language plpgsql;

create or replace function create_indexes_request(table_name varchar(50)) returns void as $create_indexes_request$
declare 
	create_indexes text;
begin
	create_indexes := 'CREATE INDEX ' || table_name || '_time_begin_idx ON ' || table_name || '(time_begin); CREATE INDEX ' 
					|| table_name || '_time_end_idx ON ' || table_name || '(time_end); CREATE INDEX ' 
					|| table_name || '_source_ip_idx ON ' || table_name || '(source_ip); CREATE INDEX ' 
					|| table_name || '_service_idx ON ' || table_name || '(service); CREATE INDEX ' 
					|| table_name || '_action_type_idx ON ' || table_name || '(action_type); CREATE INDEX '
					|| table_name || '_monitoring_idx ON ' || table_name || '(is_monitoring);';
	execute create_indexes;
end;
$create_indexes_request$ language plpgsql;

create or replace function create_tbl_request_data(time_begin timestamp without time zone, service integer, monitoring boolean) returns void as $create_tbl_request_data$
declare 
	table_name varchar(60);
	table_base varchar(60);
	table_postfix varchar(40);
	create_table 	text;
	spec_alter_table text;
	alter_table 	text;
	month integer;
	lower timestamp without time zone;
	upper  timestamp without time zone;
begin
	table_base := 'request_data';
	table_postfix := partition_postfix(time_begin, service, monitoring);
	table_name := table_base || '_' || table_postfix;

	lower := to_char(date_trunc('month', time_begin), 'YYYY-MM-DD');
	upper := to_char(date_trunc('month', time_begin + interval '1 month'), 'YYYY-MM-DD');

	if monitoring = true then
		create_table  =  'CREATE TABLE ' || table_name || ' (CHECK (entry_time_begin >= TIMESTAMP ''' || lower || ''' and entry_time_begin < TIMESTAMP ''' || upper || ''' AND entry_monitoring = ''' || bool_to_str(monitoring) || ''') ) INHERITS (' || table_base || ') ';	
	else 
		create_table  =  'CREATE TABLE ' || table_name || ' (CHECK (entry_time_begin >= TIMESTAMP ''' || lower || ''' and entry_time_begin < TIMESTAMP ''' || upper || ''' AND entry_service = ' || service || ' AND entry_monitoring = ''' || bool_to_str(monitoring) || ''') ) INHERITS (' || table_base || ') ';
	end if;
	
	spec_alter_table = 'ALTER TABLE ' || table_name || ' ADD CONSTRAINT ' || table_name || '_entry_id_fkey FOREIGN KEY (entry_id) REFERENCES request_' || table_postfix || '(id); ';

	alter_table = 'ALTER TABLE ' || table_name || ' DROP CONSTRAINT ' || table_base || '_no_insert_root';

	execute create_table;
	execute spec_alter_table;
	execute alter_table;
	
	perform create_indexes_request_data(table_name);

end;
$create_tbl_request_data$ language plpgsql;

-- create index on content removed (too large rows)
create or replace function create_indexes_request_data(table_name varchar(50)) returns void as $create_indexes_request_data$
declare 
	create_indexes text;
begin
	create_indexes = 'CREATE INDEX ' || table_name || '_entry_time_begin_idx ON ' || table_name || '(entry_time_begin); CREATE INDEX ' || table_name || '_entry_id_idx ON ' || table_name || '(entry_id); CREATE INDEX ' || table_name || '_is_response_idx ON ' || table_name || '(is_response);';
	execute create_indexes;
end;
$create_indexes_request_data$ language plpgsql;

create or replace function create_tbl_request_property_value(time_begin timestamp without time zone, service integer, monitoring boolean) returns void as $create_tbl_request_property_value$
declare 
	table_name varchar(60);
	table_base varchar(60);
	table_postfix varchar (40);
	create_table 	text;
	spec_alter_table text;
	alter_table 	text;
	month integer;
	lower timestamp without time zone;
	upper  timestamp without time zone;
begin
	table_base := 'request_property_value';
	table_postfix := partition_postfix(time_begin, service, monitoring);
	table_name := table_base || '_' || table_postfix; 


	lower := to_char(date_trunc('month', time_begin), 'YYYY-MM-DD');
	upper := to_char(date_trunc('month', time_begin + interval '1 month'), 'YYYY-MM-DD');

	if monitoring = true then
		create_table  =  'CREATE TABLE ' || table_name || ' (CHECK (entry_time_begin >= TIMESTAMP ''' || lower || ''' and entry_time_begin < TIMESTAMP ''' || upper || '''  AND entry_monitoring = ''' || bool_to_str(monitoring) || ''') ) INHERITS (' || table_base || ') ';
	else 
		create_table  =  'CREATE TABLE ' || table_name || ' (CHECK (entry_time_begin >= TIMESTAMP ''' || lower || ''' and entry_time_begin < TIMESTAMP ''' || upper || '''  AND entry_service = ' || service || ' AND entry_monitoring = ''' || bool_to_str(monitoring) || ''') ) INHERITS (' || table_base || ') ';
	end if;		

	spec_alter_table = 'ALTER TABLE ' || table_name || ' ADD PRIMARY KEY (id); ALTER TABLE ' || table_name || ' ADD CONSTRAINT ' || table_name || '_entry_id_fkey FOREIGN KEY (entry_id) REFERENCES request_' || table_postfix || '(id); ALTER TABLE ' || table_name || ' ADD CONSTRAINT ' || table_name || '_name_id_fkey FOREIGN KEY (name_id) REFERENCES request_property(id); ALTER TABLE ' || table_name || ' ADD CONSTRAINT ' || table_name || '_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES ' || table_name || '(id); ';


	alter_table  = 'ALTER TABLE ' || table_name || ' DROP CONSTRAINT ' || table_base || '_no_insert_root';

	execute create_table;
	execute spec_alter_table;
	execute alter_table;
	perform create_indexes_request_property_value(table_name);

end;
$create_tbl_request_property_value$ language plpgsql;


create or replace function create_indexes_request_property_value(table_name varchar(50)) returns void as $create_indexes_request_property_value$
declare 
	create_indexes text;
begin
	create_indexes = 'CREATE INDEX ' || table_name || '_entry_time_begin_idx ON ' || table_name || '(entry_time_begin); CREATE INDEX ' || table_name || '_entry_id_idx ON ' || table_name || '(entry_id); CREATE INDEX ' || table_name || '_name_id_idx ON ' || table_name || '(name_id); CREATE INDEX ' || table_name || '_value_idx ON ' || table_name || '(value); CREATE INDEX ' || table_name || '_output_idx ON ' || table_name || '(output); CREATE INDEX ' || table_name || '_parent_id_idx ON ' || table_name || '(parent_id);';
	execute create_indexes;

end;
$create_indexes_request_property_value$ language plpgsql;


create or replace function create_tbl_session(time_begin timestamp without time zone) returns void as $create_tbl_session$
declare 
	table_name varchar(60);
	table_base varchar(60);
	create_table 	text;
	spec_alter_table text;
	alter_table 	text;
	month integer;
	lower timestamp without time zone;
	upper  timestamp without time zone;

begin
	table_base := 'session';
	table_name := table_base || '_' || partition_postfix(time_begin, -1);

	lower := to_char(date_trunc('month', time_begin), 'YYYY-MM-DD');
	upper := to_char(date_trunc('month', time_begin + interval '1 month'), 'YYYY-MM-DD');

	create_table =  'CREATE TABLE ' || table_name || '    (CHECK (login_date >= TIMESTAMP ''' || lower || ''' and login_date < TIMESTAMP ''' || upper || ''') ) INHERITS (' || table_base || ') ';

	spec_alter_table = 'ALTER TABLE ' || table_name || ' ADD PRIMARY KEY (id); ';

	alter_table  = 'ALTER TABLE ' || table_name || ' DROP CONSTRAINT ' || table_base || '_no_insert_root';

	execute create_table;
	execute spec_alter_table;
	execute alter_table;

	perform create_indexes_session(table_name);

end;
$create_tbl_session$ language plpgsql;

create or replace function create_indexes_session(table_name varchar(50)) returns void as $create_indexes_session$
declare 
	create_indexes text;
begin

	create_indexes = 'CREATE INDEX ' || table_name || '_name_idx ON ' || table_name || '(name); CREATE INDEX ' || table_name || '_login_date_idx ON ' || table_name || '(login_date); CREATE INDEX ' || table_name || '_lang_idx ON ' || table_name || '(lang);';
	execute create_indexes;

end;
$create_indexes_session$ language plpgsql;




CREATE OR REPLACE RULE request_insert_function AS ON INSERT TO request DO INSTEAD SELECT tr_request ( NEW.id, NEW.time_begin, NEW.time_end, NEW.source_ip, NEW.service, NEW.action_type, NEW.session_id, NEW.is_monitoring); 

CREATE OR REPLACE RULE request_data_insert_function AS ON INSERT TO request_data DO INSTEAD SELECT tr_request_data ( NEW.entry_time_begin, NEW.entry_service, NEW.entry_monitoring, NEW.entry_id, NEW.content, NEW.is_response); 

CREATE OR REPLACE RULE request_property_value_insert_function AS ON INSERT TO request_property_value DO INSTEAD SELECT tr_request_property_value ( NEW.entry_time_begin, NEW.entry_service, NEW.entry_monitoring, NEW.id, NEW.entry_id, NEW.name_id, NEW.value, NEW.output, NEW.parent_id);

CREATE OR REPLACE RULE session_insert_function AS ON INSERT TO session
DO INSTEAD SELECT tr_session ( NEW.id, NEW.name, NEW.login_date, NEW.logout_date, NEW.lang); 



