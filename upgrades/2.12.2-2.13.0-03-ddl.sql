---
--- Ticket #7652
---
ALTER TABLE object_registry ADD CONSTRAINT object_registry_type_fkey FOREIGN KEY (type)
      REFERENCES enum_object_type (id);

