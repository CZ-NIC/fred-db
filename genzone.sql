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
INSERT INTO zone_soa (Zone, TTL, Hostmaster, Serial, Refresh, Update_retr, Expiry, Minimum, ns_fqdn) VALUES (1, 86400, 'hostmaster@nic.cz', NULL, 43200, 900, 1814400, 10800, 'a.ns.nic.cz');
INSERT INTO zone_soa (Zone, TTL, Hostmaster, Serial, Refresh, Update_retr, Expiry, Minimum, ns_fqdn) VALUES (2, 86400, 'hostmaster@nic.cz', NULL, 43200, 900, 1814400, 10800, 'a.ns.nic.cz');
INSERT INTO zone_soa (Zone, TTL, Hostmaster, Serial, Refresh, Update_retr, Expiry, Minimum, ns_fqdn) VALUES (3, 86400, 'hostmaster@nic.cz', NULL, 43200, 900, 1814400, 10800, 'ns.tld.cz');

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
INSERT INTO zone_ns (Zone, fqdn, addrs) VALUES (2, 'a.ns.nic.cz', '{}');
INSERT INTO zone_ns (Zone, fqdn, addrs) VALUES (3, 'ns.tld.cz', '{217.31.196.10}');
INSERT INTO zone_ns (Zone, fqdn, addrs) VALUES (3, 'ns2.nic.fr', '{}');
INSERT INTO zone_ns (Zone, fqdn, addrs) VALUES (3, 'nsl.tld.cz', '{195.66.241.202}');
INSERT INTO zone_ns (Zone, fqdn, addrs) VALUES (3, 'nss.tld.cz', '{217.31.200.10}');
INSERT INTO zone_ns (Zone, fqdn, addrs) VALUES (3, 'ns-cz.ripe.net', '{}');
INSERT INTO zone_ns (Zone, fqdn, addrs) VALUES (3, 'sunic.sunet.se', '{}');
INSERT INTO zone_ns (Zone, fqdn, addrs) VALUES (3, 'ns-ext.vix.com', '{}');
