-- list of Services which are logged into the database
-- this has to be synchronised with the enum RequestServiceType in _dataTypes.idl
INSERT INTO service (id, partition_postfix, name) VALUES (0, 'whois_', 'Unix whois');
INSERT INTO service (id, partition_postfix, name) VALUES (1, 'webwhois_', 'Web whois');
INSERT INTO service (id, partition_postfix, name) VALUES (2, 'pubreq_', 'Public Request');
INSERT INTO service (id, partition_postfix, name) VALUES (3, 'epp_', 'EPP');
INSERT INTO service (id, partition_postfix, name) VALUES (4, 'webadmin_', 'WebAdmin');
INSERT INTO service (id, partition_postfix, name) VALUES (5, 'intranet_', 'Intranet');

-- login function
INSERT INTO request_type (id, name, service_id) VALUES (100, 'ClientLogin', 3);
INSERT INTO request_type (id, name, service_id) VALUES (101, 'ClientLogout', 3);
INSERT INTO request_type (id, name, service_id) VALUES (105, 'ClientGreeting', 3);

-- poll function
INSERT INTO request_type (id, name, service_id) VALUES (120, 'PollAcknowledgement', 3);
INSERT INTO request_type (id, name, service_id) VALUES (121,  'PollResponse', 3);

-- contacts functions
INSERT INTO request_type (id, name, service_id) VALUES (200, 'ContactCheck', 3);
INSERT INTO request_type (id, name, service_id) VALUES (201, 'ContactInfo', 3);
INSERT INTO request_type (id, name, service_id) VALUES (202, 'ContactDelete', 3);
INSERT INTO request_type (id, name, service_id) VALUES (203, 'ContactUpdate', 3);
INSERT INTO request_type (id, name, service_id) VALUES (204, 'ContactCreate', 3);
INSERT INTO request_type (id, name, service_id) VALUES (205, 'ContactTransfer', 3);
 
-- nsset function
INSERT INTO request_type (id, name, service_id) VALUES (400, 'NSsetCheck', 3);
INSERT INTO request_type (id, name, service_id) VALUES (401, 'NSsetInfo', 3);
INSERT INTO request_type (id, name, service_id) VALUES (402, 'NSsetDelete', 3);
INSERT INTO request_type (id, name, service_id) VALUES (403, 'NSsetUpdate', 3);
INSERT INTO request_type (id, name, service_id) VALUES (404, 'NSsetCreate', 3);
INSERT INTO request_type (id, name, service_id) VALUES (405, 'NSsetTransfer', 3);

-- domains function
INSERT INTO request_type (id, name, service_id) VALUES (500, 'DomainCheck', 3);
INSERT INTO request_type (id, name, service_id) VALUES (501, 'DomainInfo', 3);
INSERT INTO request_type (id, name, service_id) VALUES (502, 'DomainDelete', 3);
INSERT INTO request_type (id, name, service_id) VALUES (503, 'DomainUpdate', 3);
INSERT INTO request_type (id, name, service_id) VALUES (504, 'DomainCreate', 3);
INSERT INTO request_type (id, name, service_id) VALUES (505, 'DomainTransfer', 3);
INSERT INTO request_type (id, name, service_id) VALUES (506, 'DomainRenew', 3);
INSERT INTO request_type (id, name, service_id) VALUES (507, 'DomainTrade', 3);

-- function isn't entered
INSERT INTO request_type (id, name, service_id) VALUES (1000, 'UnknownAction', 3);

-- list function
INSERT INTO request_type (id, name, service_id) VALUES (1002,  'ListContact', 3);
INSERT INTO request_type (id, name, service_id) VALUES (1004,  'ListNSset', 3); 
INSERT INTO request_type (id, name, service_id) VALUES (1005,  'ListDomain', 3);

-- credit function
INSERT INTO request_type (id, name, service_id) VALUES (1010, 'ClientCredit', 3);

-- technical check nsset
INSERT INTO request_type (id, name, service_id) VALUES (1012, 'nssetTest', 3);

-- send auth info function
INSERT INTO request_type (id, name, service_id) VALUES (1101, 'ContactSendAuthInfo', 3);
INSERT INTO request_type (id, name, service_id) VALUES (1102, 'NSSetSendAuthInfo', 3);
INSERT INTO request_type (id, name, service_id) VALUES (1103, 'DomainSendAuthInfo', 3);
INSERT INTO request_type (id, name, service_id) VALUES (1106, 'KeySetSendAuthInfo', 3);

-- keyset function
INSERT INTO request_type (id, name, service_id) VALUES (600, 'KeysetCheck', 3);
INSERT INTO request_type (id, name, service_id) VALUES (601, 'KeysetInfo', 3);
INSERT INTO request_type (id, name, service_id) VALUES (602, 'KeysetDelete', 3);
INSERT INTO request_type (id, name, service_id) VALUES (603, 'KeysetUpdate', 3);
INSERT INTO request_type (id, name, service_id) VALUES (604, 'KeysetCreate', 3);
INSERT INTO request_type (id, name, service_id) VALUES (605, 'KeysetTransfer', 3);
INSERT INTO request_type (id, name, service_id) VALUES (1006, 'ListKeySet', 3);

