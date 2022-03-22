---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.47.0' WHERE id = 1;

ALTER TABLE registrar ADD COLUMN is_internal BOOL NOT NULL DEFAULT FALSE;
