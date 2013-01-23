
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

comment on table enum_object_states is 'list of all supported status types';
comment on column enum_object_states.name is 'code name for status';
comment on column enum_object_states.types is 'what types of objects can have this status (object_registry.type list)';
comment on column enum_object_states.manual is 'if this status is set manualy';
comment on column enum_object_states.external is 'if this status is exported to public';

INSERT INTO enum_object_states 
  VALUES (01,'serverDeleteProhibited','{1,2,3}','t','t');
INSERT INTO enum_object_states 
  VALUES (02,'serverRenewProhibited','{3}','t','t');
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
  VALUES (17,'deleteCandidate','{1,2,3}','f','t');
INSERT INTO enum_object_states 
  VALUES (18,'serverRegistrantChangeProhibited','{3}','t','t');
INSERT INTO enum_object_states 
  VALUES (19,'deleteWarning','{3}','f','f');
INSERT INTO enum_object_states 
  VALUES (20,'outzoneUnguarded','{3}','f','f');


-- update for keyset
update enum_object_states set types = types || array[4] where 2 = any (types);

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

comment on table enum_object_states_desc is 'description for states in different languages';
comment on column enum_object_states_desc.lang is 'code of language';
comment on column enum_object_states_desc.description is 'descriptive text';

INSERT INTO enum_object_states_desc 
  VALUES (01,'CS','Není povoleno smazání');
INSERT INTO enum_object_states_desc 
  VALUES (01,'EN','Delete prohibited');
INSERT INTO enum_object_states_desc 
  VALUES (02,'CS','Není povoleno prodloužení registrace objektu');
INSERT INTO enum_object_states_desc 
  VALUES (02,'EN','Registration renewal prohibited');
INSERT INTO enum_object_states_desc 
  VALUES (03,'CS','Není povolena změna určeného registrátora');
INSERT INTO enum_object_states_desc 
  VALUES (03,'EN','Sponsoring registrar change prohibited');
INSERT INTO enum_object_states_desc 
  VALUES (04,'CS','Není povolena aktualizace');
INSERT INTO enum_object_states_desc 
  VALUES (04,'EN','Update prohibited');
INSERT INTO enum_object_states_desc 
  VALUES (05,'CS','Doména je administrativně vyřazena ze zóny');
INSERT INTO enum_object_states_desc 
  VALUES (05,'EN','Domain is administratively kept out of zone');
INSERT INTO enum_object_states_desc 
  VALUES (06,'CS','Doména je administrativně zařazena do zóny');
INSERT INTO enum_object_states_desc 
  VALUES (06,'EN','Domain is administratively kept in zone');
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
  VALUES (17,'CS','Určeno ke zrušení');
INSERT INTO enum_object_states_desc 
  VALUES (17,'EN','To be deleted');
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
CREATE INDEX object_state_object_id_all_idx ON object_state (object_id);
CREATE INDEX object_state_valid_from_idx ON object_state (valid_from);

comment on table object_state is 'main table of object states and their changes';
comment on column object_state.object_id is 'id of object that has this new status';
comment on column object_state.state_id is 'id of status';
comment on column object_state.valid_from is 'date and time when object entered state';
comment on column object_state.valid_to is 'date and time when object leaved state or null if still has this status';
comment on column object_state.ohid_from is 'history id of object in the moment of entering state (may be null)';
comment on column object_state.ohid_to is 'history id of object in the moment of leaving state or null';

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
  valid_from TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  -- when object should leave requested state
  valid_to TIMESTAMP,
  -- could be pointer to some list of administration actions
  crdate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
  -- could be pointer to some list of administration actions
  canceled TIMESTAMP 
);

comment on table object_state_request is 'request for setting manual state';
comment on column object_state_request.object_id is 'id of object gaining request state';
comment on column object_state_request.state_id is 'id of requested state';
comment on column object_state_request.valid_from is 'when object should enter requested state';
comment on column object_state_request.valid_to is 'when object should leave requested state';
comment on column object_state_request.crdate is 'could be pointed to some list of administation action';
comment on column object_state_request.canceled is 'could be pointed to some list of administation action';

