---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.44.0' WHERE id = 1;


CREATE TABLE domain_lifecycle_parameters (
    id SERIAL PRIMARY KEY,
    valid_from TIMESTAMP NOT NULL UNIQUE DEFAULT CURRENT_TIMESTAMP,
    expiration_notify_period INTERVAL NOT NULL,
    outzone_unguarded_email_warning_period INTERVAL NOT NULL,
    expiration_dns_protection_period INTERVAL NOT NULL,
    expiration_letter_warning_period INTERVAL NOT NULL,
    expiration_registration_protection_period INTERVAL NOT NULL,
    validation_notify1_period INTERVAL NOT NULL,
    validation_notify2_period INTERVAL NOT NULL
);

INSERT INTO domain_lifecycle_parameters (
    valid_from,
    expiration_notify_period,
    outzone_unguarded_email_warning_period,
    expiration_dns_protection_period,
    expiration_letter_warning_period,
    expiration_registration_protection_period,
    validation_notify1_period,
    validation_notify2_period)
SELECT (SELECT MIN(crdate) FROM object_registry),
       (SELECT val||'DAYS' FROM enum_parameters WHERE name='expiration_notify_period'),
       (SELECT val||'DAYS' FROM enum_parameters WHERE name='outzone_unguarded_email_warning_period'),
       (SELECT val||'DAYS' FROM enum_parameters WHERE name='expiration_dns_protection_period'),
       (SELECT val||'DAYS' FROM enum_parameters WHERE name='expiration_letter_warning_period'),
       (SELECT val||'DAYS' FROM enum_parameters WHERE name='expiration_registration_protection_period'),
       (SELECT val||'DAYS' FROM enum_parameters WHERE name='validation_notify1_period'),
       (SELECT val||'DAYS' FROM enum_parameters WHERE name='validation_notify2_period')
FROM domain_lifecycle_parameters
HAVING COUNT(*)=0;

CREATE OR REPLACE FUNCTION date_test(DATE, INTERVAL)
    RETURNS BOOLEAN
    AS $$
    SELECT ($1+$2)<=CURRENT_DATE;
    $$ STABLE LANGUAGE SQL;

CREATE OR REPLACE FUNCTION date_time_test(DATE, INTERVAL, VARCHAR, VARCHAR)
    RETURNS BOOLEAN
    AS $$
    SELECT ($1+$2+($3||'hours')::INTERVAL)<=
           CURRENT_TIMESTAMP AT TIME ZONE $4;
    $$ STABLE LANGUAGE SQL;

CREATE OR REPLACE VIEW domain_states AS
SELECT
  d.id AS object_id,
  o.historyid AS object_hid,
  COALESCE(osr.states,'{}') ||
  CASE WHEN date_test(d.exdate::date,dlp.expiration_notify_period)
            AND NOT (2 = ANY(COALESCE(osr.states,'{}'))) -- !renewProhibited
       THEN ARRAY[8] ELSE '{}' END ||  -- expirationWarning
  CASE WHEN date_test(d.exdate::date,'0')
            AND NOT (2 = ANY(COALESCE(osr.states,'{}'))) -- !renewProhibited
       THEN ARRAY[9] ELSE '{}' END ||  -- expired
  CASE WHEN date_time_test(d.exdate::date,dlp.expiration_dns_protection_period,ep_tm2.val,ep_tz.val)
            AND NOT (2 = ANY(COALESCE(osr.states,'{}'))) -- !renewProhibited
       THEN ARRAY[10] ELSE '{}' END || -- unguarded
  CASE WHEN date_test(e.exdate::date,dlp.validation_notify1_period)
       THEN ARRAY[11] ELSE '{}' END || -- validationWarning1
  CASE WHEN date_test(e.exdate::date,dlp.validation_notify2_period)
       THEN ARRAY[12] ELSE '{}' END || -- validationWarning2
  CASE WHEN date_time_test(e.exdate::date,'0',ep_tm2.val,ep_tz.val)
       THEN ARRAY[13] ELSE '{}' END || -- notValidated
  CASE WHEN d.nsset ISNULL
       THEN ARRAY[14] ELSE '{}' END || -- nssetMissing
  CASE WHEN
    d.nsset ISNULL OR
    5 = ANY(COALESCE(osr.states,'{}')) OR                -- outzoneManual
    (((date_time_test(d.exdate::date,dlp.expiration_dns_protection_period,ep_tm2.val,ep_tz.val)
       AND NOT (2 = ANY(COALESCE(osr.states,'{}')))      -- !renewProhibited
      ) OR date_time_test(e.exdate::date,'0',ep_tm2.val,ep_tz.val)) AND
     NOT (6 = ANY(COALESCE(osr.states,'{}'))))           -- !inzoneManual
       THEN ARRAY[15] ELSE '{}' END || -- outzone
  CASE WHEN date_time_test(d.exdate::date,dlp.expiration_registration_protection_period,ep_tm.val,ep_tz.val)
            AND NOT (2 = ANY(COALESCE(osr.states,'{}'))) -- !renewProhibited
            AND NOT (1 = ANY(COALESCE(osr.states,'{}'))) -- !deleteProhibited
       THEN ARRAY[17] ELSE '{}' END || -- deleteCandidate
  CASE WHEN date_test(d.exdate::date,dlp.expiration_letter_warning_period)
            AND NOT (2 = ANY(COALESCE(osr.states,'{}'))) -- !renewProhibited
       THEN ARRAY[19] ELSE '{}' END || -- deleteWarning
  CASE WHEN date_time_test(d.exdate::date,dlp.expiration_dns_protection_period,ep_tm2.val,ep_tz.val)
            AND NOT (2 = ANY(COALESCE(osr.states,'{}'))) -- !renewProhibited
            AND NOT (6 = ANY(COALESCE(osr.states,'{}'))) -- !inzoneManual
       THEN ARRAY[20] ELSE '{}' END || -- outzoneUnguarded
  CASE WHEN date_time_test(d.exdate::date,dlp.outzone_unguarded_email_warning_period,'0',ep_tz.val)
            AND NOT (2 = ANY(COALESCE(osr.states,'{}'))) -- !renewProhibited
            AND NOT (6 = ANY(COALESCE(osr.states,'{}'))) -- !inzoneManual
       THEN ARRAY[28] ELSE '{}' END    -- outzoneUnguardedWarning
  AS states
