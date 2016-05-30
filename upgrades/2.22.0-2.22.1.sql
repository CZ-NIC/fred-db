---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.22.1' WHERE id = 1;


---
--- #15839
---
ALTER TABLE bank_payment ALTER COLUMN bank_code TYPE varchar(35);
