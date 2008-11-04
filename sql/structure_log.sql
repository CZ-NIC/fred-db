CREATE TABLE log_entry (
	id SERIAL PRIMARY KEY,
	time timestamp NOT NULL,	-- TODO what type?
	source_ip varchar(15) NOT NULL,
	flag integer NOT NULL,		-- enum type
	component integer NOT NULL,	-- enum type
	content varchar(2000) NOT NULL -- TODO size
	);
	
CREATE TABLE log_property (
	id SERIAL PRIMARY KEY,
	entry_id integer NOT NULL REFERENCES log_entry,

	name varchar(30) NOT NULL,	-- property name
	value varchar(1024)		-- property value
);
	
CREATE INDEX log_entry_time_idx ON log_entry(time);
CREATE INDEX log_entry_source_ip_idx ON log_entry(source_ip);
CREATE INDEX log_entry_client_id_idx ON log_entry(client_id);
CREATE INDEX log_property_value_idx ON log_property(value); 
CREATE INDEX log_property_name_idx ON log_property(name); 
