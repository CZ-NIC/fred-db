CREATE TABLE enum_object_states (
  id INTEGER PRIMARY KEY,
  name CHAR(50) NOT NULL,
  types INTEGER[] NOT NULL,
  manual BOOLEAN NOT NULL,
  external BOOLEAN NOT NULL
);

INSERT INTO enum_object_states 
  VALUES (01,'serverDeleteProhibited','{1,2,3}','t','t');
INSERT INTO enum_object_states 
  VALUES (02,'serverRenewProhibited ','{3}','t','t');
INSERT INTO enum_object_states 
  VALUES (03,'serverTransferProhibited','{1,2,3}','t','t');
INSERT INTO enum_object_states 
  VALUES (04,'serverUpdateProhibited','{1,2,3}','t','t');
INSERT INTO enum_object_states 
  VALUES (05,'serverOutzoneManual','{3}','t','t');
INSERT INTO enum_object_states 
  VALUES (06,'serverInzoneManual','{3}','t','t');
INSERT INTO enum_object_states 
  VALUES (07,'serverBlocked','{3}','t','t');
INSERT INTO enum_object_states 
  VALUES (08,'expirationWarning','{3}','f','f');
INSERT INTO enum_object_states 
  VALUES (09,'expired','{3}','f','t');
INSERT INTO enum_object_states 
  VALUES (10,'unguarded','{3}','f','f');
INSERT INTO enum_object_states 
  VALUES (11,'validationWarning1','{3}','f','f');
INSERT INTO enum_object_states 
  VALUES (12,'validationWarning2','{3}','f','f');
INSERT INTO enum_object_states 
  VALUES (13,'notValidated','{3}','f','t');
INSERT INTO enum_object_states 
  VALUES (14,'nssetMissing','{3}','f','f');
INSERT INTO enum_object_states 
  VALUES (15,'outzone','{3}','f','t');
INSERT INTO enum_object_states 
  VALUES (16,'linked','{1,2}','f','t');
INSERT INTO enum_object_states 
  VALUES (17,'deleteCandidate','{1,2,3}','f','f');
INSERT INTO enum_object_states 
  VALUES (18,'serverRegistrantChangeProhibited','{3}','t','t');
INSERT INTO enum_object_states 
  VALUES (19,'deleteWarning','{3}','f','f');

CREATE TABLE enum_object_states_desc (
  state_id INTEGER NOT NULL REFERENCES enum_object_states (id),
  lang CHAR(2) NOT NULL,
  description VARCHAR(255),
  PRIMARY KEY (state_id,lang)
);

INSERT INTO enum_object_states_desc 
  VALUES (01,'CZ','Není povoleno smazání objektu');
INSERT INTO enum_object_states_desc 
  VALUES (01,'EN','Delete of object is forbidden');
INSERT INTO enum_object_states_desc 
  VALUES (02,'CZ','Není povoleno prodloužní registrace objektu');
INSERT INTO enum_object_states_desc 
  VALUES (02,'EN','Renew of object is forbidden');
INSERT INTO enum_object_states_desc 
  VALUES (03,'CZ','Není povolen transfer objektu');
INSERT INTO enum_object_states_desc 
  VALUES (03,'EN','Transfer of object is forbidden');
INSERT INTO enum_object_states_desc 
  VALUES (04,'CZ','Není povolena aktualizace objektu');
INSERT INTO enum_object_states_desc 
  VALUES (04,'EN','Update of object is forbidden');
INSERT INTO enum_object_states_desc 
  VALUES (05,'CZ','Doména je držena mimo zónu');
INSERT INTO enum_object_states_desc 
  VALUES (05,'EN','Domain is held out of zone');
INSERT INTO enum_object_states_desc 
  VALUES (06,'CZ','Doména je držena v zóně');
INSERT INTO enum_object_states_desc 
  VALUES (06,'EN','Domain is held in zone');
INSERT INTO enum_object_states_desc 
  VALUES (07,'CZ','Doména je blokována');
INSERT INTO enum_object_states_desc 
  VALUES (07,'EN','Domain is blocked');
