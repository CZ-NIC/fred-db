-- DROP TABLE  OBJECT  CASCADE;


CREATE TABLE OBJECT_registry (
       ID SERIAL PRIMARY KEY,
       ROID varchar(255) UNIQUE NOT NULL , -- unique roid
       type smallint , -- object type 1 contact 2 nsset 3 domain
       NAME varchar(255)  NOT NULL , -- handle or FQDN
       CrID INTEGER NOT NULL REFERENCES Registrar,
       CrDate timestamp NOT NULL DEFAULT now(),
       ErDate timestamp DEFAULT NULL, -- erase date 
       CrhistoryID INTEGER  REFERENCES History, -- link into create history
       historyID integer REFERENCES history -- link to last change in history                 
       );

-- index
CREATE INDEX object_registry_upper_name_1_idx 
 ON object_registry (UPPER(name)) WHERE type=1;
CREATE INDEX object_registry_upper_name_2_idx 
 ON object_registry (UPPER(name)) WHERE type=2;
CREATE INDEX object_registry_name_3_idx 
 ON object_registry  (NAME) WHERE type=3;
comment on column OBJECT_registry.ID is 'unique automatically generated identifier';
comment on column OBJECT_registry.ROID is 'unique roid';
comment on column OBJECT_registry.type is 'object type (1-contact, 2-nsset, 3-domain)';
comment on column OBJECT_registry.name is 'handle of fqdn';
comment on column OBJECT_registry.CrID is 'link to registrar';
comment on column OBJECT_registry.CrDate is 'object creation date and time';
comment on column OBJECT_registry.ErDate is 'object erase date';
comment on column OBJECT_registry.CrhistoryID is 'link into create history';
comment on column OBJECT_registry.historyID is 'link to last change in history';

CREATE TABLE OBJECT (
        ID INTEGER PRIMARY KEY  REFERENCES object_registry (id),
        ClID INTEGER NOT NULL REFERENCES Registrar,
        UpID INTEGER REFERENCES Registrar,
        TrDate timestamp DEFAULT NULL,
        UpDate timestamp DEFAULT NULL,
        AuthInfoPw varchar(300) -- in XML schemas
        );

-- index
CREATE INDEX object_upid_idx ON "object" (upid);
CREATE INDEX object_clid_idx ON "object" (clid);


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
        Telephone varchar(64),
        Fax varchar(64),
        Email varchar(1024),
        DiscloseName boolean DEFAULT False,
        DiscloseOrganization boolean DEFAULT False,
        DiscloseAddress boolean DEFAULT False,
        DiscloseTelephone boolean DEFAULT False,
        DiscloseFax boolean DEFAULT False,
        DiscloseEmail boolean DEFAULT False,
        NotifyEmail varchar(1024),
        VAT varchar(32),
        SSN varchar(64),
	    SSNtype INTEGER REFERENCES enum_ssntype,
        DiscloseVAT boolean DEFAULT False,
        DiscloseIdent boolean DEFAULT False,
        DiscloseNotifyEmail boolean DEFAULT False
        );

comment on table Contact is 'List of contacts which act in register as domain owners and administrative contacts for nameservers group';
comment on column Contact.ID is 'references into object table';
comment on column Contact.Name is 'name of contact person';
comment on column Contact.Organization is 'full trade name of organization';
comment on column Contact.Street1 is 'part of address';
comment on column Contact.Street2 is 'part of address';
comment on column Contact.Street3 is 'part of address';
comment on column Contact.City is 'part of address - city';
comment on column Contact.StateOrProvince is 'part of address - region';
comment on column Contact.PostalCode is 'part of address - postal code';
comment on column Contact.Country is 'two character country code (e.g. cz) from enum_country table';
comment on column Contact.Telephone is 'telephone number';
comment on column Contact.Fax is 'fax number';
comment on column Contact.Email is 'email address';
comment on column Contact.DiscloseName is 'whether reveal contact name';
comment on column contact.DiscloseOrganization is 'whether reveal organization';
comment on column Contact.DiscloseAddress is 'whether reveal address';
comment on column Contact.DiscloseTelephone is 'whether reveal phone number';
comment on column Contact.DiscloseFax is 'whether reveal fax number';
comment on column Contact.DiscloseEmail is 'whether reveal email address';
comment on column Contact.NotifyEmail is 'to this email address will be send message in case of any change in domain or nsset affecting contact';
comment on column Contact.VAT is 'tax number';
comment on column Contact.SSN is 'unambiguous identification number (e.g. Social Security number, identity card number, date of birth)';
comment on column Contact.SSNtype is 'type of identification number from enum_ssntype table';
comment on column Contact.DiscloseVAT is 'whether reveal VAT number';
comment on column Contact.DiscloseIdent is 'whether reveal SSN number';
comment on column Contact.DiscloseNotifyEmail is 'whether reveal notify email';