-- simple view for all active requests for state change
CREATE VIEW object_state_request_now AS
SELECT object_id, array_accum(state_id) AS states
FROM object_state_request
WHERE valid_from<=CURRENT_TIMESTAMP 
AND (valid_to ISNULL OR valid_to>=CURRENT_TIMESTAMP) AND canceled ISNULL
GROUP BY object_id;

-- function to test date moved by offset agains current date
CREATE OR REPLACE FUNCTION date_month_test(date, varchar, varchar, varchar)
RETURNS boolean
AS $$
SELECT $1 + ($2||' month')::interval + ($3||' hours')::interval 
       <= CURRENT_TIMESTAMP AT TIME ZONE $4;
$$ IMMUTABLE LANGUAGE SQL;

-- function to test date moved by offset agains current date
CREATE OR REPLACE FUNCTION date_test(date, varchar)
RETURNS boolean
AS $$
SELECT $1 + ($2||' days')::interval <= CURRENT_DATE ;
$$ IMMUTABLE LANGUAGE SQL;

-- function to test date moved by offset agains current date with respect
-- to current time and time zone
CREATE OR REPLACE FUNCTION date_time_test(date, varchar, varchar, varchar)
RETURNS boolean
AS $$
SELECT $1 + ($2||' days')::interval + ($3||' hours')::interval 
       <= CURRENT_TIMESTAMP AT TIME ZONE $4;
$$ IMMUTABLE LANGUAGE SQL;

-- ========== 1. type ==============================
-- following views and one setting function is for global setting of all
-- states. there are view pro each type of object to catch states of ALL
-- objects. then function is defined that compare these states with
-- actual state and update states appropriatly. That function is long
-- running so it cannot be used for updating states online. That case
-- is handled in 2. type of functions 

-- view for actual domain states
-- ================= DOMAIN ========================
-- DROP VIEW domain_states
CREATE VIEW domain_states AS
SELECT
  d.id AS object_id,
  o.historyid AS object_hid,
  COALESCE(osr.states,'{}') ||
  CASE WHEN date_test(d.exdate::date,ep_ex_not.val) 
            AND NOT (2 = ANY(COALESCE(osr.states,'{}'))) -- !renewProhibited
       THEN ARRAY[8] ELSE '{}' END ||  -- expirationWarning
  CASE WHEN date_test(d.exdate::date,'0')                
            AND NOT (2 = ANY(COALESCE(osr.states,'{}'))) -- !renewProhibited
       THEN ARRAY[9] ELSE '{}' END ||  -- expired
  CASE WHEN date_time_test(d.exdate::date,ep_ex_dns.val,ep_tm2.val,ep_tz.val)
            AND NOT (2 = ANY(COALESCE(osr.states,'{}'))) -- !renewProhibited
       THEN ARRAY[10] ELSE '{}' END || -- unguarded
  CASE WHEN date_test(e.exdate::date,ep_val_not1.val)
       THEN ARRAY[11] ELSE '{}' END || -- validationWarning1
  CASE WHEN date_test(e.exdate::date,ep_val_not2.val)
       THEN ARRAY[12] ELSE '{}' END || -- validationWarning2
  CASE WHEN date_time_test(e.exdate::date,'0',ep_tm2.val,ep_tz.val)
       THEN ARRAY[13] ELSE '{}' END || -- notValidated
  CASE WHEN d.nsset ISNULL 
       THEN ARRAY[14] ELSE '{}' END || -- nssetMissing
  CASE WHEN
    d.nsset ISNULL OR
    5 = ANY(COALESCE(osr.states,'{}')) OR                -- outzoneManual
    (((date_time_test(d.exdate::date,ep_ex_dns.val,ep_tm2.val,ep_tz.val)
       AND NOT (2 = ANY(COALESCE(osr.states,'{}')))      -- !renewProhibited
      ) OR date_time_test(e.exdate::date,'0',ep_tm2.val,ep_tz.val)) AND 
     NOT (6 = ANY(COALESCE(osr.states,'{}'))))           -- !inzoneManual
       THEN ARRAY[15] ELSE '{}' END || -- outzone
  CASE WHEN date_time_test(d.exdate::date,ep_ex_reg.val,ep_tm.val,ep_tz.val)
            AND NOT (2 = ANY(COALESCE(osr.states,'{}'))) -- !renewProhibited
            AND NOT (1 = ANY(COALESCE(osr.states,'{}'))) -- !deleteProhibited
       THEN ARRAY[17] ELSE '{}' END || -- deleteCandidate
  CASE WHEN date_test(d.exdate::date,ep_ex_let.val)
            AND NOT (2 = ANY(COALESCE(osr.states,'{}'))) -- !renewProhibited
       THEN ARRAY[19] ELSE '{}' END || -- deleteWarning
  CASE WHEN date_time_test(d.exdate::date,ep_ex_dns.val,ep_tm2.val,ep_tz.val)
            AND NOT (2 = ANY(COALESCE(osr.states,'{}'))) -- !renewProhibited
            AND NOT (6 = ANY(COALESCE(osr.states,'{}'))) -- !inzoneManual
       THEN ARRAY[20] ELSE '{}' END    -- outzoneUnguarded
  AS states
