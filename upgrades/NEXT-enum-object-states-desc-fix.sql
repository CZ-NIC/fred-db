---
--- Ticket #19686 - fix serverBlocked flag description
---
UPDATE enum_object_states_desc
SET description='Administrativně blokováno'
WHERE state_id=(SELECT id FROM enum_object_states WHERE name='serverBlocked') AND
      lang='CS';

UPDATE enum_object_states_desc
SET description='Administratively blocked'
WHERE state_id=(SELECT id FROM enum_object_states WHERE name='serverBlocked') AND
      lang='EN';