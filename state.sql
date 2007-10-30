
-- all supported status types
CREATE TABLE enum_object_states (
  -- id of status
  id INTEGER PRIMARY KEY,
  -- code name for status
  name VARCHAR(50) NOT NULL,
  -- what types of objects can have this status (object_registry.type list)
  types INTEGER[] NOT NULL,
  -- if this status is set manualy
  manual BOOLEAN NOT NULL,
  -- if this status is exported to public
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
INSERT INTO enum_object_states 
  VALUES (20,'outzoneUnguarded','{3}','f','f');

-- descriptions fo states in different languages 
CREATE TABLE enum_object_states_desc (
  -- id of status
  state_id INTEGER NOT NULL REFERENCES enum_object_states (id),
  -- char code of language
  lang CHAR(2) NOT NULL,
  -- descriptive text
  description VARCHAR(255),
  PRIMARY KEY (state_id,lang)
);

INSERT INTO enum_object_states_desc 
  VALUES (01,'CS','Není povoleno smazání');
INSERT INTO enum_object_states_desc 
  VALUES (01,'EN','Delete prohibited');
INSERT INTO enum_object_states_desc 
  VALUES (02,'CS','Není povoleno prodloužní registrace objektu');
INSERT INTO enum_object_states_desc 
  VALUES (02,'EN','Registration renew prohibited');
INSERT INTO enum_object_states_desc 
  VALUES (03,'CS','Není povolena změna určeného regsitrátora');
INSERT INTO enum_object_states_desc 
  VALUES (03,'EN','Sponsoring registrar change prohibited');
INSERT INTO enum_object_states_desc 
  VALUES (04,'CS','Není povolena aktualizace');
INSERT INTO enum_object_states_desc 
  VALUES (04,'EN','Update prohibited');
INSERT INTO enum_object_states_desc 
  VALUES (05,'CS','Doména je administrativně vyřazena ze zóny');
INSERT INTO enum_object_states_desc 
  VALUES (05,'EN','Domain is administartively kept out of zone');
INSERT INTO enum_object_states_desc 
  VALUES (06,'CS','Doména je administrativně zařazena do zóny');
INSERT INTO enum_object_states_desc 
  VALUES (06,'EN','Domain is administartively kept in zone');
INSERT INTO enum_object_states_desc 
  VALUES (07,'CS','Doména je blokována');
INSERT INTO enum_object_states_desc 
  VALUES (07,'EN','Domain blocked');
INSERT INTO enum_object_states_desc 
  VALUES (08,'CS','Doména expiruje do 30 dní');
INSERT INTO enum_object_states_desc 
  VALUES (08,'EN','Expires within 30 days');
INSERT INTO enum_object_states_desc 
  VALUES (09,'CS','Doména je po expiraci');
INSERT INTO enum_object_states_desc 
  VALUES (09,'EN','Expired');
INSERT INTO enum_object_states_desc 
  VALUES (10,'CS','Doména je 30 dnů po expiraci');
INSERT INTO enum_object_states_desc 
  VALUES (10,'EN','Domain is 30 days after expiration');
INSERT INTO enum_object_states_desc 
  VALUES (11,'CS','Validace domény skončí za 30 dní');
INSERT INTO enum_object_states_desc 
  VALUES (11,'EN','Validation of domain expire in 30 days');
INSERT INTO enum_object_states_desc 
  VALUES (12,'CS','Validace domény skončí za 15 dní');
INSERT INTO enum_object_states_desc 
  VALUES (12,'EN','Validation of domain expire in 15 days');
INSERT INTO enum_object_states_desc 
  VALUES (13,'CS','Doména není validována');
INSERT INTO enum_object_states_desc 
  VALUES (13,'EN','Domain not validated');
INSERT INTO enum_object_states_desc 
  VALUES (14,'CS','Doména nemá přiřazen nsset');
INSERT INTO enum_object_states_desc 
  VALUES (14,'EN','Domain has not associated nsset');
INSERT INTO enum_object_states_desc 
  VALUES (15,'CS','Doména není generována do zóny');
INSERT INTO enum_object_states_desc 
  VALUES (15,'EN','Domain is not generated into zone');
INSERT INTO enum_object_states_desc 
  VALUES (16,'CS','Je navázáno na další záznam v registru');
INSERT INTO enum_object_states_desc 
  VALUES (16,'EN','Has relation to other records in registry');
INSERT INTO enum_object_states_desc 
  VALUES (17,'CS','Objekt bude smazán');
INSERT INTO enum_object_states_desc 
  VALUES (17,'EN','Object is going to be deleted');
INSERT INTO enum_object_states_desc 
  VALUES (18,'CS','Není povolena změna držitele');
INSERT INTO enum_object_states_desc 
  VALUES (18,'EN','Registrant change prohibited');
INSERT INTO enum_object_states_desc 
  VALUES (19,'CS','Registrace domény bude zrušena za 11 dní');
INSERT INTO enum_object_states_desc 
  VALUES (19,'EN','Domain will be deleted in 11 days');
INSERT INTO enum_object_states_desc 
  VALUES (20,'CS','Doména vyřazena ze zóny po 30 dnech od expirace');
INSERT INTO enum_object_states_desc 
  VALUES (20,'EN','Domain is out of zone after 30 days from expiration');

-- main table of object states and their changes
CREATE TABLE object_state (
  -- id of moment when object gain status
  id SERIAL PRIMARY KEY,
  -- id of object that has this new status
  object_id INTEGER NOT NULL REFERENCES object_registry (id),
  -- id of status
  state_id INTEGER NOT NULL REFERENCES enum_object_states (id),
  -- timestamp when object entered state
  valid_from TIMESTAMP NOT NULL,
  -- timestamp when object leaved state or null if still has status
  valid_to TIMESTAMP,
  -- history id of object in the moment of entering state  (may be NULL)
  ohid_from INTEGER REFERENCES object_history (historyid),
  -- history id of object in the moment of leaving state or null
  ohid_to INTEGER REFERENCES object_history (historyid)
);

CREATE UNIQUE INDEX object_state_now_idx ON object_state (object_id, state_id)
WHERE valid_to ISNULL;

CREATE INDEX object_state_object_id_idx ON object_state (object_id) WHERE valid_to ISNULL;

-- aggregate function for accumulation of elements into array
CREATE AGGREGATE array_accum (
  BASETYPE = anyelement,
  sfunc = array_append,
  stype = anyarray,
  initcond = '{}'
);

-- simple view for all active states of object
CREATE VIEW object_state_now AS
SELECT object_id, array_accum(state_id) AS states
FROM object_state
WHERE valid_to ISNULL
GROUP BY object_id;

-- request for setting manual state
CREATE TABLE object_state_request (
  -- id of request
  id SERIAL PRIMARY KEY,
  -- id of object gaining requested state
  object_id INTEGER NOT NULL REFERENCES object_registry (id),
  -- id of requested state
  state_id INTEGER NOT NULL REFERENCES enum_object_states (id),
  -- when object should enter requested state
  valid_from TIMESTAMP NOT NULL,
  -- when object should leave requested state
  valid_to TIMESTAMP,
  -- could be pointer to some list of administration actions
  crdate TIMESTAMP NOT NULL, 
  -- could be pointer to some list of administration actions
  canceled TIMESTAMP 
);

-- simple view for all active requests for state change
CREATE VIEW object_state_request_now AS
SELECT object_id, array_accum(state_id) AS states
FROM object_state_request
WHERE valid_from<=CURRENT_TIMESTAMP 
AND (valid_to ISNULL OR valid_to>=CURRENT_TIMESTAMP) AND canceled ISNULL
GROUP BY object_id;

-- view for actual domain states
CREATE VIEW domain_states AS
SELECT
  d.id AS object_id,
  o.historyid AS object_hid,
  COALESCE(osr.states,'{}') ||
  CASE WHEN d.exdate::date - INTERVAL '30 days' <= CURRENT_DATE 
       THEN ARRAY[8] ELSE '{}' END ||
  CASE WHEN d.exdate::date <= CURRENT_DATE 
       THEN ARRAY[9] ELSE '{}' END ||
  CASE WHEN d.exdate::date + INTERVAL '30 days' + 
            INTERVAL '14 hours' <= CURRENT_TIMESTAMP 
       THEN ARRAY[10] ELSE '{}' END ||
  CASE WHEN e.exdate::date - INTERVAL '30 days' <= CURRENT_DATE 
       THEN ARRAY[11] ELSE '{}' END ||
  CASE WHEN e.exdate::date - INTERVAL '15 days' <= CURRENT_DATE 
       THEN ARRAY[12] ELSE '{}' END ||
  CASE WHEN e.exdate::date + INTERVAL '14 hours' <= CURRENT_TIMESTAMP 
       THEN ARRAY[13] ELSE '{}' END ||
  CASE WHEN d.nsset ISNULL 
       THEN ARRAY[14] ELSE '{}' END ||
  CASE WHEN
    d.nsset ISNULL OR
    5 = ANY(COALESCE(osr.states,'{}')) OR
    ( d.exdate::date + INTERVAL '30 days' + 
      INTERVAL '14 hours' <= CURRENT_TIMESTAMP OR
      e.exdate::date + INTERVAL '14 hours' <= CURRENT_TIMESTAMP ) AND 
      NOT (6 = ANY(COALESCE(osr.states,'{}'))) 
      THEN ARRAY[15] ELSE '{}' END ||
  CASE WHEN (d.exdate::date + INTERVAL '45 days' + 
            INTERVAL '14 hours' <= CURRENT_TIMESTAMP) AND
            NOT (1 = ANY(COALESCE(osr.states,'{}')))
       THEN ARRAY[17] ELSE '{}' END ||
  CASE WHEN d.exdate::date + INTERVAL '34 days' <= CURRENT_DATE 
       THEN ARRAY[19] ELSE '{}' END ||
  CASE WHEN d.exdate::date + INTERVAL '30 days' + 
            INTERVAL '14 hours' <= CURRENT_TIMESTAMP AND
            NOT (6 = ANY(COALESCE(osr.states,'{}')))
       THEN ARRAY[20] ELSE '{}' END
  AS states
FROM
  object_registry o,
  domain d
  LEFT JOIN enumval e ON (d.id=e.domainid)
  LEFT JOIN object_state_request_now osr ON (d.id=osr.object_id)
WHERE d.id=o.id;

-- view for actual nsset states
-- for NOW they are not deleted
CREATE VIEW nsset_states AS
SELECT
  n.id AS object_id,
  o.historyid AS object_hid,
  COALESCE(osr.states,'{}') ||
  CASE WHEN NOT(d.nsset ISNULL) THEN ARRAY[16] ELSE '{}' END  -- ||
--  CASE WHEN n.id ISNULL AND
--            CAST(COALESCE(l.last_linked,o.crdate) AS DATE) 
--            + INTERVAL '6 month' + INTERVAL '14 hours' <= CURRENT_TIMESTAMP
--            AND NOT (1 = ANY(COALESCE(osr.states,'{}')))
--       THEN ARRAY[17] ELSE '{}' END 
  AS states
FROM
  object_registry o, nsset n
  LEFT JOIN (
    SELECT DISTINCT nsset FROM domain
  ) AS d ON (d.nsset=n.id)
--  LEFT JOIN (
--    SELECT object_id, MAX(valid_to) AS last_linked
--    FROM object_state
--    WHERE state_id=16 GROUP BY object_id
--  ) AS l ON (n.id=l.object_id)
  LEFT JOIN object_state_request_now osr ON (n.id=osr.object_id)
WHERE
  o.type=2 AND o.id=n.id;

-- view for actual contact states
-- for NOW they are not deleted
CREATE VIEW contact_states AS
SELECT
  c.id AS object_id,
  o.historyid AS object_hid,
  COALESCE(osr.states,'{}') ||
  CASE WHEN NOT(cl.cid ISNULL) THEN ARRAY[16] ELSE '{}' END --||
--  CASE WHEN cl.cid ISNULL AND
--            CAST(COALESCE(l.last_linked,o.crdate) AS DATE) 
--            + INTERVAL '6 month' + INTERVAL '14 hours' <= CURRENT_TIMESTAMP
--            AND NOT (1 = ANY(COALESCE(osr.states,'{}')))
--       THEN ARRAY[17] ELSE '{}' END 
  AS states
FROM
  object_registry o, contact c
  LEFT JOIN (
    SELECT registrant AS cid FROM domain
    UNION
    SELECT contactid AS cid FROM domain_contact_map
    UNION
    SELECT contactid AS cid FROM nsset_contact_map
  ) AS cl ON (c.id=cl.cid)
--  LEFT JOIN (
--    SELECT object_id, MAX(valid_to) AS last_linked
--    FROM object_state
--    WHERE state_id=16 GROUP BY object_id
--  ) AS l ON (c.id=l.object_id)
    LEFT JOIN object_state_request_now osr ON (c.id=osr.object_id)
WHERE
  o.type=1 AND o.id=c.id;

CREATE OR REPLACE FUNCTION array_sort_dist (ANYARRAY)
RETURNS ANYARRAY LANGUAGE SQL
AS $$
SELECT COALESCE(ARRAY(
    SELECT DISTINCT $1[s.i] AS "sort"
    FROM
        generate_series(array_lower($1,1), array_upper($1,1)) AS s(i)
    ORDER BY sort
),'{}');
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
      object_hid INTEGER,
      new_states INTEGER[],
      old_states INTEGER[]
    );
  ELSE
    TRUNCATE tmp_object_state_change;
  END IF;

  INSERT INTO tmp_object_state_change
  SELECT
    st.object_id, st.object_hid, st.states AS new_states, 
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

  INSERT INTO object_state (object_id,state_id,valid_from,ohid_from)
  SELECT c.object_id,e.id,CURRENT_TIMESTAMP,c.object_hid
  FROM tmp_object_state_change c, enum_object_states e
  WHERE e.id = ANY(c.new_states) AND e.id != ALL(c.old_states);

  UPDATE object_state SET valid_to=CURRENT_TIMESTAMP, ohid_to=c.object_hid
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

