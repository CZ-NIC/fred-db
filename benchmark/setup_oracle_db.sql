--
-- version of script setup_db.sql for creation basic initiatory tables
-- in database for Oracle.
-- List of changes (incompatibilities with postgresql):
--     data type serial is replaced by number, sequence and trigger 
--     array is replaced by varchar
--     DAFAULT is need before NOT NULL
--     key word update can not be attribute (-> updatex)
--     boolean doesn't exist -> use char(1) with default 'f'
--     it appears that ON expressions of CASCADE action don't bite Oracle (cross out)
--     some long identifiers Oracle dosn't manage (shorten) 
--     TEXT type is replaced by varchar(1000)
--
--  -> it is clear that oracle and postgresql are for creation incompatible



-- error message clasifier
-- DROP TABLE enum_error  CASCADE;
CREATE TABLE enum_error (
        id NUMBER PRIMARY KEY,
        status varchar(128) UNIQUE NOT NULL,
        status_cs varchar(128) UNIQUE NOT NULL -- czech translation
        );
-- error message EN a CS


INSERT INTO enum_error VALUES(  1000 , 'Command completed successfully',    'P__kaz _sp__n_ proveden');
INSERT INTO enum_error VALUES(  1001 , 'Command completed successfully; action pending',  'P__kaz _sp__n_ proveden; vykon_n_ akce odlo_eno');

INSERT INTO enum_error VALUES(  1300 , 'Command completed successfully; no messages',    'P__kaz _sp__n_ proveden; __dn_ nov_ zpr_vy');
INSERT INTO enum_error VALUES(  1301 , 'Command completed successfully; ack to dequeue',    'P__kaz _sp__n_ proveden; potvr_ za __elem vy_azen_ z fronty');
INSERT INTO enum_error VALUES(  1500 , 'Command completed successfully; ending session',    'P__kaz _sp__n_ proveden; konec relace');


INSERT INTO enum_error VALUES(  2000 ,    'Unknown command',    'Nezn_m_ p__kaz');
INSERT INTO enum_error VALUES(  2001 ,    'Command syntax error',    'Chybn_ syntaxe p__kazu');
INSERT INTO enum_error VALUES(  2002 ,    'Command use error',     'Chybn_ pou_it_ p__kazu');
INSERT INTO enum_error VALUES(  2003 ,    'Required parameter missing',    'Po_adovan_ parametr neuveden');
INSERT INTO enum_error VALUES(  2004 ,    'Parameter value range error',    'Chybn_ rozsah parametru');
INSERT INTO enum_error VALUES(  2005 ,    'Parameter value syntax error',    'Chybn_ syntaxe hodnoty parametru');


INSERT INTO enum_error VALUES( 2100 ,   'Unimplemented protocol version',    'Neimplementovan_ verze protokolu');
INSERT INTO enum_error VALUES( 2101 ,   'Unimplemented command',     'Neimplementovan_ p__kaz');
INSERT INTO enum_error VALUES( 2102 ,   'Unimplemented option',    'Neimplementovan_ volba');
INSERT INTO enum_error VALUES( 2103 ,   'Unimplemented extension',    'Neimplementovan_ roz___en_');
INSERT INTO enum_error VALUES( 2104 ,   'Billing failure',     '__etn_ selh_n_');
INSERT INTO enum_error VALUES( 2105 ,   'Object is not eligible for renewal',     'Objekt je nezp_sobil_ pro obnoven_');
INSERT INTO enum_error VALUES( 2106 ,   'Object is not eligible for transfer',    'Objekt je nezp_sobil_ pro transfer');


INSERT INTO enum_error VALUES( 2200 ,    'Authentication error',    'Chyba ov__en_ identity');
INSERT INTO enum_error VALUES( 2201 ,    'Authorization error',     'Chyba opr_vn_n_');
INSERT INTO enum_error VALUES( 2202 ,    'Invalid authorization information',    'Chybn_ autoriza_n_ informace');

INSERT INTO enum_error VALUES( 2300 ,    'Object pending transfer',    'Objekt _ek_ na transfer');
INSERT INTO enum_error VALUES( 2301 ,    'Object not pending transfer',    'Objekt ne_ek_ na transfer');
INSERT INTO enum_error VALUES( 2302 ,    'Object exists',    'Objekt existuje');
INSERT INTO enum_error VALUES( 2303 ,    'Object does not exist',    'Objekt neexistuje');
INSERT INTO enum_error VALUES( 2304 ,    'Object status prohibits operation',    'Status objektu nedovoluje operaci');
INSERT INTO enum_error VALUES( 2305 ,    'Object association prohibits operation',    'Asociace objektu nedovoluje operaci');
INSERT INTO enum_error VALUES( 2306 ,    'Parameter value policy error',    'Chyba z_sady pro hodnotu parametru');
INSERT INTO enum_error VALUES( 2307 ,    'Unimplemented object service',    'Neimplementovan_ slu_ba objektu');
INSERT INTO enum_error VALUES( 2308 ,    'Data management policy violation',    'Poru_en_ z_sady pro spr_vu dat');

INSERT INTO enum_error VALUES( 2400 ,    'Command failed',    'P__kaz selhal');
INSERT INTO enum_error VALUES( 2500 ,    'Command failed; server closing connection',    'P__kaz selhal; server uzav_r_ spojen_');
INSERT INTO enum_error VALUES( 2501 ,    'Authentication error; server closing connection',    'Chyba ov__en_ identity; server uzav_r_ spojen_');
INSERT INTO enum_error VALUES( 2502 ,    'Session limit exceeded; server closing connection',    'Limit na po_et relac_ p_ekro_en; server uzav_r_ spojen_');



                                                                                                
-- DROP TABLE enum_status CASCADE;
CREATE TABLE enum_status (
        id number PRIMARY KEY,
        status varchar(64) UNIQUE NOT NULL
       );
                                               
INSERT INTO enum_status (id , status) VALUES( 1   , 'ok' );
INSERT INTO enum_status (id , status) VALUES( 2   , 'inactive' );
INSERT INTO enum_status (id , status) VALUES( 101 , 'clientDeleteProhibited');
INSERT INTO enum_status (id , status) VALUES( 201 , 'serverDeleteProhibited');
INSERT INTO enum_status (id , status) VALUES( 102 , 'clientHold');
INSERT INTO enum_status (id , status) VALUES( 202 , 'serverHold');
INSERT INTO enum_status (id , status) VALUES( 103 , 'clientRenewProhibited');
INSERT INTO enum_status (id , status) VALUES( 203 , 'serverRenewProhibited');
INSERT INTO enum_status (id , status) VALUES( 104 , 'clientTransferProhibited');
INSERT INTO enum_status (id , status) VALUES( 204 , 'serverTransferProhibited');
INSERT INTO enum_status (id , status) VALUES( 105 , 'clientUpdateProhibited');
INSERT INTO enum_status (id , status) VALUES( 205 , 'serverUpdateProhibited');
INSERT INTO enum_status (id , status) VALUES( 301 , 'pendingCreate');
INSERT INTO enum_status (id , status) VALUES( 302 , 'pendingDelete');
INSERT INTO enum_status (id , status) VALUES( 303 , 'pendingRenew');
INSERT INTO enum_status (id , status) VALUES( 304 , 'pendingTransfer');
INSERT INTO enum_status (id , status) VALUES( 305 , 'pendingUpdate');
                       -- DROP TABLE enum_country CASCADE;
CREATE TABLE enum_country (
        id char(2) PRIMARY KEY,
        country varchar(1024) UNIQUE NOT NULL,
        country_cs  varchar(1024) UNIQUE -- optional czech name 
        );


-- DROP TABLE zone CASCADE;
CREATE TABLE zone (
        id number PRIMARY KEY,
        fqdn VARCHAR(255) UNIQUE NOT NULL,
	ex_period_min int not null,
        ex_period_max int not null,
        val_period int not null
        );
CREATE SEQUENCE zone_id_seq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE OR REPLACE TRIGGER zone_trigger BEFORE INSERT ON zone
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
	SELECT zone_id_seq.nextval INTO :NEW.ID FROM dual;
END;
/

INSERT INTO zone (fqdn ,ex_period_min, ex_period_max, val_period) VALUES('0.2.4.e164.arpa',12,120,6);
INSERT INTO zone (fqdn ,ex_period_min, ex_period_max, val_period) VALUES('0.2.4.c.e164.arpa',12,120,6);
INSERT INTO zone (fqdn ,ex_period_min, ex_period_max, val_period) VALUES('cz',12,120,0);

-- DROP TABLE Registrar CASCADE;
CREATE TABLE Registrar (
        ID number PRIMARY KEY,
        Handle varchar(255) UNIQUE NOT NULL,
        Name varchar(1024),
        Organization varchar(1024),
        Street1 varchar(1024),
        Street2 varchar(1024),
        Street3 varchar(1024),
        City varchar(1024),
        StateOrProvince varchar(1024),
        PostalCode varchar(32),
        Country char(2) REFERENCES enum_country,
        Telephone varchar(32),
        Fax varchar(32),
        Email varchar(1024),
        Url varchar(1024)
        );
CREATE SEQUENCE registrar_id_seq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE OR REPLACE TRIGGER registrar_trigger BEFORE INSERT ON registrar
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
	SELECT registrar_id_seq.nextval INTO :NEW.ID FROM dual;
END;
/

-- DROP TABLE RegistrarACL CASCADE;
CREATE TABLE RegistrarACL (
        RegistrarID INTEGER NOT NULL REFERENCES Registrar,
        ZoneID INTEGER NOT NULL REFERENCES Zone,
        Cert varchar(1024) NOT NULL, -- certificate fingerprint
        Password varchar(64) NOT NULL
        );