INSERT INTO enum_object_states_desc 
  VALUES (08,'CZ','Registrace skončí za 30 dní');
INSERT INTO enum_object_states_desc 
  VALUES (08,'EN','Registration expire in 30 days');
INSERT INTO enum_object_states_desc 
  VALUES (09,'CZ','Registrace vypršela');
INSERT INTO enum_object_states_desc 
  VALUES (09,'EN','Registration expired');
INSERT INTO enum_object_states_desc 
  VALUES (10,'CZ','Doména již není v ochranné lhůtě');
INSERT INTO enum_object_states_desc 
  VALUES (10,'EN','Domain is not in guarded period');
INSERT INTO enum_object_states_desc 
  VALUES (11,'CZ','Validace domény skončí za 30 dní');
INSERT INTO enum_object_states_desc 
  VALUES (11,'EN','Validation of domain expire in 30 days');
INSERT INTO enum_object_states_desc 
  VALUES (12,'CZ','Validace domény skončí za 15 dní');
INSERT INTO enum_object_states_desc 
  VALUES (12,'EN','Validation of domain expire in 15 days');
INSERT INTO enum_object_states_desc 
  VALUES (13,'CZ','Validace domény skončila');
INSERT INTO enum_object_states_desc 
  VALUES (13,'EN','Validation of domain has expired');
INSERT INTO enum_object_states_desc 
  VALUES (14,'CZ','Doména nemá přiřazen nsset');
INSERT INTO enum_object_states_desc 
  VALUES (14,'EN','Domain has not associated nsset');
INSERT INTO enum_object_states_desc 
  VALUES (15,'CZ','Doména je vyřazena ze zóny');
INSERT INTO enum_object_states_desc 
  VALUES (15,'EN','Domain is out of zone');
INSERT INTO enum_object_states_desc 
  VALUES (16,'CZ','Objekt je použit v nějaké vazbě');
INSERT INTO enum_object_states_desc 
  VALUES (16,'EN','Object is linked to other object');
INSERT INTO enum_object_states_desc 
  VALUES (17,'CZ','Objekt bude smazán');
INSERT INTO enum_object_states_desc 
  VALUES (17,'EN','Object is going to be deleted');
INSERT INTO enum_object_states_desc 
  VALUES (18,'CZ','Není povolena změna držitele');
INSERT INTO enum_object_states_desc 
  VALUES (18,'EN','Registrant change is forbidden');
INSERT INTO enum_object_states_desc 
  VALUES (19,'CZ','Registrace domény bude zrušena za 5 dní');
INSERT INTO enum_object_states_desc 
  VALUES (19,'EN','Domain will be deleted in 5 days');

CREATE TABLE object_state (
  id SERIAL PRIMARY KEY,
  object_id INTEGER NOT NULL REFERENCES object_registry (id),
  state_id INTEGER NOT NULL REFERENCES enum_object_states (id),
  valid_from TIMESTAMP NOT NULL,
  valid_to TIMESTAMP,
  ohid_from INTEGER NOT NULL REFERENCES object_history (hid),
  ohid_to INTEGER REFERENCES object_history (hid)
);

CREATE AGGREGATE array_accum (
  BASETYPE = anyelement,
  sfunc = array_append,
  stype = anyarray,
  initcond = '{}'
);

CREATE VIEW object_state_now AS
SELECT object_id, array_accum(state_id) AS states
FROM object_state
WHERE valid_to ISNULL
GROUP BY object_id;

CREATE TABLE object_state_request (
  id SERIAL PRIMARY KEY,
  object_id INTEGER NOT NULL REFERENCES object_registry (id),
  state_id INTEGER NOT NULL REFERENCES enum_object_states (id),
  valid_from TIMESTAMP NOT NULL,
  valid_to TIMESTAMP,
  -- could be pointer to some list of administration actions
  crdate TIMESTAMP NOT NULL, 
  -- could be pointer to some list of administration actions
  canceled TIMESTAMP 
);

CREATE VIEW object_state_request_now AS
SELECT object_id, array_accum(state_id) AS states
FROM object_state_request
WHERE valid_from<=CURRENT_TIMESTAMP 
AND (valid_to ISNULL OR valid_to>=CURRENT_TIMESTAMP) AND canceled ISNULL
GROUP BY object_id;

