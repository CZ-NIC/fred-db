ALTER TABLE registrar ADD COLUMN uuid UUID NOT NULL UNIQUE DEFAULT gen_random_uuid();

COMMENT ON COLUMN registrar.uuid IS 'uuid for external reference';

ALTER TABLE invoice ADD COLUMN file_uuid UUID;
ALTER TABLE invoice ADD COLUMN file_xml_uuid UUID;

COMMENT ON COLUMN invoice.file_uuid IS 'uuid of exported file for external reference, it can be NULL if the file is not yet generated';
COMMENT ON COLUMN invoice.file_xml_uuid IS 'uuid of exported XML file for external reference, it can be NULL if the file is not yet generated';

UPDATE invoice i SET file_uuid = (SELECT uuid FROM files f WHERE f.id = i.file);
UPDATE invoice i SET file_xml_uuid = (SELECT uuid FROM files f WHERE f.id = i.filexml);
