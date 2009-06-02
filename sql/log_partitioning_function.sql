-- TODO table names inline
-- TODO create rule on insert shouldn't be used

-- create or replace function tr_log_entry returns trigger as $tr_log_entry$

/*
functions for each table: 
 - tr_* 'trigger' 
 - create_* creating a new partition
 - create_indexes_* which create indexes (used by create_*)

*/

create or replace function tr_log_entry(id integer, time_begin timestamp without time zone, time_end timestamp without time zone, source_ip inet, service integer, action_type integer, is_monitoring boolean ) returns void as $tr_log_entry$
DECLARE 
	table_name varchar(50);
	stmt 	   text;
BEGIN

	-- TODO service for partition_postfix
	stmt := 'INSERT INTO log_entry_' || partition_postfix(time_begin, service) || ' VALUES (' || id || ', ' || quote_literal(time_begin) || ', ';
	
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

	stmt := stmt || '''' || (select case when is_monitoring then 't' else 'f' end) || ''') ';

	-- raise notice 'log_entry Generated insert: %', stmt;
	execute stmt;

EXCEPTION
	WHEN undefined_table THEN
	BEGIN
		perform create_log_entry(time_begin, service);
	
		execute stmt;
	END;
END;
$tr_log_entry$ language plpgsql;


create or replace function tr_log_session(id integer, name varchar(255), login_date timestamp, logout_date timestamp, login_TRID varchar(128), logout_TRID varchar(128), lang varchar(2)) returns void as $tr_log_session$
DECLARE 
	stmt  text;
BEGIN
	-- TODO supply also service number (depending on the partitioning column used)

	stmt := 'INSERT INTO log_session_' || partition_postfix(login_date, 99) || ' VALUES (' || id || ', ' || quote_literal(name) || ', ';
	
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

	if (login_TRID is null) then 
		stmt := stmt || 'null, ';
	else 
		stmt := stmt || quote_literal(login_TRID)  || ', ';
	end if;
	
	if (logout_TRID is null) then 
		stmt := stmt || 'null, ';
	else 
		stmt := stmt || quote_literal(logout_TRID) || ', ';
	end if;
	
	stmt := stmt || quote_literal(lang) || ')';

	-- raise notice 'log_session Generated insert: %', stmt;
	execute stmt;

EXCEPTION
	WHEN undefined_table THEN
	BEGIN
		perform create_log_session(login_date, 99);
	
		execute stmt;
	END;
END;
$tr_log_session$ language plpgsql;

create or replace function tr_log_raw_content(entry_time_begin timestamp, entry_id integer, content text, is_response boolean) returns void as $tr_log_raw_content$
DECLARE 
	stmt  text;
BEGIN
	-- TODO supply also service number (depending on the partitioning column used)

	stmt := 'INSERT INTO log_raw_content_' || partition_postfix(entry_time_begin, 99) || ' VALUES (' || quote_literal(entry_time_begin) || ', ' ||
		entry_id || ', ' ||
		quote_literal(content) || ', ';
		
	if (is_response is null) then 
		stmt := stmt || 'null) ';
	else 
		stmt := stmt || '''' || (select case when is_response then 't' else 'f' end) || ''') ';
	end if;

	-- raise notice 'log_raw_content Generated insert: %', stmt;
	execute stmt;

EXCEPTION
	WHEN undefined_table THEN
	BEGIN
		perform create_log_raw_content(entry_time_begin, 99);
	
		execute stmt;
	END;
END;
$tr_log_raw_content$ language plpgsql;


create or replace function tr_log_property_value(entry_time_begin timestamp, id integer, entry_id integer, name_id integer, value text, output boolean, parent_id integer) returns void as $tr_log_property_value$
DECLARE 
	stmt  text;
