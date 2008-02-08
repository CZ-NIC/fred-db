-- function classifier
-- DROP TABLE enum_action CASCADE;
CREATE TABLE enum_action (
        id SERIAL PRIMARY KEY,
        status varchar(64) UNIQUE NOT NULL
        );

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

CREATE TABLE History (
        ID SERIAL PRIMARY KEY,
        action INTEGER NOT NULL REFERENCES action -- link into table action
        );

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


