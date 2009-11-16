-- DROP TABLE zone CASCADE;
CREATE TABLE zone (
        id SERIAL PRIMARY KEY,
        fqdn VARCHAR(255) UNIQUE NOT NULL,  --zone fully qualified name
        ex_period_min int not null,  --minimal prolongation of the period of domains validity in months
        ex_period_max int not null,  --maximal prolongation of the period of domains validity in months
        val_period int not null,  --enum domains revalidation period in months
        dots_max  int not null default 1,  --maximal number of dots in zone name
        enum_zone boolean default 'f'  --flag if zone is for enum
        );

comment on table zone is
'This table contains zone parameters';
comment on column zone.id is 'unique automatically generated identifier';
comment on column zone.fqdn is 'zone fully qualified name';
comment on column zone.ex_period_min is 'minimal prolongation of the period of domains validity in months';
comment on column zone.ex_period_max is 'maximal prolongation of the period of domains validity in months';
comment on column zone.val_period is 'enum domains revalidation period in months';
comment on column zone.dots_max is 'maximal number of dots in zone name';
comment on column zone.enum_zone is 'flag if zone is for enum';

