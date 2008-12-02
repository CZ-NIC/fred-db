CREATE TABLE log_entry (
	id SERIAL PRIMARY KEY,
	time_begin timestamp NOT NULL,	-- begin of the transaction
	time_end timestamp,		-- end of transaction, it is set if the information is complete 
					-- e.g. if an error message from backend is successfully logged, it's still set	
					-- NULL in cases like crash of the server
	source_ip INET NOT NULL,
	service integer NOT NULL	-- where does the event come from
);

CREATE TABLE log_raw_content (
	entry_id integer NOT NULL REFERENCES log_entry(id),
	request varchar(2000),
	response varchar(2000)
);

CREATE TABLE log_property_name (
	id SERIAL PRIMARY KEY,
	name varchar(30) NOT NULL
);
	
CREATE TABLE log_property_value (
	id SERIAL PRIMARY KEY,
	entry_id integer NOT NULL REFERENCES log_entry(id),

	name_id integer NOT NULL REFERENCES log_property_name(id),
	value varchar(1024) NOT NULL,		-- property value
	output boolean DEFAULT False		-- whether it's output (response) property; if False it's input (request)
);
	
CREATE INDEX log_entry_time_begin_idx ON log_entry(time_begin);
CREATE INDEX log_entry_time_end_idx ON log_entry(time_end);
CREATE INDEX log_entry_source_ip_idx ON log_entry(source_ip);
CREATE INDEX log_entry_service_idx ON log_entry(service);

CREATE INDEX log_property_value_idx ON log_property_value(value); 
CREATE INDEX log_property_name_idx ON log_property_name(name); 

