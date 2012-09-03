
-- fix some minor differences between upgraded and newly installed version

ALTER TABLE invoice_prefix ALTER COLUMN typ DROP DEFAULT;

ALTER TABLE public_request ALTER COLUMN status DROP DEFAULT;



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


-- schema changes omited from previous upgrades 

ALTER TABLE bank_payment DROP COLUMN invoice_id;

ALTER TABLE notify_letters DROP COLUMN file_id;

ALTER TABLE public_request DROP COLUMN epp_action_id;

DROP TABLE action_elements CASCADE;
DROP TABLE action_xml CASCADE;
DROP TABLE action CASCADE;
DROP TABLE enum_action CASCADE;
DROP TABLE login CASCADE;




