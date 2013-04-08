---
---  new DNSSEC related tables
---

CREATE TABLE Keyset (
    id integer PRIMARY KEY REFERENCES object (id)
);

comment on table Keyset is 'Evidence of Keysets';
comment on column Keyset.id is 'reference into object table';


CREATE TABLE keyset_contact_map (
    keysetid integer REFERENCES Keyset(id) ON UPDATE CASCADE NOT NULL,
    contactid integer REFERENCES Contact(ID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    PRIMARY KEY (contactid, keysetid)
);
CREATE INDEX keyset_contact_map_contact_idx ON keyset_contact_map (contactid);
CREATE INDEX keyset_contact_map_keyset_idx ON keyset_contact_map (keysetid);

CREATE TABLE DSRecord (
    id serial PRIMARY KEY,
    keysetid integer REFERENCES Keyset(id) ON UPDATE CASCADE NOT NULL,
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

CREATE TABLE dnskey (
    id serial PRIMARY KEY,
    keysetid integer REFERENCES Keyset(id) ON UPDATE CASCADE NOT NULL,
    flags integer NOT NULL,
    protocol integer NOT NULL,
    alg integer NOT NULL,
    key text NOT NULL
);

---
--- Ticket #7875
---

CREATE INDEX dnskey_keysetid_idx ON dnskey (keysetid);

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
    historyid integer PRIMARY KEY REFERENCES History,
    id integer REFERENCES object_registry(id)
);

comment on table Keyset_history is 'historic data from Keyset table';

CREATE TABLE keyset_contact_map_history (
    historyid integer REFERENCES History,
    keysetid integer REFERENCES object_registry(id),
    contactid integer REFERENCES object_registry(id),
    PRIMARY KEY (historyid, contactid, keysetid)
);

CREATE TABLE DSRecord_history (
    historyid integer REFERENCES History,
    id integer NOT NULL,
    keysetid integer NOT NULL,
    keyTag integer NOT NULL,
    alg integer NOT NULL,
    digestType integer NOT NULL,
    digest varchar(255) NOT NULL,
    maxSigLife integer,
    PRIMARY KEY (historyid, id)
);

comment on table DSRecord_history is 'historic data from DSRecord table';

CREATE TABLE dnskey_history (
    historyid integer REFERENCES History,
    id integer NOT NULL,
    keysetid integer NOT NULL,
    flags integer NOT NULL,
    protocol integer NOT NULL,
    alg integer NOT NULL,
    key text NOT NULL,
    PRIMARY KEY (historyid, id)
);

comment on table dnskey_history is 'historic data from dnskey table';

---
--- changes in existing tables
---

ALTER TABLE Domain ADD COLUMN keyset integer REFERENCES Keyset(id);

comment on column Domain.keyset is 'reference to used keyset';

ALTER TABLE Domain_History ADD COLUMN keyset integer;

---
--- new records in existing tables
--- 
--- !! moved into ``reason.sql'' file
---

---
--- error reason values
---
--- !! moved into ``enum_reason.sql'' file
---

CREATE INDEX object_registry_upper_name_4_idx 
 ON object_registry (UPPER(name)) WHERE type=4;
