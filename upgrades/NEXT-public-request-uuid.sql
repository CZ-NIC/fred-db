ALTER TABLE public_request ADD COLUMN uuid UUID NOT NULL UNIQUE DEFAULT gen_random_uuid();

COMMENT ON COLUMN public_request.uuid IS 'uuid for external reference';