-- DROP TABLE Contact CASCADE;
CREATE TABLE Contact (
        ID number PRIMARY KEY,
        Handle varchar(255) UNIQUE NOT NULL,
        ROID varchar(255) UNIQUE NOT NULL,
        Status varchar(255),
        CrID INTEGER NOT NULL REFERENCES Registrar,
        CrDate timestamp DEFAULT current_timestamp NOT NULL,
        UpID INTEGER REFERENCES Registrar,
        UpDatex timestamp,
        Name varchar(1024),
        Organization varchar(1024),
        Street1 varchar(1024),
        Street2 varchar(1024),
        Street3 varchar(1024),
        City varchar(1024),
        StateOrProvince varchar(1024),
        PostalCode varchar(32),
        Country char(2) REFERENCES enum_country,
        Telephone varchar(32),
        Fax varchar(32),
        Email varchar(1024),
        DiscloseName char(1) DEFAULT 'f',
        DiscloseOrganization char(1) DEFAULT 'f',
        DiscloseAddress char(1) DEFAULT 'f',
        DiscloseTelephone char(1) DEFAULT 'f',
        DiscloseFax char(1) DEFAULT 'f',
        DiscloseEmail char(1) DEFAULT 'f',
        NotifyEmail varchar(1024),
        VAT varchar(32),
        SSN varchar(32)
        );
CREATE INDEX contact_id_idx ON Contact (ID);
CREATE INDEX contact_roid_idx ON Contact (ROID);
CREATE INDEX contact_handle_idx ON Contact (Handle);

CREATE SEQUENCE contact_id_seq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE OR REPLACE TRIGGER contact_trigger BEFORE INSERT ON contact
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
	SELECT contact_id_seq.nextval INTO :NEW.ID FROM dual;
END;
/


-- DROP TABLE Term CASCADE;
-- CREATE TABLE Term (
--        ID SERIAL PRIMARY KEY,
--        CrDate date NOT NULL
--        );
-- 
-- DROP TABLE ContactAgreement CASCADE;
-- CREATE TABLE ContactAgreement (
--         ID SERIAL PRIMARY KEY,
--         ContactID INTEGER NOT NULL REFERENCES Contact ON UPDATE Cascade,
--         TermID INTEGER NOT NULL REFERENCES Term ON UPDATE Cascade
--         );
-- CREATE INDEX contactagreement_contactid_idx ON ContactAgreement (ContactID);
-- CREATE INDEX contactagreement_termid_id ON ContactAgreement (TermID);

-- DROP TABLE NSSet CASCADE;
CREATE TABLE NSSet (
        ID number PRIMARY KEY,
        ROID varchar(255) UNIQUE NOT NULL,
        Handle varchar(255) UNIQUE NOT NULL,
        Status varchar(255),
        ClID INTEGER NOT NULL REFERENCES Registrar,
        CrID INTEGER NOT NULL REFERENCES Registrar,
        CrDate timestamp DEFAULT current_timestamp NOT NULL,
        UpID INTEGER REFERENCES Registrar,
        AuthInfoPw varchar(32),
        TrDate timestamp,
        UpDatex timestamp
        );
CREATE INDEX nsset_id_idx ON NSSet (ID);
CREATE INDEX nsset_roid_idx ON NSSet (ROID);
CREATE INDEX nsset_handle_idx ON NSSet (Handle);
CREATE INDEX nsset_clid_idx ON NSSet (ClID);        
CREATE SEQUENCE nsset_id_seq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE OR REPLACE TRIGGER nsset_trigger BEFORE INSERT ON nsset
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
	SELECT nsset_id_seq.nextval INTO :NEW.ID FROM dual;
END;
/


-- DROP TABLE nsset_contact_map CASCADE;
CREATE TABLE nsset_contact_map (
        NSSetID INTEGER REFERENCES NSSet NOT NULL,
        ContactID INTEGER REFERENCES Contact NOT NULL,
        UNIQUE (NSSetID, ContactID)
        );
CREATE INDEX nsset_contact_map_nssetid_idx ON nsset_contact_map (NSSetID);


-- DROP TABLE Host CASCADE;
CREATE TABLE Host (
        ID number PRIMARY KEY,
        NSSetID INTEGER REFERENCES NSSet,
        FQDN VARCHAR(255)   NOT NULL,
        IpAddr varchar(255) NOT NULL,
        UNIQUE (NSSetID, FQDN ) -- unique key
        );
CREATE SEQUENCE host_id_seq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE OR REPLACE TRIGGER host_trigger BEFORE INSERT ON host
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
	SELECT host_id_seq.nextval INTO :NEW.ID FROM dual;
END;
/
CREATE INDEX host_nsset_idx ON Host (NSSetID);
CREATE INDEX host_fqdn_idx ON Host (FQDN);

-- DROP TABLE Domain CASCADE;
CREATE TABLE Domain (
        Zone INTEGER REFERENCES Zone (ID),
        ID number PRIMARY KEY,
        ROID varchar(255) UNIQUE NOT NULL,
        FQDN varchar(255) UNIQUE NOT NULL,
        Status varchar(255),
        Registrant INTEGER REFERENCES Contact,
        NSSet INTEGER REFERENCES NSSet,
        ClID INTEGER NOT NULL REFERENCES Registrar,
        CrID INTEGER NOT NULL REFERENCES Registrar,
        CrDate timestamp DEFAULT current_timestamp NOT NULL,
        UpID INTEGER REFERENCES Registrar,
        Exdate timestamp NOT NULL,
        TrDate timestamp,
        AuthInfoPw varchar(32),
        UpDatex timestamp
        );
CREATE INDEX domain_zone_idx ON Domain (Zone);
CREATE INDEX domain_id_idx ON Domain (ID);
CREATE INDEX domain_fqdn_idx ON Domain (FQDN);
CREATE INDEX domain_roid_idx ON Domain (ROID);
CREATE SEQUENCE domain_id_seq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE OR REPLACE TRIGGER domain_trigger BEFORE INSERT ON domain
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
	SELECT domain_id_seq.nextval INTO :NEW.ID FROM dual;
END;
/


-- DROP TABLE domain_contact_map CASCADE;
CREATE TABLE domain_contact_map (
        DomainID INTEGER REFERENCES Domain NOT NULL,
        ContactID INTEGER REFERENCES Contact NOT NULL,
        UNIQUE (DomainID, ContactID)
        );
CREATE INDEX domain_contact_map_idx ON domain_contact_map (DomainID);


-- DROP TABLE domain_host_map CASCADE;
-- CREATE TABLE domain_host_map (
--         DomainID INTEGER NOT NULL REFERENCES Domain ON UPDATE CASCADE ON DELETE CASCADE,
--         HostID INTEGER NOT NULL REFERENCES Host ON UPDATE CASCADE,
--         UNIQUE (DomainID, HostID)
--         );
-- CREATE INDEX domain_host_map_domainid_idx ON domain_host_map (DomainID);

-- DROP TABLE ENUMVal CASCADE;
CREATE TABLE ENUMVal (
        DomainID INTEGER NOT NULL PRIMARY KEY REFERENCES Domain,
        ExDate timestamp NOT NULL
        );

-- DROP TABLE Message;
CREATE TABLE Message (
        ID number PRIMARY KEY,
        ClID INTEGER REFERENCES Registrar,
        CrDate TIMESTAMP DEFAULT current_timestamp NOT NULL,
        ExDate TIMESTAMP,
        Seen char(1) DEFAULT 'f' NOT NULL,
        Message varchar(1000) NOT NULL
        );
CREATE INDEX message_clid_idx ON message (clid);
CREATE INDEX message_seen_idx ON message (clid,seen,crdate,exdate);
CREATE SEQUENCE message_id_seq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE OR REPLACE TRIGGER message_trigger BEFORE INSERT ON message
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
	SELECT message_id_seq.nextval INTO :NEW.ID FROM dual;
END;
/

-- login table for client login
-- DROP TABLE Login CASCADE;
CREATE TABLE Login (
        ID number PRIMARY KEY, -- it returns as clientID from CORBA Login function
	RegistrarID INTEGER NOT NULL REFERENCES Registrar, -- id registrar
        LoginDate timestamp DEFAULT current_timestamp NOT NULL, -- date und time of login into system
        loginTRID varchar(128) NOT NULL, -- transaction login number 
	LogoutDate timestamp, -- logout date und time
        logoutTRID varchar(128), -- transaction logout number
        lang  varchar(2) DEFAULT 'en' NOT NULL -- language for returning error messages
        );
CREATE SEQUENCE login_id_seq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE OR REPLACE TRIGGER login_trigger BEFORE INSERT ON login
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
	SELECT login_id_seq.nextval INTO :NEW.ID FROM dual;
END;
/


-- function classifier
-- DROP TABLE enum_action CASCADE;
CREATE TABLE enum_action (
        id number PRIMARY KEY,
        status varchar(64) UNIQUE NOT NULL
        );

-- login function
INSERT INTO enum_action (id , status) VALUES(100 , 'ClientLogin');
INSERT INTO enum_action (id , status) VALUES(101 , 'ClientLogout');
-- poll function
INSERT INTO enum_action (id , status) VALUES(  120 , 'PollAcknowledgement' );
INSERT INTO enum_action (id , status) VALUES(  121 ,  'PollResponse' );

 
-- function for work with contacts
INSERT INTO enum_action (id , status) VALUES(200 , 'ContactCheck');
INSERT INTO enum_action (id , status) VALUES(201 , 'ContactInfo');
INSERT INTO enum_action (id , status) VALUES(202 , 'ContactDelete');
INSERT INTO enum_action (id , status) VALUES(203 , 'ContactUpdate');
INSERT INTO enum_action (id , status) VALUES(204 , 'ContactCreate');

