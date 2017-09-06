-- Ticket #18426 - moving regex to configuration

-- list of regular expressions
CREATE TABLE regex_handle_validation_checker(
	id SERIAL CONSTRAINT regex_handle_validation_checker_pkey PRIMARY KEY,
	regex TEXT CONSTRAINT regex_handle_validation_checker_regex_key NOT NULL,
	description TEXT
);

COMMENT ON TABLE regex_handle_validation_checker IS 'This table contains regular expressions intended for handle validation';
COMMENT ON COLUMN regex_handle_validation_checker.id IS 'unique automatically generated identifier';
COMMENT ON COLUMN regex_handle_validation_checker.regex IS 'regular expression';
COMMENT ON COLUMN regex_handle_validation_checker.description IS 'human readable description (optional)';

-- which regular expressions are used for which handle types
CREATE TABLE regex_object_type_handle_validation_checker_map(
	id BIGSERIAL CONSTRAINT regex_object_type_handle_validation_checker_map_pkey PRIMARY KEY,
	type_id INTEGER NOT NULL CONSTRAINT regex_object_type_handle_validation_checker_map_type_id_fkey REFERENCES enum_object_type (id),
	checker_id INTEGER NOT NULL CONSTRAINT regex_object_type_handle_validation_checker_map_checker_id_fkey REFERENCES regex_handle_validation_checker (id),
	CONSTRAINT regex_object_type_handle_validation_checker_map_key UNIQUE (type_id, checker_id)
);

COMMENT ON TABLE regex_object_type_handle_validation_checker_map IS
'This table represents a mapping between handle types and regular expressions intended for validation of handles';
COMMENT ON COLUMN regex_object_type_handle_validation_checker_map.id IS 'unique automatically generated identifier';
COMMENT ON COLUMN regex_object_type_handle_validation_checker_map.type_id IS 'type of handle';
COMMENT ON COLUMN regex_object_type_handle_validation_checker_map.checker_id IS 'regular expression intended for validation validation';

-- populate regex_handle_validation_checker table
INSERT INTO regex_handle_validation_checker (id, regex, description)
	VALUES (
        nextval('regex_handle_validation_checker_id_seq'),
        '[a-zA-Z0-9](-?[a-zA-Z0-9])*',
        'valid characters according to CZ.NIC'
    );
INSERT INTO regex_handle_validation_checker (id, regex, description)
	VALUES (
        nextval('regex_handle_validation_checker_id_seq'),
        '.{1,30}',
        'handle length is at least 1 and no more than 30 characters'
    );

-- populate regex_object_type_handle_validation_checker_map
INSERT INTO regex_object_type_handle_validation_checker_map (id, type_id, checker_id)
	VALUES (
        nextval('regex_object_type_handle_validation_checker_map_id_seq'),
        (SELECT id FROM enum_object_type WHERE name='nsset'),
        (SELECT id FROM regex_handle_validation_checker WHERE description='valid characters according to CZ.NIC')
    );
INSERT INTO regex_object_type_handle_validation_checker_map (id, type_id, checker_id)
	VALUES (
        nextval('regex_object_type_handle_validation_checker_map_id_seq'),
        (SELECT id FROM enum_object_type WHERE name='nsset'),
        (SELECT id FROM regex_handle_validation_checker WHERE description='handle length is at least 1 and no more than 30 characters')
    );
INSERT INTO regex_object_type_handle_validation_checker_map (id, type_id, checker_id)
	VALUES (
        nextval('regex_object_type_handle_validation_checker_map_id_seq'),
        (SELECT id FROM enum_object_type WHERE name='keyset'),
        (SELECT id FROM regex_handle_validation_checker WHERE description='valid characters according to CZ.NIC')
    );
INSERT INTO regex_object_type_handle_validation_checker_map (id, type_id, checker_id)
	VALUES (nextval('regex_object_type_handle_validation_checker_map_id_seq'),
        (SELECT id FROM enum_object_type WHERE name='keyset'),
        (SELECT id FROM regex_handle_validation_checker WHERE description='handle length is at least 1 and no more than 30 characters')
    );
INSERT INTO regex_object_type_handle_validation_checker_map (id, type_id, checker_id)
	VALUES (
        nextval('regex_object_type_handle_validation_checker_map_id_seq'),
        (SELECT id FROM enum_object_type WHERE name='contact'),
        (SELECT id FROM regex_handle_validation_checker WHERE description='valid characters according to CZ.NIC')
    );
INSERT INTO regex_object_type_handle_validation_checker_map (id, type_id, checker_id)
	VALUES (
        nextval('regex_object_type_handle_validation_checker_map_id_seq'),
        (SELECT id FROM enum_object_type WHERE name='contact'),
        (SELECT id FROM regex_handle_validation_checker WHERE description='handle length is at least 1 and no more than 30 characters')
    );
