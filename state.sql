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
WHERE valid_from>=CURRENT_TIMESTAMP AND (valid_to ISNULL OR valid_to>=CURRENT_TIMESTAMP) AND canceled ISNULL
GROUP BY object_id;

CREATE VIEW domain_states AS
SELECT
  d.id AS object_id,
  COALESCE(osr.states,'{}') ||
  CASE WHEN d.exdate - INTERVAL '30 days' <= CURRENT_DATE THEN ARRAY[8] ELSE '{}' END ||
  CASE WHEN d.exdate <= CURRENT_DATE THEN ARRAY[9] ELSE '{}' END ||
  CASE WHEN d.exdate + INTERVAL '30 days' + INTERVAL '14 hours' <= CURRENT_TIMESTAMP THEN ARRAY[10] ELSE '{}' END ||
  CASE WHEN e.exdate - INTERVAL '30 days' <= CURRENT_DATE THEN ARRAY[11] ELSE '{}' END ||
  CASE WHEN e.exdate - INTERVAL '15 days' <= CURRENT_DATE THEN ARRAY[12] ELSE '{}' END ||
  CASE WHEN e.exdate + INTERVAL '14 hours' <= CURRENT_TIMESTAMP THEN ARRAY[13] ELSE '{}' END ||
  CASE WHEN d.nsset ISNULL THEN ARRAY[14] ELSE '{}' END ||
  CASE WHEN
    d.nsset ISNULL OR
    5 = ANY(osr.states) OR
    ( d.exdate + INTERVAL '30 days' + INTERVAL '14 hours' <= CURRENT_TIMESTAMP OR
      e.exdate + INTERVAL '14 hours' <= CURRENT_TIMESTAMP ) AND NOT (6 = ANY(osr.states)) THEN ARRAY[15] ELSE '{}' END ||
  CASE WHEN d.exdate + INTERVAL '45 days' + INTERVAL '14 hours' <= CURRENT_TIMESTAMP THEN ARRAY[17] ELSE '{}' END AS states
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

