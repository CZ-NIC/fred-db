--
-- verze skriptu setup_db.sql na vytvoreni a zakladni incializaci tabulek v
-- databazi pro Oracle.
-- Seznam zmen (nekompatibilit s postgresql):
--     datovy typ serial je nahrazen numberem, sekvenci a triggerem
--     pole jsou nahrazeny varcharem
--     vyzaduje DEFAULT pred NOT NULL
--     klicove slovo update nemuze byt atributem (-> updatex)
--     neexistuje boolean -> pouzit char(1) s default 'f'
--     zda se ze vyrazy ON akce CASCADE oracle nezkousava (vyskrtnuto)
--     nektere dlouhe identifikatory oracle nezkousne (zkraceno)
--     typ TEXT nahrazen varcharem(1000)
--
--  -> z toho vseho plyne ze databaze oraclu a postgresql jsou po vytvoreni
--     nekompatibilni



-- ciselnik chybovych hlaseni
-- DROP TABLE enum_error  CASCADE;
CREATE TABLE enum_error (
        id NUMBER PRIMARY KEY,
        status varchar(128) UNIQUE NOT NULL,
        status_cs varchar(128) UNIQUE NOT NULL -- cesky preklad
        );
-- chybove zpravy EN a CS


INSERT INTO enum_error VALUES(  1000 , 'Command completed successfully',    'Pøíkaz úspì¹nì proveden');
INSERT INTO enum_error VALUES(  1001 , 'Command completed successfully; action pending',  'Pøíkaz úspì¹nì proveden; vykonání akce odlo¾eno');

INSERT INTO enum_error VALUES(  1300 , 'Command completed successfully; no messages',    'Pøíkaz úspì¹nì proveden; ¾ádné nové zprávy');
INSERT INTO enum_error VALUES(  1301 , 'Command completed successfully; ack to dequeue',    'Pøíkaz úspì¹nì proveden; potvrï za úèelem vyøazení z fronty');
INSERT INTO enum_error VALUES(  1500 , 'Command completed successfully; ending session',    'Pøíkaz úspì¹nì proveden; konec relace');


INSERT INTO enum_error VALUES(  2000 ,    'Unknown command',    'Neznámý pøíkaz');
INSERT INTO enum_error VALUES(  2001 ,    'Command syntax error',    'Chybná syntaxe pøíkazu');
INSERT INTO enum_error VALUES(  2002 ,    'Command use error',     'Chybné pou¾ití pøíkazu');
INSERT INTO enum_error VALUES(  2003 ,    'Required parameter missing',    'Po¾adovaný parametr neuveden');
INSERT INTO enum_error VALUES(  2004 ,    'Parameter value range error',    'Chybný rozsah parametru');
INSERT INTO enum_error VALUES(  2005 ,    'Parameter value syntax error',    'Chybná syntaxe hodnoty parametru');


INSERT INTO enum_error VALUES( 2100 ,   'Unimplemented protocol version',    'Neimplementovaná verze protokolu');
INSERT INTO enum_error VALUES( 2101 ,   'Unimplemented command',     'Neimplementovaný pøíkaz');
INSERT INTO enum_error VALUES( 2102 ,   'Unimplemented option',    'Neimplementovaná volba');
INSERT INTO enum_error VALUES( 2103 ,   'Unimplemented extension',    'Neimplementované roz¹íøení');
INSERT INTO enum_error VALUES( 2104 ,   'Billing failure',     'Úèetní selhání');
INSERT INTO enum_error VALUES( 2105 ,   'Object is not eligible for renewal',     'Objekt je nezpùsobilý pro obnovení');
INSERT INTO enum_error VALUES( 2106 ,   'Object is not eligible for transfer',    'Objekt je nezpùsobilý pro transfer');


INSERT INTO enum_error VALUES( 2200 ,    'Authentication error',    'Chyba ovìøení identity');
INSERT INTO enum_error VALUES( 2201 ,    'Authorization error',     'Chyba oprávnìní');
INSERT INTO enum_error VALUES( 2202 ,    'Invalid authorization information',    'Chybná autorizaèní informace');

INSERT INTO enum_error VALUES( 2300 ,    'Object pending transfer',    'Objekt èeká na transfer');
INSERT INTO enum_error VALUES( 2301 ,    'Object not pending transfer',    'Objekt neèeká na transfer');
INSERT INTO enum_error VALUES( 2302 ,    'Object exists',    'Objekt existuje');
INSERT INTO enum_error VALUES( 2303 ,    'Object does not exist',    'Objekt neexistuje');
INSERT INTO enum_error VALUES( 2304 ,    'Object status prohibits operation',    'Status objektu nedovoluje operaci');
INSERT INTO enum_error VALUES( 2305 ,    'Object association prohibits operation',    'Asociace objektu nedovoluje operaci');
INSERT INTO enum_error VALUES( 2306 ,    'Parameter value policy error',    'Chyba zásady pro hodnotu parametru');
INSERT INTO enum_error VALUES( 2307 ,    'Unimplemented object service',    'Neimplementovaná slu¾ba objektu');
INSERT INTO enum_error VALUES( 2308 ,    'Data management policy violation',    'Poru¹ení zásady pro správu dat');

