INSERT INTO service (id, partition_postfix, name) VALUES 
(6, 'mojeid_', 'MojeID');

-- Important! If you add an item here, do not forget to add a translation in 
--      enum/nicms/base/trunk/apps/nicommon/logger/history_reader.py: request_type_codes

INSERT INTO request_type (service_id, id, name) VALUES 
(6, 1500, 'OpenIDRequest'),
(6, 1501, 'Login'),
(6, 1502, 'Logout'),
(6, 1504, 'UserChange'),
(6, 1507, 'PasswordResetRequest'),
(6, 1509, 'TrustChange'),
(6, 1511, 'AccountStateChange'),
(6, 1512, 'AuthChange');

INSERT INTO result_code (service_id, result_code, name) VALUES 
(6, 1 , 'Success'),
(6, 2 , 'Fail'),
(6, 3 , 'Error');

