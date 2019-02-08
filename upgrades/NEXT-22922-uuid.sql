---
--- Ticket #22922 - Add uuid to object_registry and history
---
CREATE EXTENSION pgcrypto;
ALTER TABLE object_registry ADD COLUMN uuid UUID NOT NULL UNIQUE DEFAULT gen_random_uuid();
ALTER TABLE history ADD COLUMN uuid UUID NOT NULL UNIQUE DEFAULT gen_random_uuid();