INSERT INTO enum_error VALUES( 2400 ,    'Command failed',    'Pøíkaz selhal');
INSERT INTO enum_error VALUES( 2500 ,    'Command failed; server closing connection',    'Pøíkaz selhal; server uzavírá spojení');
INSERT INTO enum_error VALUES( 2501 ,    'Authentication error; server closing connection',    'Chyba ovìøení identity; server uzavírá spojení');
INSERT INTO enum_error VALUES( 2502 ,    'Session limit exceeded; server closing connection',    'Limit na poèet relací pøekroèen; server uzavírá spojení');



                                                                                                
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
        country_cs  varchar(1024) UNIQUE -- volitelne cesky nazev 
        );


-- DROP TABLE zone CASCADE;
CREATE TABLE zone (
        id number PRIMARY KEY,
        fqdn VARCHAR(255) UNIQUE NOT NULL,
	ex_period_min int not null,
        ex_period_max int not null,
        val_period int not null
        );
CREATE SEQUENCE zone_id_seq START WITH 1 INCREMENT BY 1;
--CREATE OR REPLACE TRIGGER zone_trigger BEFORE INSERT ON zone
--REFERENCING NEW AS NEW
--FOR EACH ROW
--BEGIN
--	SELECT zone_id_seq.nextval INTO :NEW.ID FROM dual;
--END;
--/

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
CREATE SEQUENCE registrar_id_seq START WITH 1 INCREMENT BY 1;
--CREATE OR REPLACE TRIGGER registrar_trigger BEFORE INSERT ON registrar
--REFERENCING NEW AS NEW
--FOR EACH ROW
--BEGIN
--	SELECT registrar_id_seq.nextval INTO :NEW.ID FROM dual;
--END;
--/

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

--CREATE SEQUENCE contact_id_seq START WITH 1 INCREMENT BY 1;
--CREATE OR REPLACE TRIGGER contact_trigger BEFORE INSERT ON contact
--REFERENCING NEW AS NEW
--FOR EACH ROW
--BEGIN
--	SELECT contact_id_seq.nextval INTO :NEW.ID FROM dual;
--END;
--/


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
CREATE SEQUENCE nsset_id_seq START WITH 1 INCREMENT BY 1;
--CREATE OR REPLACE TRIGGER nsset_trigger BEFORE INSERT ON nsset
--REFERENCING NEW AS NEW
--FOR EACH ROW
--BEGIN
--	SELECT nsset_id_seq.nextval INTO :NEW.ID FROM dual;
--END;
--/


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
        UNIQUE (NSSetID, FQDN ) -- unikatni klic
        );
CREATE SEQUENCE host_id_seq START WITH 1 INCREMENT BY 1;
--CREATE OR REPLACE TRIGGER host_trigger BEFORE INSERT ON host
--REFERENCING NEW AS NEW
--FOR EACH ROW
--BEGIN
--	SELECT host_id_seq.nextval INTO :NEW.ID FROM dual;
--END;
--/
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
CREATE SEQUENCE domain_id_seq START WITH 1 INCREMENT BY 1;
--CREATE OR REPLACE TRIGGER domain_trigger BEFORE INSERT ON domain
--REFERENCING NEW AS NEW
--FOR EACH ROW
--BEGIN
--	SELECT domain_id_seq.nextval INTO :NEW.ID FROM dual;
--END;
--/


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
CREATE SEQUENCE message_id_seq START WITH 1 INCREMENT BY 1;
--CREATE OR REPLACE TRIGGER message_trigger BEFORE INSERT ON message
--REFERENCING NEW AS NEW
--FOR EACH ROW
--BEGIN
--	SELECT message_id_seq.nextval INTO :NEW.ID FROM dual;
--END;
--/

-- login tabulka pro pihlasovani clientu
-- DROP TABLE Login CASCADE;
CREATE TABLE Login (
        ID number PRIMARY KEY, -- vraci se jako clientID z CORBA funkce Login
	RegistrarID INTEGER NOT NULL REFERENCES Registrar, -- id registratora
        LoginDate timestamp DEFAULT current_timestamp NOT NULL, -- datum a cas prihlaseni do systemu
        loginTRID varchar(128) NOT NULL, -- cislo prihlasovaci transakce
	LogoutDate timestamp, -- datum a cas odhlaseni
        logoutTRID varchar(128), -- cislo odhlasovaci transakce
        lang  varchar(2) DEFAULT 'en' NOT NULL -- jazyk ve kterem se vraceji chybove zpravy
        );
