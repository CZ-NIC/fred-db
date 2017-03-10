---
--- Ticket #17973 - domain name db constraint
---

ALTER TABLE object_registry ADD CONSTRAINT domain_name_check CHECK (type <> get_object_type_id('domain') OR domain_name_syntax_check(name));