-- DROP TABLE NSSet CASCADE;
CREATE TABLE NSSet (
        ID INTEGER PRIMARY KEY REFERENCES object (id),
        checklevel smallint default 0
        );

-- DROP TABLE nsset_contact_map CASCADE;
CREATE TABLE nsset_contact_map (
        NSSetID INTEGER REFERENCES NSSet ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
        ContactID INTEGER REFERENCES Contact ON UPDATE CASCADE NOT NULL,
        PRIMARY KEY (NSSetID, ContactID)
        );
CREATE INDEX nsset_contact_map_nssetid_idx ON nsset_contact_map (NSSetID);
CREATE INDEX nsset_contact_map_contactid_idx ON nsset_contact_map (ContactID);


-- DROP TABLE Host CASCADE;
CREATE TABLE Host (
        ID SERIAL PRIMARY KEY,
        NSSetID INTEGER REFERENCES NSSet ON UPDATE CASCADE,
        FQDN VARCHAR(255)   NOT NULL,  -- it cannot be UNIQUE for two different NSSET same dns host 
        UNIQUE (NSSetID, FQDN ) -- unique key
        );


CREATE INDEX host_nsset_idx ON Host (NSSetID);
CREATE INDEX host_fqdn_idx ON Host (FQDN);

comment on table Host is 'Records of relationship between nameserver and ip address';
comment on column Host.id is 'unique automatically generatet identifier';
comment on column Host.NSSetID is 'in which nameserver group belong this record';
comment on column Host.FQDN is 'fully qualified domain name that is in zone file as NS';

-- DROP TABLE  host_ipaddr_map  CASCADE;
CREATE TABLE host_ipaddr_map (
           ID SERIAL PRIMARY KEY,
           HostID  INTEGER NOT NULL REFERENCES HOST ON UPDATE CASCADE ON DELETE CASCADE,
           NSSetID INTEGER NOT NULL REFERENCES NSSET ON UPDATE CASCADE ON DELETE CASCADE, 
           IpAddr INET NOT NULL -- IP address
         );

CREATE INDEX host_ipaddr_map_hostid_idx ON host_ipaddr_map (hostid);
CREATE INDEX host_ipaddr_map_nssetid_idx ON host_ipaddr_map (nssetid);


-- DROP TABLE Domain CASCADE;
CREATE TABLE Domain (
        ID INTEGER PRIMARY KEY REFERENCES object (ID),
        Zone INTEGER REFERENCES Zone (ID),
        Registrant INTEGER NOT NULL REFERENCES Contact,
        NSSet INTEGER NULL REFERENCES NSSet, -- link to nsset can be also NULL, it can register domain without nsset
        Exdate timestamp NOT NULL
        );
CREATE INDEX domain_zone_idx ON Domain (Zone);
CREATE INDEX domain_registrant_idx ON Domain (registrant);
CREATE INDEX domain_nsset_idx ON Domain (nsset);

comment on table Domain is 'Evidence of domains';
comment on column Domain.ID is 'point to object table';
comment on column Domain.Zone is 'zone in which domain belong';
comment on column Domain.Registrant is 'domain owner';
comment on column Domain.NSSet is 'link to nameserver set, can be NULL (when is domain registered withou nsset)';
comment on column Domain.Exdate is 'domain expiry date';

-- DROP TABLE domain_contact_map CASCADE;
CREATE TABLE domain_contact_map (
        DomainID INTEGER REFERENCES Domain ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
        ContactID INTEGER REFERENCES Contact ON UPDATE CASCADE NOT NULL,
        Role INTEGER NOT NULL DEFAULT 1,
        PRIMARY KEY (DomainID, ContactID)
        );
CREATE INDEX domain_contact_map_domainid_idx ON domain_contact_map (DomainID);
CREATE INDEX domain_contact_map_contactid_idx ON domain_contact_map (ContactID);



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