FROM
  object_registry o,
  domain d
  LEFT JOIN enumval e ON (d.id=e.domainid)
  LEFT JOIN object_state_request_now osr ON (d.id=osr.object_id)
  JOIN enum_parameters ep_ex_not ON (ep_ex_not.id=3)
  JOIN enum_parameters ep_ex_dns ON (ep_ex_dns.id=4)
  JOIN enum_parameters ep_ex_let ON (ep_ex_let.id=5)
  JOIN enum_parameters ep_ex_reg ON (ep_ex_reg.id=6)
  JOIN enum_parameters ep_val_not1 ON (ep_val_not1.id=7)
  JOIN enum_parameters ep_val_not2 ON (ep_val_not2.id=8)
  JOIN enum_parameters ep_tm ON (ep_tm.id=9)
  JOIN enum_parameters ep_tz ON (ep_tz.id=10)
  JOIN enum_parameters ep_tm2 ON (ep_tm2.id=14)
WHERE d.id=o.id;

-- view for actual nsset states
-- for NOW they are not deleted
-- ================= NSSET ========================
-- DROP VIEW nsset_states
CREATE VIEW nsset_states AS
SELECT
  o.id AS object_id,
  o.historyid AS object_hid,
  COALESCE(osr.states,'{}') ||
  CASE WHEN NOT(d.nsset ISNULL) THEN ARRAY[16] ELSE '{}' END ||
  CASE WHEN d.nsset ISNULL 
            AND date_month_test(
              GREATEST(
                COALESCE(l.last_linked,o.crdate)::date,
                COALESCE(ob.update,o.crdate)::date
              ),
              ep_mn.val,ep_tm.val,ep_tz.val
            )
            AND NOT (1 = ANY(COALESCE(osr.states,'{}')))
       THEN ARRAY[17] ELSE '{}' END 
  AS states
FROM
  object ob
  JOIN object_registry o ON (ob.id=o.id AND o.type=2)
  JOIN enum_parameters ep_tm ON (ep_tm.id=9)
  JOIN enum_parameters ep_tz ON (ep_tz.id=10)
  JOIN enum_parameters ep_mn ON (ep_mn.id=11)
  LEFT JOIN (
    SELECT DISTINCT nsset FROM domain
  ) AS d ON (d.nsset=o.id)
  LEFT JOIN (
    SELECT object_id, MAX(valid_to) AS last_linked
    FROM object_state
    WHERE state_id=16 GROUP BY object_id
  ) AS l ON (o.id=l.object_id)
  LEFT JOIN object_state_request_now osr ON (o.id=osr.object_id);

