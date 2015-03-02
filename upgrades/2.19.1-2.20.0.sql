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


---
--- Ticket #12846 - constraint contact discloseaddr by conditions in ticket #7495
---
CREATE OR REPLACE FUNCTION contact_discloseaddr_constraint_impl(f_object_id BIGINT)
RETURNS void AS $$
DECLARE
    is_contact_hidden_address_and_nonempty_organization BOOLEAN;
    is_contact_hidden_address_and_not_identified_and_not_validated BOOLEAN;
BEGIN
    -- ids of other object types unconstrained
    RAISE NOTICE 'check contact_discloseaddr_constraint_impl f_object_id: %', f_object_id;

    SELECT (trim(both ' ' from COALESCE(c.organization,'')) <> '') AS have_organization
    , osr.id IS NULL AS not_identified_or_validated_contact
    INTO is_contact_hidden_address_and_nonempty_organization,
    is_contact_hidden_address_and_not_identified_and_not_validated
    FROM contact c
    LEFT JOIN object_state_request osr ON (
        osr.object_id=c.id
        AND osr.state_id IN (SELECT id FROM enum_object_states WHERE name IN ('identifiedContact','validatedContact'))
        -- following condition is from view object_state_request_now used by function update_object_states to set object states
        AND osr.valid_from<=CURRENT_TIMESTAMP AND (osr.valid_to ISNULL OR osr.valid_to>=CURRENT_TIMESTAMP)
        AND osr.canceled IS NULL
    )
    WHERE c.discloseaddress = FALSE
    AND c.id = f_object_id;

    IF is_contact_hidden_address_and_nonempty_organization THEN
        --TODO: RAISE EXCEPTION
        RAISE WARNING 'contact_discloseaddr_constraint_impl failed f_object_id: % can''t have organization', f_object_id;
    END IF;

    IF is_contact_hidden_address_and_not_identified_and_not_validated THEN
        --TODO: RAISE EXCEPTION
        RAISE WARNING 'contact_discloseaddr_constraint_impl failed f_object_id: % have to be identified or validated contact', f_object_id;
    END IF;

END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION contact_discloseaddr_constraint_impl(f_object_id BIGINT)
    IS 'check that contact with hidden addres is identified and have no organization set';

CREATE OR REPLACE FUNCTION object_state_request_discloseaddr_constraint()
RETURNS "trigger" AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        PERFORM contact_discloseaddr_constraint_impl(NEW.object_id);
    ELSEIF TG_OP = 'UPDATE' THEN
        PERFORM contact_discloseaddr_constraint_impl(NEW.object_id);
        IF NEW.object_id <> OLD.object_id THEN
            PERFORM contact_discloseaddr_constraint_impl(OLD.object_id);
        END IF;
    ELSEIF TG_OP = 'DELETE' THEN
        PERFORM contact_discloseaddr_constraint_impl(OLD.object_id);
        RETURN OLD;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER "trigger_object_state_request_discloseaddr_constraint"
  AFTER INSERT OR UPDATE OR DELETE ON object_state_request
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW EXECUTE PROCEDURE object_state_request_discloseaddr_constraint();

CREATE OR REPLACE FUNCTION contact_discloseaddr_constraint()
RETURNS "trigger" AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        PERFORM contact_discloseaddr_constraint_impl(NEW.id);
    ELSEIF TG_OP = 'UPDATE' THEN
        PERFORM contact_discloseaddr_constraint_impl(NEW.id);
        IF NEW.id <> OLD.id THEN
            PERFORM contact_discloseaddr_constraint_impl(OLD.id);
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER "trigger_contact_discloseaddr_constraint"
  AFTER INSERT OR UPDATE ON contact
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW
EXECUTE PROCEDURE contact_discloseaddr_constraint();

