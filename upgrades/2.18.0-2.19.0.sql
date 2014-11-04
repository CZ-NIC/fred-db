---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.19.0' WHERE id = 1;


----
---- additional contact addresses
----
CREATE TYPE contact_address_type AS ENUM ('MAILING', 'BILLING', 'SHIPPING');

CREATE TABLE contact_address (
    id SERIAL CONSTRAINT contact_address_pkey PRIMARY KEY,
    contactid INTEGER NOT NULL CONSTRAINT contact_address_contactid_fkey REFERENCES contact (id),
    type contact_address_type NOT NULL,
    company_name VARCHAR(1024),
    street1 VARCHAR(1024),
    street2 VARCHAR(1024),
    street3 VARCHAR(1024),
    city VARCHAR(1024),
    stateorprovince VARCHAR(1024),
    postalcode VARCHAR(32),
    country CHAR(2) CONSTRAINT contact_address_country_fkey REFERENCES enum_country (id),
    CONSTRAINT contact_address_contactid_type_key UNIQUE (contactid,type)
);

CREATE TABLE contact_address_history (
        historyid INTEGER NOT NULL CONSTRAINT contact_address_history_historyid_fkey REFERENCES history (id),
        id INTEGER NOT NULL,
        contactid INTEGER NOT NULL CONSTRAINT contact_address_history_contactid_fkey REFERENCES object_registry (id),
        type contact_address_type NOT NULL,
        company_name VARCHAR(1024),
        street1 VARCHAR(1024),
        street2 VARCHAR(1024),
        street3 VARCHAR(1024),
        city VARCHAR(1024),
        stateorprovince VARCHAR(1024),
        postalcode VARCHAR(32),
        country CHAR(2) CONSTRAINT contact_address_history_country_fkey REFERENCES enum_country (id),
        CONSTRAINT contact_address_history_pkey PRIMARY KEY (id,historyid)
    );

COMMENT ON TABLE contact_address_history IS
'Historic data from contact_address table.
creation - actual data will be copied here from original table in case of any change in contact_address table';


CREATE INDEX object_state_valid_to_idx ON object_state (valid_to);
DROP INDEX object_state_object_id_idx;-- uses object_state_now_idx instead

CREATE INDEX object_state_request_object_id_idx ON object_state_request (object_id);


---
--- new public request for mojeid re-identification
---
INSERT INTO enum_public_request_type (id, name, description) VALUES
    (19, 'mojeid_contact_reidentification', 'MojeID full identification repeated');


CREATE INDEX public_request_objects_map_object_id_index ON public_request_objects_map (object_id);

---
--- fix constraint
---
ALTER TABLE domain ALTER COLUMN zone SET NOT NULL;
ALTER TABLE domain_history ALTER COLUMN zone SET NOT NULL;

---
--- admin. verification status description improvements
---
UPDATE enum_contact_test_status_localization
    SET description = 'Test does not apply to the data.'
  WHERE
    lang = 'en' AND name = 'skipped';
UPDATE enum_contact_test_status_localization
    SET description = E'Test couldn\'t be completed due to an error.'
  WHERE
    lang = 'en' AND name = 'error';
UPDATE enum_contact_test_status_localization
    SET description = 'No problem was found.'
  WHERE
    lang = 'en' AND name = 'ok';
UPDATE enum_contact_test_status_localization
    SET description = 'Test found invalid data.'
  WHERE
    lang = 'en' AND name = 'fail';

---
--- contact verification state migration
---
\set ON_ERROR_STOP 1
\set AUTOCOMMIT 0

BEGIN;

DROP TABLE IF EXISTS object_state_backup;
CREATE TABLE object_state_backup AS
    SELECT os.*
      FROM object_state os
        JOIN object_registry obr ON obr.id = os.object_id AND obr.type = 1
      WHERE os.state_id IN (21, 22, 23);

CREATE UNIQUE INDEX object_state_backup_pkey ON object_state_backup(id);
ALTER TABLE object_state_backup ADD PRIMARY KEY USING INDEX object_state_backup_pkey;
DROP SEQUENCE IF EXISTS object_state_backup_id_seq;
CREATE SEQUENCE object_state_backup_id_seq MINVALUE 100000000;
CREATE UNIQUE INDEX ON object_state_backup(object_id, state_id) WHERE valid_to IS NULL;
CREATE INDEX ON object_state_backup(object_id);
CREATE INDEX ON object_state_backup(valid_from);
CREATE INDEX ON object_state_backup(valid_to);
CREATE INDEX ON object_state_backup(object_id, state_id, valid_from);
CREATE INDEX ON object_state_backup(object_id, state_id, valid_to);
ALTER TABLE object_state_backup ALTER COLUMN id SET DEFAULT nextval('object_state_backup_id_seq'::regclass);

COMMIT;


BEGIN;

ALTER TABLE object_state DISABLE TRIGGER trigger_object_state,
                         DISABLE TRIGGER trigger_object_state_hid;
CREATE INDEX object_state_object_id_state_id_valid_from_idx ON object_state (object_id, state_id, valid_from);
CREATE INDEX object_state_object_id_state_id_valid_to_idx ON object_state (object_id, state_id, valid_to);

INSERT INTO object_state (object_id, state_id, valid_from, valid_to, ohid_from, ohid_to)
    SELECT
        osh.object_id, osh.state_id - 1, osh.valid_from, osh.valid_to, osh.ohid_from, osh.ohid_to
      FROM
        object_state osh
        JOIN object_registry obr ON (obr.id = osh.object_id AND obr.type = 1)
        JOIN enum_object_states eos ON (eos.id = osh.state_id AND eos.name = 'validatedContact')
      WHERE
        (
            SELECT 1
               FROM
                 object_state osl
               WHERE
                 osl.object_id = osh.object_id
                 AND osl.state_id = osh.state_id - 1
                 AND ((osl.valid_from < osh.valid_to OR osh.valid_to IS NULL)
                       AND (osh.valid_from < osl.valid_to OR osl.valid_to IS NULL))
               LIMIT 1
        ) IS NULL;


