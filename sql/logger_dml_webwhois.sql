INSERT INTO service (id, partition_postfix, name) VALUES 
(1, 'webwhois_', 'Web whois');

INSERT INTO request_type (service_id, id, name) VALUES 
(1, 1104, 'Info');

INSERT INTO result_code (service_id, result_code, name) VALUES 
(1, 0 , 'Ok'),
(1, 1 , 'NotFound'),
(1, 2 , 'Error');

