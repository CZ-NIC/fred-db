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
