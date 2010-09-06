INSERT INTO service (id, partition_postfix, name) VALUES 
(5, 'intranet_', 'Intranet');

INSERT INTO request_type (service_id, id, name) VALUES 
(5, 1400, 'Login'),
(5, 1401, 'Logout'),
(5, 1402, 'DisplaySummary'),
(5, 1403, 'InvoiceList'),
(5, 1404, 'DomainList'),
(5, 1405, 'FileDetail');

