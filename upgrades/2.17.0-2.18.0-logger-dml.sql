---
--- #10968 - domain browser merge contacts request type
---
INSERT INTO request_type (service_id, id, name) VALUES (7, 1707, 'MergeContacts');


---
--- #10627 - rdap logging
---
INSERT INTO service (id, partition_postfix, name) VALUES(9, 'rdap_', 'RDAP');

INSERT INTO request_type (id, name, service_id) VALUES(3001, 'EntityLookup', 9);
INSERT INTO request_type (id, name, service_id) VALUES(3002, 'DomainLookup', 9);
INSERT INTO request_type (id, name, service_id) VALUES(3003, 'NameserverLookup', 9);
INSERT INTO request_type (id, name, service_id) VALUES(3101, 'NSSetLookup', 9);
INSERT INTO request_type (id, name, service_id) VALUES(3102, 'KeySetLookup', 9);

INSERT INTO result_code (service_id, result_code, name) VALUES(9, 200, 'Ok');
INSERT INTO result_code (service_id, result_code, name) VALUES(9, 404, 'NotFound');
INSERT INTO result_code (service_id, result_code, name) VALUES(9, 500, 'internalServerError');

