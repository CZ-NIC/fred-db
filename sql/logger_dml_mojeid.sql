INSERT INTO service (id, partition_postfix, name) VALUES 
(6, 'mojeid_', 'MojeID');

-- Important! If you add an item here, do not forget to add a translation in 
--      enum/nicms/base/trunk/apps/nicommon/logger/history_reader.py: request_type_codes

INSERT INTO request_type (service_id, id, name) VALUES 
(6, 1500, 'OpenIDRequest'),
(6, 1501, 'Login'),
(6, 1502, 'Logout'),
(6, 1503, 'UserCreate'),
(6, 1504, 'UserChange'),
(6, 1505, 'PasswordChange'),
(6, 1506, 'CertificateChange'),
(6, 1507, 'PasswordResetRequest'),
(6, 1508, 'PasswordReset'),
(6, 1509, 'TrustChange');

INSERT INTO result_code (service_id, result_code, name) VALUES 
(6, 1 , 'Success'),
(6, 2 , 'Fail'),
(6, 3 , 'Error');