-- function for hosts
INSERT INTO enum_action (id , status) VALUES(300 , 'HostCheck');
INSERT INTO enum_action (id , status) VALUES(301 , 'HostInfo');
INSERT INTO enum_action (id , status) VALUES(302 , 'HostDelete');
INSERT INTO enum_action (id , status) VALUES(303 , 'HostUpdate');
INSERT INTO enum_action (id , status) VALUES(304 , 'HostCreate');

-- function for NSSET
INSERT INTO enum_action (id , status) VALUES(400 , 'NSsetCheck');
INSERT INTO enum_action (id , status) VALUES(401 , 'NSsetInfo');
INSERT INTO enum_action (id , status) VALUES(402 , 'NSsetDelete');
INSERT INTO enum_action (id , status) VALUES(403 , 'NSsetUpdate');
INSERT INTO enum_action (id , status) VALUES(404 , 'NSsetCreate');
INSERT INTO enum_action (id , status) VALUES(405 , 'NSsetTransfer');

-- function for domain
INSERT INTO enum_action (id , status) VALUES(500 , 'DomainCheck');
INSERT INTO enum_action (id , status) VALUES(501 , 'DomainInfo');
INSERT INTO enum_action (id , status) VALUES(502 , 'DomainDelete');
INSERT INTO enum_action (id , status) VALUES(503 , 'DomainUpdate');
INSERT INTO enum_action (id , status) VALUES(504 , 'DomainCreate');
INSERT INTO enum_action (id , status) VALUES(505 , 'DomainTransfer');
INSERT INTO enum_action (id , status) VALUES(506 , 'DomainRenew');
INSERT INTO enum_action (id , status) VALUES(507 , 'DomainTrade');

-- function which is not entered
INSERT INTO enum_action (id , status) VALUES( 1000 , 'UnknowAction');

--  tabel for transactions recording
-- DROP TABLE Action CASCADE;
CREATE TABLE Action (
        ID number PRIMARY KEY, -- id record
	clientID INTEGER REFERENCES Login, -- id of client from Login tabel possibility also null
	action INTEGER NOT NULL REFERENCES enum_action, -- function type from enum classifier
        response  INTEGER  REFERENCES enum_error, -- returning function code 
        StartDate timestamp DEFAULT current_timestamp NOT NULL, -- login date und time into system
        clientTRID varchar(128) NOT NULL, -- transaction login number
	EndDate timestamp, -- date and time of function end
        serverTRID varchar(128) UNIQUE   -- transaction number from server 
        );
CREATE SEQUENCE action_id_seq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE OR REPLACE TRIGGER action_trigger BEFORE INSERT ON action
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
	SELECT action_id_seq.nextval INTO :NEW.ID FROM dual;
END;
/

-- tables for saving history
-- only operation DELETE UPDATE TRANSFER are saved 
-- CREATE is not need to save

-- DROP TABLE History CASCADE;
CREATE TABLE History (
        ID number PRIMARY KEY,
        action INTEGER NOT NULL REFERENCES action, -- link into action tabel         
        ModDate timestamp DEFAULT current_timestamp NOT NULL -- date and time of realized change
        );
CREATE SEQUENCE history_id_seq START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE OR REPLACE TRIGGER history_trigger BEFORE INSERT ON history
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
	SELECT history_id_seq.nextval INTO :NEW.ID FROM dual;
END;
/

-- DROP TABLE Contact_History CASCADE;
CREATE TABLE Contact_History (
        HISTORYID number PRIMARY  KEY REFERENCES History,
        ID INTEGER   NOT NULL,
        Handle varchar(255)  NOT NULL,
        ROID varchar(255)  NOT NULL,
        Status varchar(255),
        CrID INTEGER NOT NULL REFERENCES Registrar,
        CrDate timestamp NOT NULL, -- DEFAULT now(),
        UpID INTEGER REFERENCES Registrar,
        UpDatex timestamp,
        Name varchar(1024),
        Organization varchar(1024),
        Street1 varchar(1024),
        Street2 varchar(1024),
        Street3 varchar(1024),
        City varchar(1024),
        StateOrProvince varchar(1024),
        PostalCode varchar(32),
        Country char(2) REFERENCES enum_country,
        Telephone varchar(32),
        Fax varchar(32),
        Email varchar(1024),
        DiscloseName char(1) default 'f',
        DiscloseOrganization char(1) default 'f',
        DiscloseAddress char(1) default 'f',
        DiscloseTelephone char(1) default 'f',
        DiscloseFax char(1) default 'f',
        DiscloseEmail char(1) default 'f',
        NotifyEmail varchar(1024),
        VAT varchar(32),
        SSN varchar(32)
        );

CREATE INDEX contact_history_historyid_idx ON Contact_History (historyID);


-- DROP TABLE Domain_History CASCADE;
CREATE TABLE Domain_History (
        HISTORYID number PRIMARY KEY REFERENCES History,          
        Zone INTEGER REFERENCES Zone (ID),
        ID INTEGER   NOT NULL,
        ROID varchar(255)  NOT NULL,
        FQDN varchar(255)  NOT NULL,
        Status varchar(255),
        ClID INTEGER NOT NULL REFERENCES Registrar,
        CrID INTEGER NOT NULL REFERENCES Registrar,
        CrDate timestamp DEFAULT current_timestamp NOT NULL,
        UpID INTEGER REFERENCES Registrar,
        ExDate timestamp NOT NULL,
        TrDate timestamp,
        AuthInfoPw varchar(32),
        UpDatex timestamp,
        Registrant INTEGER , -- canceled reference
        NSSet INTEGER  -- canceled references
        );
CREATE INDEX domain_History_historyid_idx ON Domain_History (historyID);

-- DROP TABLE domain_contact_map_history CASCADE;
CREATE TABLE domain_contact_map_history  (
        historyID number REFERENCES History,       
        DomainID INTEGER, --REFERENCES Domain ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
        ContactID INTEGER --REFERENCES Contact ON UPDATE CASCADE NOT NULL,
        );
-- CREATE INDEX domain_contact_map_domainid_idx ON domain_contact_map (DomainID);

-- DROP TABLE NSSet_history  CASCADE;
CREATE TABLE NSSet_history  (
        historyID number PRIMARY KEY REFERENCES History, -- only one nsset 
        ID INTEGER  NOT NULL,
        ROID varchar(255)  NOT NULL,
        Handle varchar(255)  NOT NULL,
        Status varchar(255),
        ClID INTEGER NOT NULL REFERENCES Registrar,
        CrID INTEGER NOT NULL REFERENCES Registrar,
        CrDate timestamp NOT NULL,
        UpID INTEGER REFERENCES Registrar, 
        AuthInfoPw varchar(32),
        Trdate timestamp,
        UpDatex timestamp
        );
CREATE INDEX nsset_history_historyid_idx ON NSSet_History (historyID);

-- DROP TABLE nsset_contact_map_history  CASCADE;
CREATE TABLE nsset_contact_map_history (
        historyID number  REFERENCES History,
        NSSetID INTEGER, -- REFERENCES NSSet ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
        ContactID INTEGER -- REFERENCES Contact ON UPDATE CASCADE NOT NULL,
        -- UNIQUE (NSSetID, ContactID)
        );

-- DROP TABLE Host_history  CASCADE;
CREATE TABLE Host_history  (
        historyID number  REFERENCES History,  -- can be more hosts so that it isn't primary key
        ID  INTEGER  NOT NULL,
        NSSetID INTEGER NOT NULL, -- REFERENCES NSSet ON UPDATE CASCADE,
        FQDN VARCHAR(255)  NOT NULL,
        IpAddr varchar(255) NOT NULL -- NOTE: we don't have to store IP version, since it's obvious from address
        );

CREATE INDEX host_history_historyid_idx ON HOST_History (historyID);

-- DROP TABLE ENUMVal_history  CASCADE;
CREATE TABLE ENUMVal_history (
        historyID number PRIMARY KEY REFERENCES History, -- only one nsset 
        DomainID INTEGER NOT NULL,
        ExDate timestamp NOT NULL
        );

CREATE INDEX ENUMVal_history_historyid_idx ON ENUMVal_History (historyID);
-- table for credit attribution for DomainCreate and DomainReNew operation
-- DROP TABLE Credit CASCADE;

