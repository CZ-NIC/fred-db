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
    classification classification_type NOT NULL, -- registrar certification result checked 0-5
    eval_file_id integer REFERENCES files(id) -- link to pdf file
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
    'registrar certification result checked 0-5';
COMMENT ON COLUMN registrar_certification.eval_file_id IS
    'evaluation pdf file link';

CREATE TABLE registrar_group
(
    id serial PRIMARY KEY, -- registrar group id
    short_name varchar(255) NOT NULL UNIQUE -- short name of the group
);

CREATE INDEX registrar_group_short_name_idx ON registrar_group(short_name);

COMMENT ON TABLE registrar_group IS 'available groups of registars';
COMMENT ON COLUMN registrar_group.id IS 'group id';
COMMENT ON COLUMN registrar_group.short_name IS 'group short name';

CREATE TABLE registrar_group_map
(
    id serial PRIMARY KEY, -- membership of registrar in group id
    registrar_id integer NOT NULL REFERENCES registrar(id), -- registrar id
    registrar_group_id integer NOT NULL REFERENCES registrar_group(id), -- registrar group id
    member_from date NOT NULL, --  registrar membership in the group from this date
    member_until date NOT NULL --  registrar membership in the group until this date
);

CREATE INDEX registrar_group_map_member_from_idx ON registrar_group_map(member_from);
CREATE INDEX registrar_group_map_member_until_idx ON registrar_group_map(member_until);

COMMENT ON TABLE registrar_group_map IS 'membership of registar in group';
COMMENT ON COLUMN registrar_group_map.id IS 'registrar group membership id';
COMMENT ON COLUMN registrar_group_map.registrar_id IS 'registrar id';
COMMENT ON COLUMN registrar_group_map.registrar_group_id IS 'group id';
COMMENT ON COLUMN registrar_group_map.member_from 
	IS 'registrar membership in the group from this date';
COMMENT ON COLUMN registrar_group_map.member_until 
	IS 'registrar membership in the group until this date';

