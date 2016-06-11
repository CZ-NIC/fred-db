

CREATE TABLE OBJECT_history (
        historyID INTEGER CONSTRAINT object_history_pkey PRIMARY KEY CONSTRAINT object_history_historyid_fkey REFERENCES History, -- link into history
        ID INTEGER CONSTRAINT object_history_id_fkey REFERENCES object_registry (id),
        ClID INTEGER NOT NULL CONSTRAINT object_history_clid_fkey REFERENCES Registrar,
        UpID INTEGER CONSTRAINT object_history_upid_fkey REFERENCES Registrar,
        Trdate timestamp,
        UpDate timestamp,
        AuthInfoPw varchar(300)
        );


  
-- DROP TABLE Contact_History CASCADE;
CREATE TABLE Contact_History (
        HISTORYID INTEGER CONSTRAINT contact_history_pkey PRIMARY KEY CONSTRAINT contact_history_historyid_fkey REFERENCES History,
        ID INTEGER CONSTRAINT contact_history_id_fkey REFERENCES object_registry (id),
        Name varchar(1024),
        Organization varchar(1024),
        Street1 varchar(1024),
        Street2 varchar(1024),
        Street3 varchar(1024),
        City varchar(1024),
        StateOrProvince varchar(1024),
        PostalCode varchar(32),
        Country char(2) CONSTRAINT contact_history_country_fkey REFERENCES enum_country,
        Telephone varchar(64),
        Fax varchar(64),
        Email varchar(1024),
        DiscloseName boolean NOT NULL,
        DiscloseOrganization boolean NOT NULL,
        DiscloseAddress boolean NOT NULL,
        DiscloseTelephone boolean NOT NULL,
        DiscloseFax boolean NOT NULL,
        DiscloseEmail boolean NOT NULL,
        NotifyEmail varchar(1024),
        VAT varchar(32),
        SSN varchar(64),
        SSNtype integer CONSTRAINT contact_history_ssntype_fkey REFERENCES enum_ssntype,
        DiscloseVAT boolean NOT NULL,
        DiscloseIdent boolean NOT NULL,
        DiscloseNotifyEmail boolean NOT NULL,
        warning_letter boolean
);

comment on table Contact_History is
'Historic data from contact table.
creation - actual data will be copied here from original table in case of any change in contact table';

-- DROP TABLE contact_address_history CASCADE;
CREATE TABLE contact_address_history (
        historyid INTEGER NOT NULL CONSTRAINT contact_address_history_historyid_fkey REFERENCES history (id),
        id INTEGER NOT NULL,
        contactid INTEGER NOT NULL CONSTRAINT contact_address_history_contactid_fkey REFERENCES object_registry (id),
        type contact_address_type NOT NULL,
        company_name VARCHAR(1024) CONSTRAINT company_name_shipping_only
            CHECK (company_name IS NULL OR type IN ('SHIPPING'::contact_address_type, 'SHIPPING_2'::contact_address_type,
                    'SHIPPING_3'::contact_address_type)),
        street1 VARCHAR(1024),
        street2 VARCHAR(1024),
        street3 VARCHAR(1024),
        city VARCHAR(1024),
        stateorprovince VARCHAR(1024),
        postalcode VARCHAR(32),
        country CHAR(2) CONSTRAINT contact_address_history_country_fkey REFERENCES enum_country (id),
        CONSTRAINT contact_address_history_pkey PRIMARY KEY (id,historyid)
    );

comment on table contact_address_history is
'Historic data from contact_address table.
creation - actual data will be copied here from original table in case of any change in contact_address table';


-- DROP TABLE Domain_History CASCADE;
CREATE TABLE Domain_History (
        HISTORYID INTEGER CONSTRAINT domain_history_pkey PRIMARY KEY CONSTRAINT domain_history_historyid_fkey REFERENCES History,
        Zone INTEGER NOT NULL CONSTRAINT domain_history_zone_fkey REFERENCES Zone (ID),
        ID INTEGER CONSTRAINT domain_history_id_fkey REFERENCES object_registry (id),
        ExDate date NOT NULL,
        Registrant INTEGER , -- canceled references
        NSSet INTEGER  -- canceled references
        );
CREATE INDEX domain_History_historyid_idx ON Domain_History (historyID);

