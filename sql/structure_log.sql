CREATE TABLE log_action_type (
        id SERIAL PRIMARY KEY,
        status varchar(64) UNIQUE NOT NULL
        );

CREATE TABLE log_entry (
    CONSTRAINT log_entry_no_insert_root CHECK (false),   -- constraint for partitioned table
    
	id SERIAL PRIMARY KEY,
	time_begin timestamp NOT NULL,	-- begin of the transaction
	time_end timestamp,		-- end of transaction, it is set if the information is complete 
					-- e.g. if an error message from backend is successfully logged, it's still set	
					-- NULL in cases like crash of the server
	source_ip INET,
	service integer NOT NULL,	-- service code - enum LogServiceType
	action_type integer REFERENCES log_action_type(id) DEFAULT 1000,
		
	is_monitoring boolean NOT NULL
);

CREATE TABLE log_raw_content (
	CONSTRAINT log_raw_content_no_insert_root CHECK (false), -- constraint for partitioned table

	entry_time_begin timestamp NOT NULL, -- TEMP: for partitioning


	entry_id integer NOT NULL REFERENCES log_entry(id),
	content text NOT NULL,
	is_response boolean DEFAULT False -- true if the content is response, false if it's request
);

CREATE TABLE log_property_name (
	id SERIAL PRIMARY KEY,
	name varchar(30) NOT NULL
);
	
CREATE TABLE log_property_value (
	CONSTRAINT log_property_value_no_insert_root CHECK (false),    -- constraint for partitioned table

	entry_time_begin timestamp NOT NULL, -- TEMP: for partitioning
	
	id SERIAL PRIMARY KEY,
	entry_id integer NOT NULL REFERENCES log_entry(id),

	name_id integer NOT NULL REFERENCES log_property_name(id),
	value text NOT NULL,		-- property value
	output boolean DEFAULT False,		-- whether it's output (response) property; if False it's input (request)

	parent_id integer REFERENCES log_property_value(id)
						-- in case of child property, the id of the parent, NULL otherwise
);

CREATE TABLE log_session (
	CONSTRAINT log_session_no_insert_root CHECK (false),    -- constraint for partitioned table

	id serial primary key,
	name varchar(255) not null,
	login_date timestamp not null default now(), 
	logout_date timestamp,

	login_TRID varchar(128),
	logout_TRID varchar(128),
	lang varchar(2) not null default 'en'
);

CREATE INDEX log_entry_time_begin_idx ON log_entry(time_begin);
CREATE INDEX log_entry_time_end_idx ON log_entry(time_end);
CREATE INDEX log_entry_source_ip_idx ON log_entry(source_ip);
CREATE INDEX log_entry_service_idx ON log_entry(service);
CREATE INDEX log_entry_action_type_idx ON log_entry(action_type);
CREATE INDEX log_entry_monitoring_idx ON log_entry(is_monitoring);

CREATE INDEX log_raw_content_entry_time_begin_idx ON log_raw_content(entry_time_begin);
CREATE INDEX log_raw_content_entry_id_idx ON log_raw_content(entry_id);
CREATE INDEX log_raw_content_content_idx ON log_raw_content(content);
CREATE INDEX log_raw_content_is_response_idx ON log_raw_content(is_response);

CREATE INDEX log_property_name_name_idx ON log_property_name(name); 

CREATE INDEX log_property_value_entry_time_begin_idx ON log_property_value(entry_time_begin);
CREATE INDEX log_property_value_entry_id_idx ON log_property_value(entry_id); 
CREATE INDEX log_property_value_name_id_idx ON log_property_value(name_id); 
CREATE INDEX log_property_value_value_idx ON log_property_value(value); 
CREATE INDEX log_property_value_output_idx ON log_property_value(output); 
CREATE INDEX log_property_value_parent_id_idx ON log_property_value(parent_id); 

CREATE INDEX log_session_name_idx ON log_session(name);
CREATE INDEX log_session_login_date_idx ON log_session(login_date);
CREATE INDEX log_session_lang_idx ON log_session(lang);

COMMENT ON TABLE log_action_type IS 
'List of requests which can be used by clients

id  - status
100 - ClientLogin
101 - ClientLogout
120 - PollAcknowledgement
121 - PollResponse
200 - ContactCheck
201 - ContactInfo
202 - ContactDelete
203 - ContactUpdate
204 - ContactCreate
205 - ContactTransfer
400 - NSsetCheck
401 - NSsetInfo
402 - NSsetDelete
403 - NSsetUpdate
404 - NSsetCreate
405 - NSsetTransfer
500 - DomainCheck
501 - DomainInfo
502 - DomainDelete
503 - DomainUpdate
504 - DomainCreate
505 - DomainTransfer
506 - DomainRenew
507 - DomainTrade
1000 - UnknownAction
1002 - ListContact
1004 - ListNSset
1005 - ListDomain
1010 - ClientCredit
1012 - nssetTest
1101 - ContactSendAuthInfo
1102 - NSSetSendAuthInfo
1103 - DomainSendAuthInfo
1104 - Info
1105 - GetInfoResults';

