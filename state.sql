CREATE TABLE enum_object_states (
  id INTEGER PRIMARY KEY,
  name CHAR(30) NOT NULL,
  types INTEGER[] NOT NULL,
  manual BOOLEAN NOT NULL,
  external BOOLEAN NOT NULL
);

CREATE TABLE enum_object_states_desc (
  state_id INTEGER NOT NULL REFERENCES enum_object_states (id),
  lang CHAR(2) NOT NULL,
  description VARCHAR(255),
  PRIMARY KEY (state_id,lang)
);

INSERT INTO enum_object_states VALUES (01,'serverDeleteProhibited','{1,2,3}','t','t');
INSERT INTO enum_object_states VALUES (02,'serverRenewProhibited ','{3}','t','t');
INSERT INTO enum_object_states VALUES (03,'serverTransferProhibited','{1,2,3}','t','t');
INSERT INTO enum_object_states VALUES (04,'serverUpdateProhibited','{1,2,3}','t','t');
INSERT INTO enum_object_states VALUES (05,'serverOutzoneManual','{3}','t','t');
INSERT INTO enum_object_states VALUES (06,'serverInzoneManual','{3}','t','t');
INSERT INTO enum_object_states VALUES (07,'serverBlocked','{3}','t','t');
INSERT INTO enum_object_states VALUES (08,'expirationWarning','{3}','f','f');
INSERT INTO enum_object_states VALUES (09,'expired','{3}','f','t');
INSERT INTO enum_object_states VALUES (10,'unguarded','{3}','f','f');
INSERT INTO enum_object_states VALUES (11,'validationWarning1','{3}','f','f');
INSERT INTO enum_object_states VALUES (12,'validationWarning2','{3}','f','t');
INSERT INTO enum_object_states VALUES (13,'notValidated','{3}','f','t');
INSERT INTO enum_object_states VALUES (14,'nssetMissing','{3}','f','f');
INSERT INTO enum_object_states VALUES (15,'outzone','{3}','f','t');
INSERT INTO enum_object_states VALUES (16,'linked','{1,2}','f','t');
INSERT INTO enum_object_states VALUES (17,'deleteCandidade','{1,2,3}','f','f');

