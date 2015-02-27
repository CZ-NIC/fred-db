---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.20.0' WHERE id = 1;


---
--- Ticket #8135
---
DROP TABLE object_state_request_lock;

CREATE TABLE object_state_request_lock
(
    object_id integer PRIMARY KEY REFERENCES object_registry (id)
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

DROP TRIGGER trigger_lock_object_state_request ON object_state_request;
DROP FUNCTION lock_object_state_request();

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
    PERFORM lock_object_state_request_lock(NEW.object_id);

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION lock_object_state_request()
IS 'lock changes of object state requests by object';

CREATE TRIGGER trigger_lock_object_state_request
  AFTER INSERT OR UPDATE
  ON object_state_request
  FOR EACH ROW
  EXECUTE PROCEDURE lock_object_state_request();

DROP TABLE public_request_lock;

CREATE TABLE public_request_lock
(
    object_id integer PRIMARY KEY REFERENCES object_registry (id)
);

DROP FUNCTION lock_public_request_lock(bigint, bigint);

CREATE OR REPLACE FUNCTION lock_public_request_lock(f_object_id BIGINT)
RETURNS void AS $$
DECLARE
BEGIN
    INSERT INTO public_request_lock (object_id) VALUES (f_object_id);
    DELETE FROM public_request_lock WHERE object_id = f_object_id;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER trigger_lock_public_request ON public_request;
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

CREATE TRIGGER trigger_lock_public_request
  AFTER INSERT OR UPDATE
  ON public_request
  FOR EACH ROW
  EXECUTE PROCEDURE lock_public_request();


---
--- new shipping address types
---
ALTER TYPE contact_address_type ADD VALUE 'SHIPPING_2';
ALTER TYPE contact_address_type ADD VALUE 'SHIPPING_3';
ALTER TABLE contact_address DROP CONSTRAINT company_name_shipping_only;
ALTER TABLE contact_address ADD CONSTRAINT company_name_shipping_only
    CHECK
    (
        company_name IS NULL OR
        type IN ('SHIPPING'::contact_address_type,
                 'SHIPPING_2'::contact_address_type,
                 'SHIPPING_3'::contact_address_type)
    );

ALTER TABLE contact_address_history DROP CONSTRAINT company_name_shipping_only;
ALTER TABLE contact_address_history ADD CONSTRAINT company_name_shipping_only
    CHECK
    (
        company_name IS NULL OR
        type IN ('SHIPPING'::contact_address_type,
                 'SHIPPING_2'::contact_address_type,
                 'SHIPPING_3'::contact_address_type)
    );

