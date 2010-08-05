---
--- don't forget to update database schema version
---

UPDATE enum_parameters SET val = '<insert version here>' WHERE id = 1;


---
--- #4340
--- 
---

-- mod-whoisd result codes
INSERT INTO result_code (service_id, result_code, name) VALUES (0, 101 , 'NoEntriesFound');
INSERT INTO result_code (service_id, result_code, name) VALUES (0, 107 , 'UsageError');
INSERT INTO result_code (service_id, result_code, name) VALUES (0, 108 , 'InvalidRequest');
INSERT INTO result_code (service_id, result_code, name) VALUES (0, 501 , 'InternalServerError');
INSERT INTO result_code (service_id, result_code, name) VALUES (0, 0 , 'Ok');

