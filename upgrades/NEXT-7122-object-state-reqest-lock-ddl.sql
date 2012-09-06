---
--- Ticket #7122 - lock object_state_request for manual state insert or update by state and object to the end of db transaction
---

CREATE TABLE object_state_request_lock
(
    id bigserial PRIMARY KEY -- lock id
    , state_id integer NOT NULL REFERENCES enum_object_states (id)
    , object_id integer NOT NULL REFERENCES object_registry (id)
);

-- commit separately
CREATE OR REPLACE FUNCTION insert_and_lock_object_state_request_lock( f_state_id BIGINT, f_object_id BIGINT)
RETURNS void AS $$
DECLARE
BEGIN
    PERFORM * FROM object_state_request_lock
    WHERE state_id = f_state_id
    AND object_id = f_object_id ORDER BY id FOR UPDATE; --wait if locked
    IF NOT FOUND THEN
      INSERT INTO object_state_request_lock
      (id, state_id, object_id)
      VALUES (DEFAULT, f_state_id, f_object_id);

      PERFORM * FROM object_state_request_lock
      WHERE state_id = f_state_id
      AND object_id = f_object_id ORDER BY id FOR UPDATE; --lock
      IF NOT FOUND THEN
        RAISE EXCEPTION 'Failed to lock';
      END IF;
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION lock_object_state_request_lock( f_state_id BIGINT, f_object_id BIGINT)
RETURNS void AS $$
DECLARE
BEGIN
    PERFORM * FROM object_state_request_lock
    WHERE state_id = f_state_id
    AND object_id = f_object_id ORDER BY id FOR UPDATE; --wait if locked
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Failed to lock';
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

