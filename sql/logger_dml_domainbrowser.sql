INSERT INTO service (id, partition_postfix, name) VALUES 
(7, 'd_browser_', 'Domainbrowser');

INSERT INTO request_type (service_id, id, name) VALUES 
(7, 1700, 'Login'),
(7, 1701, 'Logout'),
(7, 1702, 'BlockingChange'),
(7, 1703, 'DiscloseChange'),
(7, 1704, 'Browse'),
(7, 1705, 'Detail'),
(7, 1706, 'AuthInfoChange'),
(7, 1707, 'MergeContacts')
;

INSERT INTO result_code (service_id, result_code, name) VALUES 
(7, 1 , 'Success'),
(7, 2 , 'Fail'),
(7, 3 , 'Error'),
(7, 4 , 'NotValidated'),
(7, 5 , 'Warning')
;