CREATE SEQUENCE login_id_seq START WITH 1 INCREMENT BY 1;
--CREATE OR REPLACE TRIGGER login_trigger BEFORE INSERT ON login
--REFERENCING NEW AS NEW
--FOR EACH ROW
--BEGIN
--	SELECT login_id_seq.nextval INTO :NEW.ID FROM dual;
--END;
--/


-- ciselnik funkci
-- DROP TABLE enum_action CASCADE;
CREATE TABLE enum_action (
        id number PRIMARY KEY,
        status varchar(64) UNIQUE NOT NULL
        );

-- prihlasovaci funkce
INSERT INTO enum_action (id , status) VALUES(100 , 'ClientLogin');
INSERT INTO enum_action (id , status) VALUES(101 , 'ClientLogout');
-- poll funkce
INSERT INTO enum_action (id , status) VALUES(  120 , 'PollAcknowledgement' );
INSERT INTO enum_action (id , status) VALUES(  121 ,  'PollResponse' );

 
-- funkce pro praci s kontakty
INSERT INTO enum_action (id , status) VALUES(200 , 'ContactCheck');
INSERT INTO enum_action (id , status) VALUES(201 , 'ContactInfo');
INSERT INTO enum_action (id , status) VALUES(202 , 'ContactDelete');
INSERT INTO enum_action (id , status) VALUES(203 , 'ContactUpdate');
INSERT INTO enum_action (id , status) VALUES(204 , 'ContactCreate');

-- funkce pro hosty
INSERT INTO enum_action (id , status) VALUES(300 , 'HostCheck');
INSERT INTO enum_action (id , status) VALUES(301 , 'HostInfo');
INSERT INTO enum_action (id , status) VALUES(302 , 'HostDelete');
INSERT INTO enum_action (id , status) VALUES(303 , 'HostUpdate');
INSERT INTO enum_action (id , status) VALUES(304 , 'HostCreate');

-- funkce pro NSSET
INSERT INTO enum_action (id , status) VALUES(400 , 'NSsetCheck');
INSERT INTO enum_action (id , status) VALUES(401 , 'NSsetInfo');
INSERT INTO enum_action (id , status) VALUES(402 , 'NSsetDelete');
INSERT INTO enum_action (id , status) VALUES(403 , 'NSsetUpdate');
INSERT INTO enum_action (id , status) VALUES(404 , 'NSsetCreate');
INSERT INTO enum_action (id , status) VALUES(405 , 'NSsetTransfer');

-- funkce pro domeny
INSERT INTO enum_action (id , status) VALUES(500 , 'DomainCheck');
INSERT INTO enum_action (id , status) VALUES(501 , 'DomainInfo');
INSERT INTO enum_action (id , status) VALUES(502 , 'DomainDelete');
INSERT INTO enum_action (id , status) VALUES(503 , 'DomainUpdate');
INSERT INTO enum_action (id , status) VALUES(504 , 'DomainCreate');
INSERT INTO enum_action (id , status) VALUES(505 , 'DomainTransfer');
INSERT INTO enum_action (id , status) VALUES(506 , 'DomainRenew');
INSERT INTO enum_action (id , status) VALUES(507 , 'DomainTrade');

-- funkce nezadana
INSERT INTO enum_action (id , status) VALUES( 1000 , 'UnknowAction');

--  tabulka pro zapis transakci
-- DROP TABLE Action CASCADE;
CREATE TABLE Action (
        ID number PRIMARY KEY, -- id zaznamu
	clientID INTEGER REFERENCES Login, -- id clienta z tabulky Login moznost i nula
	action INTEGER NOT NULL REFERENCES enum_action, -- typ funkce z enum cisleniku
        response  INTEGER  REFERENCES enum_error, -- navratovt kod funkce 
        StartDate timestamp DEFAULT current_timestamp NOT NULL, -- datum a cas prihlaseni do systemu
        clientTRID varchar(128) NOT NULL, -- cislo prihlasovaci transakce
	EndDate timestamp, -- datum a cas uknceni funkce
        serverTRID varchar(128) UNIQUE   -- cislo transakce ze servru 
        );
CREATE SEQUENCE action_id_seq START WITH 1 INCREMENT BY 1;
--CREATE OR REPLACE TRIGGER action_trigger BEFORE INSERT ON action
--REFERENCING NEW AS NEW
--FOR EACH ROW
--BEGIN
--	SELECT action_id_seq.nextval INTO :NEW.ID FROM dual;
--END;
--/

-- tabulky pro ukladani hostorie
-- ukladaji se pouze operace DELETE UPDATE TRANSFER 
-- CREATE neni treba ukladat

-- DROP TABLE History CASCADE;
CREATE TABLE History (
        ID number PRIMARY KEY,
        action INTEGER NOT NULL REFERENCES action, -- odkaz to tabulky action         
        ModDate timestamp DEFAULT current_timestamp NOT NULL -- datum a cas provedene zmeny
        );