CREATE OR REPLACE FUNCTION status_set_state(
  _cond BOOL, _state_id INTEGER, _object_id INTEGER
) RETURNS VOID AS $$
 DECLARE
   _num INTEGER;
 BEGIN
   IF _cond THEN
     SELECT COUNT(*) INTO _num FROM object_state
     WHERE valid_to IS NULL AND state_id = _state_id 
     AND object_id = _object_id;
     IF _num = 0 THEN
       INSERT INTO object_state (object_id, state_id, valid_from)
       VALUES (_object_id, _state_id, CURRENT_TIMESTAMP);
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
        15, NEW.object_id -- => set outzone
      );
      EXECUTE status_update_state(
        NOT (6 = ANY (_states)) AND -- not serverInzoneManual
            (10 = ANY (_states)), -- unguarded
        20, NEW.object_id -- => set ouzoneUnguarded
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
      -- take care of all domain statuses
      IF NEW.exdate <> OLD.exdate THEN
        -- state: expiration warning
        EXECUTE status_update_state(
          NEW.exdate::date - INTERVAL '30 days' <= CURRENT_DATE, 8, NEW.id
        );
        -- state: expired
        EXECUTE status_update_state(
          NEW.exdate::date <= CURRENT_DATE, 9, NEW.id
        );
        -- state: unguarded
        EXECUTE status_update_state(
          NEW.exdate::date + INTERVAL '30 days' 
                     + INTERVAL '14 hours' <= CURRENT_TIMESTAMP, 10, NEW.id
        );
        -- state: deleteWarning
        EXECUTE status_update_state(
          NEW.exdate::date + INTERVAL '34 days' <= CURRENT_DATE, 19, NEW.id
        );
        -- state: delete candidate (seems useless - cannot switch after del)
        -- for now delete state will be set only globaly
--        EXECUTE status_update_state(
--          NEW.exdate::date + INTERVAL '45 days' 
--                     + INTERVAL '14 hours' <= CURRENT_TIMESTAMP, 17, NEW.id
--        );
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
    EXECUTE status_set_state(
      _registrant_new IS NOT NULL, 16, _registrant_new
    );
    -- add nsset's linked status if there is none
    EXECUTE status_set_state(
      _nsset_new IS NOT NULL, 16, _nsset_new
    );
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
        NEW.exdate::date - INTERVAL '30 days' <= CURRENT_DATE, 11, NEW.domainid
      );
      -- state: validation warning 2
      EXECUTE status_update_state(
        NEW.exdate::date - INTERVAL '15 days' <= CURRENT_DATE, 12, NEW.domainid
      );
      -- state: not validated
      EXECUTE status_update_state(
        NEW.exdate::date + INTERVAL '14 hours' <= CURRENT_TIMESTAMP, 13, NEW.domainid
      );
    END IF;
    RETURN NULL;
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
    EXECUTE status_set_state(
      _contact_new IS NOT NULL, 16, _contact_new
    );
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
    RETURN NULL;
  END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_domain_contact_map AFTER INSERT OR DELETE OR UPDATE
  ON domain_contact_map FOR EACH ROW 
  EXECUTE PROCEDURE status_update_contact_map();

CREATE TRIGGER trigger_nsset_contact_map AFTER INSERT OR DELETE OR UPDATE
  ON nsset_contact_map FOR EACH ROW 
  EXECUTE PROCEDURE status_update_contact_map();

-- object history tables are filled after normal object tables (i.e. domain)
-- and so when new state is generated as result of new row in normal 
-- table, no history table is available to reference in ohid_from
-- this trigger fix this be filling unfilled ohid_from after insert
-- into history
CREATE OR REPLACE FUNCTION object_history_insert() RETURNS TRIGGER AS $$
  BEGIN
    UPDATE object_state SET ohid_from=NEW.historyid 
    WHERE ohid_from ISNULL AND object_id=NEW.id;
    RETURN NEW;
  END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_object_history AFTER INSERT
  ON object_history FOR EACH ROW 
  EXECUTE PROCEDURE object_history_insert();

