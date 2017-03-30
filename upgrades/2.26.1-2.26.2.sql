---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.26.2' WHERE id = 1;


CREATE OR REPLACE VIEW object_state_now AS
SELECT object_id, array_agg(state_id) AS states
FROM object_state
WHERE valid_to ISNULL
GROUP BY object_id;


CREATE OR REPLACE VIEW object_state_request_now AS
SELECT object_id, array_agg(state_id) AS states
FROM object_state_request
WHERE valid_from<=CURRENT_TIMESTAMP
AND (valid_to ISNULL OR valid_to>=CURRENT_TIMESTAMP) AND canceled ISNULL
GROUP BY object_id;


CREATE OR REPLACE FUNCTION status_update_object_state() RETURNS TRIGGER AS $$
  DECLARE
    _states INTEGER[];
  BEGIN
    IF NEW.state_id = ANY (ARRAY[5,6,10,13,14]) THEN
      -- activation is only done on states that are relevant for
      -- dependant states to stop RECURSION
      SELECT COALESCE(array_agg(state_id), '{}'::INT[]) INTO _states FROM object_state
          WHERE valid_to IS NULL AND object_id = NEW.object_id;
      -- set or clear status 15 (outzone)
      EXECUTE status_update_state(
        (14 = ANY (_states)) OR -- nsset is null
        (5  = ANY (_states)) OR -- serverOutzoneManual
        (NOT (6 = ANY (_states)) AND -- not serverInzoneManual
          ((10 = ANY (_states)) OR -- unguarded
           (13 = ANY (_states)))),  -- not validated
        15, NEW.object_id -- => set outzone
      );
      -- set or clear status 15 (outzoneUnguarded)
      EXECUTE status_update_state(
        NOT (6 = ANY (_states)) AND -- not serverInzoneManual
            (10 = ANY (_states)), -- unguarded
        20, NEW.object_id -- => set outzoneUnguarded
      );
    END IF;
    RETURN NEW;
  END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION status_update_domain() RETURNS TRIGGER AS $$
  DECLARE
    _num INTEGER;
    _nsset_old INTEGER;
    _registrant_old INTEGER;
    _keyset_old INTEGER;
    _nsset_new INTEGER;
    _registrant_new INTEGER;
    _keyset_new INTEGER;
    _ex_not VARCHAR;
    _ex_dns VARCHAR;
    _ex_let VARCHAR;
--    _ex_reg VARCHAR;
    _proc_tm VARCHAR;
    _proc_tz VARCHAR;
    _proc_tm2 VARCHAR;
    _ou_warn VARCHAR;
    _states INTEGER[];
  BEGIN
    _nsset_old := NULL;
    _registrant_old := NULL;
    _keyset_old := NULL;
    _nsset_new := NULL;
    _registrant_new := NULL;
    _keyset_new := NULL;
    SELECT val INTO _ex_not FROM enum_parameters WHERE id=3;
    SELECT val INTO _ex_dns FROM enum_parameters WHERE id=4;
    SELECT val INTO _ex_let FROM enum_parameters WHERE id=5;
--    SELECT val INTO _ex_reg FROM enum_parameters WHERE id=6;
    SELECT val INTO _proc_tm FROM enum_parameters WHERE id=9;
    SELECT val INTO _proc_tz FROM enum_parameters WHERE id=10;
    SELECT val INTO _proc_tm2 FROM enum_parameters WHERE id=14;
    SELECT val INTO _ou_warn FROM enum_parameters WHERE id=18;
    -- is it INSERT operation
    IF TG_OP = 'INSERT' THEN
      _registrant_new := NEW.registrant;
      _nsset_new := NEW.nsset;
      _keyset_new := NEW.keyset;
      -- we ignore exdate, for new domain it shouldn't influence its state
      -- state: nsset missing
      EXECUTE status_update_state(
        NEW.nsset ISNULL, 14, NEW.id
      );
    -- is it UPDATE operation
    ELSIF TG_OP = 'UPDATE' THEN
      IF NEW.registrant <> OLD.registrant THEN
        _registrant_old := OLD.registrant;
        _registrant_new := NEW.registrant;
      END IF;
      IF COALESCE(NEW.nsset,0) <> COALESCE(OLD.nsset,0) THEN
        _nsset_old := OLD.nsset;
        _nsset_new := NEW.nsset;
      END IF;
      IF COALESCE(NEW.keyset,0) <> COALESCE(OLD.keyset,0) THEN
        _keyset_old := OLD.keyset;
        _keyset_new := NEW.keyset;
      END IF;
      -- take care of all domain statuses
      IF NEW.exdate <> OLD.exdate THEN
        -- at the first sight it seems that there should be checking
        -- for renewProhibited state before setting all of these states
        -- as it's done in global (1. type) views
        -- but the point is that when renewProhibited is set
        -- there is no way to change exdate so this situation can never happen
        -- state: expiration warning
        EXECUTE status_update_state(
          date_test(NEW.exdate::date,_ex_not),
          8, NEW.id
        );
        -- state: expired
        EXECUTE status_update_state(
          date_test(NEW.exdate::date,'0'),
          9, NEW.id
        );
        -- state: unguarded
        EXECUTE status_update_state(
          date_time_test(NEW.exdate::date,_ex_dns,_proc_tm2,_proc_tz),
          10, NEW.id
        );
        -- state: deleteWarning
        EXECUTE status_update_state(
          date_test(NEW.exdate::date,_ex_let),
          19, NEW.id
        );
        -- state: delete candidate (seems useless - cannot switch after del)
        -- for now delete state will be set only globaly
