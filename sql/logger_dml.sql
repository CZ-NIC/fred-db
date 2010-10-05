-- Set sequences beginnings
SELECT setval('request_type_id_seq', (SELECT MAX(id) FROM request_type));

-- fill object types for logger request_object_ref table
INSERT INTO request_object_type (id, name) VALUES (1, 'contact');
INSERT INTO request_object_type (id, name) VALUES (2, 'nsset');
INSERT INTO request_object_type (id, name) VALUES (3, 'domain');
INSERT INTO request_object_type (id, name) VALUES (4, 'keyset');
INSERT INTO request_object_type (id, name) VALUES (5, 'registrar');
INSERT INTO request_object_type (id, name) VALUES (6, 'mail');
INSERT INTO request_object_type (id, name) VALUES (7, 'file');
INSERT INTO request_object_type (id, name) VALUES (8, 'publicrequest');
INSERT INTO request_object_type (id, name) VALUES (9, 'invoice');
INSERT INTO request_object_type (id, name) VALUES (10, 'bankstatement');
INSERT INTO request_object_type (id, name) VALUES (11, 'request');
INSERT INTO request_object_type (id, name) VALUES (11, 'message');

--
-- have to be done manually (logger will be in separate database)
--
-- SELECT setval('request_id_seq', (SELECT max(id) FROM action));
