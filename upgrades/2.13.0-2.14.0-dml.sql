---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.14.0' WHERE id = 1;

---
--- Set values for mail type priorities
---
INSERT INTO mail_type_priority VALUES
  ((SELECT id FROM mail_type WHERE name = 'mojeid_identification'), 1),
  ((SELECT id FROM mail_type WHERE name = 'mojeid_validation'), 1),
  ((SELECT id FROM mail_type WHERE name = 'mojeid_email_change'), 1),
  ((SELECT id FROM mail_type WHERE name = 'mojeid_verified_contact_transfer'), 1),
  ((SELECT id FROM mail_type WHERE name = 'conditional_contact_identification'), 2),
  ((SELECT id FROM mail_type WHERE name = 'contact_identification'), 2),
  ((SELECT id FROM mail_type WHERE name = 'sendauthinfo_epp'), 2),
  ((SELECT id FROM mail_type WHERE name = 'sendauthinfo_pif'), 2),
  ((SELECT id FROM mail_type WHERE name = 'notification_create'), 3),
  ((SELECT id FROM mail_type WHERE name = 'notification_update'), 3),
  ((SELECT id FROM mail_type WHERE name = 'notification_transfer'), 3),
  ((SELECT id FROM mail_type WHERE name = 'notification_renew'), 3),
  ((SELECT id FROM mail_type WHERE name = 'notification_unused'), 3),
  ((SELECT id FROM mail_type WHERE name = 'notification_delete'), 3),
  ((SELECT id FROM mail_type WHERE name = 'request_block'), 3);

---
--- Set values for new importance column
---
UPDATE enum_object_states SET importance =  1*2 WHERE name = 'expired';
UPDATE enum_object_states SET importance =  2*2 WHERE name = 'mojeidContact';
UPDATE enum_object_states SET importance =  3*2 WHERE name = 'outzone';
UPDATE enum_object_states SET importance =  4*2 WHERE name = 'identifiedContact';
UPDATE enum_object_states SET importance =  5*2 WHERE name = 'conditionallyIdentifiedContact';
UPDATE enum_object_states SET importance =  6*2 WHERE name = 'validatedContact';
UPDATE enum_object_states SET importance =  7*2 WHERE name = 'serverOutzoneManual';
UPDATE enum_object_states SET importance =  8*2 WHERE name = 'serverInzoneManual';
UPDATE enum_object_states SET importance =  9*2 WHERE name = 'notValidated';
UPDATE enum_object_states SET importance = 10*2 WHERE name = 'linked';
UPDATE enum_object_states SET importance = 11*2 WHERE name = 'serverUpdateProhibited';
UPDATE enum_object_states SET importance = 12*2 WHERE name = 'serverTransferProhibited';
UPDATE enum_object_states SET importance = 13*2 WHERE name = 'serverRegistrantChangeProhibited';
UPDATE enum_object_states SET importance = 14*2 WHERE name = 'serverRenewProhibited';
UPDATE enum_object_states SET importance = 15*2 WHERE name = 'serverDeleteProhibited';
UPDATE enum_object_states SET importance = 16*2 WHERE name = 'serverBlocked';

---
--- Ticket #8289 - correct error typing
---
UPDATE enum_object_states_desc SET description = 'Kontakt je částečně identifikován' WHERE lang = 'CS' AND state_id = 21; -- conditionallyIdentifiedContact
UPDATE enum_object_states_desc SET description = 'Je navázán na další záznam v registru' WHERE lang = 'CS' AND state_id = 16; -- linked
UPDATE enum_object_states_desc SET description = 'Není povolena změna údajů' WHERE lang = 'CS' AND state_id = 4; -- serverUpdateProhibited

---
--- Fix error typing:
---
UPDATE enum_object_states_desc SET description = 'Deletion unauthorised' WHERE lang = 'EN' AND state_id = 01;
UPDATE enum_object_states_desc SET description = 'Registration renewal unauthorised' WHERE lang = 'EN' AND state_id = 02;
UPDATE enum_object_states_desc SET description = 'Sponsoring registrar change unauthorised' WHERE lang = 'EN' AND state_id = 03;
UPDATE enum_object_states_desc SET description = 'Update unauthorised' WHERE lang = 'EN' AND state_id = 04;
UPDATE enum_object_states_desc SET description = 'The domain is administratively kept out of zone' WHERE lang = 'EN' AND state_id = 05;
UPDATE enum_object_states_desc SET description = 'The domain is administratively kept in zone' WHERE lang = 'EN' AND state_id = 06;
UPDATE enum_object_states_desc SET description = 'The domain expires in 30 days' WHERE lang = 'EN' AND state_id = 08;
UPDATE enum_object_states_desc SET description = 'The domain is 30 days after expiration' WHERE lang = 'EN' AND state_id = 10;
UPDATE enum_object_states_desc SET description = 'The domain validation expires in 30 days' WHERE lang = 'EN' AND state_id = 11;
UPDATE enum_object_states_desc SET description = 'The domain validation expires in 15 days' WHERE lang = 'EN' AND state_id = 12;
UPDATE enum_object_states_desc SET description = 'The domain doesn''t have associated nsset' WHERE lang = 'EN' AND state_id = 14;
UPDATE enum_object_states_desc SET description = 'The domain isn''t generated in the zone' WHERE lang = 'EN' AND state_id = 15;
UPDATE enum_object_states_desc SET description = 'Has relation to other records in the registry' WHERE lang = 'EN' AND state_id = 16;
UPDATE enum_object_states_desc SET description = 'Registrant change unauthorised' WHERE lang = 'EN' AND state_id = 18;
UPDATE enum_object_states_desc SET description = 'The domain will be deleted in 11 days' WHERE lang = 'EN' AND state_id = 19;
UPDATE enum_object_states_desc SET description = 'The domain is out of zone after 30 days in expiration state' WHERE lang = 'EN' AND state_id = 20;

