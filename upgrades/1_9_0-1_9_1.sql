---
---  DNSSEC related tables
---

CREATE TABLE Keyset (
    id integer PRIMARY KEY REFERENCES object (id)
);

comment on table Keyset is 'Evidence of Keysets';
comment on column Keyset.id is 'reference into object table';


CREATE TABLE keyset_contact_map (
    contact_id integer REFERENCES Contact(ID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
    keyset_id integer REFERENCES Keyset(id) ON UPDATE CASCADE NOT NULL,
    PRIMARY KEY (contact_id, keyset_id)
);
CREATE INDEX keyset_contact_map_contact_idx ON keyset_contact_map (contact_id);
CREATE INDEX keyset_contact_map_keyset_idx ON keyset_contact_map (keyset_id);

CREATE TABLE DS_record (
    id serial PRIMARY KEY,
    keyset_id integer REFERENCES Keyset(id) ON UPDATE CASCADE NOT NULL,
    keyTag integer NOT NULL,
    alg integer NOT NULL,
    digestType integer NOT NULL,
    digest varchar(255) NOT NULL,
    maxSigLife integer
);

comment on table DS_record is 'table with DS resource records'; 
comment on column DS_record.id is 'unique automatically generated identifier';
comment on column DS_record.keyset_id is 'reference to relevant record in Keyset table';
comment on column DS_record.keyTag is '';
comment on column DS_record.alg is 'used algorithm. See RFC 4034 appendix A.1 for list';
comment on column DS_record.digestType is 'used digest type. See RFC 4034 appendix A.2 for list';
comment on column DS_record.digest is 'digest of DNSKEY';
comment on column DS_record.maxSigLife is 'record TTL';

ALTER TABLE Domain ADD COLUMN keyset_id integer REFERENCES Keyset(id);

comment on column Domain.keyset_id is 'reference to used keyset';

-- history tables

CREATE TABLE Keyset_history (
    historyid integer PRIMARY KEY REFERENCES History,
    id integer REFERENCES object_registry(id)
);

comment on table Keyset_history is 'historic data from Keyset table';

CREATE TABLE keyset_contact_map_history (
    historyid integer REFERENCES History,
    contact_id integer REFERENCES object_registry(id),
    keyset_id integer REFERENCES object_registry(id),
    PRIMARY KEY (historyid, contact_id, keyset_id)
);

CREATE TABLE DS_record_history (
    historyid integer PRIMARY KEY REFERENCES History,
    keyset_id integer,
    keyTag integer NOT NULL,
    alg integer NOT NULL,
    digestType integer NOT NULL,
    digest varchar(255) NOT NULL,
    maxSigLife integer
);

comment on table DS_record_history is 'historic data from DS_record table';

--- changes in existing tables

ALTER TABLE Domain_History ADD COLUMN keyset_id integer;


--- new records in existing tables

INSERT INTO enum_action VALUES (600, 'KeysetCheck');
INSERT INTO enum_action VALUES (601, 'KeysetInfo');
INSERT INTO enum_action VALUES (602, 'KeysetDelete');
INSERT INTO enum_action VALUES (603, 'KeysetUpdate');
INSERT INTO enum_action VALUES (604, 'KeysetCreate');
INSERT INTO enum_action VALUES (605, 'KeysetTransfer');
