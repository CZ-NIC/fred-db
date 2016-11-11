---
--- Ticket #16019 - Add dnskey.alg constraint
---

CREATE TABLE dnssec_algorithm (
    id INTEGER CONSTRAINT dnssec_algorithm_pkey PRIMARY KEY,
    handle VARCHAR(64) NOT NULL CONSTRAINT dnssec_algorithm_handle_idx UNIQUE,
    description TEXT
);

COMMENT ON TABLE dnssec_algorithm IS 'list of DNSSEC algorithms; see http://www.iana.org/assignments/dns-sec-alg-numbers/dns-sec-alg-numbers.xhtml'; 
COMMENT ON COLUMN dnssec_algorithm.id IS 'algorithm number'; 
COMMENT ON COLUMN dnssec_algorithm.handle IS 'mnemonic'; 

INSERT INTO dnssec_algorithm (id,handle,description)
VALUES (  1,'RSAMD5',            'RSA/MD5 (deprecated, see 5)'),
       (  2,'DH',                'Diffie-Hellman'),
       (  3,'DSA',               'DSA/SHA1'),
       (  5,'RSASHA1',           'RSA/SHA-1'),
       (  6,'DSA-NSEC3-SHA1',    'DSA-NSEC3-SHA1'),
       (  7,'RSASHA1-NSEC3-SHA1','RSASHA1-NSEC3-SHA1'),
       (  8,'RSASHA256',         'RSA/SHA-256'),
       ( 10,'RSASHA512',         'RSA/SHA-512'),
       ( 12,'ECC-GOST',          'GOST R 34.10-2001'),
       ( 13,'ECDSAP256SHA256',   'ECDSA Curve P-256 with SHA-256'),
       ( 14,'ECDSAP384SHA384',   'ECDSA Curve P-384 with SHA-384'),
       (252,'INDIRECT',          'Reserved for Indirect Keys'),
       (253,'PRIVATEDNS',        'private algorithm'),
       (254,'PRIVATEOID',        'private algorithm OID');

CREATE TABLE dnssec_algorithm_blacklist (
    alg_number INTEGER CONSTRAINT dnssec_algorithm_usability_pkey PRIMARY KEY REFERENCES dnssec_algorithm(id)
);

COMMENT ON TABLE dnssec_algorithm_blacklist IS 'list of deprecated DNSSEC algorithms'; 

INSERT INTO dnssec_algorithm_blacklist (alg_number) VALUES (1),(2),(252);

ALTER TABLE dnskey
    ADD CONSTRAINT dnskey_alg_fkey FOREIGN KEY (alg) REFERENCES dnssec_algorithm(id) ON UPDATE CASCADE;