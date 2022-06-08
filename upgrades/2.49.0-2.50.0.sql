---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.50.0' WHERE id = 1;

ALTER TABLE public_request ADD COLUMN uuid UUID NOT NULL UNIQUE DEFAULT gen_random_uuid();

COMMENT ON COLUMN public_request.uuid IS 'uuid for external reference';
