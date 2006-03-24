
DROP TABLE enum_status CASCADE;
CREATE TABLE enum_status (
        id SERIAL PRIMARY KEY,
        status varchar(64) UNIQUE NOT NULL
        );

INSERT INTO enum_status (status) VALUES('clientDeleteProhibited');
INSERT INTO enum_status (status) VALUES('serverDeleteProhibited');
INSERT INTO enum_status (status) VALUES('clientHold');
INSERT INTO enum_status (status) VALUES('serverHold');
INSERT INTO enum_status (status) VALUES('clientRenewProhibited');
INSERT INTO enum_status (status) VALUES('serverRenewProhibited');
INSERT INTO enum_status (status) VALUES('clientTransferProhibited');
INSERT INTO enum_status (status) VALUES('serverTransferProhibited');
INSERT INTO enum_status (status) VALUES('clientUpdateProhibited');
INSERT INTO enum_status (status) VALUES('serverUpdateProhibited');
INSERT INTO enum_status (status) VALUES('inactive');
INSERT INTO enum_status (status) VALUES('ok');
INSERT INTO enum_status (status) VALUES('pendingCreate');
INSERT INTO enum_status (status) VALUES('pendingDelete');
INSERT INTO enum_status (status) VALUES('pendingRenew');
INSERT INTO enum_status (status) VALUES('pendingTransfer');
INSERT INTO enum_status (status) VALUES('pendingUpdate');

DROP TABLE enum_country CASCADE;
CREATE TABLE enum_country (
        id char(2) PRIMARY KEY,
        country varchar(1024) UNIQUE NOT NULL
        );

INSERT INTO enum_country (id, country) VALUES('cz', 'Czech Republic');
INSERT INTO enum_country (id, country) VALUES('sk', 'Slovak Republic');

DROP TABLE zone CASCADE;
CREATE TABLE zone (
        id SERIAL PRIMARY KEY,
        fqdn VARCHAR(255) UNIQUE NOT NULL,
        roid VARCHAR(255) UNIQUE NOT NULL
        );

INSERT INTO zone (fqdn, roid) VALUES('0.2.4.e164.arpa', '0.2.4.e164.arpa');
INSERT INTO zone (fqdn, roid) VALUES('0.2.4.c.e164.arpa', '0.2.4.c.e164.arpa');
INSERT INTO zone (fqdn, roid) VALUES('cz', 'cz');