comment on table Domain_History is
'Historic data from domain table

creation - in case of any change in domain table, including changes in bindings to other tables';

-- DROP TABLE domain_contact_map_history CASCADE;
CREATE TABLE domain_contact_map_history  (
        historyID INTEGER CONSTRAINT domain_contact_map_history_historyid_fkey REFERENCES History,
        DomainID INTEGER CONSTRAINT domain_contact_map_history_domainid_fkey REFERENCES object_registry (id),
        ContactID INTEGER CONSTRAINT domain_contact_map_history_contactid_fkey REFERENCES object_registry (id),
        Role INTEGER NOT NULL,
-- TODO         ContactHistoryID INTEGER REFERENCES  History(id) --  Contact in state in which was by the change  
       CONSTRAINT domain_contact_map_history_pkey PRIMARY KEY(historyID,DomainID,ContactID)
        );

comment on table domain_contact_map_history is
'Historic data from domain_contact_map table

creation - all contacts links which are linked to changed domain are copied here';

-- DROP TABLE NSSet_history  CASCADE;
CREATE TABLE NSSet_history  (
        historyID INTEGER CONSTRAINT nsset_history_pkey PRIMARY KEY CONSTRAINT nsset_history_historyid_fkey REFERENCES History, -- only one nsset 
        ID INTEGER CONSTRAINT nsset_history_id_fkey REFERENCES object_registry (id),
        checklevel smallint --write up check level
        );
CREATE INDEX nsset_history_historyid_idx ON NSSet_History (historyID);

comment on table NSSet_History is
'Historic data from domain nsset

creation - in case of any change in nsset table, including changes in bindings to other tables';

-- DROP TABLE nsset_contact_map_history  CASCADE;
CREATE TABLE nsset_contact_map_history (
        historyID INTEGER CONSTRAINT nsset_contact_map_history_historyid_fkey REFERENCES History,
        NSSetID INTEGER CONSTRAINT nsset_contact_map_history_nssetid_fkey REFERENCES object_registry (id), 
        ContactID INTEGER CONSTRAINT nsset_contact_map_history_contactid_fkey REFERENCES object_registry (id),
-- TODO   ContactHistoryID 
        CONSTRAINT nsset_contact_map_history_pkey PRIMARY KEY (historyID,NSSetID, ContactID)
        );

comment on table nsset_contact_map_history is
'Historic data from nsset_contact_map table

creation - all contact links which are linked to changed nsset are copied here';

-- DROP TABLE Host_history  CASCADE;
CREATE TABLE Host_history  (
        historyID INTEGER CONSTRAINT host_history_historyid_fkey REFERENCES History,  -- it can exist more hosts so that it isn't primary key
        ID  INTEGER  NOT NULL,
        NSSetID INTEGER CONSTRAINT host_history_nssetid_fkey REFERENCES object_registry (id), -- REFERENCES NSSet ON UPDATE CASCADE,
        FQDN VARCHAR(255)  NOT NULL,
        CONSTRAINT host_history_pkey PRIMARY KEY(historyID,ID)
        );
-- replaced

comment on table Host_history is
'historic data from host table

creation - all entries from host table which exist for given nsset are copied here when nsset is altering';

CREATE TABLE host_ipaddr_map_history (
	historyID INTEGER CONSTRAINT host_ipaddr_map_history_historyid_fkey REFERENCES History,
        ID INTEGER NOT NULL,
	HostID  INTEGER NOT NULL,
	NSSetID INTEGER CONSTRAINT host_ipaddr_map_history_nssetid_fkey REFERENCES object_registry (id),
	IpAddr INET NOT NULL,
       CONSTRAINT host_ipaddr_map_history_pkey PRIMARY KEY(historyID,ID)
	);



-- DROP TABLE ENUMVal_history  CASCADE;
CREATE TABLE ENUMVal_history (
        historyID INTEGER CONSTRAINT enumval_history_pkey PRIMARY KEY CONSTRAINT enumval_history_historyid_fkey REFERENCES History, -- only one nsset
        DomainID INTEGER CONSTRAINT enumval_history_domainid_fkey REFERENCES object_registry (id),
        ExDate date NOT NULL,
        publish BOOLEAN NOT NULL
        );