CREATE VIEW domain_states AS
SELECT
  d.id AS object_id,
  COALESCE(osr.states,'{}') ||
  CASE WHEN d.exdate - INTERVAL '30 days' <= CURRENT_DATE 
       THEN ARRAY[8] ELSE '{}' END ||
  CASE WHEN d.exdate <= CURRENT_DATE 
       THEN ARRAY[9] ELSE '{}' END ||
  CASE WHEN d.exdate + INTERVAL '30 days' + 
            INTERVAL '14 hours' <= CURRENT_TIMESTAMP 
       THEN ARRAY[10] ELSE '{}' END ||
  CASE WHEN e.exdate - INTERVAL '30 days' <= CURRENT_DATE 
       THEN ARRAY[11] ELSE '{}' END ||
  CASE WHEN e.exdate - INTERVAL '15 days' <= CURRENT_DATE 
       THEN ARRAY[12] ELSE '{}' END ||
  CASE WHEN e.exdate + INTERVAL '14 hours' <= CURRENT_TIMESTAMP 
       THEN ARRAY[13] ELSE '{}' END ||
  CASE WHEN d.nsset ISNULL 
       THEN ARRAY[14] ELSE '{}' END ||
  CASE WHEN
    d.nsset ISNULL OR
    5 = ANY(COALESCE(osr.states,'{}')) OR
    ( d.exdate + INTERVAL '30 days' + 
      INTERVAL '14 hours' <= CURRENT_TIMESTAMP OR
      e.exdate + INTERVAL '14 hours' <= CURRENT_TIMESTAMP ) AND 
      NOT (6 = ANY(COALESCE(osr.states,'{}'))) 
      THEN ARRAY[15] ELSE '{}' END ||
  CASE WHEN d.exdate + INTERVAL '45 days' + 
            INTERVAL '14 hours' <= CURRENT_TIMESTAMP 
       THEN ARRAY[17] ELSE '{}' END AS states
FROM
  domain d, object_registry
  LEFT JOIN enumval e ON (d.id=e.domainid)
  LEFT JOIN object_state_request_now osr ON (d.id=osr.object_id);

CREATE VIEW nsset_states AS
SELECT
  n.id AS object_id,
  COALESCE(osr.states,'{}') ||
  CASE WHEN NOT(d.nsset ISNULL) THEN ARRAY[16] ELSE '{}' END ||
  CASE WHEN n.id ISNULL AND
            CAST(COALESCE(l.last_linked,o.crdate) AS DATE) 
            + INTERVAL '6 month' + INTERVAL '14 hours' <= CURRENT_TIMESTAMP
       THEN ARRAY[17] ELSE '{}' END AS states
FROM
  object_registry o, nsset n
  LEFT JOIN (
    SELECT DISTINCT nsset FROM domain
  ) AS d ON (d.nsset=n.id)
  LEFT JOIN (
    SELECT object_id, MAX(valid_to) AS last_linked
    FROM object_state
    WHERE state_id=16 GROUP BY object_id
  ) AS l ON (n.id=l.object_id)
  LEFT JOIN object_state_request_now osr ON (n.id=osr.object_id)
WHERE
  o.type=2 AND o.id=n.id;

CREATE VIEW contact_states AS
SELECT
  c.id AS object_id,
  COALESCE(osr.states,'{}') ||
  CASE WHEN NOT(cl.cid ISNULL) THEN ARRAY[16] ELSE '{}' END ||
  CASE WHEN cl.cid ISNULL AND
            CAST(COALESCE(l.last_linked,o.crdate) AS DATE) 
            + INTERVAL '6 month' + INTERVAL '14 hours' <= CURRENT_TIMESTAMP
       THEN ARRAY[17] ELSE '{}' END AS states
