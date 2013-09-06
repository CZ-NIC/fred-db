-- table holding data from SOA record for a zone
CREATE TABLE zone_soa (
        Zone INTEGER CONSTRAINT zone_soa_pkey PRIMARY KEY CONSTRAINT zone_soa_zone_fkey REFERENCES Zone (ID),  --default period of validity of records in the zone in seconds
        TTL INTEGER NOT NULL,  --default period of validity of records in the zone in seconds
        Hostmaster VARCHAR(255) NOT NULL,  --responsible person email (in format: user@domain.tld )
        Serial INTEGER,  --serial number incremented on change in the form YYYYMMDDnn (year, month, date, revision)
        Refresh INTEGER NOT NULL,  --secondary nameservers copy of zone refresh interval in seconds
        Update_retr INTEGER NOT NULL,  --retry interval of secondary nameservers zone update (in case of failed zone refresh) in seconds
        Expiry INTEGER NOT NULL,  --zone expiration period for secondary nameservers in seconds
        Minimum INTEGER NOT NULL,  --the time a NAME ERROR = NXDOMAIN result may be cached by any resolver in seconds
        ns_fqdn VARCHAR(255) NOT NULL  --primary nameserver fully qualified name
        );

comment on table zone_soa is
'Table holding data from SOA record for a zone';
comment on column zone_soa.zone is 'zone id';
comment on column zone_soa.ttl is 'default period of validity of records in the zone in seconds';
comment on column zone_soa.hostmaster is 'responsible person email (in format: user@domain.tld )';
comment on column zone_soa.serial is 'serial number incremented on change in the form YYYYMMDDnn (year, month, date, revision)';
comment on column zone_soa.refresh is 'secondary nameservers copy of zone refresh interval in seconds';
comment on column zone_soa.update_retr is 'retry interval of secondary nameservers zone update (in case of failed zone refresh) in seconds';
comment on column zone_soa.expiry is 'zone expiration period for secondary nameservers in seconds';
comment on column zone_soa.minimum is 'the time a NAME ERROR = NXDOMAIN result may be cached by any resolver in seconds';
comment on column zone_soa.ns_fqdn is 'primary nameserver fully qualified name';

-- Nameservers for a zone
CREATE TABLE zone_ns (
        id SERIAL PRIMARY KEY,  --unique automatically generated identifier
        Zone INTEGER REFERENCES Zone (ID),  --zone id
        fqdn VARCHAR(255) NOT NULL,  --nameserver fully qualified name
        addrs INET[] NOT NULL  --nameserver ip addresses array
        );

comment on table zone_ns is
'This table contains nameservers for a zone';
comment on column zone_ns.id is 'unique automatically generated identifier';
comment on column zone_ns.zone is 'zone id';
comment on column zone_ns.fqdn is 'nameserver fully qualified name';
comment on column zone_ns.fqdn is 'nameserver ip addresses array';

-- List of status for domain zone generator classification
-- supplement missing enum type in postgresql
CREATE TABLE genzone_domain_status (  --deprecated, unused, prepared for removal
	id integer PRIMARY KEY, -- id of status
	name char(20) NOT NULL -- decriptive name
);

INSERT INTO genzone_domain_status VALUES (1,'is in zone');
INSERT INTO genzone_domain_status VALUES (2,'is deleted');
INSERT INTO genzone_domain_status VALUES (3,'is without nsset');
INSERT INTO genzone_domain_status VALUES (4,'expired');
INSERT INTO genzone_domain_status VALUES (5,'is not validated');

comment on table genzone_domain_status is
'deprecated, unused, prepared for removal
List of status for domain zone generator classification

id - name
 1 - domain is in zone
 2 - domain is deleted
 3 - domain is without nsset
 4 - domain is expired
 5 - domain is not validated';

-- History of generation of domain in zone file
CREATE TABLE genzone_domain_history ( --deprecated, unused, prepared for removal
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

comment on table genzone_domain_history is
'deprecated, unused, prepared for removal';
