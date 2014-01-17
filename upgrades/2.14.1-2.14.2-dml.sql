---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.14.2' WHERE id = 1;

UPDATE enum_object_states_desc
    SET description = 'Deletion forbidden'
  WHERE lang = 'EN' AND state_id = 1;

UPDATE enum_object_states_desc
    SET description = 'Registration renewal forbidden'
  WHERE lang = 'EN' AND state_id = 2;

UPDATE enum_object_states_desc
    SET description = 'Sponsoring registrar change forbidden'
  WHERE lang = 'EN' AND state_id = 3;

UPDATE enum_object_states_desc
    SET description = 'Update forbidden'
  WHERE lang = 'EN' AND state_id = 4;

UPDATE enum_object_states_desc
    SET description = 'Registrant change forbidden'
  WHERE lang = 'EN' AND state_id = 18;

