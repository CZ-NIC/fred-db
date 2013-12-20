---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.14.4' WHERE id = 1;


INSERT INTO enum_object_states VALUES (25,'manuallyVerifiedContact','{1}','t','t', NULL);
INSERT INTO enum_object_states_desc VALUES (25, 'CS', 'Kontakt byl ověřen zákaznickou podporou CZ.NIC');
INSERT INTO enum_object_states_desc VALUES (25, 'EN', 'Contact has been verified by CZ.NIC customer support');