DROP TABLE Registrar CASCADE;
CREATE TABLE Registrar (
        ID SERIAL PRIMARY KEY,
        ROID varchar(255) UNIQUE NOT NULL,
        Handle varchar(255) UNIQUE NOT NULL,
        Status smallint[], -- TODO: create trigger to check values agains enum_status
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

DROP TABLE RegistrarACL CASCADE;
CREATE TABLE RegistrarACL (
        RegistrarID INTEGER NOT NULL REFERENCES Registrar,
        ZoneID INTEGER NOT NULL REFERENCES Zone,
        Cert varchar(1024) NOT NULL, -- certificate fingerprint
        Password varchar(64) NOT NULL
        );

DROP TABLE Contact CASCADE;
CREATE TABLE Contact (
        ID SERIAL PRIMARY KEY,
        Handle varchar(255) UNIQUE NOT NULL,
        ROID varchar(255) UNIQUE NOT NULL,
        Status smallint[], -- TODO: create trigger to check values agains enum_status
        ClID INTEGER NOT NULL REFERENCES Registrar,
        CrID INTEGER NOT NULL REFERENCES Registrar,
        CrDate timestamp NOT NULL DEFAULT now(),
        UpID INTEGER REFERENCES Registrar,
        UpDate timestamp,
        TrDate timestamp,
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
        AuthInfoPw varchar(32),
        NotifyEmail varchar(1024),
        VAT varchar(32),
        SSN varchar(32)
        );
CREATE INDEX contact_id_idx ON Contact (ID);
CREATE INDEX contact_roid_idx ON Contact (ROID);
CREATE INDEX contact_handle_idx ON Contact (Handle);

DROP TABLE Term CASCADE;
CREATE TABLE Term (
        ID SERIAL PRIMARY KEY,
        CrDate date NOT NULL
        );

DROP TABLE ContactAgreement CASCADE;
CREATE TABLE ContactAgreement (
        ID SERIAL PRIMARY KEY,
        ContactID INTEGER NOT NULL REFERENCES Contact ON UPDATE Cascade,
        TermID INTEGER NOT NULL REFERENCES Term ON UPDATE Cascade
        );
CREATE INDEX contactagreement_contactid_idx ON ContactAgreement (ContactID);
CREATE INDEX contactagreement_termid_id ON ContactAgreement (TermID);

DROP TABLE Domain CASCADE;
CREATE TABLE Domain (
        Zone INTEGER REFERENCES Zone (ID),
        ID SERIAL PRIMARY KEY,
        ROID varchar(255) UNIQUE NOT NULL,
        FQDN varchar(255) UNIQUE NOT NULL,
        Status smallint[], -- TODO: create trigger to check values agains enum_status
        Registrant INTEGER REFERENCES Contact,
        ClID INTEGER NOT NULL REFERENCES Registrar,
        CrID INTEGER NOT NULL REFERENCES Registrar,
        CrDate timestamp NOT NULL,
        UpID INTEGER REFERENCES Registrar,
        UpDate timestamp NOT NULL,
        ExDate timestamp NOT NULL,
        TrDate timestamp,
        AuthInfoPw varchar(32)
        );
CREATE INDEX domain_zone_idx ON Domain (Zone);
CREATE INDEX domain_id_idx ON Domain (ID);
CREATE INDEX domain_fqdn_idx ON Domain (FQDN);
CREATE INDEX domain_roid_idx ON Domain (ROID);

DROP TABLE domain_contact_map CASCADE;
CREATE TABLE domain_contact_map (
        DomainID INTEGER REFERENCES Domain ON UPDATE CASCADE ON DELETE CASCADE,
        ContactID INTEGER REFERENCES Contact ON UPDATE CASCADE,
        Role CHAR(10) NOT NULL CHECK (Role in ('admin', 'tech', 'billing')),
        UNIQUE (DomainID, ContactID, Role)
        );
CREATE INDEX domain_contact_map_domainid_idx ON domain_contact_map (DomainID);

DROP TABLE Host CASCADE;
CREATE TABLE Host (
        ID SERIAL PRIMARY KEY,
        DomainID INTEGER REFERENCES Domain ON UPDATE CASCADE,
        FQDN VARCHAR(255) UNIQUE NOT NULL,
        ClID INTEGER NOT NULL REFERENCES Registrar ON UPDATE CASCADE,
        CrDate TIMESTAMP NOT NULL,
        UpID INTEGER NOT NULL REFERENCES Registrar ON UPDATE CASCADE ON DELETE SET NULL,
        UpDate TIMESTAMP NOT NULL,
        Status INTEGER[], -- TODO: write trigger to check values
        IpAddr INET[] NOT NULL -- NOTE: we don't have to store IP version, since it's obvious from address
        );

CREATE INDEX host_domainid_idx ON Host (DomainID);
CREATE INDEX host_fqdn_idx ON Host (FQDN);

DROP TABLE domain_host_map CASCADE;
CREATE TABLE domain_host_map (
        DomainID INTEGER NOT NULL REFERENCES Domain ON UPDATE CASCADE ON DELETE CASCADE,
        HostID INTEGER NOT NULL REFERENCES Host ON UPDATE CASCADE,
        UNIQUE (DomainID, HostID)
        );
CREATE INDEX domain_host_map_domainid_idx ON domain_host_map (DomainID);

DROP TABLE DNSSEC CASCADE;
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

DROP TABLE ENUMVal CASCADE;
CREATE TABLE ENUMVal (
        ValID SERIAL PRIMARY KEY,
        DomainID INTEGER NOT NULL REFERENCES Domain ON UPDATE CASCADE ON DELETE CASCADE,
        Method varchar(1024) NOT NULL,
        EnumRegistrar CHARACTER VARYING(255) NOT NULL,
        CrDate timestamp NOT NULL,
        ExDate timestamp NOT NULL
        );

DROP TABLE Message;
CREATE TABLE Message (
        ID SERIAL PRIMARY KEY,
        ClID INTEGER REFERENCES Registrar ON UPDATE CASCADE,
        CrDate TIMESTAMP NOT NULL,
        ExDate TIMESTAMP,
        Seen BOOLEAN,
        Message TEXT
        );
CREATE INDEX message_clid_idx ON message (clid);
CREATE INDEX message_seen_idx ON message (clid,seen,crdate,exdate);
