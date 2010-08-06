---
--- don't forget to update database schema version
---

UPDATE enum_parameters SET val = '<insert version here>' WHERE id = 1;


---
--- #4354
--- 
---

-- whois result codes
INSERT INTO result_code (service_id, result_code, name) VALUES (1, 0 , 'Ok');

