-- function classifier
-- DROP TABLE enum_action CASCADE;
CREATE TABLE enum_action (
        id SERIAL PRIMARY KEY,
        status varchar(64) UNIQUE NOT NULL
        );

COMMENT ON TABLE enum_action IS 
'List of action which can be done using epp communication over central registry

id  - status
100 - ClientLogin
101 - ClientLogin
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
1000 - UnknowAction
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
INSERT INTO enum_action (id , status) VALUES(100 , 'ClientLogin');
INSERT INTO enum_action (id , status) VALUES(101 , 'ClientLogout');
-- poll function
INSERT INTO enum_action (id , status) VALUES(  120 , 'PollAcknowledgement' );
INSERT INTO enum_action (id , status) VALUES(  121 ,  'PollResponse' );

 
-- function for working with contacts
INSERT INTO enum_action (id , status) VALUES(200 , 'ContactCheck');
INSERT INTO enum_action (id , status) VALUES(201 , 'ContactInfo');
INSERT INTO enum_action (id , status) VALUES(202 , 'ContactDelete');
INSERT INTO enum_action (id , status) VALUES(203 , 'ContactUpdate');
INSERT INTO enum_action (id , status) VALUES(204 , 'ContactCreate');
INSERT INTO enum_action (id , status) VALUES(205 , 'ContactTransfer');
 
-- NSSET function
INSERT INTO enum_action (id , status) VALUES(400 , 'NSsetCheck');
INSERT INTO enum_action (id , status) VALUES(401 , 'NSsetInfo');
INSERT INTO enum_action (id , status) VALUES(402 , 'NSsetDelete');
INSERT INTO enum_action (id , status) VALUES(403 , 'NSsetUpdate');
INSERT INTO enum_action (id , status) VALUES(404 , 'NSsetCreate');
INSERT INTO enum_action (id , status) VALUES(405 , 'NSsetTransfer');

-- domains function
INSERT INTO enum_action (id , status) VALUES(500 , 'DomainCheck');
INSERT INTO enum_action (id , status) VALUES(501 , 'DomainInfo');
INSERT INTO enum_action (id , status) VALUES(502 , 'DomainDelete');
INSERT INTO enum_action (id , status) VALUES(503 , 'DomainUpdate');
INSERT INTO enum_action (id , status) VALUES(504 , 'DomainCreate');
INSERT INTO enum_action (id , status) VALUES(505 , 'DomainTransfer');
INSERT INTO enum_action (id , status) VALUES(506 , 'DomainRenew');
INSERT INTO enum_action (id , status) VALUES(507 , 'DomainTrade');

-- function isn't entered
INSERT INTO enum_action (id , status) VALUES( 1000 , 'UnknowAction');

-- list function
INSERT INTO  enum_action (id , status) VALUES( 1002 ,  'ListContact' );
INSERT INTO  enum_action (id , status) VALUES( 1004 ,  'ListNSset' ); 
INSERT INTO  enum_action (id , status) VALUES( 1005  ,  'ListDomain' );
-- credit function
INSERT INTO enum_action (id , status) VALUES(1010 , 'ClientCredit');
-- tech check nsset
INSERT INTO enum_action (id , status) VALUES( 1012 , 'nssetTest' );

-- send auth info function
INSERT INTO enum_action (  status , id )  VALUES(  'ContactSendAuthInfo' ,  1101 );
INSERT INTO enum_action (  status , id )  VALUES(  'NSSetSendAuthInfo'  , 1102 );
INSERT INTO enum_action (  status , id )  VALUES(  'DomainSendAuthInfo' ,  1103 );

-- info function
INSERT INTO enum_action (  status , id )  VALUES(  'Info'  , 1104 );
INSERT INTO enum_action (  status , id )  VALUES(  'GetInfoResults' ,  1105 );

select setval('enum_action_id_seq', 1105); 

--  table for transactions record
-- DROP TABLE Action CASCADE;
CREATE TABLE Action (
        ID SERIAL PRIMARY KEY, -- id record
	clientID INTEGER REFERENCES Login, -- id of client from table Login possible NULL too
	action INTEGER NOT NULL REFERENCES enum_action, -- type of function from ENUM classifier
        response  INTEGER  REFERENCES enum_error, -- return code of function 
        StartDate timestamp NOT NULL DEFAULT now(), -- date and time of login into system
        clientTRID varchar(128) NOT NULL, -- number of login transaction
	EndDate timestamp, -- date and time of ending function
        serverTRID varchar(128) UNIQUE   -- number of transaction from server 
        );

CREATE INDEX action_clientid_idx ON action (clientid);
CREATE INDEX action_response_idx ON action (response);
CREATE INDEX action_startdate_idx ON action (startdate);
CREATE INDEX action_action_idx ON action (action);

COMMENT on table action is 
'Table for transactions record. In this table is logged every operation done over central register

creation - at the beginning of processing any epp message
update - at the end of processing any epp message';
COMMENT on COLUMN action.id is 'unique automatically generated identifier';
comment on column action.clientid is 'id of client from table Login, it is possible have null value here';
comment on column action.action is 'type of function(action) from classifier';
comment on column action.response is 'return code of function';
comment on column action.StartDate is 'date and time when function starts';
comment on column action.EndDate is 'date and time when function ends';
comment on column action.clientTRID is 'client transaction identifier, client must care about its unique, server copy it to response';
comment on column action.serverTRID is 'server transaction identifier';

CREATE TABLE History (
        ID SERIAL PRIMARY KEY,
        action INTEGER NOT NULL REFERENCES action -- link into table action
        );
comment on table history is
'Main evidence table with modified data, it join historic tables modified during same operation

create - in case of any change';
comment on column history.id is 'unique automatically generated identifier';
comment on column history.action is 'link to action which cause modification';

CREATE INDEX history_action_idx ON history (action);

-- DROP TABLE  action_xml CASCADE;
CREATE TABLE action_xml( actionID INTEGER PRIMARY KEY REFERENCES action, xml text not NULL  , xml_out text );

CREATE TABLE action_elements(
  id SERIAL PRIMARY KEY,
  actionid INTEGER REFERENCES action,
  elementid INTEGER,
  value VARCHAR(255)
);

CREATE INDEX action_elements_value_idx ON action_elements (value);
CREATE INDEX action_elements_elementid_idx ON action_elements (elementid);


