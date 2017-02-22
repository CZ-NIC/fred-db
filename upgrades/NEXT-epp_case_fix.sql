---
--- Ticket #18356 - epp case fix
---

ALTER TABLE object_registry ADD CONSTRAINT name_case_check
  CHECK ((type <> get_object_type_id('domain') AND name = UPPER(name))
     OR (type = get_object_type_id('domain') AND name = LOWER(name)));

