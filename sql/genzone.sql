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

--
-- Default values for zone soa
--
INSERT INTO zone_soa (Zone, TTL, Hostmaster, Serial, Refresh, Update_retr, Expiry, Minimum, ns_fqdn) VALUES (1, 18000, 'hostmaster@nic.cz', NULL, 10600, 3600, 1209600, 7200, 'a.ns.nic.cz');
INSERT INTO zone_soa (Zone, TTL, Hostmaster, Serial, Refresh, Update_retr, Expiry, Minimum, ns_fqdn) VALUES (2, 18000, 'hostmaster@nic.cz', NULL, 10600, 3600, 1209600, 7200, 'a.ns.nic.cz');
INSERT INTO zone_soa (Zone, TTL, Hostmaster, Serial, Refresh, Update_retr, Expiry, Minimum, ns_fqdn) VALUES (3, 18000, 'hostmaster@nic.cz', NULL, 10600, 3600, 1209600, 7200, 'ns.tld.cz');

-- Nameservers for a zone
CREATE TABLE zone_ns (
        id SERIAL PRIMARY KEY,
        Zone INTEGER REFERENCES Zone (ID),
        fqdn VARCHAR(255) NOT NULL,
        addrs INET[] NOT NULL
        );

--
-- Default values for nameservers
--
INSERT INTO zone_ns (Zone, fqdn, addrs) VALUES (1, 'a.ns.nic.cz', '{}');
INSERT INTO zone_ns (Zone, fqdn, addrs) VALUES (1, 'b.ns.cznic.org', '{}');
INSERT INTO zone_ns (Zone, fqdn, addrs) VALUES (1, 'c.ns.nic.cz', '{}');
INSERT INTO zone_ns (Zone, fqdn, addrs) VALUES (1, 'e.ns.nic.cz', '{}');
INSERT INTO zone_ns (Zone, fqdn, addrs) VALUES (2, 'a.ns.nic.cz', '{}');
INSERT INTO zone_ns (Zone, fqdn, addrs) VALUES (3, 'ns.tld.cz', '{217.31.196.10}');
INSERT INTO zone_ns (Zone, fqdn, addrs) VALUES (3, 'ns2.nic.fr', '{}');
INSERT INTO zone_ns (Zone, fqdn, addrs) VALUES (3, 'nsl.tld.cz', '{195.66.241.202}');
INSERT INTO zone_ns (Zone, fqdn, addrs) VALUES (3, 'nss.tld.cz', '{217.31.200.10}');
INSERT INTO zone_ns (Zone, fqdn, addrs) VALUES (3, 'ns-cz.ripe.net', '{}');
INSERT INTO zone_ns (Zone, fqdn, addrs) VALUES (3, 'sunic.sunet.se', '{}');
INSERT INTO zone_ns (Zone, fqdn, addrs) VALUES (3, 'ns-ext.vix.com', '{}');

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