BEGIN
	-- TODO supply also service number (depending on the partitioning column used)

	stmt := 'INSERT INTO log_property_value_' || partition_postfix(entry_time_begin, 99) || ' VALUES (' || quote_literal(entry_time_begin) || ', ';

	if (id is null) then
		stmt := stmt || ' null, ';
	else 
		stmt := stmt || id || ', '; 
	end if;

	stmt := stmt || entry_id || ', ' || name_id || ', ' || quote_literal(value) || ', ';	

	if (output is null) then 
		stmt := stmt || 'null, ';
	else 
		stmt := stmt || '''' || (select case when output then 't' else 'f' end) || ''', ';
	end if;

	if (parent_id is null) then
		stmt := stmt || 'null)';
	else 
		stmt := stmt || parent_id || ')';
	end if;

	-- raise notice 'log_property_value Generated insert: %', stmt;
	execute stmt;

EXCEPTION
	WHEN undefined_table THEN
	BEGIN
		perform create_log_property_value(entry_time_begin, 99);
	
		execute stmt;
	END;
END;
$tr_log_property_value$ language plpgsql;

-- can handle years from 2000 to 2099
create or replace function partition_postfix(rec_time timestamp without time zone, service integer) returns varchar(40) as 
$partition_postfix$
declare 
	date_part varchar(5);
begin
	return to_char(date_trunc('month', rec_time), 'YY_MM');

end;
$partition_postfix$ language plpgsql;


create or replace function create_log_entry(time_begin timestamp without time zone, service integer) returns void as $create_log_entry$
declare 
	table_name varchar(30);
	table_base varchar(30);
	create_table 	text;
	create_rule 	text;
	spec_alter_table text;
	alter_table 	text;
	month integer;
	lower timestamp without time zone;
	upper  timestamp without time zone;

begin
	-- TODO change
	table_base := 'log_entry';
	table_name := table_base || '_' || partition_postfix(time_begin, service);

	lower := to_char(date_trunc('month', time_begin), 'YYYY-MM-DD');
	upper := to_char(date_trunc('month', time_begin + interval '1 month'), 'YYYY-MM-DD');

