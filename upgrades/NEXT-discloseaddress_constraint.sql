---
--- Ticket #12846 - constraint contact discloseaddr by conditions in ticket #7495
---
CREATE OR REPLACE FUNCTION contact_discloseaddr_constraint_impl(f_object_id BIGINT)
RETURNS void AS $$
DECLARE
    is_contact_with_hidden_address_and_have_nonempty_organization BOOLEAN;
    is_contact_with_hidden_address_and_not_identified BOOLEAN;
    is_contact_with_hidden_address_and_not_validated BOOLEAN;
BEGIN
    -- ids of other object types unconstrained
    RAISE NOTICE 'check contact_discloseaddr_constraint_impl f_object_id: %', f_object_id;

    SELECT (trim(both ' ' from COALESCE(c.organization,'')) <> '') AS have_organization
    , osri.id IS NULL AS not_identified_contact
    , osrv.id IS NULL AS not_validated_contact
    INTO is_contact_with_hidden_address_and_have_nonempty_organization,
    is_contact_with_hidden_address_and_not_identified,
    is_contact_with_hidden_address_and_not_validated
    FROM contact c
    LEFT JOIN object_state_request osri ON (
        osri.object_id=c.id
        AND osri.state_id = (SELECT id FROM enum_object_states WHERE name = 'identifiedContact')
        -- following condition is from view object_state_request_now used by function update_object_states to set object states
        AND osri.valid_from<=CURRENT_TIMESTAMP AND (osri.valid_to ISNULL OR osri.valid_to>=CURRENT_TIMESTAMP)
        AND osri.canceled IS NULL
    )
    LEFT JOIN object_state_request osrv ON (
        osrv.object_id=c.id
        AND osrv.state_id = (SELECT id FROM enum_object_states WHERE name = 'validatedContact')
        -- following condition is from view object_state_request_now used by function update_object_states to set object states
        AND osrv.valid_from<=CURRENT_TIMESTAMP AND (osrv.valid_to ISNULL OR osrv.valid_to>=CURRENT_TIMESTAMP)
        AND osrv.canceled IS NULL
    )
    WHERE c.discloseaddress = FALSE
    AND c.id = f_object_id;

    IF is_contact_with_hidden_address_and_have_nonempty_organization THEN
        --TODO: RAISE EXCEPTION
        RAISE WARNING 'contact_discloseaddr_constraint_impl failed f_object_id: % can''t have organization', f_object_id;
    END IF;

    IF is_contact_with_hidden_address_and_not_identified AND is_contact_with_hidden_address_and_not_validated THEN
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
        IF NEW.object_id = OLD.object_id THEN
            PERFORM contact_discloseaddr_constraint_impl(NEW.object_id);
        ELSE
            PERFORM contact_discloseaddr_constraint_impl(NEW.object_id);
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
        IF NEW.id = OLD.id THEN
            PERFORM contact_discloseaddr_constraint_impl(NEW.id);
        ELSE
            PERFORM contact_discloseaddr_constraint_impl(NEW.id);
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

