-- check whether registrar_certification life is valid
CREATE OR REPLACE FUNCTION registrar_certification_life_check()
RETURNS "trigger" AS $$
DECLARE
    last_reg_cert RECORD;
BEGIN
    IF NEW.valid_from > NEW.valid_until THEN
        RAISE EXCEPTION 'Invalid registrar certification life: valid_from > valid_until';
    END IF;

    IF TG_OP = 'INSERT' THEN
        SELECT * FROM registrar_certification INTO last_reg_cert
            WHERE registrar_id = NEW.registrar_id AND id < NEW.id
            ORDER BY valid_from DESC, id DESC LIMIT 1;
        IF FOUND THEN
            IF last_reg_cert.valid_until IS NULL  THEN
                RAISE EXCEPTION 'Invalid registrar certification life: last registrar certification is still valid';
            END IF;
            IF last_reg_cert.valid_until >= NEW.valid_from  THEN
                RAISE EXCEPTION 'Invalid registrar certification life: last valid_until >= new valid_from';
            END IF;
        END IF;
    ELSEIF TG_OP = 'UPDATE' THEN
        IF NEW.valid_from <> OLD.valid_from THEN
            RAISE EXCEPTION 'Change of valid_from not allowed';
        END IF;
        IF NEW.valid_until < OLD.valid_from THEN
            RAISE EXCEPTION 'Invalid registrar certification life: valid_until < valid_from';
        END IF;
        IF NEW.registrar_id <> OLD.registrar_id THEN
            RAISE EXCEPTION 'Change of registrar not allowed';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION registrar_certification_life_check()
    IS 'check whether registrar_certification life is valid';

COMMENT ON TABLE registrar_certification IS 'result of registrar certification';
COMMENT ON COLUMN registrar_certification.registrar_id IS 'certified registrar id';
COMMENT ON COLUMN registrar_certification.valid_from IS
    'certification is valid from this date';
COMMENT ON COLUMN registrar_certification.valid_until IS
    'certification is valid until this date';
COMMENT ON COLUMN registrar_certification.classification IS
    'registrar certification result checked 0-5';
COMMENT ON COLUMN registrar_certification.eval_file_id IS
    'evaluation pdf file link';


---
--- update registrar_certification - valid_until is optional value
---
ALTER TABLE registrar_certification
    ALTER COLUMN valid_until DROP NOT NULL;

