ALTER TABLE object_state_request ADD COLUMN uuid UUID NOT NULL UNIQUE DEFAULT gen_random_uuid();
