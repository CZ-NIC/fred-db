-- DROP TABLE  OBJECT  CASCADE;

CREATE TABLE OBJECT (
        ID SERIAL PRIMARY KEY,
        historyID integer REFERENCES history, -- odkaz na posledni zmenu v historii
        type smallint , -- typ objektu 1 kontakt 2 nsset 3 domena
        NAME varchar(255) UNIQUE NOT NULL , -- handle ci FQDN
        ROID varchar(64) UNIQUE NOT NULL,
        ClID INTEGER NOT NULL REFERENCES Registrar,
        CrID INTEGER NOT NULL REFERENCES Registrar,
        UpID INTEGER REFERENCES Registrar,
        CrDate timestamp NOT NULL DEFAULT now(),
        TrDate timestamp DEFAULT NULL,
        UpDate timestamp DEFAULT NULL,
        AuthInfoPw varchar(300) -- dle Honzy v XML schematech
        );



-- DROP TABLE Contact CASCADE;
CREATE TABLE Contact (
        ID INTEGER PRIMARY KEY REFERENCES object (id),
-- REMOVE        Handle varchar(255) UNIQUE NOT NULL,
-- REMOVE        ROID varchar(255) UNIQUE NOT NULL,
-- REMOVE        Status smallint[], -- TODO: create trigger to check values agains enum_status
-- REMOVE        ClID INTEGER NOT NULL REFERENCES Registrar,
-- REMOVE        CrID INTEGER NOT NULL REFERENCES Registrar,
-- REMOVE        CrDate timestamp NOT NULL DEFAULT now(),
-- REMOVE        UpID INTEGER REFERENCES Registrar,
-- REMOVE        UpDate timestamp,
-- REMOVE        TrDate timestamp,
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
        DiscloseName boolean DEFAULT False,
        DiscloseOrganization boolean DEFAULT False,
        DiscloseAddress boolean DEFAULT False,
        DiscloseTelephone boolean DEFAULT False,
        DiscloseFax boolean DEFAULT False,
        DiscloseEmail boolean DEFAULT False,
--         AuthInfoPw varchar(32),
        NotifyEmail varchar(1024),
        VAT varchar(32),
        SSN varchar(32),
	SSNtype INTEGER REFERENCES enum_ssntype
        );
CREATE INDEX contact_id_idx ON Contact (ID);


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
        ID INTEGER PRIMARY KEY REFERENCES object (id),
-- REMOVE        ROID varchar(255) UNIQUE NOT NULL,
-- REMOVE        Handle varchar(255) UNIQUE NOT NULL,
-- REMOVE        Status smallint[], -- TODO: create trigger to check values agains enum_status
-- REMOVE        ClID INTEGER NOT NULL REFERENCES Registrar,
-- REMOVE        CrID INTEGER NOT NULL REFERENCES Registrar,
-- REMOVE        CrDate timestamp NOT NULL DEFAULT now(),
-- REMOVE        UpID INTEGER REFERENCES Registrar,
-- REMOVE        AuthInfoPw varchar(32),
-- REMOVE        TrDate timestamp,
-- REMOVE        UpDate timestamp,
        checklevel smallint default 0
        );
CREATE INDEX nsset_id_idx ON NSSet (ID);

-- DROP TABLE nsset_contact_map CASCADE;
CREATE TABLE nsset_contact_map (
        NSSetID INTEGER REFERENCES NSSet ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
        ContactID INTEGER REFERENCES Contact ON UPDATE CASCADE NOT NULL,
        UNIQUE (NSSetID, ContactID)
        );
CREATE INDEX nsset_contact_map_nssetid_idx ON nsset_contact_map (NSSetID);


-- DROP TABLE Host CASCADE;
CREATE TABLE Host (
        ID SERIAL PRIMARY KEY,
        NSSetID INTEGER REFERENCES NSSet ON UPDATE CASCADE,
        FQDN VARCHAR(255)   NOT NULL,  -- nemuze byt UNIQUE pro dva ruzne nssety stejny dns host
--        ClID INTEGER NOT NULL REFERENCES Registrar ON UPDATE CASCADE,
-- zruseno        CrDate TIMESTAMP NOT NULL,
-- duplicitni    UpID INTEGER NOT NULL REFERENCES Registrar ON UPDATE CASCADE ON DELETE SET NULL,
-- udaje         UpDate TIMESTAMP NOT NULL,
-- s nsset       Status INTEGER[], -- TODO: write trigger to check values
-- zruseno nahrazeno vazebni tabulkou host_ipaddr_map
--     IpAddr INET[] NOT NULL,  -- NOTE: we don't have to store IP version, since it's obvious from address
        UNIQUE (NSSetID, FQDN ) -- unikatni klic
        );


