ALTER TABLE registrar ADD COLUMN uuid UUID NOT NULL UNIQUE DEFAULT gen_random_uuid();

COMMENT ON COLUMN registrar.uuid IS 'uuid for external reference';
