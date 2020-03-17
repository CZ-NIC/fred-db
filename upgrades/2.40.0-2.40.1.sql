---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.40.1' WHERE id = 1;


DROP INDEX CONCURRENTLY IF EXISTS object_registry_name_trgm_idx;

DROP INDEX CONCURRENTLY IF EXISTS contact_name_trgm_idx;
DROP INDEX CONCURRENTLY IF EXISTS contact_organization_trgm_idx;
DROP INDEX CONCURRENTLY IF EXISTS contact_streets_trgm_idx;
DROP INDEX CONCURRENTLY IF EXISTS contact_city_trgm_idx;
DROP INDEX CONCURRENTLY IF EXISTS contact_stateorprovince_trgm_idx;
DROP INDEX CONCURRENTLY IF EXISTS contact_postalcode_trgm_idx;
DROP INDEX CONCURRENTLY IF EXISTS contact_telephone_trgm_idx;
DROP INDEX CONCURRENTLY IF EXISTS contact_fax_trgm_idx;
DROP INDEX CONCURRENTLY IF EXISTS contact_email_trgm_idx;
DROP INDEX CONCURRENTLY IF EXISTS contact_notifyemail_trgm_idx;
DROP INDEX CONCURRENTLY IF EXISTS contact_vat_trgm_idx;
DROP INDEX CONCURRENTLY IF EXISTS contact_ssn_trgm_idx;

DROP INDEX CONCURRENTLY IF EXISTS contact_address_company_name_trgm_idx;
DROP INDEX CONCURRENTLY IF EXISTS contact_address_streets_trgm_idx;
DROP INDEX CONCURRENTLY IF EXISTS contact_address_city_trgm_idx;
DROP INDEX CONCURRENTLY IF EXISTS contact_address_stateorprovince_trgm_idx;
DROP INDEX CONCURRENTLY IF EXISTS contact_address_postalcode_trgm_idx;
