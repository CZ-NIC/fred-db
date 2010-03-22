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
        status varchar(64),
        service integer REFERENCES service(id)
);

ALTER TABLE request_type ADD PRIMARY KEY (status, service);

CREATE TABLE request (
	id SERIAL PRIMARY KEY,
	time_begin timestamp NOT NULL,	-- begin of the transaction
	time_end timestamp,		-- end of transaction, it is set if the information is complete 
					-- e.g. if an error message from backend is successfully logged, it's still set	
					-- NULL in cases like crash of the server
	source_ip INET,
	service integer NOT NULL REFERENCES service(id),   -- service code - enum LogServiceType in IDL
	action_type integer REFERENCES request_type(id) DEFAULT 1000,
	session_id  integer,            --  REFERENCES session(id),
        user_name varchar(255),         -- name of the user who issued the request (from session table)
		
	is_monitoring boolean NOT NULL
);

CREATE TABLE request_data (
        id SERIAL PRIMARY KEY,
	entry_time_begin timestamp NOT NULL, -- TEMP: for partitioning
	entry_service integer NOT NULL, -- TEMP: for partitioning
	entry_monitoring boolean NOT NULL, -- TEMP: for partitioning

	entry_id integer NOT NULL REFERENCES request(id),
	content text NOT NULL,
	is_response boolean DEFAULT False -- true if the content is response, false if it's request
);

CREATE TABLE request_property (
	id SERIAL PRIMARY KEY,
	name varchar(30) NOT NULL
);
	
CREATE TABLE request_property_value (
	entry_time_begin timestamp NOT NULL, -- TEMP: for partitioning
	entry_service integer NOT NULL, -- TEMP: for partitioning
	entry_monitoring boolean NOT NULL, -- TEMP: for partitioning
	
	id SERIAL PRIMARY KEY,
	entry_id integer NOT NULL REFERENCES request(id), 
	name_id integer NOT NULL REFERENCES request_property(id),
	value text NOT NULL,		-- property value
	output boolean DEFAULT False,		-- whether it's output (response) property; if False it's input (request)

	parent_id integer REFERENCES request_property_value(id)
						-- in case of child property, the id of the parent, NULL otherwise
);

CREATE INDEX request_time_begin_idx ON request(time_begin);
CREATE INDEX request_time_end_idx ON request(time_end);
CREATE INDEX request_source_ip_idx ON request(source_ip);
CREATE INDEX request_service_idx ON request(service);
CREATE INDEX request_action_type_idx ON request(action_type);
CREATE INDEX request_monitoring_idx ON request(is_monitoring);

CREATE INDEX request_data_entry_time_begin_idx ON request_data(entry_time_begin);
CREATE INDEX request_data_entry_id_idx ON request_data(entry_id);
CREATE INDEX request_data_content_idx ON request_data(content);
CREATE INDEX request_data_is_response_idx ON request_data(is_response);

CREATE INDEX request_property_name_idx ON request_property(name); 

CREATE INDEX request_property_value_entry_time_begin_idx ON request_property_value(entry_time_begin);
CREATE INDEX request_property_value_entry_id_idx ON request_property_value(entry_id); 
CREATE INDEX request_property_value_name_id_idx ON request_property_value(name_id); 
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
