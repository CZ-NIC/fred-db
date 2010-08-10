INSERT INTO service (id, partition_postfix, name) VALUES (6, 'mojeid_', 'MojeID');

-- Intranet functions

-- Important! If you add an item here, do not forget to add a translation in 
--      enum/nicms/base/trunk/apps/nicommon/logger/history_reader.py: request_type_codes

INSERT INTO request_type (id, name, service_id) VALUES (1500, 'OpenIDRequest', 6);
INSERT INTO request_type (id, name, service_id) VALUES (1501, 'Login', 6);
INSERT INTO request_type (id, name, service_id) VALUES (1502, 'Logout', 6);
INSERT INTO request_type (id, name, service_id) VALUES (1503, 'UserCreate', 6);
INSERT INTO request_type (id, name, service_id) VALUES (1504, 'UserUpdate', 6);
INSERT INTO request_type (id, name, service_id) VALUES (1505, 'PasswordChange', 6);
INSERT INTO request_type (id, name, service_id) VALUES (1506, 'CertificateChange', 6);
INSERT INTO request_type (id, name, service_id) VALUES (1507, 'PasswordResetRequest', 6);
INSERT INTO request_type (id, name, service_id) VALUES (1508, 'PasswordReset', 6);
INSERT INTO request_type (id, name, service_id) VALUES (1509, 'TrustUpdate', 6);


SELECT setval('request_type_id_seq', (SELECT MAX(id) FROM request_type));

INSERT INTO result_code (service_id, result_code, name) VALUES (6, 1 , 'Success');
INSERT INTO result_code (service_id, result_code, name) VALUES (6, 2 , 'Fail');
INSERT INTO result_code (service_id, result_code, name) VALUES (6, 3 , 'Error');