INSERT INTO object_state (object_id, state_id, valid_from, valid_to, ohid_from, ohid_to)
    SELECT
        osh.object_id, osh.state_id - 1, osh.valid_from, osh.valid_to, osh.ohid_from, osh.ohid_to
      FROM
        object_state osh
        JOIN object_registry obr ON (obr.id=osh.object_id AND obr.type = 1)
        JOIN enum_object_states eos ON (eos.id = osh.state_id AND eos.name = 'identifiedContact')
      WHERE
        (
            SELECT 1
              FROM
                object_state osl
              WHERE
                osl.object_id = osh.object_id
                AND osl.state_id = osh.state_id - 1
                AND ((osl.valid_from<osh.valid_to OR osh.valid_to IS NULL)
                      AND (osh.valid_from<osl.valid_to OR osl.valid_to IS NULL))
              LIMIT 1
        ) IS NULL;

CREATE FUNCTION join_states() RETURNS INT AS $$
DECLARE
    s INT := 0;
BEGIN
    LOOP
        WITH state_to_delete AS
          (
              DELETE FROM object_state osd
                WHERE osd.id IN
                  (
                      WITH state_choice AS
                        (
                            SELECT
                                id
                              FROM
                                enum_object_states
                              WHERE
                                name IN ('conditionallyIdentifiedContact',
                                         'identifiedContact',
                                         'validatedContact')
                        ),
                           state_finished AS
                        (
                            SELECT
                                os.id AS object_state_id,
                                os.object_id AS contact_id,
                                os.state_id,
                                os.valid_to
                              FROM
                                object_registry obr
                                JOIN object_state os ON (os.object_id = obr.id
                                    AND os.state_id IN (SELECT id FROM state_choice))
                              WHERE
                                obr.type = 1
                                AND os.valid_to IS NOT NULL
                        )
                      SELECT
                          os.id
                        FROM state_finished sf
                        JOIN object_state os ON (
                                os.object_id = sf.contact_id
                                AND os.state_id = sf.state_id
                                AND os.valid_from = sf.valid_to
                        )
                  )
                AND
                  (
                      SELECT 1
                        FROM
                            object_state os
                        WHERE
                            os.state_id = osd.state_id
                            AND os.object_id = osd.object_id
                            AND os.valid_from = osd.valid_to
                        LIMIT 1
                  ) IS NULL
              RETURNING id, object_id, state_id, valid_from, valid_to, ohid_to
          )
        UPDATE object_state os
          SET valid_to = std.valid_to, ohid_to = std.ohid_to
          FROM
            state_to_delete std
          WHERE
            os.object_id = std.object_id
            AND os.state_id = std.state_id
            AND os.valid_to = std.valid_from;

        EXIT WHEN NOT FOUND;
        s := s + 1;

    END LOOP;
    RETURN s;
END;
$$ LANGUAGE plpgsql;

SELECT join_states();

DROP FUNCTION join_states();

WITH state_choice AS
  (
    SELECT
        os.*
      FROM
        object_registry obr
        JOIN object_state os ON (os.object_id = obr.id)
        JOIN enum_object_states eos ON eos.id = os.state_id
      WHERE
        obr.type = 1
        AND eos.name IN ('identifiedContact', 'validatedContact')
  )
  SELECT
      COUNT(*) AS cnt, obr.name, obr.crdate, MIN(sc.valid_from) AS valid_from
    FROM
      state_choice sc
      JOIN object_registry obr ON (obr.id = sc.object_id AND obr.type = 1)
    WHERE
      (
          SELECT 1
            FROM
              object_state os
            WHERE
              os.object_id = sc.object_id
              AND os.state_id = (sc.state_id - 1)
              AND os.valid_from <= sc.valid_from
              AND (sc.valid_to <= os.valid_to OR os.valid_to IS NULL)
      ) IS NULL
    GROUP BY
      obr.id
    ORDER BY
      cnt DESC, obr.id;

ALTER TABLE object_state_request DISABLE TRIGGER trigger_lock_object_state_request;

DELETE FROM object_state_request osr
  WHERE osr.state_id IN (21, 22, 23)
       AND
         (
            SELECT 1
              FROM
                object_registry obr
              WHERE
                obr.id = osr.object_id
                AND obr.type = 1
              LIMIT 1
         ) IS NOT NULL;

INSERT INTO object_state_request (object_id, state_id, valid_from, valid_to, crdate, canceled)
  SELECT
      os.object_id, os.state_id, os.valid_from, os.valid_to, os.valid_from, os.valid_to
    FROM
      object_state os
    WHERE
      os.state_id IN (21, 22, 23)
        AND
          (
              SELECT 1
                FROM
                  object_registry obr
                WHERE
                  obr.id = os.object_id
                  AND obr.type = 1
                LIMIT 1
          ) IS NOT NULL
    ORDER BY
      os.valid_from, os.object_id, os.state_id;

ALTER TABLE object_state_request ENABLE TRIGGER trigger_lock_object_state_request;

DROP INDEX object_state_object_id_state_id_valid_to_idx;
DROP INDEX object_state_object_id_state_id_valid_from_idx;
ALTER TABLE object_state ENABLE TRIGGER trigger_object_state_hid,
                         ENABLE TRIGGER trigger_object_state;

COMMIT;

