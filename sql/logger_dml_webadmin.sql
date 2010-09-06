INSERT INTO service (id, partition_postfix, name) VALUES 
(4, 'webadmin_', 'WebAdmin');

INSERT INTO request_type (service_id, id, name) VALUES 
(4, 1300, 'Login'),
(4, 1301, 'Logout'), 
(4, 1302, 'DomainFilter'),
(4, 1303, 'ContactFilter'),
(4, 1304, 'NSSetFilter'),
(4, 1305, 'KeySetFilter'),
(4, 1306, 'RegistrarFilter'),
(4, 1307, 'InvoiceFilter'),
(4, 1308, 'EmailsFilter'),
(4, 1309, 'FileFilter'),
(4, 1310, 'ActionsFilter'),
(4, 1311, 'PublicRequestFilter'), 
(4, 1312, 'DomainDetail'),
(4, 1313, 'ContactDetail'),
(4, 1314, 'NSSetDetail'),
(4, 1315, 'KeySetDetail'),
(4, 1316, 'RegistrarDetail'),
(4, 1317, 'InvoiceDetail'),
(4, 1318, 'EmailsDetail'),
(4, 1319, 'FileDetail'),
(4, 1320, 'ActionsDetail'),
(4, 1321, 'PublicRequestDetail'), 
(4, 1322, 'RegistrarCreate'),
(4, 1323, 'RegistrarUpdate'), 
(4, 1324, 'PublicRequestAccept'),
(4, 1325, 'PublicRequestInvalidate'), 
(4, 1326, 'DomainDig'),
(4, 1327, 'FilterCreate'), 
(4, 1328, 'RequestDetail'),
(4, 1329, 'RequestFilter'), 
(4, 1330, 'BankStatementDetail'),
(4, 1331, 'BankStatementFilter'), 
(4, 1332, 'PaymentPair'),
(4, 1333, 'SetInZoneStatus'),
(4, 1334, 'SaveFilter'),
(4, 1335, 'LoadFilter'),
(4, 1336, 'CreateRegistrarGroup'),
(4, 1337, 'DeleteRegistrarGroup'),
(4, 1338, 'UpdateRegistrarGroup');

INSERT INTO result_code (service_id, result_code, name) VALUES 
(4, 1 , 'Success'),
(4, 2 , 'Fail'),
(4, 3 , 'Error');

