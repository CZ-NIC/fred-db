---
--- **********************************************************
--- *                                                        *
--- * new stuff                                              *
--- *                                                        *
--- **********************************************************
---

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
    maxSigLife integer
);

comment on table DSRecord_history is 'historic data from DSRecord table';


---
--- changes in existing tables
---

ALTER TABLE Domain ADD COLUMN keyset integer REFERENCES Keyset(id);

comment on column Domain.keyset is 'reference to used keyset';

ALTER TABLE Domain_History ADD COLUMN keyset integer;

---
--- new records in existing tables
---

INSERT INTO enum_action VALUES (600, 'KeysetCheck');
INSERT INTO enum_action VALUES (601, 'KeysetInfo');
INSERT INTO enum_action VALUES (602, 'KeysetDelete');
INSERT INTO enum_action VALUES (603, 'KeysetUpdate');
INSERT INTO enum_action VALUES (604, 'KeysetCreate');
INSERT INTO enum_action VALUES (605, 'KeysetTransfer');
INSERT INTO enum_action VALUES (1006, 'ListKeySet');
INSERT INTO enum_action VALUES (1106, 'KeySetSendAuthInfo');

---
--- error reason values
---

INSERT INTO enum_reason VALUES (39, 'Bad format keyset handle', 'Neplatný formát ukazatele keysetu');
INSERT INTO enum_reason VALUES (40, 'Handle of keyset does not exists', 'Ukazatel keysetu není vytvořen');
INSERT INTO enum_reason VALUES (41, 'DSRecord does not exists', 'DSRecord záznam neexistuje');
INSERT INTO enum_reason VALUES (42, 'Can not remove DSRecord', 'Nelze odstranit DSRecord záznam');
INSERT INTO enum_reason VALUES (43, 'Duplicity DSRecord', 'Duplicitní DSRecord záznam');
INSERT INTO enum_reason VALUES (44, 'DSRecord already exists for this keyset', 'DSRecord již pro tento keyset existuje');
INSERT INTO enum_reason VALUES (45, 'DSRedord is not set for this keyset', 'DSRecord pro tento keyset neexistuje');
INSERT INTO enum_reason VALUES (46, 'Field ``digest type'''' must be 1 (SHA-1)', 'Pole ``digest type'''' musí být 1 (SHA-1)');
INSERT INTO enum_reason VALUES (47, 'Digest must be 40 character long', 'Digest musí být dlouhý 40 znaků');

select setval('enum_reason_id_seq', 47);

---
--- Values to table messagetype (see poll.sql)
---

INSERT INTO MessageType VALUES (14, 'transfer_keyset');
INSERT INTO MessageType VALUES (15, 'delete_keyset');


---
--- **********************************************************
--- *                                                        *
--- * updates to existing stuff                              *
--- *                                                        *
--- **********************************************************
---

--
-- create object and return it's id. duplicate is not raised as exception
-- but return 0 as id instead. it expect unique index on table
-- object_registry. cannot check enum subdomains!!!
--
CREATE OR REPLACE FUNCTION create_object(
 crregid INTEGER, 
 oname VARCHAR, 
 otype INTEGER
) 
RETURNS INTEGER AS $$
DECLARE iid INTEGER;
BEGIN
 iid := NEXTVAL('object_registry_id_seq');
 INSERT INTO object_registry (id,roid,name,type,crid) 
 VALUES (
  iid,
  (ARRAY['C','N','D', 'K'])[otype] || LPAD(iid::text,10,'0') || '-CZ' ,
  CASE
   WHEN otype=1 THEN UPPER(oname)
   WHEN otype=2 THEN UPPER(oname)
   WHEN otype=3 THEN LOWER(oname)
   WHEN otype=4 THEN UPPER(oname)
  END,
  otype,
  crregid
 );
 RETURN iid;
 EXCEPTION
 WHEN UNIQUE_VIOLATION THEN RETURN 0;
END;
$$ LANGUAGE plpgsql;

-- when technical/administrative contact not exist or is already assigned to object (domain/keyset/nsset)
update enum_reason set reason='Technical contact is already assigned to this object.', reason_cs='Technický kontakt je již přiřazen k tomuto objektu' where id=24;
update enum_reason set reason='Technical contact not exists', reason_cs='Technický kontakt neexistuje' where id=25;
update enum_reason set reason='Administrative contact is already assigned to this object.', reason_cs='Administrátorký kontakt je již přiřazen k tomuto objektu' where id=26;
update enum_reason set reason='Administravite contact not exists', reason_cs='Administrátorký kontakt neexistuje' where id=27;

--- update version
update enum_parameters set val='2.0.0' where id=1;


--- all done!
