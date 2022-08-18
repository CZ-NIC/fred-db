---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.51.1' WHERE id = 1;

ALTER TABLE files ADD COLUMN IF NOT EXISTS uuid UUID NOT NULL UNIQUE DEFAULT gen_random_uuid();
CREATE UNIQUE INDEX IF NOT EXISTS files_uuid_idx ON files (uuid);

COMMENT ON COLUMN files.uuid IS 'uuid for external reference';
