---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.34.1' WHERE id = 1;

ALTER FUNCTION get_object_type_id(text) SET search_path = 'public';
