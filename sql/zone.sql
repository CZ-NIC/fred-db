-- DROP TABLE zone CASCADE;
CREATE TABLE zone (
        id SERIAL CONSTRAINT zone_pkey PRIMARY KEY,
        fqdn VARCHAR(255) CONSTRAINT zone_fqdn_key UNIQUE NOT NULL,  --zone fully qualified name
        ex_period_min int NOT NULL,  --minimal prolongation of the period of domains validity in months
        ex_period_max int NOT NULL,  --maximal prolongation of the period of domains validity in months
        val_period int NOT NULL,  --enum domains revalidation period in months
        dots_max  int NOT NULL DEFAULT 1,  --maximal number of dots in zone name
        enum_zone BOOLEAN DEFAULT 'f',  --flag if zone is for enum
        warning_letter BOOLEAN NOT NULL DEFAULT TRUE
        );

COMMENT ON TABLE zone IS
'This table contains zone parameters';
COMMENT ON COLUMN zone.id IS 'unique automatically generated identifier';
COMMENT ON COLUMN zone.fqdn IS 'zone fully qualified name';
COMMENT ON COLUMN zone.ex_period_min IS 'minimal prolongation of the period of domains validity in months';
COMMENT ON COLUMN zone.ex_period_max IS 'maximal prolongation of the period of domains validity in months';
COMMENT ON COLUMN zone.val_period IS 'enum domains revalidation period in months';
COMMENT ON COLUMN zone.dots_max IS 'maximal number of dots in zone name';
COMMENT ON COLUMN zone.enum_zone IS 'flag if zone is for enum';


---
--- #9085 domain name validation configuration by zone
---

CREATE TABLE enum_domain_name_validation_checker (
        id SERIAL CONSTRAINT enum_domain_name_validation_checker_pkey PRIMARY KEY,
        name TEXT CONSTRAINT enum_domain_name_validation_checker_name_key UNIQUE NOT NULL,
        description TEXT NOT NULL
        );

COMMENT ON TABLE enum_domain_name_validation_checker IS
'This table contains names of domain name checkers used in server DomainNameValidator';
COMMENT ON COLUMN enum_domain_name_validation_checker.id IS 'unique automatically generated identifier';
COMMENT ON COLUMN enum_domain_name_validation_checker.name IS 'name of the checker';
COMMENT ON COLUMN enum_domain_name_validation_checker.description IS 'description of the checker';

CREATE TABLE domain_name_validation_config_by_zone (
  id BIGSERIAL CONSTRAINT domain_name_validation_config_by_zone_pkey PRIMARY KEY,
  checker_id INTEGER NOT NULL CONSTRAINT domain_name_validation_config_by_zone_checker_id_fkey
    REFERENCES enum_domain_name_validation_checker (id),
  zone_id INTEGER NOT NULL CONSTRAINT domain_name_validation_config_by_zone_zone_id_fkey
    REFERENCES zone (id),
  CONSTRAINT domain_name_validation_config_by_zone_key UNIQUE (checker_id, zone_id)
);

COMMENT ON TABLE domain_name_validation_config_by_zone IS
'This table domain name checkers applied to domain names by zone';
COMMENT ON COLUMN domain_name_validation_config_by_zone.id IS 'unique automatically generated identifier';
COMMENT ON COLUMN domain_name_validation_config_by_zone.checker_id IS 'checker';
COMMENT ON COLUMN domain_name_validation_config_by_zone.zone_id IS 'zone';
