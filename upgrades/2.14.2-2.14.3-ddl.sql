---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.14.3' WHERE id = 1;



---
--- unused tables removal
---
DROP TABLE genzone_domain_history;
DROP TABLE genzone_domain_status;
ALTER TABLE domain_blacklist DROP COLUMN creator;
DROP TABLE "user";
DROP TABLE dnssec;

