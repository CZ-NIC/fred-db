---
--- message types
---
INSERT INTO message_type (id, type) VALUES ( 2, 'mojeid_pin2');
INSERT INTO message_type (id, type) VALUES ( 3, 'mojeid_pin3');
INSERT INTO message_type (id, type) VALUES ( 4, 'mojeid_sms_change');
INSERT INTO message_type (id, type) VALUES ( 8, 'mojeid_pin3_reminder');
INSERT INTO message_type (id, type) VALUES (11, 'mojeid_card');

---
--- file types
---
INSERT INTO enum_filetype (id, name) VALUES ( 7, 'mojeid contact identification request');
INSERT INTO enum_filetype (id, name) VALUES (10, 'mojeid card');

---
--- contact states
---
INSERT INTO enum_object_states VALUES (21,'conditionallyIdentifiedContact','{1}','t','t', 32);
INSERT INTO enum_object_states VALUES (22,'identifiedContact','{1}','t','t', 16);
INSERT INTO enum_object_states VALUES (23,'validatedContact','{1}','t','t', 64);
INSERT INTO enum_object_states VALUES (24,'mojeidContact','{1}','t','t', 4);

INSERT INTO enum_object_states_desc VALUES (21, 'CS', 'Kontakt je částečně identifikován');
INSERT INTO enum_object_states_desc VALUES (21, 'EN', 'Contact is conditionally identified');
INSERT INTO enum_object_states_desc VALUES (22, 'CS', 'Kontakt je identifikován');
INSERT INTO enum_object_states_desc VALUES (22, 'EN', 'Contact is identified');
INSERT INTO enum_object_states_desc VALUES (23, 'CS', 'Kontakt je validován');
INSERT INTO enum_object_states_desc VALUES (23, 'EN', 'Contact is validated');
INSERT INTO enum_object_states_desc VALUES (24, 'CS', 'MojeID kontakt');
INSERT INTO enum_object_states_desc VALUES (24, 'EN', 'MojeID contact');
