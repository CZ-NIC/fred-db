---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.37.0' WHERE id = 1;

---
--- Ticket #23634 - Add unique constraint to varsymb
---
UPDATE registrar SET varsymb = NULL WHERE varsymb = '';

ALTER TABLE registrar ADD CONSTRAINT registrar_varsymb_key UNIQUE(varsymb);
