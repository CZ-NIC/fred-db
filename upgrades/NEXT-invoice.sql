ALTER TABLE registrar ADD COLUMN uuid UUID NOT NULL UNIQUE DEFAULT gen_random_uuid();

COMMENT ON COLUMN registrar.uuid IS 'uuid for external reference';

ALTER TABLE invoice ADD COLUMN file_uuid UUID;
ALTER TABLE invoice ADD COLUMN file_xml_uuid UUID;

COMMENT ON COLUMN invoice.file_uuid IS 'uuid of exported file for external reference, it can be NULL if the file is not yet generated';
COMMENT ON COLUMN invoice.file_xml_uuid IS 'uuid of exported XML file for external reference, it can be NULL if the file is not yet generated';

UPDATE invoice i SET file_uuid = (SELECT f.uuid FROM files f WHERE f.id = i.file);
UPDATE invoice i SET file_xml_uuid = (SELECT f.uuid FROM files f WHERE f.id = i.filexml);

CREATE OR REPLACE FUNCTION invoice_update_file()
RETURNS trigger AS
$$
BEGIN
    IF TG_OP = 'INSERT' THEN
        IF NEW.file IS NOT NULL THEN
            RAISE EXCEPTION 'Inserting file (%) into invoice table. This is deprecated. Insert file_uuid instead.', NEW.file;
        END IF;
        IF NEW.filexml IS NOT NULL THEN
            RAISE EXCEPTION 'Inserting filexml (%) into invoice table. This is deprecated. Insert file_xml_uuid instead.', NEW.filexml;
        END IF;
    ELSIF TG_OP = 'UPDATE' THEN
        IF NEW.file <> OLD.file THEN
            RAISE EXCEPTION 'Updating file (%) in invoice table. This is deprecated. Update file_uuid instead.', NEW.file;
        END IF;
        IF NEW.filexml <> OLD.filexml THEN
            RAISE EXCEPTION 'Updating filexml (%) in invoice table. This is deprecated. Update file_xml_uuid instead.', NEW.filexml;
        END IF;
    END IF;
    IF NEW.file_uuid IS NULL THEN
        NEW.file := NULL;
    ELSE
        SELECT f.id
          FROM files f
         WHERE f.uuid = NEW.file_uuid
          INTO NEW.file;
    END IF;
    IF NEW.file_xml_uuid IS NULL THEN
        NEW.filexml := NULL;
    ELSE
        SELECT f.id
          FROM files f
         WHERE f.uuid = NEW.file_xml_uuid
          INTO NEW.filexml;
    END IF;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tr_invoice_update_file ON invoice;
CREATE TRIGGER tr_invoice_update_file
BEFORE INSERT OR UPDATE ON invoice
FOR EACH ROW EXECUTE PROCEDURE
invoice_update_file();