FROM
  object_registry o, contact c
  LEFT JOIN (
    SELECT registrant AS cid FROM domain
    UNION
    SELECT contactid AS cid FROM domain_contact_map
    UNION
    SELECT contactid AS cid FROM nsset_contact_map
  ) AS cl ON (c.id=cl.cid)
  LEFT JOIN (
    SELECT object_id, MAX(valid_to) AS last_linked
    FROM object_state
    WHERE state_id=16 GROUP BY object_id
  ) AS l ON (c.id=l.object_id)
  LEFT JOIN object_state_request_now osr ON (c.id=osr.object_id)
WHERE
  o.type=1 AND o.id=c.id;

CREATE OR REPLACE FUNCTION array_sort_dist (ANYARRAY)
RETURNS ANYARRAY LANGUAGE SQL
AS $$
SELECT ARRAY(
    SELECT DISTINCT $1[s.i] AS "sort"
    FROM
        generate_series(array_lower($1,1), array_upper($1,1)) AS s(i)
    ORDER BY sort
);
$$ IMMUTABLE;

-- CREATE LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION update_object_states()
RETURNS void
AS $$
BEGIN
  IF NOT EXISTS(
    SELECT relname FROM pg_class
    WHERE relname = 'tmp_object_state_change' AND relkind = 'r' AND
    pg_table_is_visible(oid)
  )
  THEN
    CREATE TEMPORARY TABLE tmp_object_state_change (
      object_id INTEGER,
      new_states INTEGER[],
      old_states INTEGER[]
    );
  ELSE
    TRUNCATE tmp_object_state_change;
  END IF;

  INSERT INTO tmp_object_state_change
  SELECT
    st.object_id, st.states AS new_states, 
    COALESCE(o.states,'{}') AS old_states
  FROM (
    SELECT * FROM domain_states
    UNION
    SELECT * FROM contact_states
    UNION
    SELECT * FROM nsset_states
  ) AS st
  LEFT JOIN object_state_now o ON (st.object_id=o.object_id)
  WHERE array_sort_dist(st.states)!=COALESCE(array_sort_dist(o.states),'{}');

  INSERT INTO object_state (object_id,state_id,valid_from)
  SELECT c.object_id,e.id,CURRENT_TIMESTAMP
  FROM tmp_object_state_change c, enum_object_states e
  WHERE e.id = ANY(c.new_states) AND e.id != ALL(c.old_states);

  UPDATE object_state SET valid_to=CURRENT_TIMESTAMP
  FROM enum_object_states e, tmp_object_state_change c
  WHERE e.id = ANY(c.old_states) AND e.id != ALL(c.new_states)
  AND e.id=object_state.state_id and c.object_id=object_state.object_id 
  AND object_state.valid_to ISNULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION status_update_state(
  _cond BOOL, _state_id INTEGER, _object_id INTEGER
) RETURNS VOID AS $$
 DECLARE
   _num INTEGER;
 BEGIN
   SELECT COUNT(*) INTO _num FROM object_state
   WHERE state_id = _state_id AND valid_to IS NULL 
   AND object_id = _object_id;
   IF _cond THEN
     IF _num = 0 THEN
       INSERT INTO object_state (object_id, state_id, valid_from)
       VALUES (_object_id, _state_id, CURRENT_TIMESTAMP);
     END IF;
   ELSE 
     IF _num > 0 THEN
       UPDATE object_state SET valid_to = CURRENT_TIMESTAMP
       WHERE state_id = _state_id AND valid_to IS NULL 
       AND object_id = _object_id;
     END IF;
   END IF;
 END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION status_update_object_state() RETURNS TRIGGER AS $$
  DECLARE
    _states INTEGER[];
  BEGIN
    IF NEW.state_id = ANY (ARRAY[5,6,10,13,14]) THEN -- stop RECURSION !!!
      SELECT array_accum(state_id) INTO _states FROM object_state
          WHERE valid_to IS NULL AND object_id = NEW.object_id;
      EXECUTE status_update_state(
        (14 = ANY (_states)) OR -- nsset is null
        (5  = ANY (_states)) OR -- serverOutzoneManual
        (NOT (6 = ANY (_states)) AND -- not serverInzoneManual
          ((10 = ANY (_states)) OR -- unguarded
           (13 = ANY (_states)))),  -- not validated
        15, NEW.object_id
      );
    END IF;
    RETURN NEW;
  END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_object_state AFTER INSERT OR UPDATE
  ON object_state FOR EACH ROW EXECUTE PROCEDURE status_update_object_state();

