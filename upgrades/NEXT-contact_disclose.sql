---
--- don't forget to update database schema version
---

UPDATE enum_parameters SET val = '<insert version here>' WHERE id = 1;


---
--- #4790
--- set contact disclose not null
---

--ddl
ALTER TABLE contact ALTER COLUMN disclosename SET NOT NULL;
ALTER TABLE contact ALTER COLUMN discloseorganization SET NOT NULL;
ALTER TABLE contact ALTER COLUMN discloseaddress SET NOT NULL;

ALTER TABLE contact ALTER COLUMN disclosetelephone SET NOT NULL;
ALTER TABLE contact ALTER COLUMN disclosefax SET NOT NULL;
ALTER TABLE contact ALTER COLUMN discloseemail SET NOT NULL;
ALTER TABLE contact ALTER COLUMN disclosevat SET NOT NULL;
ALTER TABLE contact ALTER COLUMN discloseident SET NOT NULL;
ALTER TABLE contact ALTER COLUMN disclosenotifyemail SET NOT NULL;

ALTER TABLE contact_history ALTER COLUMN disclosename SET NOT NULL;
ALTER TABLE contact_history ALTER COLUMN discloseorganization SET NOT NULL;
ALTER TABLE contact_history ALTER COLUMN discloseaddress SET NOT NULL;

ALTER TABLE contact_history ALTER COLUMN disclosetelephone SET NOT NULL;
ALTER TABLE contact_history ALTER COLUMN disclosefax SET NOT NULL;
ALTER TABLE contact_history ALTER COLUMN discloseemail SET NOT NULL;
ALTER TABLE contact_history ALTER COLUMN disclosevat SET NOT NULL;
ALTER TABLE contact_history ALTER COLUMN discloseident SET NOT NULL;
ALTER TABLE contact_history ALTER COLUMN disclosenotifyemail SET NOT NULL;

--dml
UPDATE contact SET disclosename = TRUE; 
UPDATE contact SET discloseorganization = TRUE;
UPDATE contact SET discloseaddress = TRUE;

UPDATE contact SET disclosetelephone = FALSE WHERE disclosetelephone IS NULL;
UPDATE contact SET disclosetelephone = FALSE WHERE disclosefax IS NULL; 
UPDATE contact SET disclosetelephone = FALSE WHERE discloseemail IS NULL; 
UPDATE contact SET disclosetelephone = FALSE WHERE disclosevat IS NULL; 
UPDATE contact SET disclosetelephone = FALSE WHERE discloseident IS NULL; 
UPDATE contact SET disclosetelephone = FALSE WHERE disclosenotifyemail IS NULL;  

UPDATE contact_history SET disclosename = TRUE; 
UPDATE contact_history SET discloseorganization = TRUE;
UPDATE contact_history SET discloseaddress = TRUE;

UPDATE contact_history SET disclosetelephone = FALSE WHERE disclosetelephone IS NULL;
UPDATE contact_history SET disclosetelephone = FALSE WHERE disclosefax IS NULL; 
UPDATE contact_history SET disclosetelephone = FALSE WHERE discloseemail IS NULL; 
UPDATE contact_history SET disclosetelephone = FALSE WHERE disclosevat IS NULL; 
UPDATE contact_history SET disclosetelephone = FALSE WHERE discloseident IS NULL; 
UPDATE contact_history SET disclosetelephone = FALSE WHERE disclosenotifyemail IS NULL;  

