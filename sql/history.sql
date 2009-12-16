

CREATE TABLE OBJECT_history (
        historyID INTEGER PRIMARY KEY REFERENCES History, -- link into history
        ID INTEGER  REFERENCES object_registry (id),
        ClID INTEGER NOT NULL REFERENCES Registrar,
        UpID INTEGER REFERENCES Registrar,
        Trdate timestamp,
        UpDate timestamp,
        AuthInfoPw varchar(300)
        );


  
-- DROP TABLE Contact_History CASCADE;
CREATE TABLE Contact_History (
        HISTORYID INTEGER PRIMARY  KEY REFERENCES History,
        ID INTEGER  REFERENCES object_registry (id),
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
        SSNtype integer REFERENCES enum_ssntype,
        DiscloseVAT boolean DEFAULT False,
        DiscloseIdent boolean DEFAULT False,
        DiscloseNotifyEmail boolean DEFAULT False
);

comment on table Contact_History is
'Historic data from contact table.
creation - actual data will be copied here from original table in case of any change in contact table';


-- DROP TABLE Domain_History CASCADE;
CREATE TABLE Domain_History (
        HISTORYID INTEGER PRIMARY KEY REFERENCES History,          
        Zone INTEGER REFERENCES Zone (ID),
        ID INTEGER   REFERENCES object_registry (id),
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
        historyID INTEGER REFERENCES History,       
        DomainID INTEGER  REFERENCES object_registry (id),
        ContactID INTEGER REFERENCES object_registry (id),
        Role INTEGER NOT NULL DEFAULT 1,
-- TODO         ContactHistoryID INTEGER REFERENCES  History(id) --  Contact in state in which was by the change  
       PRIMARY KEY(historyID,DomainID,ContactID)
        );

comment on table domain_contact_map_history is
'Historic data from domain_contact_map table

creation - all contacts links which are linked to changed domain are copied here';

-- DROP TABLE NSSet_history  CASCADE;
CREATE TABLE NSSet_history  (
        historyID INTEGER PRIMARY KEY REFERENCES History, -- only one nsset 
        ID INTEGER  REFERENCES object_registry (id),
        checklevel smallint default 0 --write up check level
        );
CREATE INDEX nsset_history_historyid_idx ON NSSet_History (historyID);

comment on table NSSet_History is
'Historic data from domain nsset

creation - in case of any change in nsset table, including changes in bindings to other tables';

-- DROP TABLE nsset_contact_map_history  CASCADE;
CREATE TABLE nsset_contact_map_history (
        historyID INTEGER  REFERENCES History,
        NSSetID INTEGER REFERENCES object_registry (id), 
        ContactID INTEGER REFERENCES object_registry (id),
-- TODO   ContactHistoryID 
        PRIMARY KEY (historyID,NSSetID, ContactID)
        );

comment on table nsset_contact_map_history is
'Historic data from nsset_contact_map table

creation - all contact links which are linked to changed nsset are copied here';

-- DROP TABLE Host_history  CASCADE;
CREATE TABLE Host_history  (
        historyID INTEGER  REFERENCES History,  -- it can exist more hosts so that it isn't primary key 
        ID  INTEGER  NOT NULL,
        NSSetID INTEGER REFERENCES object_registry (id), -- REFERENCES NSSet ON UPDATE CASCADE,
        FQDN VARCHAR(255)  NOT NULL,
        PRIMARY KEY(historyID,ID)
        );
-- replaced

comment on table Host_history is
'historic data from host table

creation - all entries from host table which exist for given nsset are copied here when nsset is altering';

CREATE TABLE host_ipaddr_map_history (
	historyID INTEGER  REFERENCES History,
        ID INTEGER NOT NULL,
	HostID  INTEGER NOT NULL,
	NSSetID INTEGER REFERENCES object_registry (id),
	IpAddr INET NOT NULL,
        PRIMARY KEY(historyID,ID)
	);



-- DROP TABLE ENUMVal_history  CASCADE;
CREATE TABLE ENUMVal_history (
        historyID INTEGER PRIMARY KEY REFERENCES History, -- only one nsset 
        DomainID INTEGER REFERENCES object_registry (id),
        ExDate date NOT NULL,
        publish BOOLEAN NOT NULL DEFAULT false
        );