CREATE SEQUENCE history_id_seq START WITH 1 INCREMENT BY 1;
--CREATE OR REPLACE TRIGGER history_trigger BEFORE INSERT ON history
--REFERENCING NEW AS NEW
--FOR EACH ROW
--BEGIN
--	SELECT history_id_seq.nextval INTO :NEW.ID FROM dual;
--END;
--/

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
        Registrant INTEGER , -- zrusena reference
        NSSet INTEGER  -- zruseny reference
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
        historyID number PRIMARY KEY REFERENCES History, -- pouze jeden nsset 
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
        historyID number  REFERENCES History,  -- muze byt vice hostu takze to neni primary key
        ID  INTEGER  NOT NULL,
        NSSetID INTEGER NOT NULL, -- REFERENCES NSSet ON UPDATE CASCADE,
        FQDN VARCHAR(255)  NOT NULL,
        IpAddr varchar(255) NOT NULL -- NOTE: we don't have to store IP version, since it's obvious from address
        );

CREATE INDEX host_history_historyid_idx ON HOST_History (historyID);

-- DROP TABLE ENUMVal_history  CASCADE;
CREATE TABLE ENUMVal_history (
        historyID number PRIMARY KEY REFERENCES History, -- pouze jeden nsset 
        DomainID INTEGER NOT NULL,
        ExDate timestamp NOT NULL
        );

CREATE INDEX ENUMVal_history_historyid_idx ON ENUMVal_History (historyID);
-- tabulka pro pricitani creditu za operace DomainCreate a DomainReNew
-- DROP TABLE Credit CASCADE;

