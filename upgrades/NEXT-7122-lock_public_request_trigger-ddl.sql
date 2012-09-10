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
