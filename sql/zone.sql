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

INSERT INTO zone  VALUES(1,'0.2.4.e164.arpa',12,120,6,9,'t');
INSERT INTO zone  VALUES(2,'0.2.4.c.e164.arpa',12,120,6,9,'t');
INSERT INTO zone  VALUES(3,'cz',12,120,0,1,'f');

