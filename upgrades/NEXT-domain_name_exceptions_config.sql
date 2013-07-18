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
    REFERENCES domain_name_validation_config_by_zone (id),
  zone_id INTEGER NOT NULL CONSTRAINT domain_name_validation_config_by_zone_zone_id_fkey
    REFERENCES zone (id),
  CONSTRAINT domain_name_validation_config_by_zone_key UNIQUE (checker_id, zone_id)
);

COMMENT ON TABLE domain_name_validation_config_by_zone IS
'This table domain name checkers applied to domain names by zone';
COMMENT ON COLUMN domain_name_validation_config_by_zone.id IS 'unique automatically generated identifier';
COMMENT ON COLUMN domain_name_validation_config_by_zone.checker_id IS 'checker';
COMMENT ON COLUMN domain_name_validation_config_by_zone.zone_id IS 'zone';


