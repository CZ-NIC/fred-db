-- tabulky pro ukladani hostorie
-- ukladaji se pouze operace DELETE UPDATE TRANSFER 
-- CREATE neni treba ukladat

DROP TABLE History CASCADE;
CREATE TABLE History (
        ID SERIAL PRIMARY KEY,
        action INTEGER NOT NULL REFERENCES action, -- odkaz to tabulky action         
        ModDate timestamp NOT NULL DEFAULT now() -- datum a cas provedene zmeny
        );
        


DROP TABLE Contact_History CASCADE;
CREATE TABLE Contact_History (
        HISTORYID SERIAL PRIMARY  KEY REFERENCES History,
        ID INTEGER   NOT NULL,
        Handle varchar(255)  NOT NULL,
        ROID varchar(255)  NOT NULL,
        Status smallint[], -- TODO: create trigger to check values agains enum_status
# zruseno        ClID INTEGER NOT NULL REFERENCES Registrar,
        CrID INTEGER NOT NULL REFERENCES Registrar,
        CrDate timestamp NOT NULL, -- DEFAULT now(),
        UpID INTEGER REFERENCES Registrar,
        UpDate timestamp,
# zruseno       TrDate timestamp,
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
# zruseno       AuthInfoPw varchar(32),
        NotifyEmail varchar(1024),
        VAT varchar(32),
        SSN varchar(32)
        );

CREATE INDEX contact_history_historyid_idx ON Contact_History (historyID);


DROP TABLE Domain_History CASCADE;
CREATE TABLE Domain_History (
        HISTORYID SERIAL PRIMARY KEY REFERENCES History,          
        Zone INTEGER REFERENCES Zone (ID),
        ID INTEGER   NOT NULL,
        ROID varchar(255)  NOT NULL,
        FQDN varchar(255)  NOT NULL,
        Status smallint[], -- TODO: create trigger to check values agains enum_status
        Registrant INTEGER REFERENCES Contact,
        NSSet INTEGER REFERENCES NSSet,
        ClID INTEGER NOT NULL REFERENCES Registrar,
        CrID INTEGER NOT NULL REFERENCES Registrar,
        CrDate timestamp NOT NULL,
        UpID INTEGER REFERENCES Registrar,
        UpDate timestamp,
        ExDate timestamp NOT NULL,
        TrDate timestamp,
        AuthInfoPw varchar(32)
        );
CREATE INDEX domain_History_historyid_idx ON Domain_History (historyID);

DROP TABLE domain_contact_map_history CASCADE;
CREATE TABLE domain_contact_map_history  (
        historyID SERIAL REFERENCES History,       
        DomainID INTEGER, --REFERENCES Domain ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
        ContactID INTEGER --REFERENCES Contact ON UPDATE CASCADE NOT NULL,
       -- UNIQUE (DomainID, ContactID)
        );
-- CREATE INDEX domain_contact_map_domainid_idx ON domain_contact_map (DomainID);

DROP TABLE NSSet_history  CASCADE;
CREATE TABLE NSSet_history  (
        historyID SERIAL PRIMARY KEY REFERENCES History, -- pouze jeden nsset 
        ID INTEGER  NOT NULL,
        ROID varchar(255)  NOT NULL,
        Handle varchar(255)  NOT NULL,
        Status smallint[], -- TODO: create trigger to check values agains enum_status
        ClID INTEGER NOT NULL REFERENCES Registrar,
        CrID INTEGER NOT NULL REFERENCES Registrar,
        CrDate timestamp NOT NULL,
        UpID INTEGER REFERENCES Registrar,
        UpDate timestamp,
        AuthInfoPw varchar(32)
        );
CREATE INDEX nsset_history_historyid_idx ON NSSet_History (historyID);

DROP TABLE nsset_contact_map_history  CASCADE;
CREATE TABLE nsset_contact_map_history (
        historyID SERIAL  REFERENCES History,
        NSSetID INTEGER, -- REFERENCES NSSet ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
        ContactID INTEGER -- REFERENCES Contact ON UPDATE CASCADE NOT NULL,
        -- UNIQUE (NSSetID, ContactID)
        );

DROP TABLE Host_history  CASCADE;
CREATE TABLE Host_history  (
        historyID SERIAL  REFERENCES History,  -- muze byt vice hostu takze to neni primary key
        ID  INTEGER  NOT NULL,
        NSSetID INTEGER, -- REFERENCES NSSet ON UPDATE CASCADE,
        FQDN VARCHAR(255)  NOT NULL,
        ClID INTEGER NOT NULL REFERENCES Registrar, -- ON UPDATE CASCADE,
        CrDate TIMESTAMP NOT NULL,
        UpID INTEGER NOT NULL REFERENCES Registrar, -- ON UPDATE CASCADE ON DELETE SET NULL,
        UpDate TIMESTAMP NOT NULL,
        Status INTEGER[], -- TODO: write trigger to check values
        IpAddr INET[] NOT NULL -- NOTE: we don't have to store IP version, since it's obvious from address
        );

CREATE INDEX host_history_historyid_idx ON HOST_History (historyID);

DROP TABLE ENUMVal_history  CASCADE;
CREATE TABLE ENUMVal_history (
        historyID SERIAL PRIMARY KEY REFERENCES History, -- pouze jeden nsset 
        DomainID INTEGER NOT NULL,
        ExDate timestamp NOT NULL
        );

CREATE INDEX ENUMVal_history_historyid_idx ON ENUMVal_History (historyID);
