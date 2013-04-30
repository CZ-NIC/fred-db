---
--- Ticket #8135
---

DROP TABLE object_state_request_lock;

CREATE TABLE object_state_request_lock
(
    object_id integer PRIMARY KEY --REFERENCES object_registry (id)
);

DROP FUNCTION lock_object_state_request_lock( f_state_id BIGINT, f_object_id BIGINT);

CREATE OR REPLACE FUNCTION lock_object_state_request_lock(f_object_id BIGINT)
RETURNS void AS $$
DECLARE
BEGIN
    INSERT INTO object_state_request_lock (object_id) VALUES (f_object_id);
    DELETE FROM object_state_request_lock WHERE object_id = f_object_id;
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
    PERFORM lock_object_state_request_lock(NEW.object_id);

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;




DROP TABLE public_request_lock;

CREATE TABLE public_request_lock
(
    object_id integer PRIMARY KEY --REFERENCES object_registry (id)
);

DROP FUNCTION lock_public_request_lock(f_object_id BIGINT);

CREATE OR REPLACE FUNCTION lock_public_request_lock(f_object_id BIGINT)
RETURNS void AS $$
DECLARE
BEGIN
    INSERT INTO public_request_lock (object_id) VALUES (f_object_id);
    DELETE FROM public_request_lock WHERE object_id = f_object_id;
END;
$$ LANGUAGE plpgsql;


DROP FUNCTION lock_public_request();

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
    PERFORM lock_public_request_lock(nobject.object_id);
  END LOOP;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION lock_public_request()
IS 'lock changes of public requests by object';