-- login function
INSERT INTO log_action_type (id , status) VALUES(100 , 'ClientLogin');
INSERT INTO log_action_type (id , status) VALUES(101 , 'ClientLogout');
-- poll function
INSERT INTO log_action_type (id , status) VALUES(  120 , 'PollAcknowledgement' );
INSERT INTO log_action_type (id , status) VALUES(  121 ,  'PollResponse' );

 
-- function for working with contacts
INSERT INTO log_action_type (id , status) VALUES(200 , 'ContactCheck');
INSERT INTO log_action_type (id , status) VALUES(201 , 'ContactInfo');
INSERT INTO log_action_type (id , status) VALUES(202 , 'ContactDelete');
INSERT INTO log_action_type (id , status) VALUES(203 , 'ContactUpdate');
INSERT INTO log_action_type (id , status) VALUES(204 , 'ContactCreate');
INSERT INTO log_action_type (id , status) VALUES(205 , 'ContactTransfer');
 
-- NSSET function
INSERT INTO log_action_type (id , status) VALUES(400 , 'NSsetCheck');
INSERT INTO log_action_type (id , status) VALUES(401 , 'NSsetInfo');
INSERT INTO log_action_type (id , status) VALUES(402 , 'NSsetDelete');
INSERT INTO log_action_type (id , status) VALUES(403 , 'NSsetUpdate');
INSERT INTO log_action_type (id , status) VALUES(404 , 'NSsetCreate');
INSERT INTO log_action_type (id , status) VALUES(405 , 'NSsetTransfer');

-- domains function
INSERT INTO log_action_type (id , status) VALUES(500 , 'DomainCheck');
INSERT INTO log_action_type (id , status) VALUES(501 , 'DomainInfo');
INSERT INTO log_action_type (id , status) VALUES(502 , 'DomainDelete');
INSERT INTO log_action_type (id , status) VALUES(503 , 'DomainUpdate');
INSERT INTO log_action_type (id , status) VALUES(504 , 'DomainCreate');
INSERT INTO log_action_type (id , status) VALUES(505 , 'DomainTransfer');
INSERT INTO log_action_type (id , status) VALUES(506 , 'DomainRenew');
INSERT INTO log_action_type (id , status) VALUES(507 , 'DomainTrade');

-- function isn't entered
INSERT INTO log_action_type (id , status) VALUES( 1000 , 'UnknownAction');

-- list function
INSERT INTO  log_action_type (id , status) VALUES( 1002 ,  'ListContact' );
INSERT INTO  log_action_type (id , status) VALUES( 1004 ,  'ListNSset' ); 
INSERT INTO  log_action_type (id , status) VALUES( 1005  ,  'ListDomain' );
-- credit function
INSERT INTO log_action_type (id , status) VALUES(1010 , 'ClientCredit');
-- tech check nsset
INSERT INTO log_action_type (id , status) VALUES( 1012 , 'nssetTest' );

-- send auth info function
INSERT INTO log_action_type (  status , id )  VALUES(  'ContactSendAuthInfo' ,  1101 );
INSERT INTO log_action_type (  status , id )  VALUES(  'NSSetSendAuthInfo'  , 1102 );
INSERT INTO log_action_type (  status , id )  VALUES(  'DomainSendAuthInfo' ,  1103 );

-- info function
INSERT INTO log_action_type (  status , id )  VALUES(  'Info'  , 1104 );
INSERT INTO log_action_type (  status , id )  VALUES(  'GetInfoResults' ,  1105 );

-- keyset function
INSERT INTO log_action_type VALUES (600, 'KeysetCheck');
INSERT INTO log_action_type VALUES (601, 'KeysetInfo');
INSERT INTO log_action_type VALUES (602, 'KeysetDelete');
INSERT INTO log_action_type VALUES (603, 'KeysetUpdate');
INSERT INTO log_action_type VALUES (604, 'KeysetCreate');
INSERT INTO log_action_type VALUES (605, 'KeysetTransfer');
INSERT INTO log_action_type VALUES (1006, 'ListKeySet');
INSERT INTO log_action_type VALUES (1106, 'KeySetSendAuthInfo');

-- ####### up to here it's a copy of enum_action from action.sql

select setval('enum_action_id_seq', 1106); 



