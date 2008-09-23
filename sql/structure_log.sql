CREATE TABLE log_entry (
	id serial PRIMARY KEY,
	time timestamp NOT NULL,	-- TODO what type?
	source_ip varchar(15) NOT NULL,
	flag integer NOT NULL,		-- enum type
	component integer NOT NULL,	-- enum type
	content varchar(2000) NOT NULL, -- TODO size
	client_id integer NOT NULL		-- what is this?
	);
	
CREATE TABLE property (
	id SERIAL PRIMARY KEY,
	name varchar(30) UNIQUE		-- property name
);
	
CREATE TABLE property_value (
	entry_id integer NOT NULL REFERENCES log_entry,
	property_id integer NOT NULL REFERENCES property,
	value varchar(1024)
);

CREATE INDEX log_entry_time_idx ON log_entry(time);
CREATE INDEX log_entry_source_ip_idx ON log_entry(source_ip);
CREATE INDEX log_entry_client_id_idx ON log_entry(client_id);
CREATE INDEX property_value_value_idx ON property_value(value); 
