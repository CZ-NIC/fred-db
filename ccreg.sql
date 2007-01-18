-- DROP TABLE  OBJECT  CASCADE;


CREATE TABLE OBJECT_registry (
       ID SERIAL PRIMARY KEY,
       ROID varchar(255) UNIQUE NOT NULL , -- unikatni roid
       type smallint , -- typ objektu 1 kontakt 2 nsset 3 domena
       NAME varchar(255)  NOT NULL , -- handle ci FQDN
       CrID INTEGER NOT NULL REFERENCES Registrar,
       CrDate timestamp NOT NULL DEFAULT now(),
       ErDate timestamp DEFAULT NULL, -- erase date 
       CrhistoryID INTEGER  REFERENCES History, -- odkaz do historie vytvoreni
       historyID integer REFERENCES history -- odkaz na posledni zmenu v historii                 
       );

-- index
CREATE INDEX object_registry_name_idx ON Object_registry  (NAME);

CREATE TABLE OBJECT (
        ID INTEGER PRIMARY KEY  REFERENCES object_registry (id),
        ClID INTEGER NOT NULL REFERENCES Registrar,
        UpID INTEGER REFERENCES Registrar,
        TrDate timestamp DEFAULT NULL,
        UpDate timestamp DEFAULT NULL,
        AuthInfoPw varchar(300) -- dle Honzy v XML schematech
        );

-- indexy
CREATE INDEX object_id_idx ON Object (ID);


-- DROP TABLE Contact CASCADE;
CREATE TABLE Contact (
        ID INTEGER PRIMARY KEY REFERENCES object (id),
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
        NotifyEmail varchar(1024),
        VAT varchar(32),
        SSN varchar(32),
	SSNtype INTEGER REFERENCES enum_ssntype
        );
CREATE INDEX contact_id_idx ON Contact (ID);



-- DROP TABLE NSSet CASCADE;
CREATE TABLE NSSet (
        ID INTEGER PRIMARY KEY REFERENCES object (id),
        checklevel smallint default 0
        );
CREATE INDEX nsset_id_idx ON NSSet (ID);

-- DROP TABLE nsset_contact_map CASCADE;
CREATE TABLE nsset_contact_map (
        NSSetID INTEGER REFERENCES NSSet ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
        ContactID INTEGER REFERENCES Contact ON UPDATE CASCADE NOT NULL,
        PRIMARY KEY (NSSetID, ContactID)
        );
CREATE INDEX nsset_contact_map_nssetid_idx ON nsset_contact_map (NSSetID);


-- DROP TABLE Host CASCADE;
CREATE TABLE Host (
        ID SERIAL PRIMARY KEY,
        NSSetID INTEGER REFERENCES NSSet ON UPDATE CASCADE,
        FQDN VARCHAR(255)   NOT NULL,  -- nemuze byt UNIQUE pro dva ruzne nssety stejny dns host
        UNIQUE (NSSetID, FQDN ) -- unikatni klic
        );


CREATE INDEX host_nsset_idx ON Host (NSSetID);
CREATE INDEX host_fqdn_idx ON Host (FQDN);

-- DROP TABLE  host_ipaddr_map  CASCADE;
CREATE TABLE host_ipaddr_map (
           ID SERIAL PRIMARY KEY,
           HostID  INTEGER NOT NULL REFERENCES HOST ON UPDATE CASCADE ON DELETE CASCADE,
           NSSetID INTEGER NOT NULL REFERENCES NSSET ON UPDATE CASCADE ON DELETE CASCADE, 
           IpAddr INET NOT NULL -- ip adresa
         );


-- DROP TABLE Domain CASCADE;
CREATE TABLE Domain (
        ID INTEGER PRIMARY KEY REFERENCES object (ID),
        Zone INTEGER REFERENCES Zone (ID),
        Registrant INTEGER NOT NULL REFERENCES Contact,
        NSSet INTEGER NULL REFERENCES NSSet, -- odkaz na nsset muze by i NULL lze zaregistrovat domenu bez nssetu
        Exdate timestamp NOT NULL
        );
CREATE INDEX domain_zone_idx ON Domain (Zone);
CREATE INDEX domain_id_idx ON Domain (ID);

-- DROP TABLE domain_contact_map CASCADE;
CREATE TABLE domain_contact_map (
        DomainID INTEGER REFERENCES Domain ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
        ContactID INTEGER REFERENCES Contact ON UPDATE CASCADE NOT NULL,
        PRIMARY KEY (DomainID, ContactID)
        );
CREATE INDEX domain_contact_map_domainid_idx ON domain_contact_map (DomainID);



-- DROP TABLE DNSSEC CASCADE;
CREATE TABLE DNSSEC (
        DomainID INTEGER PRIMARY KEY REFERENCES Domain ON UPDATE CASCADE ON DELETE CASCADE,
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
        ExDate date NOT NULL
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