-- ================= KEYSET ========================
-- DROP VIEW keyset_states
CREATE VIEW keyset_states AS
SELECT
  o.id AS object_id,
  o.historyid AS object_hid,
  COALESCE(osr.states,'{}') ||
  CASE WHEN NOT(d.keyset ISNULL) THEN ARRAY[16] ELSE '{}' END ||
  CASE WHEN d.keyset ISNULL 
            AND date_month_test(
              GREATEST(
                COALESCE(l.last_linked,o.crdate)::date,
                COALESCE(ob.update,o.crdate)::date
              ),
              ep_mn.val,ep_tm.val,ep_tz.val
            )
            AND NOT (1 = ANY(COALESCE(osr.states,'{}')))
       THEN ARRAY[17] ELSE '{}' END 
  AS states
FROM
  object ob
  JOIN object_registry o ON (ob.id=o.id AND o.type=4)
  JOIN enum_parameters ep_tm ON (ep_tm.id=9)
  JOIN enum_parameters ep_tz ON (ep_tz.id=10)
  JOIN enum_parameters ep_mn ON (ep_mn.id=11)
  LEFT JOIN (
    SELECT DISTINCT keyset FROM domain
  ) AS d ON (d.keyset=o.id)
  LEFT JOIN (
    SELECT object_id, MAX(valid_to) AS last_linked
    FROM object_state
    WHERE state_id=16 GROUP BY object_id
  ) AS l ON (o.id=l.object_id)
  LEFT JOIN object_state_request_now osr ON (o.id=osr.object_id);

-- view for actual contact states
-- ================= CONTACT ========================
-- DROP VIEW contact_states
CREATE VIEW contact_states AS
SELECT
  o.id AS object_id,
  o.historyid AS object_hid,
  COALESCE(osr.states,'{}') ||
  CASE WHEN NOT(cl.cid ISNULL) THEN ARRAY[16] ELSE '{}' END ||
  CASE WHEN cl.cid ISNULL 
            AND date_month_test(
              GREATEST(
                COALESCE(l.last_linked,o.crdate)::date,
                COALESCE(ob.update,o.crdate)::date
              ),
              ep_mn.val,ep_tm.val,ep_tz.val
            )
            AND NOT (1 = ANY(COALESCE(osr.states,'{}')))
       THEN ARRAY[17] ELSE '{}' END 
  AS states
FROM
  object ob
  JOIN object_registry o ON (ob.id=o.id AND o.type=1)
  JOIN enum_parameters ep_tm ON (ep_tm.id=9)
  JOIN enum_parameters ep_tz ON (ep_tz.id=10)
  JOIN enum_parameters ep_mn ON (ep_mn.id=11)
  LEFT JOIN (
    SELECT registrant AS cid FROM domain
    UNION
    SELECT contactid AS cid FROM domain_contact_map
    UNION
    SELECT contactid AS cid FROM nsset_contact_map
    UNION
    SELECT contactid AS cid FROM keyset_contact_map
  ) AS cl ON (o.id=cl.cid)
  LEFT JOIN (
    SELECT object_id, MAX(valid_to) AS last_linked
    FROM object_state
    WHERE state_id=16 GROUP BY object_id
  ) AS l ON (o.id=l.object_id)
  LEFT JOIN object_state_request_now osr ON (o.id=osr.object_id);

-- in next function compared arrays need to be sorted
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