--        EXECUTE status_update_state(
--          date_time_test(NEW.exdate::date,_ex_reg,_proc_tm,_proc_tz),
--          17, NEW.id
--        );
        -- state: outzoneUnguardedWarning
        SELECT COALESCE(array_agg(state_id), '{}'::INT[]) INTO _states FROM object_state
          WHERE valid_to IS NULL AND object_id = NEW.id;
        EXECUTE status_update_state(
          date_test(NEW.exdate::date,_ou_warn)
          AND NOT (6 = ANY (_states)), -- not serverInzoneManual
          28, NEW.id -- => set outzoneUnguardedWarning
        );
      END IF; -- change in exdate
      IF COALESCE(NEW.nsset,0) <> COALESCE(OLD.nsset,0) THEN
        -- state: nsset missing
        EXECUTE status_update_state(
          NEW.nsset ISNULL, 14, NEW.id
        );
      END IF; -- change in nsset
    -- is it DELETE operation
    ELSIF TG_OP = 'DELETE' THEN
      _registrant_old := OLD.registrant;
      _nsset_old := OLD.nsset; -- may be NULL!
      _keyset_old := OLD.keyset; -- may be NULL!
      -- exdate is meaningless when deleting (probably)
    END IF;

    -- add registrant's linked status if there is none
    EXECUTE status_set_state(
      _registrant_new IS NOT NULL, 16, _registrant_new
    );
    -- add nsset's linked status if there is none
    EXECUTE status_set_state(
      _nsset_new IS NOT NULL, 16, _nsset_new
    );
    -- add keyset's linked status if there is none
    EXECUTE status_set_state(
      _keyset_new IS NOT NULL, 16, _keyset_new
    );
    -- remove registrant's linked status if not bound
    -- locking must be done (see comment above)
    IF _registrant_old IS NOT NULL AND
       status_clear_lock(_registrant_old, 16) IS NOT NULL
    THEN
      SELECT count(*) INTO _num FROM domain
          WHERE registrant = OLD.registrant;
      IF _num = 0 THEN
        SELECT count(*) INTO _num FROM domain_contact_map
            WHERE contactid = OLD.registrant;
        IF _num = 0 THEN
          SELECT count(*) INTO _num FROM nsset_contact_map
              WHERE contactid = OLD.registrant;
          IF _num = 0 THEN
            SELECT count(*) INTO _num FROM keyset_contact_map
                WHERE contactid = OLD.registrant;
            EXECUTE status_clear_state(_num <> 0, 16, OLD.registrant);
          END IF;
        END IF;
      END IF;
    END IF;
    -- remove nsset's linked status if not bound
    -- locking must be done (see comment above)
    IF _nsset_old IS NOT NULL AND
       status_clear_lock(_nsset_old, 16) IS NOT NULL
    THEN
      SELECT count(*) INTO _num FROM domain WHERE nsset = OLD.nsset;
      EXECUTE status_clear_state(_num <> 0, 16, OLD.nsset);
    END IF;
    -- remove keyset's linked status if not bound
    -- locking must be done (see comment above)
    IF _keyset_old IS NOT NULL AND
       status_clear_lock(_keyset_old, 16) IS NOT NULL
    THEN
      SELECT count(*) INTO _num FROM domain WHERE keyset = OLD.keyset;
      EXECUTE status_clear_state(_num <> 0, 16, OLD.keyset);
    END IF;
    RETURN NULL;
  END;
$$ LANGUAGE plpgsql;
