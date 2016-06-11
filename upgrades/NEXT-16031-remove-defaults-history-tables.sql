---
--- #16031
---
ALTER TABLE contact_history ALTER COLUMN disclosename DROP DEFAULT;
ALTER TABLE contact_history ALTER COLUMN discloseorganization DROP DEFAULT;
ALTER TABLE contact_history ALTER COLUMN discloseaddress DROP DEFAULT;
ALTER TABLE contact_history ALTER COLUMN disclosetelephone DROP DEFAULT;
ALTER TABLE contact_history ALTER COLUMN disclosefax DROP DEFAULT;
ALTER TABLE contact_history ALTER COLUMN discloseemail DROP DEFAULT;
ALTER TABLE contact_history ALTER COLUMN disclosevat DROP DEFAULT;
ALTER TABLE contact_history ALTER COLUMN discloseident DROP DEFAULT;
ALTER TABLE contact_history ALTER COLUMN disclosenotifyemail DROP DEFAULT;
ALTER TABLE contact_history ALTER COLUMN warning_letter DROP DEFAULT;
ALTER TABLE domain_contact_map_history ALTER COLUMN role DROP DEFAULT;
ALTER TABLE nsset_history ALTER COLUMN checklevel DROP DEFAULT;
ALTER TABLE enumval_history ALTER COLUMN publish DROP DEFAULT;