-- ================= UPDATE FUNCTION =================
-- CREATE LANGUAGE plpgsql;
CREATE OR REPLACE FUNCTION update_object_states(int)
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

  IF $1 = 0
  THEN
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
      UNION
      SELECT * FROM keyset_states
    ) AS st
    LEFT JOIN object_state_now o ON (st.object_id=o.object_id)
    WHERE array_sort_dist(st.states)!=COALESCE(array_sort_dist(o.states),'{}');
  ELSE
    -- domain
    INSERT INTO tmp_object_state_change
    SELECT
      st.object_id, st.object_hid, st.states AS new_states, 
      COALESCE(o.states,'{}') AS old_states
    FROM domain_states st
    LEFT JOIN object_state_now o ON (st.object_id=o.object_id)
    WHERE array_sort_dist(st.states)!=COALESCE(array_sort_dist(o.states),'{}')
    AND st.object_id=$1;
    -- contact
    INSERT INTO tmp_object_state_change
    SELECT
      st.object_id, st.object_hid, st.states AS new_states, 
      COALESCE(o.states,'{}') AS old_states
    FROM contact_states st
    LEFT JOIN object_state_now o ON (st.object_id=o.object_id)
    WHERE array_sort_dist(st.states)!=COALESCE(array_sort_dist(o.states),'{}')
    AND st.object_id=$1;
    -- nsset
    INSERT INTO tmp_object_state_change
    SELECT
      st.object_id, st.object_hid, st.states AS new_states, 
      COALESCE(o.states,'{}') AS old_states
    FROM nsset_states st
    LEFT JOIN object_state_now o ON (st.object_id=o.object_id)
    WHERE array_sort_dist(st.states)!=COALESCE(array_sort_dist(o.states),'{}')
    AND st.object_id=$1;
    -- keyset
    INSERT INTO tmp_object_state_change
    SELECT
      st.object_id, st.object_hid, st.states AS new_states, 
      COALESCE(o.states,'{}') AS old_states
    FROM keyset_states st
    LEFT JOIN object_state_now o ON (st.object_id=o.object_id)
    WHERE array_sort_dist(st.states)!=COALESCE(array_sort_dist(o.states),'{}')
    AND st.object_id=$1;
  END IF;

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

-- ========== 2. type ==============================
-- following functions and triggers are for automatic state update
-- as a reaction on normal EPP commands.

-- RACE CONTIONS! :
-- there are some places where race conditions can play a role. this is
-- because of sharing of nsset and contacts. their status 'linked' is
-- updated when they appear in EPP commands on others object and because
-- of parallel execution of these commands, linked status is 'shared resource'.
--  1. setting linked state. situation when two transactions want to add 
--     linked state is handled by UNIQUE constraint and EXCEPTION 
--     catching in status_set_state function. second setting is let to fail
--     alternative is to lock all table with states which is inefficient
--  2. clearing linked state. when test is done to clear a state, there
--     can appear transaction that change results of this before clear so
--     test and clear need to be atomic. this must be done by row locking
--     of linked state row in states table. this is done by function
--     status_clear_lock.
CREATE OR REPLACE FUNCTION status_clear_lock(integer, integer)
RETURNS boolean
AS $$
SELECT id IS NOT NULL FROM object_state 
WHERE object_id=$1 AND state_id=$2 AND valid_to IS NULL FOR UPDATE;
$$ LANGUAGE SQL;

-- set state of object if condition is satisfied. use optimistic access
-- so there is no need for locking, could be enhanced by checking of 
-- presence of state (to minimize number of failures in unique constraint)
-- but expectation is that this is faster
-- this function only set state, it won't clean it (see next function) 
CREATE OR REPLACE FUNCTION status_set_state(
  _cond BOOL, _state_id INTEGER, _object_id INTEGER
) RETURNS VOID AS $$
 BEGIN
   IF _cond THEN
     -- optimistic access, don't check if status exists
     -- but may fail on UNIQUE constraint, so catching exception 
     INSERT INTO object_state (object_id, state_id, valid_from)
     VALUES (_object_id, _state_id, CURRENT_TIMESTAMP);
   END IF;
 EXCEPTION
   WHEN UNIQUE_VIOLATION THEN
   -- do nothing
 END;
$$ LANGUAGE plpgsql;

-- clear state of object
CREATE OR REPLACE FUNCTION status_clear_state(
  _cond BOOL, _state_id INTEGER, _object_id INTEGER
) RETURNS VOID AS $$
 BEGIN
   IF NOT _cond THEN
     -- condition (valid_to IS NULL) is essential to avoid closing closed
     -- state
     UPDATE object_state SET valid_to = CURRENT_TIMESTAMP
     WHERE state_id = _state_id AND valid_to IS NULL 
     AND object_id = _object_id;
   END IF;
 END;
$$ LANGUAGE plpgsql;