-- create table
	create_table := 'CREATE TABLE ' || table_name || '    (CHECK (time_begin >= TIMESTAMP ''' || lower || ''' and time_begin < TIMESTAMP ''' 
	|| upper || ''') ) INHERITS (' || table_base || ')';

-- create rule - TODO this is to be removed
	create_rule  := 'CREATE RULE ' || table_name || ' AS ON INSERT TO ' || table_base || ' WHERE (time_begin >= TIMESTAMP ''' || lower || ''' and time_begin < TIMESTAMP ''' || upper || 
	''') DO INSTEAD INSERT INTO ' || table_name || 
	' VALUES ( NEW.id, NEW.time_begin, NEW.time_end, NEW.source_ip, NEW.service, NEW.action_type, NEW.is_monitoring); ';

	spec_alter_table := 'ALTER TABLE ' || table_name || ' ADD PRIMARY KEY (id); ';
	alter_table := 'ALTER TABLE ' || table_name || ' DROP CONSTRAINT ' || table_base || '_no_insert_root';

	execute create_table;
	-- execute create_rule;
	execute spec_alter_table;
	execute alter_table;

	perform create_indexes_log_entry(table_name);

end;
$create_log_entry$ language plpgsql;

create or replace function create_indexes_log_entry(table_name varchar(50)) returns void as $create_indexes_log_entry$
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
$create_indexes_log_entry$ language plpgsql;

create or replace function create_log_raw_content(time_begin timestamp without time zone, service integer) returns void as $create_log_raw_content$
declare 
	table_name varchar(30);
	table_base varchar(30);
	table_postfix varchar(20);
	create_table 	text;
	create_rule 	text;
	spec_alter_table text;
	alter_table 	text;
	month integer;
	lower timestamp without time zone;
	upper  timestamp without time zone;
begin
	-- TODO change
	table_base := 'log_raw_content';
	table_postfix := partition_postfix(time_begin, service);
	table_name := table_base || '_' || table_postfix;

	lower := to_char(date_trunc('month', time_begin), 'YYYY-MM-DD');
	upper := to_char(date_trunc('month', time_begin + interval '1 month'), 'YYYY-MM-DD');

	create_table  =  'CREATE TABLE ' || table_name || '    (CHECK (entry_time_begin >= TIMESTAMP ''' || lower || ''' and entry_time_begin < TIMESTAMP ''' || upper || ''') ) INHERITS (' || table_base || ') ';

	create_rule =  'CREATE RULE ' || table_name || ' AS ON INSERT TO ' || table_base || ' WHERE (entry_time_begin >= TIMESTAMP ''' || lower || ''' and entry_time_begin < TIMESTAMP ''' || upper || ''') DO INSTEAD INSERT INTO ' || table_name || ' VALUES ( NEW.entry_time_begin, NEW.entry_id, NEW.content, NEW.is_response); ';

	spec_alter_table = 'ALTER TABLE ' || table_name || ' ADD CONSTRAINT ' || table_name || '_entry_id_fkey FOREIGN KEY (entry_id) REFERENCES log_entry_' || table_postfix || '(id); ';

	alter_table = 'ALTER TABLE ' || table_name || ' DROP CONSTRAINT ' || table_base || '_no_insert_root';

	execute create_table;
	-- execute create_rule;
	execute spec_alter_table;
	execute alter_table;
	
	perform create_indexes_log_raw_content(table_name);

end;
$create_log_raw_content$ language plpgsql;

-- create index on content removed (too large rows)
create or replace function create_indexes_log_raw_content(table_name varchar(50)) returns void as $create_indexes_log_raw_content$
declare 
	create_indexes text;
begin
	create_indexes = 'CREATE INDEX ' || table_name || '_entry_time_begin_idx ON ' || table_name || '(entry_time_begin); CREATE INDEX ' || table_name || '_entry_id_idx ON ' || table_name || '(entry_id); CREATE INDEX ' || table_name || '_is_response_idx ON ' || table_name || '(is_response);';
	execute create_indexes;
end;
$create_indexes_log_raw_content$ language plpgsql;

create or replace function create_log_property_value(time_begin timestamp without time zone, service integer) returns void as $create_log_property_value$
declare 
	table_name varchar(30);
	table_base varchar(30);
	table_postfix varchar (20);
	create_table 	text;
	create_rule 	text;
	spec_alter_table text;
	alter_table 	text;
	month integer;
	lower timestamp without time zone;
	upper  timestamp without time zone;
begin
	-- TODO change
	table_base := 'log_property_value';
	table_postfix := partition_postfix(time_begin, service);
	table_name := table_base || '_' || table_postfix; 


	lower := to_char(date_trunc('month', time_begin), 'YYYY-MM-DD');
	upper := to_char(date_trunc('month', time_begin + interval '1 month'), 'YYYY-MM-DD');


	create_table  =  'CREATE TABLE ' || table_name || '    (CHECK (entry_time_begin >= TIMESTAMP ''' || lower || ''' and entry_time_begin < TIMESTAMP ''' || upper || ''') ) INHERITS (' || table_base || ') ';

	create_rule =  'CREATE RULE ' || table_name || ' AS ON INSERT TO ' || table_base || ' WHERE (entry_time_begin >= TIMESTAMP ''' || lower || ''' and entry_time_begin < TIMESTAMP ''' || upper || ''') DO INSTEAD INSERT INTO ' || table_name || ' VALUES ( NEW.entry_time_begin, NEW.id, NEW.entry_id, NEW.name_id, NEW.value, NEW.output, NEW.parent_id); ';

	spec_alter_table = 'ALTER TABLE ' || table_name || ' ADD PRIMARY KEY (id); ALTER TABLE ' || table_name || ' ADD CONSTRAINT ' || table_name || '_entry_id_fkey FOREIGN KEY (entry_id) REFERENCES log_entry_' || table_postfix || '(id); ALTER TABLE ' || table_name || ' ADD CONSTRAINT ' || table_name || '_name_id_fkey FOREIGN KEY (name_id) REFERENCES log_property_name(id); ALTER TABLE ' || table_name || ' ADD CONSTRAINT ' || table_name || '_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES ' || table_name || '(id); ';


	alter_table  = 'ALTER TABLE ' || table_name || ' DROP CONSTRAINT ' || table_base || '_no_insert_root';

	execute create_table;
	-- execute create_rule;
	execute spec_alter_table;
	execute alter_table;
	perform create_indexes_log_property_value(table_name);

end;
$create_log_property_value$ language plpgsql;


create or replace function create_indexes_log_property_value(table_name varchar(50)) returns void as $create_indexes_log_property_value$
declare 
	create_indexes text;
begin
	create_indexes = 'CREATE INDEX ' || table_name || '_entry_time_begin_idx ON ' || table_name || '(entry_time_begin); CREATE INDEX ' || table_name || '_entry_id_idx ON ' || table_name || '(entry_id); CREATE INDEX ' || table_name || '_name_id_idx ON ' || table_name || '(name_id); CREATE INDEX ' || table_name || '_value_idx ON ' || table_name || '(value); CREATE INDEX ' || table_name || '_output_idx ON ' || table_name || '(output); CREATE INDEX ' || table_name || '_parent_id_idx ON ' || table_name || '(parent_id);';
	execute create_indexes;

end;
$create_indexes_log_property_value$ language plpgsql;


create or replace function create_log_session(time_begin timestamp without time zone, service integer) returns void as $create_log_session$
declare 
	table_name varchar(30);
	table_base varchar(30);
	create_table 	text;
	create_rule 	text;
	spec_alter_table text;
	alter_table 	text;
	month integer;
	lower timestamp without time zone;
	upper  timestamp without time zone;

begin
	-- TODO change
	table_base := 'log_session';
	table_name := table_base || '_' || partition_postfix(time_begin, service);

	lower := to_char(date_trunc('month', time_begin), 'YYYY-MM-DD');
	upper := to_char(date_trunc('month', time_begin + interval '1 month'), 'YYYY-MM-DD');

	create_table =  'CREATE TABLE ' || table_name || '    (CHECK (login_date >= TIMESTAMP ''' || lower || ''' and login_date < TIMESTAMP ''' || upper || ''') ) INHERITS (' || table_base || ') ';

	create_rule =  'CREATE RULE ' || table_name || ' AS ON INSERT TO ' || table_base || ' WHERE (login_date >= TIMESTAMP ''' || lower || ''' and login_date < TIMESTAMP ''' || upper || ''') DO INSTEAD INSERT INTO ' || table_name || ' VALUES ( NEW.id, NEW.name, NEW.login_date, NEW.logout_date, NEW.login_TRID, NEW.logout_TRID, NEW.lang); ';

	spec_alter_table = 'ALTER TABLE ' || table_name || ' ADD PRIMARY KEY (id); ';


	alter_table  = 'ALTER TABLE ' || table_name || ' DROP CONSTRAINT ' || table_base || '_no_insert_root';

	execute create_table;
	-- execute create_rule;
	execute spec_alter_table;
	execute alter_table;

	perform create_indexes_log_session(table_name);

end;
$create_log_session$ language plpgsql;

create or replace function create_indexes_log_session(table_name varchar(50)) returns void as $create_indexes_log_session$
declare 
	create_indexes text;
begin

	create_indexes = 'CREATE INDEX ' || table_name || '_name_idx ON ' || table_name || '(name); CREATE INDEX ' || table_name || '_login_date_idx ON ' || table_name || '(login_date); CREATE INDEX ' || table_name || '_lang_idx ON ' || table_name || '(lang);';
	execute create_indexes;

end;
$create_indexes_log_session$ language plpgsql;


CREATE RULE log_entry_insert_function AS ON INSERT TO log_entry DO INSTEAD SELECT tr_log_entry ( NEW.id, NEW.time_begin, NEW.time_end, NEW.source_ip, NEW.service, NEW.action_type, NEW.is_monitoring); 

CREATE RULE log_raw_content_insert_function AS ON INSERT TO log_raw_content DO INSTEAD SELECT tr_log_raw_content ( NEW.entry_time_begin, NEW.entry_id, NEW.content, NEW.is_response); 

CREATE RULE log_property_value_insert_function AS ON INSERT TO log_property_value DO INSTEAD SELECT tr_log_property_value ( NEW.entry_time_begin, NEW.id, NEW.entry_id, NEW.name_id, NEW.value, NEW.output, NEW.parent_id);

CREATE RULE log_session_insert_function AS ON INSERT TO log_session
DO INSTEAD SELECT tr_log_session ( NEW.id, NEW.name, NEW.login_date, NEW.logout_date, NEW.login_TRID, NEW.logout_TRID, NEW.lang); 



