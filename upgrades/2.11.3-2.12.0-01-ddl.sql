---
--- Ticket #6062
---
ALTER TABLE poll_credit ALTER COLUMN credit TYPE numeric(10,2);
ALTER TABLE poll_credit ALTER COLUMN credlimit TYPE numeric(10,2);

ALTER TABLE poll_credit_zone_limit ALTER COLUMN credlimit TYPE numeric(10,2);


---
--- Ticket #6164
---
CREATE TABLE enum_public_request_status
(
  id INTEGER PRIMARY KEY NOT NULL,
  name VARCHAR(32) UNIQUE NOT NULL,
  description VARCHAR(128)
);


CREATE TABLE enum_public_request_type
(
  id INTEGER PRIMARY KEY NOT NULL,
  name VARCHAR(64) UNIQUE NOT NULL,
  description VARCHAR(256)
);


---
--- schema fix
---
ALTER TABLE invoice_prefix ALTER COLUMN typ DROP DEFAULT;
ALTER TABLE public_request ALTER COLUMN status DROP DEFAULT;

ALTER TABLE contact ALTER COLUMN disclosename SET NOT NULL;
ALTER TABLE contact ALTER COLUMN discloseorganization SET NOT NULL;
ALTER TABLE contact ALTER COLUMN discloseaddress SET NOT NULL;
ALTER TABLE contact ALTER COLUMN disclosetelephone SET NOT NULL;
ALTER TABLE contact ALTER COLUMN disclosefax SET NOT NULL;
ALTER TABLE contact ALTER COLUMN discloseemail SET NOT NULL;
ALTER TABLE contact ALTER COLUMN disclosevat SET NOT NULL;
ALTER TABLE contact ALTER COLUMN discloseident SET NOT NULL;
ALTER TABLE contact ALTER COLUMN disclosenotifyemail SET NOT NULL;
ALTER TABLE contact_history ALTER COLUMN disclosename SET NOT NULL;
ALTER TABLE contact_history ALTER COLUMN discloseorganization SET NOT NULL;
ALTER TABLE contact_history ALTER COLUMN discloseaddress SET NOT NULL;
ALTER TABLE contact_history ALTER COLUMN disclosetelephone SET NOT NULL;
ALTER TABLE contact_history ALTER COLUMN disclosefax SET NOT NULL;
ALTER TABLE contact_history ALTER COLUMN discloseemail SET NOT NULL;
ALTER TABLE contact_history ALTER COLUMN disclosevat SET NOT NULL;
ALTER TABLE contact_history ALTER COLUMN discloseident SET NOT NULL;
ALTER TABLE contact_history ALTER COLUMN disclosenotifyemail SET NOT NULL;

---
--- Ticket #7265
---
CREATE INDEX object_state_valid_from_idx ON object_state (valid_from);



---
--- Ticket #7122 - lock public_request insert or update by its type and object to the end of db transaction
---
CREATE TABLE public_request_lock
(
    id bigserial PRIMARY KEY -- lock id
    , request_type smallint NOT NULL REFERENCES enum_public_request_type(id)
    , object_id integer NOT NULL --REFERENCES object_registry (id)
);


---
--- Ticket #7122 - lock object_state_request for manual state insert or update by state and object to the end of db transaction
---
CREATE TABLE object_state_request_lock
(
    id bigserial PRIMARY KEY -- lock id
    , state_id integer NOT NULL REFERENCES enum_object_states (id)
    , object_id integer NOT NULL --REFERENCES object_registry (id)
);

