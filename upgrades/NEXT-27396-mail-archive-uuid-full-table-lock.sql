---
--- Ticket #27424 - Add uuid to mail_archive
---
--- This code lock both tables exclusively (postgresql 9.6) so it only suitable for run during maintenance window
--- (can take long time - depends on table size - best to test on staging environment)
---
ALTER TABLE mail_archive ADD COLUMN uuid UUID NOT NULL UNIQUE DEFAULT gen_random_uuid();