-- set state of object and clear state of object according to condition
CREATE OR REPLACE FUNCTION status_update_state(
  _cond BOOL, _state_id INTEGER, _object_id INTEGER
) RETURNS VOID AS $$
 DECLARE
   _num INTEGER;
 BEGIN
   -- don't know if it's faster to not test condition twise or call EXECUTE
   -- that immidietely return (removing IF), guess is twice test is faster
   IF _cond THEN
     EXECUTE status_set_state(_cond, _state_id, _object_id);
   ELSE
     EXECUTE status_clear_state(_cond, _state_id, _object_id);
   END IF;
 END;
$$ LANGUAGE plpgsql;

-- trigger function to handle dependant state. some states depends on others
-- so trigger is fired on state table after every change and
-- dependant states are updated aproprietly
CREATE OR REPLACE FUNCTION status_update_object_state() RETURNS TRIGGER AS $$
  DECLARE
    _states INTEGER[];
  BEGIN
    IF NEW.state_id = ANY (ARRAY[5,6,10,13,14]) THEN
      -- activation is only done on states that are relevant for
      -- dependant states to stop RECURSION
      SELECT array_accum(state_id) INTO _states FROM object_state
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
        20, NEW.object_id -- => set ouzoneUnguarded
      );
    END IF;
    RETURN NEW;
  END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_object_state AFTER INSERT OR UPDATE
  ON object_state FOR EACH ROW EXECUTE PROCEDURE status_update_object_state();

-- update history id of object at status opening and closing
-- it's useful to catch history id of object on state opening and closing
-- to centralize this setting, it's done by trigger here
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

-- trigger to update state of domain, fired with every change on
-- on domain table
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
    -- locking must be done (see comment above)
    IF _contact_old IS NOT NULL AND
       status_clear_lock(_contact_old, 16) IS NOT NULL 
    THEN
      SELECT count(*) INTO _num FROM domain WHERE registrant = OLD.contactid;
      IF _num = 0 THEN
        SELECT count(*) INTO _num FROM domain_contact_map
            WHERE contactid = OLD.contactid;
        IF _num = 0 THEN
          SELECT count(*) INTO _num FROM nsset_contact_map
              WHERE contactid = OLD.contactid;
          IF _num = 0 THEN
            SELECT count(*) INTO _num FROM keyset_contact_map
                WHERE contactid = OLD.contactid;
            EXECUTE status_clear_state(_num <> 0, 16, OLD.contactid);
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

CREATE TRIGGER trigger_keyset_contact_map AFTER INSERT OR DELETE OR UPDATE
  ON keyset_contact_map FOR EACH ROW 
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

---
--- Ticket #7122 - lock object_state_request for manual state insert or update by state and object to the end of db transaction
---

CREATE TABLE object_state_request_lock
(
    id bigserial PRIMARY KEY -- lock id
    , state_id integer NOT NULL REFERENCES enum_object_states (id)
    , object_id integer NOT NULL --REFERENCES object_registry (id)
);

CREATE OR REPLACE FUNCTION lock_object_state_request_lock( f_state_id BIGINT, f_object_id BIGINT)
RETURNS void AS $$
DECLARE
BEGIN
    PERFORM * FROM object_state_request_lock
    WHERE state_id = f_state_id
    AND object_id = f_object_id ORDER BY id FOR UPDATE; --wait if locked
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Failed to lock state_id: % object_id: %', f_state_id, f_object_id;
    END IF;
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
    PERFORM lock_object_state_request_lock( NEW.state_id, NEW.object_id);
  --try cleanup
  BEGIN
    SELECT MAX(id) - 100 FROM object_state_request_lock INTO max_id_to_delete;
    PERFORM * FROM object_state_request_lock
      WHERE id < max_id_to_delete FOR UPDATE NOWAIT;
    IF FOUND THEN
      DELETE FROM object_state_request_lock
        WHERE id < max_id_to_delete;
    END IF;
  EXCEPTION WHEN lock_not_available THEN
    RAISE NOTICE 'cleanup lock not available';
  END;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION lock_object_state_request()
IS 'lock changes of object state requests by object and state';

CREATE TRIGGER "trigger_lock_object_state_request"
  AFTER INSERT OR UPDATE ON object_state_request
  FOR EACH ROW EXECUTE PROCEDURE lock_object_state_request();

