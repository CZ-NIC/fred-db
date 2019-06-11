---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.37.1' WHERE id = 1;


ALTER FUNCTION unaccent_streets(text, text, text) SET search_path = 'public';
