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

CREATE OR REPLACE FUNCTION lock_public_request_lock( f_request_type_id BIGINT, f_object_id BIGINT)
RETURNS void AS $$
DECLARE
BEGIN
    PERFORM * FROM public_request_lock
    WHERE request_type = f_request_type_id
    AND object_id = f_object_id ORDER BY id FOR UPDATE; --wait if locked
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Failed to lock request_type_id: % object_id: %', f_request_type_id, f_object_id;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- lock public request
CREATE OR REPLACE FUNCTION lock_public_request()
RETURNS "trigger" AS $$
DECLARE
  nobject RECORD;
BEGIN
  RAISE NOTICE 'lock_public_request start NEW.id: % NEW.request_type: %'
  , NEW.id, NEW.request_type;

  FOR nobject IN SELECT prom.object_id
    FROM public_request_objects_map prom
    JOIN object_registry obr ON obr.id = prom.object_id
    WHERE prom.request_id = NEW.id
  LOOP
    RAISE NOTICE 'lock_public_request nobject.object_id: %'
    , nobject.object_id;
    PERFORM lock_public_request_lock( NEW.request_type, nobject.object_id);
  END LOOP;

  --try cleanup
  BEGIN
    PERFORM * FROM public_request_lock
      WHERE id < (NEW.id - 100) FOR UPDATE NOWAIT;
    IF FOUND THEN
      DELETE FROM public_request_lock
        WHERE id < (NEW.id - 100);
    END IF;
  EXCEPTION WHEN lock_not_available THEN
    RAISE NOTICE 'cleanup lock not available';
  END;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION lock_public_request()
IS 'lock changes of public requests by object and request type';

CREATE TRIGGER "trigger_lock_public_request"
  AFTER INSERT OR UPDATE ON public_request
  FOR EACH ROW EXECUTE PROCEDURE lock_public_request();



---
--- Ticket #7122 - lock object_state_request for manual state insert or update by state and object to the end of db transaction
---
CREATE TABLE object_state_request_lock
(
    id bigserial PRIMARY KEY -- lock id
    , state_id integer NOT NULL REFERENCES enum_object_states (id)
    , object_id integer NOT NULL --REFERENCES object_registry (id)
);


CREATE OR REPLACE FUNCTION lock_object_state_request_lock( f_state_id BIGINT, f_object_id BIGINT)
RETURNS void AS $$
DECLARE
BEGIN
    PERFORM * FROM object_state_request_lock
    WHERE state_id = f_state_id
    AND object_id = f_object_id ORDER BY id FOR UPDATE; --wait if locked
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Failed to lock state_id: % object_id: %', f_state_id, f_object_id;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- lock object_state_request for manual states
CREATE OR REPLACE FUNCTION lock_object_state_request()
RETURNS "trigger" AS $$
DECLARE
BEGIN
  --lock for manual states
  PERFORM * FROM enum_object_states WHERE id = NEW.state_id AND manual = true;
  IF NOT FOUND THEN
    RETURN NEW;
  END IF;

  RAISE NOTICE 'lock_object_state_request NEW.id: % NEW.state_id: % NEW.object_id: %'
  , NEW.id, NEW.state_id, NEW.object_id ;
    PERFORM lock_object_state_request_lock( NEW.state_id, NEW.object_id);
  --try cleanup
  BEGIN
    PERFORM * FROM object_state_request_lock
      WHERE id < (NEW.id - 100) FOR UPDATE NOWAIT;
    IF FOUND THEN
      DELETE FROM object_state_request_lock
        WHERE id < (NEW.id - 100);
    END IF;
  EXCEPTION WHEN lock_not_available THEN
    RAISE NOTICE 'cleanup lock not available';
  END;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION lock_object_state_request()
IS 'lock changes of object state requests by object and state';

CREATE TRIGGER "trigger_lock_object_state_request"
  AFTER INSERT OR UPDATE ON object_state_request
  FOR EACH ROW EXECUTE PROCEDURE lock_object_state_request();