CREATE INDEX host_nsset_idx ON Host (NSSetID);
CREATE INDEX host_fqdn_idx ON Host (FQDN);

-- DROP TABLE  host_ipaddr_map  CASCADE;
CREATE TABLE host_ipaddr_map (
           HostID  INTEGER NOT NULL REFERENCES HOST ON UPDATE CASCADE ON DELETE CASCADE,
           NSSetID INTEGER NOT NULL REFERENCES NSSET ON UPDATE CASCADE ON DELETE CASCADE, 
           IpAddr INET NOT NULL -- ip adresa
         );


-- DROP TABLE Domain CASCADE;
CREATE TABLE Domain (
        ID INTEGER PRIMARY KEY REFERENCES object (ID),
        Zone INTEGER REFERENCES Zone (ID),

-- REMOVE        ROID varchar(255) UNIQUE NOT NULL,
-- REMOVE        FQDN varchar(255) UNIQUE NOT NULL,
-- REMOVE        Status smallint[], -- TODO: create trigger to check values agains enum_status
        Registrant INTEGER NOT NULL REFERENCES Contact,
        NSSet INTEGER NULL REFERENCES NSSet, -- odkaz na nsset muze by i NULL lze zaregistrovat domenu bez nssetu
-- REMOVE        ClID INTEGER NOT NULL REFERENCES Registrar,
-- REMOVE        CrID INTEGER NOT NULL REFERENCES Registrar,
-- REMOVE        CrDate timestamp NOT NULL DEFAULT now(),
-- REMOVE        UpID INTEGER REFERENCES Registrar,
        Exdate timestamp NOT NULL,
-- REMOVE        TrDate timestamp,
-- REMOVE        AuthInfoPw varchar(32),
        UpDate timestamp
        );
CREATE INDEX domain_zone_idx ON Domain (Zone);
CREATE INDEX domain_id_idx ON Domain (ID);

-- DROP TABLE domain_contact_map CASCADE;
CREATE TABLE domain_contact_map (
        DomainID INTEGER REFERENCES Domain ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
        ContactID INTEGER REFERENCES Contact ON UPDATE CASCADE NOT NULL,
        UNIQUE (DomainID, ContactID)
        );
CREATE INDEX domain_contact_map_domainid_idx ON domain_contact_map (DomainID);


-- DROP TABLE domain_host_map CASCADE;
-- CREATE TABLE domain_host_map (
--         DomainID INTEGER NOT NULL REFERENCES Domain ON UPDATE CASCADE ON DELETE CASCADE,
--         HostID INTEGER NOT NULL REFERENCES Host ON UPDATE CASCADE,
--         UNIQUE (DomainID, HostID)
--         );
-- CREATE INDEX domain_host_map_domainid_idx ON domain_host_map (DomainID);

-- DROP TABLE DNSSEC CASCADE;
CREATE TABLE DNSSEC (
        DomainID INTEGER NOT NULL REFERENCES Domain ON UPDATE CASCADE ON DELETE CASCADE,
        KeyTag varchar(255) NOT NULL,
        Alg smallint NOT NULL CHECK (Alg >= 0 AND Alg <= 255),
        DigestType smallint NOT NULL,
        Digest character varying (255) NOT NULL,
        MaxSigLive interval NULL,
        KeyFlags BIT(16) CHECK (BIT '1000000010000000' & KeyFlags = KeyFlags),
        KeyProtocol smallint CHECK (KeyProtocol = 3),
        KeyAlg smallint CHECK (KeyAlg >= 0 AND KeyAlg <= 255),
        PubKey character varying(1024)
        );        

-- DROP TABLE ENUMVal CASCADE;
CREATE TABLE ENUMVal (
        DomainID INTEGER NOT NULL PRIMARY KEY REFERENCES Domain ON UPDATE CASCADE ON DELETE CASCADE,
        ExDate timestamp NOT NULL
        );

-- DROP TABLE Message;
CREATE TABLE Message (
        ID SERIAL PRIMARY KEY,
        ClID INTEGER NOT NULL REFERENCES Registrar ON UPDATE CASCADE,
        CrDate timestamp NOT NULL DEFAULT now(),
        ExDate TIMESTAMP,
        Seen BOOLEAN NOT NULL DEFAULT false,
        Message TEXT NOT NULL
        );
CREATE INDEX message_clid_idx ON message (clid);
CREATE INDEX message_seen_idx ON message (clid,seen,crdate,exdate);

