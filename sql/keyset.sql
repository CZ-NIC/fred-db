---
---  new DNSSEC related tables
---

CREATE TABLE Keyset (
    id integer CONSTRAINT keyset_pkey PRIMARY KEY CONSTRAINT keyset_id_fkey REFERENCES object (id)
);

comment on table Keyset is 'Evidence of Keysets';
comment on column Keyset.id is 'reference into object table';


CREATE TABLE keyset_contact_map (
    keysetid integer CONSTRAINT keyset_contact_map_keysetid_fkey REFERENCES Keyset(id) ON UPDATE CASCADE NOT NULL,
    contactid integer CONSTRAINT keyset_contact_map_contactid_fkey REFERENCES Contact(ID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    CONSTRAINT keyset_contact_map_pkey PRIMARY KEY (contactid, keysetid)
);
CREATE INDEX keyset_contact_map_contact_idx ON keyset_contact_map (contactid);
CREATE INDEX keyset_contact_map_keyset_idx ON keyset_contact_map (keysetid);

CREATE TABLE DSRecord (
    id serial CONSTRAINT dsrecord_pkey PRIMARY KEY,
    keysetid integer CONSTRAINT dsrecord_keysetid_fkey REFERENCES Keyset(id) ON UPDATE CASCADE NOT NULL,
    keyTag integer NOT NULL,
    alg integer NOT NULL,
    digestType integer NOT NULL,
    digest varchar(255) NOT NULL,
    maxSigLife integer
);

comment on table DSRecord is 'table with DS resource records'; 
comment on column DSRecord.id is 'unique automatically generated identifier';
comment on column DSRecord.keysetid is 'reference to relevant record in Keyset table';
comment on column DSRecord.keyTag is '';
comment on column DSRecord.alg is 'used algorithm. See RFC 4034 appendix A.1 for list';
comment on column DSRecord.digestType is 'used digest type. See RFC 4034 appendix A.2 for list';
comment on column DSRecord.digest is 'digest of DNSKEY';
comment on column DSRecord.maxSigLife is 'record TTL';

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

CREATE TABLE dnskey (
    id serial CONSTRAINT dnskey_pkey PRIMARY KEY,
    keysetid integer CONSTRAINT dnskey_keysetid_fkey REFERENCES Keyset(id) ON UPDATE CASCADE NOT NULL,
    flags integer NOT NULL,
    protocol integer NOT NULL,
    alg integer NOT NULL CONSTRAINT dnskey_alg_fkey REFERENCES dnssec_algorithm(id) ON UPDATE CASCADE NOT NULL,
    key text NOT NULL
);

---
--- Ticket #7875
---

CREATE INDEX dnskey_keysetid_idx ON dnskey (keysetid);

ALTER TABLE dnskey ADD CONSTRAINT dnskey_unique_key UNIQUE (keysetid, flags, protocol, alg, key);

comment on table dnskey is '';
comment on column dnskey.id is 'unique automatically generated identifier';
comment on column dnskey.keysetid is 'reference to relevant record in keyset table';
comment on column dnskey.flags is '';
comment on column dnskey.protocol is 'must be 3';
comment on column dnskey.alg is 'used algorithm (see http://rfc-ref.org/RFC-TEXTS/4034/chapter11.html for further details)';
comment on column dnskey.key is 'base64 decoded key';

---
--- new DNSSEC related history tables
---

CREATE TABLE Keyset_history (
    historyid integer CONSTRAINT keyset_history_pkey PRIMARY KEY
    CONSTRAINT keyset_history_historyid_fkey REFERENCES History,
    id integer CONSTRAINT keyset_history_id_fkey REFERENCES object_registry(id)
);

comment on table Keyset_history is 'historic data from Keyset table';

CREATE TABLE keyset_contact_map_history (
    historyid integer CONSTRAINT keyset_contact_map_history_historyid_fkey REFERENCES History,
    keysetid integer CONSTRAINT keyset_contact_map_history_keysetid_fkey REFERENCES object_registry(id),
    contactid integer CONSTRAINT keyset_contact_map_history_contactid_fkey REFERENCES object_registry(id),
    CONSTRAINT keyset_contact_map_history_pkey PRIMARY KEY (historyid, contactid, keysetid)
);

CREATE TABLE DSRecord_history (
    historyid integer CONSTRAINT dsrecord_history_historyid_fkey REFERENCES History,
    id integer NOT NULL,
    keysetid integer NOT NULL,
    keyTag integer NOT NULL,
    alg integer NOT NULL,
    digestType integer NOT NULL,
    digest varchar(255) NOT NULL,
    maxSigLife integer,
    CONSTRAINT dsrecord_history_pkey PRIMARY KEY (historyid, id)
);

comment on table DSRecord_history is 'historic data from DSRecord table';

CREATE TABLE dnskey_history (
    historyid integer CONSTRAINT dnskey_history_historyid_fkey REFERENCES History,
    id integer NOT NULL,
    keysetid integer NOT NULL,
    flags integer NOT NULL,
    protocol integer NOT NULL,
    alg integer NOT NULL,
    key text NOT NULL,
    CONSTRAINT dnskey_history_pkey PRIMARY KEY (historyid, id)
);

comment on table dnskey_history is 'historic data from dnskey table';

---
--- changes in existing tables
---

ALTER TABLE Domain ADD COLUMN keyset integer CONSTRAINT domain_keyset_fkey REFERENCES Keyset(id);

comment on column Domain.keyset is 'reference to used keyset';

ALTER TABLE Domain_History ADD COLUMN keyset integer;

CREATE INDEX object_registry_upper_name_4_idx 
 ON object_registry (UPPER(name)) WHERE type=4;
