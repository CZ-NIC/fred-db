---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.18.1' WHERE id = 1;


INSERT INTO enum_contact_test (id, handle)
    VALUES ('8', 'email_existence_in_managed_zones');
INSERT INTO enum_contact_test_localization (id, lang, name, description)
    VALUES ('8', 'en', 'email_existence_in_managed_zones', 'Testing if e-mail hosts from managed zones are valid.');
INSERT INTO contact_testsuite_map (enum_contact_test_id, enum_contact_testsuite_id)
    VALUES ('8', '1');
