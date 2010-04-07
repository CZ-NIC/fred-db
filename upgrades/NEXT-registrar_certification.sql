---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '<insert version here>' WHERE id = 1;

---
--- Ticket #3747
---

CREATE DOMAIN classification_type AS integer NOT NULL
	CONSTRAINT classification_type_check CHECK (VALUE IN (0, 1, 2, 3, 4, 5)); 

COMMENT ON DOMAIN classification_type 
	IS 'allowed values of classification for registrar certification';

CREATE TABLE registrar_certification
(
    id serial PRIMARY KEY, -- certification id
    registrar_id integer NOT NULL REFERENCES registrar(id), -- registrar id
    valid_from date NOT NULL, --  registrar certification valid from
    valid_until date NOT NULL, --  registrar certification valid until = valid_from + 1year
    classification classification_type NOT NULL, -- registrar certification result 0-5
    eval_files_id integer REFERENCES files(id) -- link to pdf file
);

CREATE INDEX registrar_certification_valid_from_idx ON registrar_certification(valid_from);
CREATE INDEX registrar_certification_valid_until_idx ON registrar_certification(valid_until);

COMMENT ON TABLE registrar_certification IS 'result of registrar certification';
COMMENT ON COLUMN registrar_certification.registrar_id IS 'certified registrar id';
COMMENT ON COLUMN registrar_certification.valid_from IS
    'certification is valid from this date';
COMMENT ON COLUMN registrar_certification.valid_until IS
    'certification is valid until this date, certification should be valid for 1 year';
COMMENT ON COLUMN registrar_certification.classification IS
    'registrar certification result 0-5';
COMMENT ON COLUMN registrar_certification.eval_files_id IS
    'evaluation pdf file link';

CREATE TABLE registrar_www_list
(
    id serial PRIMARY KEY, -- registrar list id
    short_name varchar(255) -- short name of the list
);

COMMENT ON TABLE registrar_www_list IS 'available www-lists of registars';
COMMENT ON COLUMN registrar_www_list.id IS 'www-list id';
COMMENT ON COLUMN registrar_www_list.short_name IS 'www-list short name';

CREATE TABLE registrar_www_list_map
(
    id serial PRIMARY KEY, -- id of membership of registrar in www-list
    registrar_id integer NOT NULL REFERENCES registrar(id), -- registrar id
    registrar_www_list_id integer NOT NULL REFERENCES registrar_www_list(id) -- registrar www-list id
    member_from date NOT NULL, --  registrar membership of the list from this date
    member_until date NOT NULL, --  registrar membership of the list until this date
);

CREATE INDEX registrar_www_list_map_member_from_idx ON registrar_www_list_map(member_from);
CREATE INDEX registrar_www_list_map_member_until_idx ON registrar_www_list_map(member_until);

COMMENT ON TABLE registrar_www_list_map IS 'membership of registar in www-list';
COMMENT ON COLUMN registrar_www_list_map.id IS 'registrar list membership id';
COMMENT ON COLUMN registrar_www_list_map.registrar_id IS 'registrar id';
COMMENT ON COLUMN registrar_www_list_map.registrar_www_list_id IS 'www-list id';
COMMENT ON COLUMN registrar_www_list_map.member_from 
	IS 'registrar membership of the list from this date';
COMMENT ON COLUMN registrar_www_list_map.member_until 
	IS 'registrar membership of the list until this date';