-- vymaz vsechny zaznamy 
DELETE FROM  enum_country ;
-- nacti vsechny staty
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
-- kodovani
\encoding       LATIN2
-- nazvy zemi v cestine
UPDATE enum_country SET country_cs= 'Afghánistán'  WHERE ID= 'AF' ;
UPDATE enum_country SET country_cs= 'Albánie'  WHERE ID= 'AL' ;
UPDATE enum_country SET country_cs= 'Al¾írsko'  WHERE ID= 'DZ' ;
UPDATE enum_country SET country_cs= 'Americká Samoa'  WHERE ID= 'AS' ;
UPDATE enum_country SET country_cs= 'Americké Panenské ostrovy'  WHERE ID= 'VI' ;
UPDATE enum_country SET country_cs= 'Andorra'  WHERE ID= 'AD' ;
UPDATE enum_country SET country_cs= 'Angola'  WHERE ID= 'AO' ;
UPDATE enum_country SET country_cs= 'Anguilla'  WHERE ID= 'AI' ;
UPDATE enum_country SET country_cs= 'Antarktika'  WHERE ID= 'AQ' ;
UPDATE enum_country SET country_cs= 'Antigua a Barbuda'  WHERE ID= 'AG' ;
UPDATE enum_country SET country_cs= 'Argentina'  WHERE ID= 'AR' ;
UPDATE enum_country SET country_cs= 'Arménie'  WHERE ID= 'AM' ;
UPDATE enum_country SET country_cs= 'Aruba'  WHERE ID= 'AW' ;
UPDATE enum_country SET country_cs= 'Austrálie'  WHERE ID= 'AU' ;
UPDATE enum_country SET country_cs= 'Ázerbajd¾án'  WHERE ID= 'AZ' ;
UPDATE enum_country SET country_cs= 'Bahamy'  WHERE ID= 'BS' ;
UPDATE enum_country SET country_cs= 'Bahrajn'  WHERE ID= 'BH' ;
UPDATE enum_country SET country_cs= 'Bangladé¹'  WHERE ID= 'BD' ;
UPDATE enum_country SET country_cs= 'Barbados'  WHERE ID= 'BB' ;
UPDATE enum_country SET country_cs= 'Barma'  WHERE ID= 'MM' ;
UPDATE enum_country SET country_cs= 'Belgie'  WHERE ID= 'BE' ;
UPDATE enum_country SET country_cs= 'Belize'  WHERE ID= 'BZ' ;
UPDATE enum_country SET country_cs= 'Bìlorusko'  WHERE ID= 'BY' ;
UPDATE enum_country SET country_cs= 'Benin'  WHERE ID= 'BJ' ;
UPDATE enum_country SET country_cs= 'Bermudy'  WHERE ID= 'BM' ;
UPDATE enum_country SET country_cs= 'Bhútán'  WHERE ID= 'BT' ;
UPDATE enum_country SET country_cs= 'Bolívie'  WHERE ID= 'BO' ;
UPDATE enum_country SET country_cs= 'Bosna a Hercegovina'  WHERE ID= 'BA' ;
UPDATE enum_country SET country_cs= 'Botswana'  WHERE ID= 'BW' ;
UPDATE enum_country SET country_cs= 'Brazílie'  WHERE ID= 'BR' ;
UPDATE enum_country SET country_cs= 'Britské indickooceánské teritorium'  WHERE ID= 'IO' ;
UPDATE enum_country SET country_cs= 'Britské Panenské ostrovy'  WHERE ID= 'VG' ;
UPDATE enum_country SET country_cs= 'Brunej'  WHERE ID= 'BN' ;
UPDATE enum_country SET country_cs= 'Bulharsko'  WHERE ID= 'BG' ;
UPDATE enum_country SET country_cs= 'Burkina Faso'  WHERE ID= 'BF' ;
UPDATE enum_country SET country_cs= 'Burundi'  WHERE ID= 'BI' ;
UPDATE enum_country SET country_cs= 'Cookovy ostrovy'  WHERE ID= 'CK' ;
UPDATE enum_country SET country_cs= 'Èad'  WHERE ID= 'TD' ;
UPDATE enum_country SET country_cs= 'Èeská republika'  WHERE ID= 'CZ' ;
UPDATE enum_country SET country_cs= 'Èína'  WHERE ID= 'CN' ;
UPDATE enum_country SET country_cs= 'Dánsko'  WHERE ID= 'DK' ;
UPDATE enum_country SET country_cs= 'Dominika'  WHERE ID= 'DM' ;
UPDATE enum_country SET country_cs= 'Dominikánská republika'  WHERE ID= 'DO' ;
UPDATE enum_country SET country_cs= 'D¾ibuti'  WHERE ID= 'DJ' ;
UPDATE enum_country SET country_cs= 'Egypt'  WHERE ID= 'EG' ;
UPDATE enum_country SET country_cs= 'Ekvádor'  WHERE ID= 'EC' ;
UPDATE enum_country SET country_cs= 'Eritrea'  WHERE ID= 'ER' ;
UPDATE enum_country SET country_cs= 'Estonsko'  WHERE ID= 'EE' ;
UPDATE enum_country SET country_cs= 'Etiopie'  WHERE ID= 'ET' ;
UPDATE enum_country SET country_cs= 'Faerské ostrovy'  WHERE ID= 'FO' ;
UPDATE enum_country SET country_cs= 'Falklandy'  WHERE ID= 'FK' ;
UPDATE enum_country SET country_cs= 'Fid¾i'  WHERE ID= 'FJ' ;
UPDATE enum_country SET country_cs= 'Filipíny'  WHERE ID= 'PH' ;
UPDATE enum_country SET country_cs= 'Finsko'  WHERE ID= 'FI' ;
UPDATE enum_country SET country_cs= 'Francie'  WHERE ID= 'FR' ;
UPDATE enum_country SET country_cs= 'Francouzská Guyana'  WHERE ID= 'GF' ;
UPDATE enum_country SET country_cs= 'Francouzská Polynézie'  WHERE ID= 'PF' ;
UPDATE enum_country SET country_cs= 'Francouzská ji¾ní území'  WHERE ID= 'TF' ;
UPDATE enum_country SET country_cs= 'Gabun'  WHERE ID= 'GA' ;
UPDATE enum_country SET country_cs= 'Gambie'  WHERE ID= 'GM' ;
UPDATE enum_country SET country_cs= 'Ghana'  WHERE ID= 'GH' ;
UPDATE enum_country SET country_cs= 'Gibraltar'  WHERE ID= 'GI' ;
UPDATE enum_country SET country_cs= 'Grenada'  WHERE ID= 'GD' ;
UPDATE enum_country SET country_cs= 'Grónsko'  WHERE ID= 'GL' ;
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
UPDATE enum_country SET country_cs= 'Indonézie'  WHERE ID= 'ID' ;
UPDATE enum_country SET country_cs= 'Irák'  WHERE ID= 'IQ' ;
UPDATE enum_country SET country_cs= 'Írán'  WHERE ID= 'IR' ;
UPDATE enum_country SET country_cs= 'Irsko'  WHERE ID= 'IE' ;
UPDATE enum_country SET country_cs= 'Island'  WHERE ID= 'IS' ;
UPDATE enum_country SET country_cs= 'Itálie'  WHERE ID= 'IT' ;
UPDATE enum_country SET country_cs= 'Izrael'  WHERE ID= 'IL' ;
UPDATE enum_country SET country_cs= 'Jamajka'  WHERE ID= 'JM' ;
UPDATE enum_country SET country_cs= 'Japonsko'  WHERE ID= 'JP' ;
UPDATE enum_country SET country_cs= 'Jemen'  WHERE ID= 'YE' ;
UPDATE enum_country SET country_cs= 'Jihoafrická republika'  WHERE ID= 'ZA' ;
UPDATE enum_country SET country_cs= 'Ji¾ní Georgie'  WHERE ID= 'GS' ;
UPDATE enum_country SET country_cs= 'Jordánsko'  WHERE ID= 'JO' ;
UPDATE enum_country SET country_cs= 'Kajmanské ostrovy'  WHERE ID= 'KY' ;
UPDATE enum_country SET country_cs= 'Kambod¾a'  WHERE ID= 'KH' ;
UPDATE enum_country SET country_cs= 'Kamerun'  WHERE ID= 'CM' ;
UPDATE enum_country SET country_cs= 'Kanada'  WHERE ID= 'CA' ;
UPDATE enum_country SET country_cs= 'Kapverdy'  WHERE ID= 'CV' ;
UPDATE enum_country SET country_cs= 'Katar'  WHERE ID= 'QA' ;
UPDATE enum_country SET country_cs= 'Kazachstán'  WHERE ID= 'KZ' ;
UPDATE enum_country SET country_cs= 'Keòa'  WHERE ID= 'KE' ;
UPDATE enum_country SET country_cs= 'Kiribati'  WHERE ID= 'KI' ;
UPDATE enum_country SET country_cs= 'Kolumbie'  WHERE ID= 'CO' ;
UPDATE enum_country SET country_cs= 'Kokosové ostrovy'  WHERE ID= 'CC' ;
UPDATE enum_country SET country_cs= 'Komory'  WHERE ID= 'KM' ;
UPDATE enum_country SET country_cs= 'Kongo'  WHERE ID= 'CG' ;
UPDATE enum_country SET country_cs= 'Kongo (Demokratická republika Kongo)'  WHERE ID= 'CD' ;
UPDATE enum_country SET country_cs= 'Severní Korea (Korejská lidovì demokratická republika)'  WHERE ID= 'KP' ;
UPDATE enum_country SET country_cs= 'Korea (Korejská republika)'  WHERE ID= 'KR' ;
UPDATE enum_country SET country_cs= 'Kostarika'  WHERE ID= 'CR' ;
UPDATE enum_country SET country_cs= 'Kuba'  WHERE ID= 'CU' ;
UPDATE enum_country SET country_cs= 'Kuvajt'  WHERE ID= 'KW' ;
UPDATE enum_country SET country_cs= 'Kypr'  WHERE ID= 'CY' ;
UPDATE enum_country SET country_cs= 'Kyrgyzstán'  WHERE ID= 'KG' ;
UPDATE enum_country SET country_cs= 'Laos'  WHERE ID= 'LA' ;
UPDATE enum_country SET country_cs= 'Libanon'  WHERE ID= 'LB' ;
UPDATE enum_country SET country_cs= 'Lesotho'  WHERE ID= 'LS' ;
UPDATE enum_country SET country_cs= 'Libérie'  WHERE ID= 'LR' ;
UPDATE enum_country SET country_cs= 'Libye'  WHERE ID= 'LY' ;
UPDATE enum_country SET country_cs= 'Lichten¹tejnsko'  WHERE ID= 'LI' ;
UPDATE enum_country SET country_cs= 'Litva'  WHERE ID= 'LT' ;
UPDATE enum_country SET country_cs= 'Loty¹sko'  WHERE ID= 'LV' ;
UPDATE enum_country SET country_cs= 'Lucembursko'  WHERE ID= 'LU' ;
UPDATE enum_country SET country_cs= 'Makao'  WHERE ID= 'MO' ;
UPDATE enum_country SET country_cs= 'Makedonie'  WHERE ID= 'MK' ;
UPDATE enum_country SET country_cs= 'Madagaskar'  WHERE ID= 'MG' ;
UPDATE enum_country SET country_cs= 'Maïarsko'  WHERE ID= 'HU' ;
UPDATE enum_country SET country_cs= 'Malawi'  WHERE ID= 'MW' ;
UPDATE enum_country SET country_cs= 'Malajsie'  WHERE ID= 'MY' ;
UPDATE enum_country SET country_cs= 'Maledivy'  WHERE ID= 'MV' ;
UPDATE enum_country SET country_cs= 'Mali'  WHERE ID= 'ML' ;
UPDATE enum_country SET country_cs= 'Malta'  WHERE ID= 'MT' ;
UPDATE enum_country SET country_cs= 'Maroko'  WHERE ID= 'MA' ;
UPDATE enum_country SET country_cs= 'Marshallovy ostrovy'  WHERE ID= 'MH' ;
UPDATE enum_country SET country_cs= 'Martinik'  WHERE ID= 'MQ' ;
UPDATE enum_country SET country_cs= 'Mauretánie'  WHERE ID= 'MR' ;
UPDATE enum_country SET country_cs= 'Mauricius'  WHERE ID= 'MU' ;
UPDATE enum_country SET country_cs= 'Mayotte'  WHERE ID= 'YT' ;
UPDATE enum_country SET country_cs= 'Mexiko'  WHERE ID= 'MX' ;
UPDATE enum_country SET country_cs= 'Mikronésie'  WHERE ID= 'FM' ;
UPDATE enum_country SET country_cs= 'Moldavsko'  WHERE ID= 'MD' ;
UPDATE enum_country SET country_cs= 'Monako'  WHERE ID= 'MC' ;
UPDATE enum_country SET country_cs= 'Mongolsko'  WHERE ID= 'MN' ;
UPDATE enum_country SET country_cs= 'Montserrat'  WHERE ID= 'MS' ;
UPDATE enum_country SET country_cs= 'Mosambik'  WHERE ID= 'MZ' ;
UPDATE enum_country SET country_cs= 'Namíbie'  WHERE ID= 'NA' ;
UPDATE enum_country SET country_cs= 'Nauru'  WHERE ID= 'NR' ;
UPDATE enum_country SET country_cs= 'Nìmecko'  WHERE ID= 'DE' ;
UPDATE enum_country SET country_cs= 'Nepál'  WHERE ID= 'NP' ;
UPDATE enum_country SET country_cs= 'Niger'  WHERE ID= 'NE' ;
UPDATE enum_country SET country_cs= 'Nigérie'  WHERE ID= 'NG' ;
UPDATE enum_country SET country_cs= 'Nikaragua'  WHERE ID= 'NI' ;
UPDATE enum_country SET country_cs= 'Nizozemí'  WHERE ID= 'NL' ;
UPDATE enum_country SET country_cs= 'Nizozemské Antily'  WHERE ID= 'AN' ;
UPDATE enum_country SET country_cs= 'Niue'  WHERE ID= 'NU' ;
UPDATE enum_country SET country_cs= 'Norfolk'  WHERE ID= 'NF' ;
UPDATE enum_country SET country_cs= 'Norsko'  WHERE ID= 'NO' ;
UPDATE enum_country SET country_cs= 'Nová Kaledonie'  WHERE ID= 'NC' ;
UPDATE enum_country SET country_cs= 'Nový Zéland'  WHERE ID= 'NZ' ;
UPDATE enum_country SET country_cs= 'Omán'  WHERE ID= 'OM' ;
UPDATE enum_country SET country_cs= 'Pákistán'  WHERE ID= 'PK' ;
UPDATE enum_country SET country_cs= 'Palau'  WHERE ID= 'PW' ;
UPDATE enum_country SET country_cs= 'Palestina'  WHERE ID= 'PS' ;
UPDATE enum_country SET country_cs= 'Panama'  WHERE ID= 'PA' ;
UPDATE enum_country SET country_cs= 'Papua Nová Guinea'  WHERE ID= 'PG' ;
UPDATE enum_country SET country_cs= 'Paraguay'  WHERE ID= 'PY' ;
UPDATE enum_country SET country_cs= 'Peru'  WHERE ID= 'PE' ;
UPDATE enum_country SET country_cs= 'Pitcairnovy ostrovy'  WHERE ID= 'PN' ;
UPDATE enum_country SET country_cs= 'Pobøe¾í slonoviny'  WHERE ID= 'CI' ;
UPDATE enum_country SET country_cs= 'Polsko'  WHERE ID= 'PL' ;
UPDATE enum_country SET country_cs= 'Portoriko'  WHERE ID= 'PR' ;
UPDATE enum_country SET country_cs= 'Portugalsko'  WHERE ID= 'PT' ;
UPDATE enum_country SET country_cs= 'Rakousko'  WHERE ID= 'AT' ;
UPDATE enum_country SET country_cs= 'Réunion'  WHERE ID= 'RE' ;
UPDATE enum_country SET country_cs= 'Rovníková Guinea'  WHERE ID= 'GQ' ;
UPDATE enum_country SET country_cs= 'Rumunsko'  WHERE ID= 'RO' ;
UPDATE enum_country SET country_cs= 'Rusko'  WHERE ID= 'RU' ;
UPDATE enum_country SET country_cs= 'Rwanda'  WHERE ID= 'RW' ;
UPDATE enum_country SET country_cs= 'Øecko'  WHERE ID= 'GR' ;
UPDATE enum_country SET country_cs= 'Salvador'  WHERE ID= 'SV' ;
UPDATE enum_country SET country_cs= 'Samoa'  WHERE ID= 'WS' ;
UPDATE enum_country SET country_cs= 'San Marino'  WHERE ID= 'SM' ;
UPDATE enum_country SET country_cs= 'Saúdská Arábie'  WHERE ID= 'SA' ;
UPDATE enum_country SET country_cs= 'Senegal'  WHERE ID= 'SN' ;
UPDATE enum_country SET country_cs= 'Severní Mariany'  WHERE ID= 'MP' ;
UPDATE enum_country SET country_cs= 'Seychely'  WHERE ID= 'SC' ;
UPDATE enum_country SET country_cs= 'Sierra Leone'  WHERE ID= 'SL' ;
UPDATE enum_country SET country_cs= 'Singapur'  WHERE ID= 'SG' ;
UPDATE enum_country SET country_cs= 'Slovensko'  WHERE ID= 'SK' ;
UPDATE enum_country SET country_cs= 'Slovinsko'  WHERE ID= 'SI' ;
UPDATE enum_country SET country_cs= 'Somálsko'  WHERE ID= 'SO' ;
UPDATE enum_country SET country_cs= 'Spojené arabské emiráty'  WHERE ID= 'AE' ;
UPDATE enum_country SET country_cs= 'Spojené státy americké'  WHERE ID= 'US' ;
UPDATE enum_country SET country_cs= 'Srbsko a Èerná hora'  WHERE ID= 'CS' ;
UPDATE enum_country SET country_cs= 'Srí Lanka (Cejlon)'  WHERE ID= 'LK' ;
UPDATE enum_country SET country_cs= 'Støedoafrická republika'  WHERE ID= 'CF' ;
UPDATE enum_country SET country_cs= 'Súdán'  WHERE ID= 'SD' ;
UPDATE enum_country SET country_cs= 'Surinam'  WHERE ID= 'SR' ;
UPDATE enum_country SET country_cs= 'Svatá Helena'  WHERE ID= 'SH' ;
UPDATE enum_country SET country_cs= 'Svatá Lucie'  WHERE ID= 'LC' ;
UPDATE enum_country SET country_cs= 'Svazijsko'  WHERE ID= 'SZ' ;
UPDATE enum_country SET country_cs= 'Sýrie'  WHERE ID= 'SY' ;
UPDATE enum_country SET country_cs= '©alomounovy ostrovy'  WHERE ID= 'SB' ;
UPDATE enum_country SET country_cs= '©panìlsko'  WHERE ID= 'ES' ;
UPDATE enum_country SET country_cs= '©picberky'  WHERE ID= 'SJ' ;
UPDATE enum_country SET country_cs= '©védsko'  WHERE ID= 'SE' ;
UPDATE enum_country SET country_cs= '©výcarsko'  WHERE ID= 'CH' ;
UPDATE enum_country SET country_cs= 'Tád¾ikistán'  WHERE ID= 'TJ' ;
UPDATE enum_country SET country_cs= 'Tanzánie'  WHERE ID= 'TZ' ;
UPDATE enum_country SET country_cs= 'Thajsko'  WHERE ID= 'TH' ;
UPDATE enum_country SET country_cs= 'Tchajwan'  WHERE ID= 'TW' ;
UPDATE enum_country SET country_cs= 'Togo'  WHERE ID= 'TG' ;
UPDATE enum_country SET country_cs= 'Tokelau'  WHERE ID= 'TK' ;
UPDATE enum_country SET country_cs= 'Tonga'  WHERE ID= 'TO' ;
UPDATE enum_country SET country_cs= 'Trinidad a Tobago'  WHERE ID= 'TT' ;
UPDATE enum_country SET country_cs= 'Tunisko'  WHERE ID= 'TN' ;
UPDATE enum_country SET country_cs= 'Turecko'  WHERE ID= 'TR' ;
UPDATE enum_country SET country_cs= 'Turkmenistán'  WHERE ID= 'TM' ;
UPDATE enum_country SET country_cs= 'Tuvalu'  WHERE ID= 'TV' ;
UPDATE enum_country SET country_cs= 'Uganda'  WHERE ID= 'UG' ;
UPDATE enum_country SET country_cs= 'Ukrajina'  WHERE ID= 'UA' ;
UPDATE enum_country SET country_cs= 'Uruguay'  WHERE ID= 'UY' ;
UPDATE enum_country SET country_cs= 'Uzbekistán'  WHERE ID= 'UZ' ;
UPDATE enum_country SET country_cs= 'Vánoèní ostrov'  WHERE ID= 'CX' ;
UPDATE enum_country SET country_cs= 'Vanuatu'  WHERE ID= 'VU' ;
UPDATE enum_country SET country_cs= 'Vatikán'  WHERE ID= 'VA' ;
UPDATE enum_country SET country_cs= 'Velká Británie a Severní Irsko'  WHERE ID= 'GB' ;
UPDATE enum_country SET country_cs= 'Venezuela'  WHERE ID= 'VE' ;
UPDATE enum_country SET country_cs= 'Vietnam'  WHERE ID= 'VN' ;
UPDATE enum_country SET country_cs= 'Východní timor'  WHERE ID= 'TL' ;
UPDATE enum_country SET country_cs= 'Wallisovy ostrovy'  WHERE ID= 'WF' ;
UPDATE enum_country SET country_cs= 'Zambie'  WHERE ID= 'ZM' ;
UPDATE enum_country SET country_cs= 'Západní Sahara'  WHERE ID= 'EH' ;
UPDATE enum_country SET country_cs= 'Zimbabwe'  WHERE ID= 'ZW' ;
