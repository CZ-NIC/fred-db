---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '<insert version here>' WHERE id = 1;

---
--- Ticket #3747
---
CREATE TABLE registrar_certification
(
    id SERIAL PRIMARY KEY, -- certification id
    registrar_id integer NOT NULL REFERENCES registrar(id), -- registrar id
    valid_from date NOT NULL, --  registrar certification valid from
    valid_until date NOT NULL, --  registrar certification valid until = valid_from + 1year
    classification integer NOT NULL, -- registrar certification result 0-5
    evaluation REFERENCES file(id), -- link to pdf file
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
COMMENT ON COLUMN registrar_certification.evaluation IS
    'evaluation pdf file link';

CREATE TABLE registrar_www_lists
(
    id SERIAL PRIMARY KEY, -- registrar list id
    short_name varchar(255) -- short name of the list
);

INSERT INTO registrar_www_lists (id, short_name) VALUES (0, 'NONE');

COMMENT ON TABLE registrar_www_lists IS 'available www-lists of registars';
COMMENT ON COLUMN registrar_www_lists.id IS 'www-list id';
COMMENT ON COLUMN registrar_www_lists.short_name IS 'www-list short name';

CREATE TABLE registrar_www_list_membership
(
    id SERIAL PRIMARY KEY, -- registrar list membership id
    registrar_id integer NOT NULL REFERENCES registrar(id), -- registrar id
    registrar_www_lists_id integer NOT NULL REFERENCES registrar_www_lists(id) -- registrar_www_lists id
);

COMMENT ON TABLE registrar_www_list_membership IS 'membership of registar in www-list';
COMMENT ON COLUMN registrar_www_list_membership.id IS 'registrar list membership id';
COMMENT ON COLUMN registrar_www_list_membership.registrar_id IS 'registrar id';
COMMENT ON COLUMN registrar_www_list_membership.registrar_www_lists_id IS 'www-list id';
