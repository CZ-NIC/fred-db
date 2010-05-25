-- DROP TABLE zone CASCADE;
CREATE TABLE zone (
        id SERIAL PRIMARY KEY,
        fqdn VARCHAR(255) UNIQUE NOT NULL,  --zone fully qualified name
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

