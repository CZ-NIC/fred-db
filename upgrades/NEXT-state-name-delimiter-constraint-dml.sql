---
--- Ticket #11770 - object state name delimiter constraint
---

ALTER TABLE enum_object_states ADD CONSTRAINT name_delimiter_check CHECK (name not like '%,%');

