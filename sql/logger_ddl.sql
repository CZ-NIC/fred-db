CREATE TABLE session (
	id serial primary key,
	name varchar(255) not null,       -- user name for Webadmin or id from registrar table for EPP
	login_date timestamp not null default now(), 
	logout_date timestamp,

	lang varchar(2) not null default 'en'
);

CREATE TABLE service (
	id SERIAL PRIMARY KEY,
	partition_postfix varchar(10) UNIQUE NOT NULL,
	name varchar(64) UNIQUE NOT NULL
);

CREATE TABLE request_type (
        id SERIAL UNIQUE NOT NULL, 
        name varchar(64),
        service_id integer REFERENCES service(id)
);

ALTER TABLE request_type ADD PRIMARY KEY (name, service_id);


CREATE TABLE result_code (
    id SERIAL PRIMARY KEY,
    service_id INTEGER REFERENCES service(id),
    result_code INTEGER NOT NULL,
    name VARCHAR(64) NOT NULL    
);

ALTER TABLE result_code ADD CONSTRAINT result_code_unique  UNIQUE (service_id, result_code );
ALTER TABLE result_code ADD CONSTRAINT result_code_unique  UNIQUE (service_id, name );

COMMENT ON TABLE result_code IS 'all possible operation result codes';
COMMENT ON COLUMN result_code.id IS 'result_code id';
COMMENT ON COLUMN result_code.service_id IS 'reference to service table. This is needed to distinguish entries with identical result_code values';
COMMENT ON COLUMN result_code.result_code IS 'result code as returned by the specific service, it''s only unique within the service';
COMMENT ON COLUMN result_code.name IS 'short name for error (abbreviation) written in camelcase';

-- check null for CloseRequest result_code_id updates, exception commented out until request.result_code_id optional
CREATE OR REPLACE FUNCTION check_null(param integer) 
RETURNS integer AS $$
BEGIN
    IF param is null THEN
--        RAISE EXCEPTION 'param is null';
    END IF;
    RETURN param;
END;
$$ LANGUAGE plpgsql;


CREATE TABLE request (
	id SERIAL PRIMARY KEY,
	time_begin timestamp NOT NULL,	-- begin of the transaction
	time_end timestamp,		-- end of transaction, it is set if the information is complete 
					-- e.g. if an error message from backend is successfully logged, it's still set	
					-- NULL in cases like crash of the server
	source_ip INET,
	service_id integer NOT NULL REFERENCES service(id),   -- service_id code - enum LogServiceType in IDL
	request_type_id integer REFERENCES request_type(id) DEFAULT 1000,
	session_id  integer,            --  REFERENCES session(id),
        user_name varchar(255),         -- name of the user who issued the request (from session table)
		
	is_monitoring boolean NOT NULL, 
	result_code_id INTEGER
);

ALTER TABLE request ADD FOREIGN KEY (result_code_id) REFERENCES result_code(id); 

COMMENT ON COLUMN request.result_code_id IS 'result code as returned by the specific service, it''s only unique within the service';

CREATE TABLE request_data (
        id SERIAL PRIMARY KEY,
	request_time_begin timestamp NOT NULL, -- TEMP: for partitioning
	request_service_id integer NOT NULL, -- TEMP: for partitioning
	request_monitoring boolean NOT NULL, -- TEMP: for partitioning

	request_id integer NOT NULL REFERENCES request(id),
	content text NOT NULL,
	is_response boolean DEFAULT False -- true if the content is response, false if it's request
);

CREATE TABLE request_property_name (
	id SERIAL PRIMARY KEY,
	name varchar(30) NOT NULL
);
	
CREATE TABLE request_property_value (
	request_time_begin timestamp NOT NULL, -- TEMP: for partitioning
	request_service_id integer NOT NULL, -- TEMP: for partitioning
	request_monitoring boolean NOT NULL, -- TEMP: for partitioning
	
	id SERIAL PRIMARY KEY,
	request_id integer NOT NULL REFERENCES request(id), 
	property_name_id integer NOT NULL REFERENCES request_property_name(id),
	value text NOT NULL,		-- property value
	output boolean DEFAULT False,		-- whether it's output (response) property; if False it's input (request)

	parent_id integer REFERENCES request_property_value(id)
						-- in case of child property, the id of the parent, NULL otherwise
);

