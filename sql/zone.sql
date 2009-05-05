-- DROP TABLE zone CASCADE;
CREATE TABLE zone (
        id SERIAL PRIMARY KEY,
        fqdn VARCHAR(255) UNIQUE NOT NULL,
        ex_period_min int not null,
        ex_period_max int not null,
        val_period int not null,
        dots_max  int not null default 1,
        enum_zone boolean default 'f'
        );

