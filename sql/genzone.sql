-- table holding data from SOA record for a zone
CREATE TABLE zone_soa (
        Zone INTEGER PRIMARY KEY REFERENCES Zone (ID),
        TTL INTEGER NOT NULL,
        Hostmaster VARCHAR(255) NOT NULL,
        Serial INTEGER,
        Refresh INTEGER NOT NULL,
        Update_retr INTEGER NOT NULL, 
        Expiry INTEGER NOT NULL,
        Minimum INTEGER NOT NULL,
        ns_fqdn VARCHAR(255) NOT NULL
        );

-- Nameservers for a zone
CREATE TABLE zone_ns (
        id SERIAL PRIMARY KEY,
        Zone INTEGER REFERENCES Zone (ID),
        fqdn VARCHAR(255) NOT NULL,
        addrs INET[] NOT NULL
        );

-- List of status for domain zone generator classification
-- supplement missing enum type in postgresql
CREATE TABLE genzone_domain_status (
	id integer PRIMARY KEY, -- id of status
	name char(20) NOT NULL -- decriptive name
);

INSERT INTO genzone_domain_status VALUES (1,'is in zone');
INSERT INTO genzone_domain_status VALUES (2,'is deleted');
INSERT INTO genzone_domain_status VALUES (3,'is without nsset');
INSERT INTO genzone_domain_status VALUES (4,'expired');
INSERT INTO genzone_domain_status VALUES (5,'is not validated');

comment on table genzone_domain_status is
'List of status for domain zone generator classification

id - name
 1 - domain is in zone
 2 - domain is deleted
 3 - domain is without nsset
 4 - domain is expired
 5 - domain is not validated';

-- History of generation of domain in zone file
CREATE TABLE genzone_domain_history (
    -- id of record
    id SERIAL PRIMARY KEY,
    -- domain  
    domain_id INTEGER REFERENCES object_registry (id), 
    -- domain version, actual in time of record creation
    domain_hid INTEGER REFERENCES domain_history (historyid), 
    -- zone identifier of domain
    zone_id INTEGER REFERENCES zone (id),
    -- status of generation
    status INTEGER REFERENCES genzone_domain_status (id), 
    -- shortage for status=1
    inzone boolean NOT NULL,
    -- time of record creation
    chdate timestamp NOT NULL DEFAULT now(), 
    -- flag of actual record
    last boolean NOT NULL DEFAULT True 
);

CREATE INDEX genzone_domain_history_domain_hid_idx 
  ON genzone_domain_history (domain_hid);
CREATE INDEX genzone_domain_history_domain_id_idx 
  ON genzone_domain_history (domain_id);