CREATE TABLE object_state (
  id SERIAL PRIMARY KEY,
  object_id INTEGER NOT NULL REFERENCES object_registry (id),
  state_id INTEGER NOT NULL REFERENCES enum_object_states (id),
  valid_from TIMESTAMP NOT NULL,
  valid_to TIMESTAMP
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
-- WHERE valid_from<=CURRENT_TIMESTAMP AND (valid_to ISNULL OR valid_to>=CURRENT_TIMESTAMP)
WHERE valid_to ISNULL
GROUP BY object_id;

CREATE TABLE object_state_request (
  id SERIAL PRIMARY KEY,
  object_id INTEGER NOT NULL REFERENCES object_registry (id),
  state_id INTEGER NOT NULL REFERENCES enum_object_states (id),
  valid_from TIMESTAMP NOT NULL,
  valid_to TIMESTAMP,
  crdate TIMESTAMP NOT NULL, -- could be pointer to some list of administration actions
  canceled TIMESTAMP -- could be pointer to some list of administration actions
);

CREATE VIEW object_state_request_now AS
SELECT object_id, array_accum(state_id) AS states
FROM object_state_request
WHERE valid_from<=CURRENT_TIMESTAMP AND (valid_to ISNULL OR valid_to>=CURRENT_TIMESTAMP) AND canceled ISNULL
GROUP BY object_id;

CREATE VIEW domain_states AS
SELECT
  d.id AS object_id,
  COALESCE(osr.states,'{}') ||
  CASE WHEN d.exdate - INTERVAL '30 days' <= CURRENT_DATE THEN ARRAY[8] ELSE '{}' END ||
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
  domain d
  LEFT JOIN enumval e ON (d.id=e.domainid)
  LEFT JOIN object_state_request_now osr ON (d.id=osr.object_id);

CREATE VIEW nsset_states AS
SELECT
  n.id AS object_id,
  COALESCE(osr.states,'{}') ||
  CASE WHEN NOT(d.nsset ISNULL) THEN ARRAY[16] ELSE '{}' END ||
  CASE WHEN n.id ISNULL AND
            CAST(COALESCE(l.last_linked,o.crdate) AS DATE) + INTERVAL '6 month' + INTERVAL '14 hours' <= CURRENT_TIMESTAMP
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
            CAST(COALESCE(l.last_linked,o.crdate) AS DATE) + INTERVAL '6 month' + INTERVAL '14 hours' <= CURRENT_TIMESTAMP
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
    st.object_id, st.states AS new_states, COALESCE(o.states,'{}') AS old_states
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
  AND e.id=object_state.state_id and c.object_id=object_state.object_id AND object_state.valid_to ISNULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION status_update_object_state() RETURNS TRIGGER AS $$
  DECLARE
    _num INTEGER;
    _states INTEGER[];
  BEGIN
    IF NEW.state_id = ANY (ARRAY[5,6,10,13,14]) THEN -- stop RECURSION !!!
      SELECT array_accum(state_id) INTO _states FROM object_state
          WHERE valid_to IS NULL AND object_id = NEW.object_id
          GROUP BY object_id;

      SELECT count(*) INTO _num FROM object_state
          WHERE state_id = 15 AND object_id = NEW.object_id AND valid_to ISNULL;
      IF (14 = ANY (_states)) OR -- nsset is null
         (5  = ANY (_states)) OR -- serverOutzoneManual
        (NOT (6 = ANY (_states)) AND -- not serverInzoneManual
        ((10 = ANY (_states)) OR -- unguarded
         (13 = ANY (_states))))  -- not validated
      THEN
        IF _num = 0 THEN
          INSERT INTO object_state (object_id, state_id, valid_from)
              VALUES (NEW.id, 15, CURRENT_TIMESTAMP);
        END IF;
      ELSE
        IF _num > 0 THEN
          UPDATE object_state SET valid_to = CURRENT_TIMESTAMP
              WHERE state_id = 15 AND valid_to IS NULL AND object_id=NEW.id;
        END IF;
      END IF;
    END IF;
  END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_object_state AFTER INSERT OR UPDATE
  ON object_state FOR EACH ROW EXECUTE PROCEDURE status_update_object_state();

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
      IF NEW.nsset <> OLD.nsset THEN
        _nsset_old := OLD.nsset;
        _nsset_new := NEW.nsset;
      END IF;
      -- take care of all domain statuses
      IF NEW.exdate <> OLD.exdate THEN
        -- state: expiration warning
        SELECT count(*) INTO _num FROM object_state
            WHERE state_id = 8 AND valid_to IS NULL AND object_id = NEW.id;
        IF NEW.exdate - INTERVAL '30 days' <= CURRENT_DATE THEN
          IF _num = 0 THEN
            INSERT INTO object_state (object_id, state_id, valid_from)
                VALUES (NEW.id, 8, CURRENT_TIMESTAMP);
          END IF;
        ELSE
          IF _num > 0 THEN
            UPDATE object_state SET valid_to = CURRENT_TIMESTAMP
                WHERE state_id = 8 AND valid_to IS NULL AND object_id = OLD.id;
          END IF;
        END IF;
        -- state: expired
        SELECT count(*) INTO _num FROM object_state
            WHERE state_id = 9 AND valid_to IS NULL AND object_id = NEW.id;
        IF NEW.exdate <= CURRENT_DATE THEN
          IF _num = 0 THEN
            INSERT INTO object_state (object_id, state_id, valid_from)
                VALUES (NEW.id, 9, CURRENT_TIMESTAMP);
          END IF;
        ELSE
          IF _num > 0 THEN
            UPDATE object_state SET valid_to = CURRENT_TIMESTAMP
                WHERE state_id = 9 AND valid_to IS NULL AND object_id = OLD.id;
          END IF;
        END IF;
        -- state: unguarded
        SELECT count(*) INTO _num FROM object_state
            WHERE state_id = 10 AND valid_to IS NULL AND object_id = NEW.id;
        IF NEW.exdate + INTERVAL '30 days' + INTERVAL '14 hours' <= CURRENT_TIMESTAMP THEN
          IF _num = 0 THEN
            INSERT INTO object_state (object_id, state_id, valid_from)
                VALUES (NEW.id, 10, CURRENT_TIMESTAMP);
          END IF;
        ELSE
          IF _num > 0 THEN
            UPDATE object_state SET valid_to = CURRENT_TIMESTAMP
                WHERE state_id = 10 AND valid_to IS NULL AND object_id = OLD.id;
          END IF;
        END IF;
        -- state: nsset missing
        SELECT count(*) INTO _num FROM object_state
            WHERE state_id = 14 AND valid_to IS NULL AND object_id = NEW.id;
        IF NEW.nsset ISNULL THEN
          IF _num = 0 THEN
            INSERT INTO object_state (object_id, state_id, valid_from)
                VALUES (NEW.id, 14, CURRENT_TIMESTAMP);
          END IF;
        ELSE
          IF _num > 0 THEN
            UPDATE object_state SET valid_to = CURRENT_TIMESTAMP
                WHERE state_id = 14 AND valid_to IS NULL AND object_id = OLD.id;
          END IF;
        END IF;
        -- state: delete candidate
        SELECT count(*) INTO _num FROM object_state
            WHERE state_id = 17 AND valid_to IS NULL AND object_id = NEW.id;
        IF NEW.exdate + INTERVAL '45 days' + INTERVAL '14 hours' <= CURRENT_TIMESTAMP THEN
          IF _num = 0 THEN
            INSERT INTO object_state (object_id, state_id, valid_from)
                VALUES (NEW.id, 17, CURRENT_TIMESTAMP);
          END IF;
        ELSE
          IF _num > 0 THEN
            UPDATE object_state SET valid_to = CURRENT_TIMESTAMP
                WHERE state_id = 17 AND valid_to IS NULL AND object_id = OLD.id;
          END IF;
        END IF;
      END IF;
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
      SELECT count(*) INTO _num FROM object_state
          WHERE state_id = 11 AND valid_to IS NULL AND object_id = NEW.domainid;
      IF NEW.exdate - INTERVAL '30 days' <= CURRENT_DATE THEN
        IF _num = 0 THEN
          INSERT INTO object_state (object_id, state_id, valid_from)
              VALUES (NEW.domainid, 11, CURRENT_TIMESTAMP);
        END IF;
      ELSE
        IF _num > 0 THEN
          UPDATE object_state SET valid_to = CURRENT_TIMESTAMP
              WHERE state_id = 11 AND valid_to IS NULL AND object_id = OLD.domainid;
        END IF;
      END IF;
      -- state: validation warning 2
      SELECT count(*) INTO _num FROM object_state
          WHERE state_id = 12 AND valid_to IS NULL AND object_id = NEW.domainid;
      IF NEW.exdate - INTERVAL '15 days' <= CURRENT_DATE THEN
        IF _num = 0 THEN
          INSERT INTO object_state (object_id, state_id, valid_from)
              VALUES (NEW.domainid, 12, CURRENT_TIMESTAMP);
        END IF;
      ELSE
        IF _num > 0 THEN
          UPDATE object_state SET valid_to = CURRENT_TIMESTAMP
              WHERE state_id = 12 AND valid_to IS NULL AND object_id = OLD.domainid;
        END IF;
      END IF;
      -- state: not validated
      SELECT count(*) INTO _num FROM object_state
          WHERE state_id = 13 AND valid_to IS NULL AND object_id = NEW.domainid;
      IF NEW.exdate + INTERVAL '14 hours' <= CURRENT_TIMESTAMP THEN
        IF _num = 0 THEN
          INSERT INTO object_state (object_id, state_id, valid_from)
              VALUES (NEW.domainid, 13, CURRENT_TIMESTAMP);
        END IF;
      ELSE
        IF _num > 0 THEN
          UPDATE object_state SET valid_to = CURRENT_TIMESTAMP
              WHERE state_id = 13 AND valid_to IS NULL AND object_id = OLD.domainid;
        END IF;
      END IF;
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
          WHERE valid_to IS NULL AND state_id = 16 AND object_id = _contact_new;
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
  ON domain_contact_map FOR EACH ROW EXECUTE PROCEDURE status_update_contact_map();

CREATE TRIGGER trigger_nsset_contact_map AFTER INSERT OR DELETE OR UPDATE
  ON nsset_contact_map FOR EACH ROW EXECUTE PROCEDURE status_update_contact_map();

