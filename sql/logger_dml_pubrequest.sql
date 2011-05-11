INSERT INTO service (id, partition_postfix, name) VALUES 
(2, 'pubreq_', 'Public Request');

-- public request result code
INSERT INTO result_code (service_id, result_code, name) VALUES 
(2, 0 , 'Ok'),
(2, 1 , 'Error');

INSERT INTO request_type (service_id, id, name) VALUES 
(2, 1600, 'AuthInfo'),
(2, 1601, 'BlockTransfer'),
(2, 1602, 'BlockChanges'),
(2, 1603, 'UnblockTransfer'),
(2, 1604, 'UnblockChanges');

