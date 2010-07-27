INSERT INTO service (id, partition_postfix, name) VALUES (6, 'mojeid_', 'MojeID');

-- Intranet functions
INSERT INTO request_type (id, status, service) VALUES (1500, 'OpenIDRequest', 6);
INSERT INTO request_type (id, status, service) VALUES (1501, 'Login', 6);
INSERT INTO request_type (id, status, service) VALUES (1502, 'Logout', 6);
INSERT INTO request_type (id, status, service) VALUES (1503, 'UserCreate', 6);
INSERT INTO request_type (id, status, service) VALUES (1504, 'UserUpdate', 6);



SELECT setval('request_type_id_seq', (SELECT MAX(id) FROM request_type));