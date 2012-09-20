ALTER TABLE public_request ADD CONSTRAINT public_request_status_fkey FOREIGN KEY(status) REFERENCES enum_public_request_status(id);
ALTER TABLE public_request ADD CONSTRAINT public_request_type_fkey FOREIGN KEY(request_type) REFERENCES enum_public_request_type(id);

---
--- schema changes omited from previous upgrades
---
ALTER TABLE bank_payment DROP COLUMN invoice_id;
ALTER TABLE notify_letters DROP COLUMN file_id;
ALTER TABLE public_request DROP COLUMN epp_action_id;

DROP TABLE action_elements CASCADE;
DROP TABLE action_xml CASCADE;
DROP TABLE action CASCADE;
DROP TABLE enum_action CASCADE;
DROP TABLE login CASCADE;


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
  max_id_to_delete BIGINT;
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
    SELECT MAX(id) - 100 FROM public_request_lock INTO max_id_to_delete;
    PERFORM * FROM public_request_lock
      WHERE id < max_id_to_delete FOR UPDATE NOWAIT;
    IF FOUND THEN
      DELETE FROM public_request_lock
        WHERE id < max_id_to_delete;
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
max_id_to_delete BIGINT;
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
    SELECT MAX(id) - 100 FROM object_state_request_lock INTO max_id_to_delete;
    PERFORM * FROM object_state_request_lock
      WHERE id < max_id_to_delete FOR UPDATE NOWAIT;
    IF FOUND THEN
      DELETE FROM object_state_request_lock
        WHERE id < max_id_to_delete;
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

