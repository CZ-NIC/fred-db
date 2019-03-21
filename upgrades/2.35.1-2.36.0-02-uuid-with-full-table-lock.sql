---
--- Ticket #22922 - Add uuid to object_registry and history
---
--- This code lock both tables exclusively (postgresql 9.6) so it only suitable for run during maintenance window
--- (can take long time - depends on table size - best to test on staging environment)
---
ALTER TABLE object_registry ADD COLUMN uuid UUID NOT NULL UNIQUE DEFAULT gen_random_uuid();
ALTER TABLE history ADD COLUMN uuid UUID NOT NULL UNIQUE DEFAULT gen_random_uuid();