CREATE INDEX request_time_begin_idx ON request(time_begin);
CREATE INDEX request_time_end_idx ON request(time_end);
CREATE INDEX request_source_ip_idx ON request(source_ip);
CREATE INDEX request_service_idx ON request(service_id);
CREATE INDEX request_action_type_idx ON request(request_type_id);
CREATE INDEX request_monitoring_idx ON request(is_monitoring);

CREATE INDEX request_data_entry_time_begin_idx ON request_data(request_time_begin);
CREATE INDEX request_data_entry_id_idx ON request_data(request_id);
CREATE INDEX request_data_content_idx ON request_data(content);
CREATE INDEX request_data_is_response_idx ON request_data(is_response);

CREATE INDEX request_property_name_idx ON request_property_name(name); 

CREATE INDEX request_property_value_entry_time_begin_idx ON request_property_value(request_time_begin);
CREATE INDEX request_property_value_entry_id_idx ON request_property_value(request_id); 
CREATE INDEX request_property_value_name_id_idx ON request_property_value(property_name_id); 
CREATE INDEX request_property_value_value_idx ON request_property_value(value); 
CREATE INDEX request_property_value_output_idx ON request_property_value(output); 
CREATE INDEX request_property_value_parent_id_idx ON request_property_value(parent_id); 

CREATE INDEX session_name_idx ON session(name);
CREATE INDEX session_login_date_idx ON session(login_date);
CREATE INDEX session_lang_idx ON session(lang);
   
COMMENT ON TABLE request_type IS 
'List of requests which can be used by clients

id  - status
100 - ClientLogin
101 - ClientLogout
105 - ClientGreeting
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
600 - KeysetCheck
601 - KeysetInfo
602 - KeysetDelete
603 - KeysetUpdate
604 - KeysetCreate
605 - KeysetTransfer
1000 - UnknownAction
1002 - ListContact
1004 - ListNSset
1005 - ListDomain
1006 - ListKeySet
1010 - ClientCredit
1012 - nssetTest
1101 - ContactSendAuthInfo
1102 - NSSetSendAuthInfo
1103 - DomainSendAuthInfo
1104 - Info
1106 - KeySetSendAuthInfo
1200 - InfoListContacts
1201 - InfoListDomains
1202 - InfoListNssets
1203 - InfoListKeysets
1204 - InfoDomainsByNsset
1205 - InfoDomainsByKeyset
1206 - InfoDomainsByContact
1207 - InfoNssetsByContact
1208 - InfoNssetsByNs
1209 - InfoKeysetsByContact
1210 - InfoGetResults

1300 - Login
1301 - Logout 
1302 - DomainFilter
1303 - ContactFilter
1304 - NSSetFilter
1305 - KeySetFilter
1306 - RegistrarFilter
1307 - InvoiceFilter
1308 - EmailsFilter
1309 - FileFilter
1310 - ActionsFilter
1311 - PublicRequestFilter 

1312 - DomainDetail
1313 - ContactDetail
1314 - NSSetDetail
1315 - KeySetDetail
1316 - RegistrarDetail
1317 - InvoiceDetail
1318 - EmailsDetail
1319 - FileDetail
1320 - ActionsDetail
1321 - PublicRequestDetail 

1322 - RegistrarCreate
1323 - RegistrarUpdate 

1324 - PublicRequestAccept
1325 - PublicRequestInvalidate 

1326 - DomainDig
1327 - FilterCreate 

1328 - RequestDetail
1329 - RequestFilter

1330 - BankStatementDetail
1331 - BankStatementFilter

1400 -  Login 
1401 -  Logout

1402 -  DisplaySummary
1403 -  InvoiceList
1404 -  DomainList
1405 -  FileDetail';

