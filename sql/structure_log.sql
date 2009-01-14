CREATE TABLE log_entry (
	id SERIAL PRIMARY KEY,
	time_begin timestamp NOT NULL,	-- begin of the transaction
	time_end timestamp,		-- end of transaction, it is set if the information is complete 
					-- e.g. if an error message from backend is successfully logged, it's still set	
					-- NULL in cases like crash of the server
	source_ip INET,
	service integer NOT NULL	-- where does the event come from
);

CREATE TABLE log_raw_content (
	entry_id integer NOT NULL REFERENCES log_entry(id),
	content varchar(2000) NOT NULL,
	is_response boolean DEFAULT False -- true if the content is response, false if it's request
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
	output boolean DEFAULT False,		-- whether it's output (response) property; if False it's input (request)

	parent_id integer REFERENCES log_property_value(id)
						-- in case of child property, the id of the parent, NULL otherwise
);

CREATE INDEX log_entry_time_begin_idx ON log_entry(time_begin);
CREATE INDEX log_entry_time_end_idx ON log_entry(time_end);
CREATE INDEX log_entry_source_ip_idx ON log_entry(source_ip);
CREATE INDEX log_entry_service_idx ON log_entry(service);

CREATE INDEX log_raw_content_entry_id_idx ON log_raw_content(entry_id);
CREATE INDEX log_raw_content_content_idx ON log_raw_content(content);
CREATE INDEX log_raw_content_is_response_idx ON log_raw_content(is_response);

CREATE INDEX log_property_name_name_idx ON log_property_name(name); 

CREATE INDEX log_property_value_entry_id_idx ON log_property_value(entry_id); 
CREATE INDEX log_property_value_name_id_idx ON log_property_value(name_id); 
CREATE INDEX log_property_value_value_idx ON log_property_value(value); 
CREATE INDEX log_property_value_output_idx ON log_property_value(output); 
CREATE INDEX log_property_value_parent_id_idx ON log_property_value(parent_id); 