-- update history id of object at status opening and closing 
CREATE OR REPLACE FUNCTION status_update_hid() RETURNS TRIGGER AS $$
  BEGIN
    IF TG_OP = 'UPDATE' AND NEW.ohid_to ISNULL THEN
      SELECT historyid INTO NEW.ohid_to 
      FROM object_registry WHERE id=NEW.object_id;
    ELSE IF TG_OP = 'INSERT' AND NEW.ohid_from ISNULL THEN
        SELECT historyid INTO NEW.ohid_from 
        FROM object_registry WHERE id=NEW.object_id;
      END IF;
    END IF;
    RETURN NEW;
  END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_object_state_hid BEFORE INSERT OR UPDATE
  ON object_state FOR EACH ROW EXECUTE PROCEDURE status_update_hid();

CREATE OR REPLACE FUNCTION status_update_domain() RETURNS TRIGGER AS $$
  DECLARE
    _num INTEGER;
    _nsset_old INTEGER;
    _registrant_old INTEGER;
    _nsset_new INTEGER;
    _registrant_new INTEGER;
  BEGIN
    _nsset_old := NULL;
    _registrant_old := NULL;
    _nsset_new := NULL;
    _registrant_new := NULL;
    -- is it INSERT operation
    IF TG_OP = 'INSERT' THEN
      _registrant_new := NEW.registrant;
      _nsset_new := NEW.nsset;
      -- we ignore exdate, for new domain it shouldn't influence its state
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
      -- take care of all domain statuses
      IF NEW.exdate <> OLD.exdate THEN
        -- state: expiration warning
        EXECUTE status_update_state(
          NEW.exdate - INTERVAL '30 days' <= CURRENT_DATE, 8, NEW.id
        );
        -- state: expired
        EXECUTE status_update_state(
          NEW.exdate <= CURRENT_DATE, 9, NEW.id
        );
        -- state: unguarded
        EXECUTE status_update_state(
          NEW.exdate + INTERVAL '30 days' 
                     + INTERVAL '14 hours' <= CURRENT_TIMESTAMP, 10, NEW.id
        );
        -- state: delete candidate (seems useless - cannot switch after del)
        EXECUTE status_update_state(
          NEW.exdate + INTERVAL '45 days' 
                     + INTERVAL '14 hours' <= CURRENT_TIMESTAMP, 17, NEW.id
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
      -- exdate is meaningless when deleting (probably)
    END IF;

    -- add registrant's linked status if there is none
    IF _registrant_new IS NOT NULL THEN
      SELECT count(*) INTO _num FROM object_state
          WHERE valid_to IS NULL AND state_id = 16 AND
              object_id = _registrant_new;
      IF _num = 0 THEN
        INSERT INTO object_state (object_id, state_id, valid_from)
            VALUES (NEW.registrant, 16, CURRENT_TIMESTAMP);
      END IF;
    END IF;
    -- add nsset's linked status if there is none
    IF _nsset_new IS NOT NULL THEN
      SELECT count(*) INTO _num FROM object_state
          WHERE valid_to IS NULL AND state_id = 16 AND
            object_id = NEW.nsset;
      IF _num = 0 THEN
        INSERT INTO object_state (object_id, state_id, valid_from)
          VALUES (NEW.nsset, 16, CURRENT_TIMESTAMP);
      END IF;
    END IF;
    -- remove registrant's linked status if not bound
    IF _registrant_old IS NOT NULL THEN
      SELECT count(*) INTO _num FROM domain
          WHERE registrant = OLD.registrant;
      IF _num = 0 THEN
        SELECT count(*) INTO _num FROM domain_contact_map
            WHERE contactid = OLD.registrant;
        IF _num = 0 THEN
          SELECT count(*) INTO _num FROM nsset_contact_map
              WHERE contactid = OLD.registrant;
          IF _num = 0 THEN
            UPDATE object_state SET valid_to = CURRENT_TIMESTAMP
                WHERE object_id = OLD.registrant AND state_id = 16 AND
                    valid_to IS NULL;
          END IF;
        END IF;
      END IF;
    END IF;
    -- remove nsset's linked status if not bound
    IF _nsset_old IS NOT NULL THEN
      SELECT count(*) INTO _num FROM domain WHERE nsset = OLD.nsset;
      IF _num = 0 THEN
        UPDATE object_state SET valid_to = CURRENT_TIMESTAMP
            WHERE object_id = OLD.nsset AND state_id = 16 AND valid_to IS NULL;
      END IF;
    END IF;
    RETURN NULL;
  END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_domain AFTER INSERT OR DELETE OR UPDATE
  ON domain FOR EACH ROW EXECUTE PROCEDURE status_update_domain();

CREATE OR REPLACE FUNCTION status_update_enumval() RETURNS TRIGGER AS $$
  DECLARE
    _num INTEGER;
  BEGIN
    -- is it UPDATE operation
    IF TG_OP = 'UPDATE' AND NEW.exdate <> OLD.exdate THEN
      -- state: validation warning 1
      EXECUTE status_update_state(
        NEW.exdate - INTERVAL '30 days' <= CURRENT_DATE, 11, NEW.domainid
      );
      -- state: validation warning 2
      EXECUTE status_update_state(
        NEW.exdate - INTERVAL '15 days' <= CURRENT_DATE, 12, NEW.domainid
      );
      -- state: not validated
      EXECUTE status_update_state(
        NEW.exdate + INTERVAL '14 hours' <= CURRENT_TIMESTAMP, 13, NEW.domainid
      );
    END IF;
  END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_enumval AFTER UPDATE ON enumval
    FOR EACH ROW EXECUTE PROCEDURE status_update_enumval();

CREATE OR REPLACE FUNCTION status_update_contact_map() RETURNS TRIGGER AS $$
  DECLARE
    _num INTEGER;
    _contact_old INTEGER;
    _contact_new INTEGER;
  BEGIN
    _contact_old := NULL;
    _contact_new := NULL;
    -- is it INSERT operation
    IF TG_OP = 'INSERT' THEN
      _contact_new := NEW.contactid;
    -- is it UPDATE operation
    ELSIF TG_OP = 'UPDATE' THEN
      IF NEW.contactid <> OLD.contactid THEN
        _contact_old := OLD.contactid;
        _contact_new := NEW.contactid;
      END IF;
    -- is it DELETE operation
    ELSIF TG_OP = 'DELETE' THEN
      _contact_old := OLD.contactid;
    END IF;

    -- add contact's linked status if there is none
    IF _contact_new IS NOT NULL THEN
      SELECT count(*) INTO _num FROM object_state
        WHERE valid_to IS NULL AND state_id = 16 
        AND object_id = _contact_new;
      IF _num = 0 THEN
        INSERT INTO object_state (object_id, state_id, valid_from)
            VALUES (NEW.contactid, 16, CURRENT_TIMESTAMP);
      END IF;
    END IF;
    -- remove contact's linked status if not bound
    IF _contact_old IS NOT NULL THEN
      SELECT count(*) INTO _num FROM domain WHERE registrant = OLD.contactid;
      IF _num = 0 THEN
        SELECT count(*) INTO _num FROM domain_contact_map
            WHERE contactid = OLD.contactid;
        IF _num = 0 THEN
          SELECT count(*) INTO _num FROM nsset_contact_map
              WHERE contactid = OLD.contactid;
          IF _num = 0 THEN
            UPDATE object_state SET valid_to = CURRENT_TIMESTAMP
                WHERE object_id = OLD.contactid AND state_id = 16 AND
                    valid_to IS NULL;
          END IF;
        END IF;
      END IF;
    END IF;
  END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_domain_contact_map AFTER INSERT OR DELETE OR UPDATE
  ON domain_contact_map FOR EACH ROW 
  EXECUTE PROCEDURE status_update_contact_map();

CREATE TRIGGER trigger_nsset_contact_map AFTER INSERT OR DELETE OR UPDATE
  ON nsset_contact_map FOR EACH ROW 
  EXECUTE PROCEDURE status_update_contact_map();
