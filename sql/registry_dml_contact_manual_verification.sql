INSERT INTO enum_object_states VALUES (26,'contactInManualVerification','{1}','t','t', NULL);
INSERT INTO enum_object_states VALUES (25,'contactPassedManualVerification','{1}','t','t', NULL);
INSERT INTO enum_object_states VALUES (27,'contactFailedManualVerification','{1}','t','t', NULL);

INSERT INTO enum_object_states_desc VALUES (26, 'CS', 'Kontakt je ověřován zákaznickou podporou CZ.NIC');
INSERT INTO enum_object_states_desc VALUES (25, 'CS', 'Kontakt byl ověřen zákaznickou podporou CZ.NIC');
INSERT INTO enum_object_states_desc VALUES (27, 'CS', 'Ověření kontaktu zákaznickou podporou bylo neúspěšné');

INSERT INTO enum_object_states_desc VALUES (26, 'EN', 'Contact is being verified by CZ.NIC customer support');
INSERT INTO enum_object_states_desc VALUES (25, 'EN', 'Contact has been verified by CZ.NIC customer support');
INSERT INTO enum_object_states_desc VALUES (27, 'EN', 'Contact has failed the verification by CZ.NIC customer support');
