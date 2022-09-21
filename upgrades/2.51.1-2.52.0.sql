---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.52.0' WHERE id = 1;


---
--- Issue #2 - add object_authinfo table
---
CREATE TABLE IF NOT EXISTS object_authinfo
(
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    object_id INTEGER NOT NULL CONSTRAINT object_authinfo_object_id_fkey REFERENCES object_registry(id),
    registrar_id INTEGER NOT NULL CONSTRAINT object_authinfo_registrar_id_fkey REFERENCES registrar(id),
    password VARCHAR NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL CONSTRAINT object_authinfo_expires_at_check CHECK (created_at < expires_at),
    canceled_at TIMESTAMP NULL DEFAULT NULL CONSTRAINT object_authinfo_canceled_at_check
                CHECK (canceled_at IS NULL OR (created_at <= canceled_at AND COALESCE(password, '') = '')),
    use_count INTEGER NOT NULL DEFAULT 0
);

CREATE UNIQUE INDEX IF NOT EXISTS object_authinfo_object_id_registrar_id_idx
    ON object_authinfo (object_id, registrar_id)
 WHERE password <> '';

CREATE INDEX IF NOT EXISTS object_authinfo_expires_at_idx
    ON object_authinfo (expires_at)
 WHERE password <> '' AND
       canceled_at IS NULL;


ALTER TABLE registraracl
    ADD COLUMN uuid UUID NOT NULL UNIQUE DEFAULT gen_random_uuid(),
    ADD create_time TIMESTAMP,
    ADD cert_data_pem VARCHAR(16384),
    ALTER create_time SET DEFAULT CURRENT_TIMESTAMP;

CREATE UNIQUE INDEX registraracl_registrarid_hexcert_fkey
       ON registraracl (registrarid, DECODE(REGEXP_REPLACE(cert, ':', '', 'g'), 'hex'));

COMMENT ON COLUMN registraracl.cert IS 'MD5 fingerprint of registrar''s certificate in HEX format ''FA:09:...:73''';
COMMENT ON COLUMN registraracl.uuid IS 'uuid for external reference';
COMMENT ON COLUMN registraracl.create_time IS 'when the record was created';
COMMENT ON COLUMN registraracl.cert_data_pem IS 'certificate data in PEM format';


ALTER TABLE registrar_certification
        ADD COLUMN uuid UUID NOT NULL UNIQUE DEFAULT gen_random_uuid(),
        ADD eval_file_uuid UUID;

UPDATE registrar_certification rc
   SET eval_file_uuid = files.uuid
  FROM files
 WHERE files.id = rc.eval_file_id;

ALTER TABLE registrar_certification
        ALTER eval_file_uuid SET NOT NULL;

COMMENT ON COLUMN registrar_certification.uuid IS 'uuid for external reference';
COMMENT ON COLUMN registrar_certification.eval_file_uuid IS
    'evaluation pdf file external link';

-- synchronize eval_file_id with eval_file_uuid through files table
CREATE OR REPLACE FUNCTION registrar_certification_eval_file_id_sync()
RETURNS "trigger" AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- old clients insert id
        IF NEW.eval_file_id IS NOT NULL THEN
            SELECT f.uuid
              FROM files f
             WHERE f.id = NEW.eval_file_id
              INTO NEW.eval_file_uuid;
            RETURN NEW;
        END IF;
        -- new clients insert uuid
        IF NEW.eval_file_uuid IS NOT NULL THEN
            SELECT f.id
              FROM files f
             WHERE f.uuid = NEW.eval_file_uuid
              INTO NEW.eval_file_id;
            RETURN NEW;
        END IF;
    ELSEIF TG_OP = 'UPDATE' THEN
        -- old clients update id
        IF NEW.eval_file_id IS NOT NULL AND NEW.eval_file_id <> OLD.eval_file_id THEN
            SELECT f.uuid
              FROM files f
             WHERE f.id = NEW.eval_file_id
              INTO NEW.eval_file_uuid;
            RETURN NEW;
        END IF;
        -- new clients update uuid
        IF NEW.eval_file_uuid IS NOT NULL AND NEW.eval_file_uuid <> OLD.eval_file_uuid THEN
            SELECT f.id
              FROM files f
             WHERE f.uuid = NEW.eval_file_uuid
              INTO NEW.eval_file_id;
            RETURN NEW;
        END IF;
    END IF;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION registrar_certification_eval_file_id_sync()
    IS 'synchronize `eval_file_id` with `eval_file_uuid` through `files` table';

CREATE TRIGGER "trigger_registrar_certification_eval_file_id_sync"
    BEFORE INSERT OR UPDATE ON registrar_certification
    FOR EACH ROW EXECUTE PROCEDURE registrar_certification_eval_file_id_sync();
