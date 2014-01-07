---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.15.0' WHERE id = 1;


---
--- administrative domain blocking/unblocking
---
UPDATE enum_object_states SET types='{1,3}' WHERE name='serverBlocked';