FROM object_registry o
JOIN domain d ON d.id=o.id
LEFT JOIN enumval e ON e.domainid=d.id
LEFT JOIN object_state_request_now osr ON osr.object_id=d.id
JOIN domain_lifecycle_parameters dlp ON dlp.valid_from=(SELECT MAX(valid_from) FROM domain_lifecycle_parameters WHERE valid_from<=d.exdate)
JOIN enum_parameters ep_tm ON (ep_tm.id=9)  -- regular_day_procedure_period
JOIN enum_parameters ep_tz ON (ep_tz.id=10) -- regular_day_procedure_zone
JOIN enum_parameters ep_tm2 ON (ep_tm2.id=14); -- regular_day_outzone_procedure_period

CREATE OR REPLACE FUNCTION status_update_domain() RETURNS TRIGGER AS $$
  DECLARE
    _num INTEGER;
    _nsset_old INTEGER;
    _registrant_old INTEGER;
    _keyset_old INTEGER;
    _nsset_new INTEGER;
    _registrant_new INTEGER;
    _keyset_new INTEGER;
    _ex_not INTERVAL;
    _ex_dns INTERVAL;
    _ex_let INTERVAL;
    _proc_tm VARCHAR;
    _proc_tz VARCHAR;
    _proc_tm2 VARCHAR;
    _ou_warn INTERVAL;
    _states INTEGER[];
  BEGIN
    _nsset_old := NULL;
    _registrant_old := NULL;
    _keyset_old := NULL;
    _nsset_new := NULL;
    _registrant_new := NULL;
    _keyset_new := NULL;
    IF TG_OP = 'DELETE' THEN
      SELECT expiration_notify_period,
             expiration_dns_protection_period,
             expiration_letter_warning_period,
             outzone_unguarded_email_warning_period
      INTO _ex_not,_ex_dns,_ex_let,_ou_warn
      FROM domain_lifecycle_parameters
      WHERE valid_from=(SELECT MAX(valid_from) FROM domain_lifecycle_parameters WHERE valid_from<=OLD.exdate);
    ELSE
      SELECT expiration_notify_period,
             expiration_dns_protection_period,
             expiration_letter_warning_period,
             outzone_unguarded_email_warning_period
      INTO _ex_not,_ex_dns,_ex_let,_ou_warn
      FROM domain_lifecycle_parameters
      WHERE valid_from=(SELECT MAX(valid_from) FROM domain_lifecycle_parameters WHERE valid_from<=NEW.exdate);
    END IF;
    SELECT val INTO _proc_tm FROM enum_parameters WHERE id=9;
    SELECT val INTO _proc_tz FROM enum_parameters WHERE id=10;
    SELECT val INTO _proc_tm2 FROM enum_parameters WHERE id=14;
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