-- whois action (the only one used for whois)
INSERT INTO request_type (id, name, service_id) VALUES (1104, 'Info', 1);

-- the same operation for unix whois
INSERT INTO request_type (id, name, service_id) VALUES (1105, 'Info', 0);

-- up to here it's a copy of enum_action from action.sql
-- with 2 info functions removed (and substituted by following)

-- info functions
INSERT INTO request_type (id, name, service_id) VALUES (1200, 'InfoListContacts', 3);
INSERT INTO request_type (id, name, service_id) VALUES (1201, 'InfoListDomains', 3);
INSERT INTO request_type (id, name, service_id) VALUES (1202, 'InfoListNssets', 3);
INSERT INTO request_type (id, name, service_id) VALUES (1203, 'InfoListKeysets', 3);
INSERT INTO request_type (id, name, service_id) VALUES (1204, 'InfoDomainsByNsset', 3);
INSERT INTO request_type (id, name, service_id) VALUES (1205, 'InfoDomainsByKeyset', 3);
INSERT INTO request_type (id, name, service_id) VALUES (1206, 'InfoDomainsByContact', 3);
INSERT INTO request_type (id, name, service_id) VALUES (1207, 'InfoNssetsByContact', 3);
INSERT INTO request_type (id, name, service_id) VALUES (1208, 'InfoNssetsByNs', 3);
INSERT INTO request_type (id, name, service_id) VALUES (1209, 'InfoKeysetsByContact', 3);
INSERT INTO request_type (id, name, service_id) VALUES (1210, 'InfoGetResults', 3);

-- webadmin functions 
INSERT INTO request_type (id, name, service_id) VALUES (1300, 'Login', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1301, 'Logout', 4); 
INSERT INTO request_type (id, name, service_id) VALUES (1302, 'DomainFilter', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1303, 'ContactFilter', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1304, 'NSSetFilter', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1305, 'KeySetFilter', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1306, 'RegistrarFilter', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1307, 'InvoiceFilter', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1308, 'EmailsFilter', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1309, 'FileFilter', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1310, 'ActionsFilter', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1311, 'PublicRequestFilter', 4); 
INSERT INTO request_type (id, name, service_id) VALUES (1312, 'DomainDetail', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1313, 'ContactDetail', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1314, 'NSSetDetail', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1315, 'KeySetDetail', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1316, 'RegistrarDetail', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1317, 'InvoiceDetail', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1318, 'EmailsDetail', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1319, 'FileDetail', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1320, 'ActionsDetail', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1321, 'PublicRequestDetail', 4); 
INSERT INTO request_type (id, name, service_id) VALUES (1322, 'RegistrarCreate', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1323, 'RegistrarUpdate', 4); 
INSERT INTO request_type (id, name, service_id) VALUES (1324, 'PublicRequestAccept', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1325, 'PublicRequestInvalidate', 4); 
INSERT INTO request_type (id, name, service_id) VALUES (1326, 'DomainDig', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1327, 'FilterCreate', 4); 
INSERT INTO request_type (id, name, service_id) VALUES (1328, 'RequestDetail', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1329, 'RequestFilter', 4); 
INSERT INTO request_type (id, name, service_id) VALUES (1330, 'BankStatementDetail', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1331, 'BankStatementFilter', 4); 
INSERT INTO request_type (id, name, service_id) VALUES (1332, 'PaymentPair', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1333, 'SetInZoneStatus', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1334, 'SaveFilter', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1335, 'LoadFilter', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1336, 'CreateRegistrarGroup', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1337, 'DeleteRegistrarGroup', 4);
INSERT INTO request_type (id, name, service_id) VALUES (1338, 'UpdateRegistrarGroup', 4);

-- Intranet functions
INSERT INTO request_type (id, name, service_id) VALUES (1400, 'Login', 5); 
INSERT INTO request_type (id, name, service_id) VALUES (1401, 'Logout', 5);
INSERT INTO request_type (id, name, service_id) VALUES (1402, 'DisplaySummary', 5);
INSERT INTO request_type (id, name, service_id) VALUES (1403, 'InvoiceList', 5);
INSERT INTO request_type (id, name, service_id) VALUES (1404, 'DomainList', 5);
INSERT INTO request_type (id, name, service_id) VALUES (1405, 'FileDetail', 5);

-- Set sequences beginnings
SELECT setval('request_type_id_seq', 1406); 

--
-- have to be done manually (logger will be in separate database)
-- 
-- SELECT setval('request_id_seq', (SELECT max(id) FROM action));
