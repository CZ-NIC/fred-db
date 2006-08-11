-- DROP TABLE soa CASCADE;
CREATE TABLE zone_soa (
        Zone INTEGER PRIMARY KEY REFERENCES Zone (ID),
        TTL INTEGER NOT NULL,
        Hostmaster VARCHAR(255) NOT NULL,
        Serial INTEGER,
        Refresh INTEGER NOT NULL,
        Update_retr INTEGER NOT NULL, 
        Expiry INTEGER NOT NULL,
        Minimum INTEGER NOT NULL,
        ns_fqdn VARCHAR(255) NOT NULL,
        ns_addrs INET[] NOT NULL
        );

--
-- Uncomment for testing values
--
--INSERT INTO zone_soa (Zone, TTL, Hostmaster, Serial, Refresh, Update_retr, Expiry, Minimum, ns_fqdn, ns_addrs) VALUES (1, 86400, 'hostmaster@nic.cz', NULL, 43200, 900, 1814400, 10800, 'primary.ns.cz', '{123.123.123.2, 32.123.22.3}');
--INSERT INTO zone_soa (Zone, TTL, Hostmaster, Serial, Refresh, Update_retr, Expiry, Minimum, ns_fqdn, ns_addrs) VALUES (2, 86400, 'hostmaster@nic.cz', NULL, 43200, 900, 1814400, 10800, 'primary.ns.cz', '{123.123.123.2, 32.123.22.3}');
--INSERT INTO zone_soa (Zone, TTL, Hostmaster, Serial, Refresh, Update_retr, Expiry, Minimum, ns_fqdn, ns_addrs) VALUES (3, 86400, 'hostmaster@nic.cz', NULL, 43200, 900, 1814400, 10800, 'primary.ns.cz', '{123.123.123.2, 32.123.22.3}');

-- DROP TABLE secNS
CREATE TABLE zone_ns (
        id SERIAL PRIMARY KEY,
        Zone INTEGER REFERENCES Zone (ID),
        fqdn VARCHAR(255) NOT NULL,
        addrs INET[] NOT NULL
        );

--
-- Uncomment for testing values
--
--INSERT INTO zone_ns (Zone, fqdn, addrs) VALUES (1, 'sec1.ns.cz', '{123.21.21.1}');
--INSERT INTO zone_ns (Zone, fqdn, addrs) VALUES (1, 'sec2.czns.org', '{}');
--INSERT INTO zone_ns (Zone, fqdn, addrs) VALUES (2, 'sec1.ns.cz', '{123.21.21.1}');
--INSERT INTO zone_ns (Zone, fqdn, addrs) VALUES (2, 'sec2.czns.org', '{}');
--INSERT INTO zone_ns (Zone, fqdn, addrs) VALUES (3, 'sec1.ns.cz', '{123.21.21.1}');
