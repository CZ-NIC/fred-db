---
--- Ticket #23634 - Add unique constraint to varsymb
---

UPDATE registrar SET varsymb=NULL WHERE varsymb='';

ALTER TABLE registrar ADD CONSTRAINT registrar_varsymb_key UNIQUE(varsymb);