-- delete all records 
DELETE FROM  enum_country ;
-- read all state
INSERT INTO enum_country (id,country) VALUES ( 'AF' , 'AFGHANISTAN' );
INSERT INTO enum_country (id,country) VALUES ( 'AX' , 'ALAND ISLANDS' );
INSERT INTO enum_country (id,country) VALUES ( 'AL' , 'ALBANIA' );
INSERT INTO enum_country (id,country) VALUES ( 'DZ' , 'ALGERIA' );
INSERT INTO enum_country (id,country) VALUES ( 'AS' , 'AMERICAN SAMOA' );
INSERT INTO enum_country (id,country) VALUES ( 'AD' , 'ANDORRA' );
INSERT INTO enum_country (id,country) VALUES ( 'AO' , 'ANGOLA' );
INSERT INTO enum_country (id,country) VALUES ( 'AI' , 'ANGUILLA' );
INSERT INTO enum_country (id,country) VALUES ( 'AQ' , 'ANTARCTICA' );
INSERT INTO enum_country (id,country) VALUES ( 'AG' , 'ANTIGUA AND BARBUDA' );
INSERT INTO enum_country (id,country) VALUES ( 'AR' , 'ARGENTINA' );
INSERT INTO enum_country (id,country) VALUES ( 'AM' , 'ARMENIA' );
INSERT INTO enum_country (id,country) VALUES ( 'AW' , 'ARUBA' );
INSERT INTO enum_country (id,country) VALUES ( 'AU' , 'AUSTRALIA' );
INSERT INTO enum_country (id,country) VALUES ( 'AT' , 'AUSTRIA' );
INSERT INTO enum_country (id,country) VALUES ( 'AZ' , 'AZERBAIJAN' );
INSERT INTO enum_country (id,country) VALUES ( 'BS' , 'BAHAMAS' );
INSERT INTO enum_country (id,country) VALUES ( 'BH' , 'BAHRAIN' );
INSERT INTO enum_country (id,country) VALUES ( 'BD' , 'BANGLADESH' );
INSERT INTO enum_country (id,country) VALUES ( 'BB' , 'BARBADOS' );
INSERT INTO enum_country (id,country) VALUES ( 'BY' , 'BELARUS' );
INSERT INTO enum_country (id,country) VALUES ( 'BE' , 'BELGIUM' );
INSERT INTO enum_country (id,country) VALUES ( 'BZ' , 'BELIZE' );
INSERT INTO enum_country (id,country) VALUES ( 'BJ' , 'BENIN' );
INSERT INTO enum_country (id,country) VALUES ( 'BM' , 'BERMUDA' );
INSERT INTO enum_country (id,country) VALUES ( 'BT' , 'BHUTAN' );
INSERT INTO enum_country (id,country) VALUES ( 'BO' , 'BOLIVIA' );
INSERT INTO enum_country (id,country) VALUES ( 'BA' , 'BOSNIA AND HERZEGOVINA' );
INSERT INTO enum_country (id,country) VALUES ( 'BW' , 'BOTSWANA' );
INSERT INTO enum_country (id,country) VALUES ( 'BV' , 'BOUVET ISLAND' );
INSERT INTO enum_country (id,country) VALUES ( 'BR' , 'BRAZIL' );
INSERT INTO enum_country (id,country) VALUES ( 'IO' , 'BRITISH INDIAN OCEAN TERRITORY' );
INSERT INTO enum_country (id,country) VALUES ( 'BN' , 'BRUNEI DARUSSALAM' );
INSERT INTO enum_country (id,country) VALUES ( 'BG' , 'BULGARIA' );
INSERT INTO enum_country (id,country) VALUES ( 'BF' , 'BURKINA FASO' );
INSERT INTO enum_country (id,country) VALUES ( 'BI' , 'BURUNDI' );
INSERT INTO enum_country (id,country) VALUES ( 'KH' , 'CAMBODIA' );
INSERT INTO enum_country (id,country) VALUES ( 'CM' , 'CAMEROON' );
INSERT INTO enum_country (id,country) VALUES ( 'CA' , 'CANADA' );
INSERT INTO enum_country (id,country) VALUES ( 'CV' , 'CAPE VERDE' );
INSERT INTO enum_country (id,country) VALUES ( 'KY' , 'CAYMAN ISLANDS' );
INSERT INTO enum_country (id,country) VALUES ( 'CF' , 'CENTRAL AFRICAN REPUBLIC' );
INSERT INTO enum_country (id,country) VALUES ( 'TD' , 'CHAD' );
INSERT INTO enum_country (id,country) VALUES ( 'CL' , 'CHILE' );
INSERT INTO enum_country (id,country) VALUES ( 'CN' , 'CHINA' );
INSERT INTO enum_country (id,country) VALUES ( 'CX' , 'CHRISTMAS ISLAND' );
INSERT INTO enum_country (id,country) VALUES ( 'CC' , 'COCOS (KEELING); ISLANDS' );
INSERT INTO enum_country (id,country) VALUES ( 'CO' , 'COLOMBIA' );
INSERT INTO enum_country (id,country) VALUES ( 'KM' , 'COMOROS' );
INSERT INTO enum_country (id,country) VALUES ( 'CG' , 'CONGO' );
INSERT INTO enum_country (id,country) VALUES ( 'CD' , 'CONGO, THE DEMOCRATIC REPUBLIC OF THE' );
INSERT INTO enum_country (id,country) VALUES ( 'CK' , 'COOK ISLANDS' );
INSERT INTO enum_country (id,country) VALUES ( 'CR' , 'COSTA RICA' );
INSERT INTO enum_country (id,country) VALUES ( 'CI' , 'COTE D''IVOIRE' );
INSERT INTO enum_country (id,country) VALUES ( 'HR' , 'CROATIA' );
INSERT INTO enum_country (id,country) VALUES ( 'CU' , 'CUBA' );
INSERT INTO enum_country (id,country) VALUES ( 'CY' , 'CYPRUS' );
INSERT INTO enum_country (id,country) VALUES ( 'CZ' , 'CZECH REPUBLIC' );
INSERT INTO enum_country (id,country) VALUES ( 'DK' , 'DENMARK' );
INSERT INTO enum_country (id,country) VALUES ( 'DJ' , 'DJIBOUTI' );
INSERT INTO enum_country (id,country) VALUES ( 'DM' , 'DOMINICA' );
INSERT INTO enum_country (id,country) VALUES ( 'DO' , 'DOMINICAN REPUBLIC' );
INSERT INTO enum_country (id,country) VALUES ( 'EC' , 'ECUADOR' );
INSERT INTO enum_country (id,country) VALUES ( 'EG' , 'EGYPT' );
INSERT INTO enum_country (id,country) VALUES ( 'SV' , 'EL SALVADOR' );
INSERT INTO enum_country (id,country) VALUES ( 'GQ' , 'EQUATORIAL GUINEA' );
INSERT INTO enum_country (id,country) VALUES ( 'ER' , 'ERITREA' );
INSERT INTO enum_country (id,country) VALUES ( 'EE' , 'ESTONIA' );
INSERT INTO enum_country (id,country) VALUES ( 'ET' , 'ETHIOPIA' );
INSERT INTO enum_country (id,country) VALUES ( 'FK' , 'FALKLAND ISLANDS (MALVINAS);' );
INSERT INTO enum_country (id,country) VALUES ( 'FO' , 'FAROE ISLANDS' );
INSERT INTO enum_country (id,country) VALUES ( 'FJ' , 'FIJI' );
INSERT INTO enum_country (id,country) VALUES ( 'FI' , 'FINLAND' );
INSERT INTO enum_country (id,country) VALUES ( 'FR' , 'FRANCE' );
INSERT INTO enum_country (id,country) VALUES ( 'GF' , 'FRENCH GUIANA' );
INSERT INTO enum_country (id,country) VALUES ( 'PF' , 'FRENCH POLYNESIA' );
INSERT INTO enum_country (id,country) VALUES ( 'TF' , 'FRENCH SOUTHERN TERRITORIES' );
INSERT INTO enum_country (id,country) VALUES ( 'GA' , 'GABON' );
INSERT INTO enum_country (id,country) VALUES ( 'GM' , 'GAMBIA' );
INSERT INTO enum_country (id,country) VALUES ( 'GE' , 'GEORGIA' );
INSERT INTO enum_country (id,country) VALUES ( 'DE' , 'GERMANY' );
INSERT INTO enum_country (id,country) VALUES ( 'GH' , 'GHANA' );
INSERT INTO enum_country (id,country) VALUES ( 'GI' , 'GIBRALTAR' );
INSERT INTO enum_country (id,country) VALUES ( 'GR' , 'GREECE' );
INSERT INTO enum_country (id,country) VALUES ( 'GL' , 'GREENLAND' );
INSERT INTO enum_country (id,country) VALUES ( 'GD' , 'GRENADA' );
INSERT INTO enum_country (id,country) VALUES ( 'GP' , 'GUADELOUPE' );
INSERT INTO enum_country (id,country) VALUES ( 'GU' , 'GUAM' );
INSERT INTO enum_country (id,country) VALUES ( 'GT' , 'GUATEMALA' );
INSERT INTO enum_country (id,country) VALUES ( 'GN' , 'GUINEA' );
INSERT INTO enum_country (id,country) VALUES ( 'GW' , 'GUINEA-BISSAU' );
INSERT INTO enum_country (id,country) VALUES ( 'GY' , 'GUYANA' );
INSERT INTO enum_country (id,country) VALUES ( 'HT' , 'HAITI' );
INSERT INTO enum_country (id,country) VALUES ( 'HM' , 'HEARD ISLAND AND MCDONALD ISLANDS' );
INSERT INTO enum_country (id,country) VALUES ( 'VA' , 'HOLY SEE (VATICAN CITY STATE);' );
INSERT INTO enum_country (id,country) VALUES ( 'HN' , 'HONDURAS' );
INSERT INTO enum_country (id,country) VALUES ( 'HK' , 'HONG KONG' );
INSERT INTO enum_country (id,country) VALUES ( 'HU' , 'HUNGARY' );
INSERT INTO enum_country (id,country) VALUES ( 'IS' , 'ICELAND' );
INSERT INTO enum_country (id,country) VALUES ( 'IN' , 'INDIA' );
INSERT INTO enum_country (id,country) VALUES ( 'ID' , 'INDONESIA' );
INSERT INTO enum_country (id,country) VALUES ( 'IR' , 'IRAN, ISLAMIC REPUBLIC OF' );
INSERT INTO enum_country (id,country) VALUES ( 'IQ' , 'IRAQ' );
INSERT INTO enum_country (id,country) VALUES ( 'IE' , 'IRELAND' );
INSERT INTO enum_country (id,country) VALUES ( 'IL' , 'ISRAEL' );
INSERT INTO enum_country (id,country) VALUES ( 'IT' , 'ITALY' );
INSERT INTO enum_country (id,country) VALUES ( 'JM' , 'JAMAICA' );
INSERT INTO enum_country (id,country) VALUES ( 'JP' , 'JAPAN' );
INSERT INTO enum_country (id,country) VALUES ( 'JO' , 'JORDAN' );
INSERT INTO enum_country (id,country) VALUES ( 'KZ' , 'KAZAKHSTAN' );
INSERT INTO enum_country (id,country) VALUES ( 'KE' , 'KENYA' );
INSERT INTO enum_country (id,country) VALUES ( 'KI' , 'KIRIBATI' );
INSERT INTO enum_country (id,country) VALUES ( 'KP' , 'KOREA, DEMOCRATIC PEOPLE''S REPUBLIC OF' );
INSERT INTO enum_country (id,country) VALUES ( 'KR' , 'KOREA, REPUBLIC OF' );
INSERT INTO enum_country (id,country) VALUES ( 'KW' , 'KUWAIT' );
INSERT INTO enum_country (id,country) VALUES ( 'KG' , 'KYRGYZSTAN' );
INSERT INTO enum_country (id,country) VALUES ( 'LA' , 'LAO PEOPLE''S DEMOCRATIC REPUBLIC' );
INSERT INTO enum_country (id,country) VALUES ( 'LV' , 'LATVIA' );
INSERT INTO enum_country (id,country) VALUES ( 'LB' , 'LEBANON' );
INSERT INTO enum_country (id,country) VALUES ( 'LS' , 'LESOTHO' );
INSERT INTO enum_country (id,country) VALUES ( 'LR' , 'LIBERIA' );
INSERT INTO enum_country (id,country) VALUES ( 'LY' , 'LIBYAN ARAB JAMAHIRIYA' );
INSERT INTO enum_country (id,country) VALUES ( 'LI' , 'LIECHTENSTEIN' );
INSERT INTO enum_country (id,country) VALUES ( 'LT' , 'LITHUANIA' );
INSERT INTO enum_country (id,country) VALUES ( 'LU' , 'LUXEMBOURG' );
INSERT INTO enum_country (id,country) VALUES ( 'MO' , 'MACAO' );
INSERT INTO enum_country (id,country) VALUES ( 'MK' , 'MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF' );
INSERT INTO enum_country (id,country) VALUES ( 'MG' , 'MADAGASCAR' );
INSERT INTO enum_country (id,country) VALUES ( 'MW' , 'MALAWI' );
INSERT INTO enum_country (id,country) VALUES ( 'MY' , 'MALAYSIA' );
INSERT INTO enum_country (id,country) VALUES ( 'MV' , 'MALDIVES' );
INSERT INTO enum_country (id,country) VALUES ( 'ML' , 'MALI' );
INSERT INTO enum_country (id,country) VALUES ( 'MT' , 'MALTA' );
INSERT INTO enum_country (id,country) VALUES ( 'MH' , 'MARSHALL ISLANDS' );
INSERT INTO enum_country (id,country) VALUES ( 'MQ' , 'MARTINIQUE' );
INSERT INTO enum_country (id,country) VALUES ( 'MR' , 'MAURITANIA' );
INSERT INTO enum_country (id,country) VALUES ( 'MU' , 'MAURITIUS' );
INSERT INTO enum_country (id,country) VALUES ( 'YT' , 'MAYOTTE' );
INSERT INTO enum_country (id,country) VALUES ( 'MX' , 'MEXICO' );
INSERT INTO enum_country (id,country) VALUES ( 'FM' , 'MICRONESIA, FEDERATED STATES OF' );
INSERT INTO enum_country (id,country) VALUES ( 'MD' , 'MOLDOVA, REPUBLIC OF' );
INSERT INTO enum_country (id,country) VALUES ( 'MC' , 'MONACO' );
INSERT INTO enum_country (id,country) VALUES ( 'MN' , 'MONGOLIA' );
INSERT INTO enum_country (id,country) VALUES ( 'MS' , 'MONTSERRAT' );
INSERT INTO enum_country (id,country) VALUES ( 'MA' , 'MOROCCO' );
INSERT INTO enum_country (id,country) VALUES ( 'MZ' , 'MOZAMBIQUE' );
INSERT INTO enum_country (id,country) VALUES ( 'MM' , 'MYANMAR' );
INSERT INTO enum_country (id,country) VALUES ( 'NA' , 'NAMIBIA' );
INSERT INTO enum_country (id,country) VALUES ( 'NR' , 'NAURU' );
INSERT INTO enum_country (id,country) VALUES ( 'NP' , 'NEPAL' );
INSERT INTO enum_country (id,country) VALUES ( 'NL' , 'NETHERLANDS' );
INSERT INTO enum_country (id,country) VALUES ( 'AN' , 'NETHERLANDS ANTILLES' );
INSERT INTO enum_country (id,country) VALUES ( 'NC' , 'NEW CALEDONIA' );
INSERT INTO enum_country (id,country) VALUES ( 'NZ' , 'NEW ZEALAND' );
INSERT INTO enum_country (id,country) VALUES ( 'NI' , 'NICARAGUA' );
INSERT INTO enum_country (id,country) VALUES ( 'NE' , 'NIGER' );
INSERT INTO enum_country (id,country) VALUES ( 'NG' , 'NIGERIA' );
INSERT INTO enum_country (id,country) VALUES ( 'NU' , 'NIUE' );
INSERT INTO enum_country (id,country) VALUES ( 'NF' , 'NORFOLK ISLAND' );
INSERT INTO enum_country (id,country) VALUES ( 'MP' , 'NORTHERN MARIANA ISLANDS' );
INSERT INTO enum_country (id,country) VALUES ( 'NO' , 'NORWAY' );
INSERT INTO enum_country (id,country) VALUES ( 'OM' , 'OMAN' );
INSERT INTO enum_country (id,country) VALUES ( 'PK' , 'PAKISTAN' );
INSERT INTO enum_country (id,country) VALUES ( 'PW' , 'PALAU' );
INSERT INTO enum_country (id,country) VALUES ( 'PS' , 'PALESTINIAN TERRITORY, OCCUPIED' );
INSERT INTO enum_country (id,country) VALUES ( 'PA' , 'PANAMA' );
INSERT INTO enum_country (id,country) VALUES ( 'PG' , 'PAPUA NEW GUINEA' );
INSERT INTO enum_country (id,country) VALUES ( 'PY' , 'PARAGUAY' );
INSERT INTO enum_country (id,country) VALUES ( 'PE' , 'PERU' );
INSERT INTO enum_country (id,country) VALUES ( 'PH' , 'PHILIPPINES' );
INSERT INTO enum_country (id,country) VALUES ( 'PN' , 'PITCAIRN' );
INSERT INTO enum_country (id,country) VALUES ( 'PL' , 'POLAND' );
INSERT INTO enum_country (id,country) VALUES ( 'PT' , 'PORTUGAL' );
INSERT INTO enum_country (id,country) VALUES ( 'PR' , 'PUERTO RICO' );
INSERT INTO enum_country (id,country) VALUES ( 'QA' , 'QATAR' );
INSERT INTO enum_country (id,country) VALUES ( 'RE' , 'REUNION' );
INSERT INTO enum_country (id,country) VALUES ( 'RO' , 'ROMANIA' );
INSERT INTO enum_country (id,country) VALUES ( 'RU' , 'RUSSIAN FEDERATION' );
INSERT INTO enum_country (id,country) VALUES ( 'RW' , 'RWANDA' );
INSERT INTO enum_country (id,country) VALUES ( 'SH' , 'SAINT HELENA' );
INSERT INTO enum_country (id,country) VALUES ( 'KN' , 'SAINT KITTS AND NEVIS' );
INSERT INTO enum_country (id,country) VALUES ( 'LC' , 'SAINT LUCIA' );
INSERT INTO enum_country (id,country) VALUES ( 'PM' , 'SAINT PIERRE AND MIQUELON' );
INSERT INTO enum_country (id,country) VALUES ( 'VC' , 'SAINT VINCENT AND THE GRENADINES' );
INSERT INTO enum_country (id,country) VALUES ( 'WS' , 'SAMOA' );
INSERT INTO enum_country (id,country) VALUES ( 'SM' , 'SAN MARINO' );
INSERT INTO enum_country (id,country) VALUES ( 'ST' , 'SAO TOME AND PRINCIPE' );
INSERT INTO enum_country (id,country) VALUES ( 'SA' , 'SAUDI ARABIA' );
INSERT INTO enum_country (id,country) VALUES ( 'SN' , 'SENEGAL' );
INSERT INTO enum_country (id,country) VALUES ( 'CS' , 'SERBIA AND MONTENEGRO' );
INSERT INTO enum_country (id,country) VALUES ( 'SC' , 'SEYCHELLES' );
INSERT INTO enum_country (id,country) VALUES ( 'SL' , 'SIERRA LEONE' );
INSERT INTO enum_country (id,country) VALUES ( 'SG' , 'SINGAPORE' );
INSERT INTO enum_country (id,country) VALUES ( 'SK' , 'SLOVAKIA' );
INSERT INTO enum_country (id,country) VALUES ( 'SI' , 'SLOVENIA' );
INSERT INTO enum_country (id,country) VALUES ( 'SB' , 'SOLOMON ISLANDS' );
INSERT INTO enum_country (id,country) VALUES ( 'SO' , 'SOMALIA' );
INSERT INTO enum_country (id,country) VALUES ( 'ZA' , 'SOUTH AFRICA' );
INSERT INTO enum_country (id,country) VALUES ( 'GS' , 'SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS' );
INSERT INTO enum_country (id,country) VALUES ( 'ES' , 'SPAIN' );
INSERT INTO enum_country (id,country) VALUES ( 'LK' , 'SRI LANKA' );
INSERT INTO enum_country (id,country) VALUES ( 'SD' , 'SUDAN' );
INSERT INTO enum_country (id,country) VALUES ( 'SR' , 'SURINAME' );
INSERT INTO enum_country (id,country) VALUES ( 'SJ' , 'SVALBARD AND JAN MAYEN' );
INSERT INTO enum_country (id,country) VALUES ( 'SZ' , 'SWAZILAND' );
INSERT INTO enum_country (id,country) VALUES ( 'SE' , 'SWEDEN' );
INSERT INTO enum_country (id,country) VALUES ( 'CH' , 'SWITZERLAND' );
INSERT INTO enum_country (id,country) VALUES ( 'SY' , 'SYRIAN ARAB REPUBLIC' );
INSERT INTO enum_country (id,country) VALUES ( 'TW' , 'TAIWAN, PROVINCE OF CHINA' );
INSERT INTO enum_country (id,country) VALUES ( 'TJ' , 'TAJIKISTAN' );
INSERT INTO enum_country (id,country) VALUES ( 'TZ' , 'TANZANIA, UNITED REPUBLIC OF' );
INSERT INTO enum_country (id,country) VALUES ( 'TH' , 'THAILAND' );
INSERT INTO enum_country (id,country) VALUES ( 'TL' , 'TIMOR-LESTE' );
INSERT INTO enum_country (id,country) VALUES ( 'TG' , 'TOGO' );
INSERT INTO enum_country (id,country) VALUES ( 'TK' , 'TOKELAU' );
INSERT INTO enum_country (id,country) VALUES ( 'TO' , 'TONGA' );
INSERT INTO enum_country (id,country) VALUES ( 'TT' , 'TRINIDAD AND TOBAGO' );
INSERT INTO enum_country (id,country) VALUES ( 'TN' , 'TUNISIA' );
INSERT INTO enum_country (id,country) VALUES ( 'TR' , 'TURKEY' );
INSERT INTO enum_country (id,country) VALUES ( 'TM' , 'TURKMENISTAN' );
INSERT INTO enum_country (id,country) VALUES ( 'TC' , 'TURKS AND CAICOS ISLANDS' );
INSERT INTO enum_country (id,country) VALUES ( 'TV' , 'TUVALU' );
INSERT INTO enum_country (id,country) VALUES ( 'UG' , 'UGANDA' );
INSERT INTO enum_country (id,country) VALUES ( 'UA' , 'UKRAINE' );
INSERT INTO enum_country (id,country) VALUES ( 'AE' , 'UNITED ARAB EMIRATES' );
INSERT INTO enum_country (id,country) VALUES ( 'GB' , 'UNITED KINGDOM' );
INSERT INTO enum_country (id,country) VALUES ( 'US' , 'UNITED STATES' );
INSERT INTO enum_country (id,country) VALUES ( 'UM' , 'UNITED STATES MINOR OUTLYING ISLANDS' );
INSERT INTO enum_country (id,country) VALUES ( 'UY' , 'URUGUAY' );
INSERT INTO enum_country (id,country) VALUES ( 'UZ' , 'UZBEKISTAN' );
INSERT INTO enum_country (id,country) VALUES ( 'VU' , 'VANUATU' );
INSERT INTO enum_country (id,country) VALUES ( 'VE' , 'VENEZUELA' );
INSERT INTO enum_country (id,country) VALUES ( 'VN' , 'VIET NAM' );
INSERT INTO enum_country (id,country) VALUES ( 'VG' , 'VIRGIN ISLANDS, BRITISH' );
INSERT INTO enum_country (id,country) VALUES ( 'VI' , 'VIRGIN ISLANDS, U.S.' );
INSERT INTO enum_country (id,country) VALUES ( 'WF' , 'WALLIS AND FUTUNA' );
INSERT INTO enum_country (id,country) VALUES ( 'EH' , 'WESTERN SAHARA' );
INSERT INTO enum_country (id,country) VALUES ( 'YE' , 'YEMEN' );
INSERT INTO enum_country (id,country) VALUES ( 'ZM' , 'ZAMBIA' );
INSERT INTO enum_country (id,country) VALUES ( 'ZW' , 'ZIMBABWE' );
-- encoding
-- country names in czech
UPDATE enum_country SET country_cs= 'Afgh_nist_n'  WHERE ID= 'AF' ;
UPDATE enum_country SET country_cs= 'Alb_nie'  WHERE ID= 'AL' ;
UPDATE enum_country SET country_cs= 'Al__rsko'  WHERE ID= 'DZ' ;
UPDATE enum_country SET country_cs= 'Americk_ Samoa'  WHERE ID= 'AS' ;
UPDATE enum_country SET country_cs= 'Americk_ Panensk_ ostrovy'  WHERE ID= 'VI' ;
UPDATE enum_country SET country_cs= 'Andorra'  WHERE ID= 'AD' ;
UPDATE enum_country SET country_cs= 'Angola'  WHERE ID= 'AO' ;
UPDATE enum_country SET country_cs= 'Anguilla'  WHERE ID= 'AI' ;
UPDATE enum_country SET country_cs= 'Antarktika'  WHERE ID= 'AQ' ;
UPDATE enum_country SET country_cs= 'Antigua a Barbuda'  WHERE ID= 'AG' ;
UPDATE enum_country SET country_cs= 'Argentina'  WHERE ID= 'AR' ;
UPDATE enum_country SET country_cs= 'Arm_nie'  WHERE ID= 'AM' ;
UPDATE enum_country SET country_cs= 'Aruba'  WHERE ID= 'AW' ;
UPDATE enum_country SET country_cs= 'Austr_lie'  WHERE ID= 'AU' ;
UPDATE enum_country SET country_cs= '_zerbajd__n'  WHERE ID= 'AZ' ;
UPDATE enum_country SET country_cs= 'Bahamy'  WHERE ID= 'BS' ;
UPDATE enum_country SET country_cs= 'Bahrajn'  WHERE ID= 'BH' ;
UPDATE enum_country SET country_cs= 'Banglad__'  WHERE ID= 'BD' ;
UPDATE enum_country SET country_cs= 'Barbados'  WHERE ID= 'BB' ;
UPDATE enum_country SET country_cs= 'Barma'  WHERE ID= 'MM' ;
UPDATE enum_country SET country_cs= 'Belgie'  WHERE ID= 'BE' ;
UPDATE enum_country SET country_cs= 'Belize'  WHERE ID= 'BZ' ;
UPDATE enum_country SET country_cs= 'B_lorusko'  WHERE ID= 'BY' ;
UPDATE enum_country SET country_cs= 'Benin'  WHERE ID= 'BJ' ;
UPDATE enum_country SET country_cs= 'Bermudy'  WHERE ID= 'BM' ;
UPDATE enum_country SET country_cs= 'Bh_t_n'  WHERE ID= 'BT' ;
UPDATE enum_country SET country_cs= 'Bol_vie'  WHERE ID= 'BO' ;
UPDATE enum_country SET country_cs= 'Bosna a Hercegovina'  WHERE ID= 'BA' ;
UPDATE enum_country SET country_cs= 'Botswana'  WHERE ID= 'BW' ;
UPDATE enum_country SET country_cs= 'Braz_lie'  WHERE ID= 'BR' ;
UPDATE enum_country SET country_cs= 'Britsk_ indickooce_nsk_ teritorium'  WHERE ID= 'IO' ;
UPDATE enum_country SET country_cs= 'Britsk_ Panensk_ ostrovy'  WHERE ID= 'VG' ;
UPDATE enum_country SET country_cs= 'Brunej'  WHERE ID= 'BN' ;
UPDATE enum_country SET country_cs= 'Bulharsko'  WHERE ID= 'BG' ;
UPDATE enum_country SET country_cs= 'Burkina Faso'  WHERE ID= 'BF' ;
UPDATE enum_country SET country_cs= 'Burundi'  WHERE ID= 'BI' ;
UPDATE enum_country SET country_cs= 'Cookovy ostrovy'  WHERE ID= 'CK' ;
UPDATE enum_country SET country_cs= '_ad'  WHERE ID= 'TD' ;
UPDATE enum_country SET country_cs= '_esk_ republika'  WHERE ID= 'CZ' ;
UPDATE enum_country SET country_cs= '__na'  WHERE ID= 'CN' ;
UPDATE enum_country SET country_cs= 'D_nsko'  WHERE ID= 'DK' ;
UPDATE enum_country SET country_cs= 'Dominika'  WHERE ID= 'DM' ;
UPDATE enum_country SET country_cs= 'Dominik_nsk_ republika'  WHERE ID= 'DO' ;
UPDATE enum_country SET country_cs= 'D_ibuti'  WHERE ID= 'DJ' ;
UPDATE enum_country SET country_cs= 'Egypt'  WHERE ID= 'EG' ;
UPDATE enum_country SET country_cs= 'Ekv_dor'  WHERE ID= 'EC' ;
UPDATE enum_country SET country_cs= 'Eritrea'  WHERE ID= 'ER' ;
UPDATE enum_country SET country_cs= 'Estonsko'  WHERE ID= 'EE' ;
UPDATE enum_country SET country_cs= 'Etiopie'  WHERE ID= 'ET' ;
UPDATE enum_country SET country_cs= 'Faersk_ ostrovy'  WHERE ID= 'FO' ;
UPDATE enum_country SET country_cs= 'Falklandy'  WHERE ID= 'FK' ;
UPDATE enum_country SET country_cs= 'Fid_i'  WHERE ID= 'FJ' ;
UPDATE enum_country SET country_cs= 'Filip_ny'  WHERE ID= 'PH' ;
UPDATE enum_country SET country_cs= 'Finsko'  WHERE ID= 'FI' ;
UPDATE enum_country SET country_cs= 'Francie'  WHERE ID= 'FR' ;
UPDATE enum_country SET country_cs= 'Francouzsk_ Guyana'  WHERE ID= 'GF' ;
UPDATE enum_country SET country_cs= 'Francouzsk_ Polyn_zie'  WHERE ID= 'PF' ;
UPDATE enum_country SET country_cs= 'Francouzsk_ ji_n_ _zem_'  WHERE ID= 'TF' ;
UPDATE enum_country SET country_cs= 'Gabun'  WHERE ID= 'GA' ;
UPDATE enum_country SET country_cs= 'Gambie'  WHERE ID= 'GM' ;
UPDATE enum_country SET country_cs= 'Ghana'  WHERE ID= 'GH' ;
UPDATE enum_country SET country_cs= 'Gibraltar'  WHERE ID= 'GI' ;
UPDATE enum_country SET country_cs= 'Grenada'  WHERE ID= 'GD' ;
UPDATE enum_country SET country_cs= 'Gr_nsko'  WHERE ID= 'GL' ;
UPDATE enum_country SET country_cs= 'Gruzie'  WHERE ID= 'GE' ;
UPDATE enum_country SET country_cs= 'Guadeloupe'  WHERE ID= 'GP' ;
UPDATE enum_country SET country_cs= 'Guam' WHERE ID= 'GU' ;
UPDATE enum_country SET country_cs= 'Guatemala'  WHERE ID= 'GT' ;
UPDATE enum_country SET country_cs= 'Guinea'  WHERE ID= 'GN' ;
UPDATE enum_country SET country_cs= 'Guinea-Bissau'  WHERE ID= 'GW' ;
UPDATE enum_country SET country_cs= 'Guyana'  WHERE ID= 'GY' ;
UPDATE enum_country SET country_cs= 'Haiti'  WHERE ID= 'HT' ;
UPDATE enum_country SET country_cs= 'Honduras'  WHERE ID= 'HN' ;
UPDATE enum_country SET country_cs= 'Hongkong'  WHERE ID= 'HK' ;
UPDATE enum_country SET country_cs= 'Chile'  WHERE ID= 'CL' ;
UPDATE enum_country SET country_cs= 'Chorvatsko'  WHERE ID= 'HR' ;
UPDATE enum_country SET country_cs= 'Indie'  WHERE ID= 'IN' ;
UPDATE enum_country SET country_cs= 'Indon_zie'  WHERE ID= 'ID' ;
UPDATE enum_country SET country_cs= 'Ir_k'  WHERE ID= 'IQ' ;
UPDATE enum_country SET country_cs= '_r_n'  WHERE ID= 'IR' ;
UPDATE enum_country SET country_cs= 'Irsko'  WHERE ID= 'IE' ;
UPDATE enum_country SET country_cs= 'Island'  WHERE ID= 'IS' ;
UPDATE enum_country SET country_cs= 'It_lie'  WHERE ID= 'IT' ;
UPDATE enum_country SET country_cs= 'Izrael'  WHERE ID= 'IL' ;
UPDATE enum_country SET country_cs= 'Jamajka'  WHERE ID= 'JM' ;
UPDATE enum_country SET country_cs= 'Japonsko'  WHERE ID= 'JP' ;
UPDATE enum_country SET country_cs= 'Jemen'  WHERE ID= 'YE' ;
UPDATE enum_country SET country_cs= 'Jihoafrick_ republika'  WHERE ID= 'ZA' ;
UPDATE enum_country SET country_cs= 'Ji_n_ Georgie'  WHERE ID= 'GS' ;
UPDATE enum_country SET country_cs= 'Jord_nsko'  WHERE ID= 'JO' ;
UPDATE enum_country SET country_cs= 'Kajmansk_ ostrovy'  WHERE ID= 'KY' ;
UPDATE enum_country SET country_cs= 'Kambod_a'  WHERE ID= 'KH' ;
UPDATE enum_country SET country_cs= 'Kamerun'  WHERE ID= 'CM' ;
UPDATE enum_country SET country_cs= 'Kanada'  WHERE ID= 'CA' ;
UPDATE enum_country SET country_cs= 'Kapverdy'  WHERE ID= 'CV' ;
UPDATE enum_country SET country_cs= 'Katar'  WHERE ID= 'QA' ;
UPDATE enum_country SET country_cs= 'Kazachst_n'  WHERE ID= 'KZ' ;
UPDATE enum_country SET country_cs= 'Ke_a'  WHERE ID= 'KE' ;
UPDATE enum_country SET country_cs= 'Kiribati'  WHERE ID= 'KI' ;
UPDATE enum_country SET country_cs= 'Kolumbie'  WHERE ID= 'CO' ;
UPDATE enum_country SET country_cs= 'Kokosov_ ostrovy'  WHERE ID= 'CC' ;
UPDATE enum_country SET country_cs= 'Komory'  WHERE ID= 'KM' ;
UPDATE enum_country SET country_cs= 'Kongo'  WHERE ID= 'CG' ;
UPDATE enum_country SET country_cs= 'Kongo (Demokratick_ republika Kongo)'  WHERE ID= 'CD' ;
UPDATE enum_country SET country_cs= 'Severn_ Korea (Korejsk_ lidov_ demokratick_ republika)'  WHERE ID= 'KP' ;
UPDATE enum_country SET country_cs= 'Korea (Korejsk_ republika)'  WHERE ID= 'KR' ;
UPDATE enum_country SET country_cs= 'Kostarika'  WHERE ID= 'CR' ;
UPDATE enum_country SET country_cs= 'Kuba'  WHERE ID= 'CU' ;
UPDATE enum_country SET country_cs= 'Kuvajt'  WHERE ID= 'KW' ;
UPDATE enum_country SET country_cs= 'Kypr'  WHERE ID= 'CY' ;
UPDATE enum_country SET country_cs= 'Kyrgyzst_n'  WHERE ID= 'KG' ;
UPDATE enum_country SET country_cs= 'Laos'  WHERE ID= 'LA' ;
UPDATE enum_country SET country_cs= 'Libanon'  WHERE ID= 'LB' ;
UPDATE enum_country SET country_cs= 'Lesotho'  WHERE ID= 'LS' ;
UPDATE enum_country SET country_cs= 'Lib_rie'  WHERE ID= 'LR' ;
UPDATE enum_country SET country_cs= 'Libye'  WHERE ID= 'LY' ;
UPDATE enum_country SET country_cs= 'Lichten_tejnsko'  WHERE ID= 'LI' ;
UPDATE enum_country SET country_cs= 'Litva'  WHERE ID= 'LT' ;
UPDATE enum_country SET country_cs= 'Loty_sko'  WHERE ID= 'LV' ;
UPDATE enum_country SET country_cs= 'Lucembursko'  WHERE ID= 'LU' ;
UPDATE enum_country SET country_cs= 'Makao'  WHERE ID= 'MO' ;
UPDATE enum_country SET country_cs= 'Makedonie'  WHERE ID= 'MK' ;
UPDATE enum_country SET country_cs= 'Madagaskar'  WHERE ID= 'MG' ;
UPDATE enum_country SET country_cs= 'Ma_arsko'  WHERE ID= 'HU' ;
UPDATE enum_country SET country_cs= 'Malawi'  WHERE ID= 'MW' ;
UPDATE enum_country SET country_cs= 'Malajsie'  WHERE ID= 'MY' ;
UPDATE enum_country SET country_cs= 'Maledivy'  WHERE ID= 'MV' ;
UPDATE enum_country SET country_cs= 'Mali'  WHERE ID= 'ML' ;
UPDATE enum_country SET country_cs= 'Malta'  WHERE ID= 'MT' ;
UPDATE enum_country SET country_cs= 'Maroko'  WHERE ID= 'MA' ;
UPDATE enum_country SET country_cs= 'Marshallovy ostrovy'  WHERE ID= 'MH' ;
UPDATE enum_country SET country_cs= 'Martinik'  WHERE ID= 'MQ' ;
UPDATE enum_country SET country_cs= 'Mauret_nie'  WHERE ID= 'MR' ;
UPDATE enum_country SET country_cs= 'Mauricius'  WHERE ID= 'MU' ;
UPDATE enum_country SET country_cs= 'Mayotte'  WHERE ID= 'YT' ;
UPDATE enum_country SET country_cs= 'Mexiko'  WHERE ID= 'MX' ;
UPDATE enum_country SET country_cs= 'Mikron_sie'  WHERE ID= 'FM' ;
UPDATE enum_country SET country_cs= 'Moldavsko'  WHERE ID= 'MD' ;
UPDATE enum_country SET country_cs= 'Monako'  WHERE ID= 'MC' ;
UPDATE enum_country SET country_cs= 'Mongolsko'  WHERE ID= 'MN' ;
UPDATE enum_country SET country_cs= 'Montserrat'  WHERE ID= 'MS' ;
UPDATE enum_country SET country_cs= 'Mosambik'  WHERE ID= 'MZ' ;
UPDATE enum_country SET country_cs= 'Nam_bie'  WHERE ID= 'NA' ;
UPDATE enum_country SET country_cs= 'Nauru'  WHERE ID= 'NR' ;
UPDATE enum_country SET country_cs= 'N_mecko'  WHERE ID= 'DE' ;
UPDATE enum_country SET country_cs= 'Nep_l'  WHERE ID= 'NP' ;
UPDATE enum_country SET country_cs= 'Niger'  WHERE ID= 'NE' ;
UPDATE enum_country SET country_cs= 'Nig_rie'  WHERE ID= 'NG' ;
UPDATE enum_country SET country_cs= 'Nikaragua'  WHERE ID= 'NI' ;
UPDATE enum_country SET country_cs= 'Nizozem_'  WHERE ID= 'NL' ;
UPDATE enum_country SET country_cs= 'Nizozemsk_ Antily'  WHERE ID= 'AN' ;
UPDATE enum_country SET country_cs= 'Niue'  WHERE ID= 'NU' ;
UPDATE enum_country SET country_cs= 'Norfolk'  WHERE ID= 'NF' ;
UPDATE enum_country SET country_cs= 'Norsko'  WHERE ID= 'NO' ;
UPDATE enum_country SET country_cs= 'Nov_ Kaledonie'  WHERE ID= 'NC' ;
UPDATE enum_country SET country_cs= 'Nov_ Z_land'  WHERE ID= 'NZ' ;
UPDATE enum_country SET country_cs= 'Om_n'  WHERE ID= 'OM' ;
UPDATE enum_country SET country_cs= 'P_kist_n'  WHERE ID= 'PK' ;
UPDATE enum_country SET country_cs= 'Palau'  WHERE ID= 'PW' ;
UPDATE enum_country SET country_cs= 'Palestina'  WHERE ID= 'PS' ;
UPDATE enum_country SET country_cs= 'Panama'  WHERE ID= 'PA' ;
UPDATE enum_country SET country_cs= 'Papua Nov_ Guinea'  WHERE ID= 'PG' ;
UPDATE enum_country SET country_cs= 'Paraguay'  WHERE ID= 'PY' ;
UPDATE enum_country SET country_cs= 'Peru'  WHERE ID= 'PE' ;
UPDATE enum_country SET country_cs= 'Pitcairnovy ostrovy'  WHERE ID= 'PN' ;
UPDATE enum_country SET country_cs= 'Pob_e__ slonoviny'  WHERE ID= 'CI' ;
UPDATE enum_country SET country_cs= 'Polsko'  WHERE ID= 'PL' ;
UPDATE enum_country SET country_cs= 'Portoriko'  WHERE ID= 'PR' ;
UPDATE enum_country SET country_cs= 'Portugalsko'  WHERE ID= 'PT' ;
UPDATE enum_country SET country_cs= 'Rakousko'  WHERE ID= 'AT' ;
UPDATE enum_country SET country_cs= 'R_union'  WHERE ID= 'RE' ;
UPDATE enum_country SET country_cs= 'Rovn_kov_ Guinea'  WHERE ID= 'GQ' ;
UPDATE enum_country SET country_cs= 'Rumunsko'  WHERE ID= 'RO' ;
UPDATE enum_country SET country_cs= 'Rusko'  WHERE ID= 'RU' ;
UPDATE enum_country SET country_cs= 'Rwanda'  WHERE ID= 'RW' ;
UPDATE enum_country SET country_cs= '_ecko'  WHERE ID= 'GR' ;
UPDATE enum_country SET country_cs= 'Salvador'  WHERE ID= 'SV' ;
UPDATE enum_country SET country_cs= 'Samoa'  WHERE ID= 'WS' ;
UPDATE enum_country SET country_cs= 'San Marino'  WHERE ID= 'SM' ;
UPDATE enum_country SET country_cs= 'Sa_dsk_ Ar_bie'  WHERE ID= 'SA' ;
UPDATE enum_country SET country_cs= 'Senegal'  WHERE ID= 'SN' ;
UPDATE enum_country SET country_cs= 'Severn_ Mariany'  WHERE ID= 'MP' ;
UPDATE enum_country SET country_cs= 'Seychely'  WHERE ID= 'SC' ;
UPDATE enum_country SET country_cs= 'Sierra Leone'  WHERE ID= 'SL' ;
UPDATE enum_country SET country_cs= 'Singapur'  WHERE ID= 'SG' ;
UPDATE enum_country SET country_cs= 'Slovensko'  WHERE ID= 'SK' ;
UPDATE enum_country SET country_cs= 'Slovinsko'  WHERE ID= 'SI' ;
UPDATE enum_country SET country_cs= 'Som_lsko'  WHERE ID= 'SO' ;
UPDATE enum_country SET country_cs= 'Spojen_ arabsk_ emir_ty'  WHERE ID= 'AE' ;
UPDATE enum_country SET country_cs= 'Spojen_ st_ty americk_'  WHERE ID= 'US' ;
UPDATE enum_country SET country_cs= 'Srbsko a _ern_ hora'  WHERE ID= 'CS' ;
UPDATE enum_country SET country_cs= 'Sr_ Lanka (Cejlon)'  WHERE ID= 'LK' ;
UPDATE enum_country SET country_cs= 'St_edoafrick_ republika'  WHERE ID= 'CF' ;
UPDATE enum_country SET country_cs= 'S_d_n'  WHERE ID= 'SD' ;
UPDATE enum_country SET country_cs= 'Surinam'  WHERE ID= 'SR' ;
UPDATE enum_country SET country_cs= 'Svat_ Helena'  WHERE ID= 'SH' ;
UPDATE enum_country SET country_cs= 'Svat_ Lucie'  WHERE ID= 'LC' ;
UPDATE enum_country SET country_cs= 'Svazijsko'  WHERE ID= 'SZ' ;
UPDATE enum_country SET country_cs= 'S_rie'  WHERE ID= 'SY' ;
UPDATE enum_country SET country_cs= '_alomounovy ostrovy'  WHERE ID= 'SB' ;
UPDATE enum_country SET country_cs= '_pan_lsko'  WHERE ID= 'ES' ;
UPDATE enum_country SET country_cs= '_picberky'  WHERE ID= 'SJ' ;
UPDATE enum_country SET country_cs= '_v_dsko'  WHERE ID= 'SE' ;
UPDATE enum_country SET country_cs= '_v_carsko'  WHERE ID= 'CH' ;
UPDATE enum_country SET country_cs= 'T_d_ikist_n'  WHERE ID= 'TJ' ;
UPDATE enum_country SET country_cs= 'Tanz_nie'  WHERE ID= 'TZ' ;
UPDATE enum_country SET country_cs= 'Thajsko'  WHERE ID= 'TH' ;
UPDATE enum_country SET country_cs= 'Tchajwan'  WHERE ID= 'TW' ;
UPDATE enum_country SET country_cs= 'Togo'  WHERE ID= 'TG' ;
UPDATE enum_country SET country_cs= 'Tokelau'  WHERE ID= 'TK' ;
UPDATE enum_country SET country_cs= 'Tonga'  WHERE ID= 'TO' ;
UPDATE enum_country SET country_cs= 'Trinidad a Tobago'  WHERE ID= 'TT' ;
UPDATE enum_country SET country_cs= 'Tunisko'  WHERE ID= 'TN' ;
UPDATE enum_country SET country_cs= 'Turecko'  WHERE ID= 'TR' ;
UPDATE enum_country SET country_cs= 'Turkmenist_n'  WHERE ID= 'TM' ;
UPDATE enum_country SET country_cs= 'Tuvalu'  WHERE ID= 'TV' ;
UPDATE enum_country SET country_cs= 'Uganda'  WHERE ID= 'UG' ;
UPDATE enum_country SET country_cs= 'Ukrajina'  WHERE ID= 'UA' ;
UPDATE enum_country SET country_cs= 'Uruguay'  WHERE ID= 'UY' ;
UPDATE enum_country SET country_cs= 'Uzbekist_n'  WHERE ID= 'UZ' ;
UPDATE enum_country SET country_cs= 'V_no_n_ ostrov'  WHERE ID= 'CX' ;
UPDATE enum_country SET country_cs= 'Vanuatu'  WHERE ID= 'VU' ;
UPDATE enum_country SET country_cs= 'Vatik_n'  WHERE ID= 'VA' ;
UPDATE enum_country SET country_cs= 'Velk_ Brit_nie a Severn_ Irsko'  WHERE ID= 'GB' ;
UPDATE enum_country SET country_cs= 'Venezuela'  WHERE ID= 'VE' ;
UPDATE enum_country SET country_cs= 'Vietnam'  WHERE ID= 'VN' ;
UPDATE enum_country SET country_cs= 'V_chodn_ timor'  WHERE ID= 'TL' ;
UPDATE enum_country SET country_cs= 'Wallisovy ostrovy'  WHERE ID= 'WF' ;
UPDATE enum_country SET country_cs= 'Zambie'  WHERE ID= 'ZM' ;
UPDATE enum_country SET country_cs= 'Z_padn_ Sahara'  WHERE ID= 'EH' ;
UPDATE enum_country SET country_cs= 'Zimbabwe'  WHERE ID= 'ZW' ;

COMMIT;
