INSERT INTO service (id, partition_postfix, name) VALUES
(2, 'pubreq_', 'Public Request');

INSERT INTO request_type (service_id, id, name) VALUES
(2, 1600, 'AuthInfo'),
(2, 1601, 'BlockTransfer'),
(2, 1602, 'BlockChanges'),
(2, 1603, 'UnblockTransfer'),
(2, 1604, 'UnblockChanges'),
(2, 1605, 'Verification'),
(2, 1606, 'ConditionalIdentification'),
(2, 1607, 'Identification');
