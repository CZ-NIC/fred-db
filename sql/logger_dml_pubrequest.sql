INSERT INTO service (id, partition_postfix, name) VALUES 
(2, 'pubreq_', 'Public Request');

-- public request result code
INSERT INTO result_code (service_id, result_code, name) VALUES (2, 0 , 'Ok');
INSERT INTO result_code (service_id, result_code, name) VALUES (2, 1 , 'Error');
