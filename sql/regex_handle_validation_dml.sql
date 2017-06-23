-- populate regex_handle_validation_checker table
INSERT INTO regex_handle_validation_checker (id, regex, description)
	VALUES (
        nextval('regex_handle_validation_checker_id_seq'),
        '[a-zA-Z0-9](-?[a-zA-Z0-9])*',
        'valid characters'
    );
INSERT INTO regex_handle_validation_checker (id, regex, description)
	VALUES (
        nextval('regex_handle_validation_checker_id_seq'),
        '.{1,30}',
        'valid length'
    );

-- populate regex_object_type_handle_validation_checker_map
INSERT INTO regex_object_type_handle_validation_checker_map (id, type_id, checker_id)
	VALUES (
        nextval('regex_object_type_handle_validation_checker_map_id_seq'),
        (SELECT id FROM enum_object_type WHERE name='nsset'),
        (SELECT id FROM regex_handle_validation_checker WHERE description='valid characters')
    );
INSERT INTO regex_object_type_handle_validation_checker_map (id, type_id, checker_id)
	VALUES (
        nextval('regex_object_type_handle_validation_checker_map_id_seq'),
        (SELECT id FROM enum_object_type WHERE name='nsset'),
        (SELECT id FROM regex_handle_validation_checker WHERE description='valid length')
    );
INSERT INTO regex_object_type_handle_validation_checker_map (id, type_id, checker_id)
	VALUES (
        nextval('regex_object_type_handle_validation_checker_map_id_seq'),
        (SELECT id FROM enum_object_type WHERE name='keyset'),
        (SELECT id FROM regex_handle_validation_checker WHERE description='valid characters')
    );
INSERT INTO regex_object_type_handle_validation_checker_map (id, type_id, checker_id)
	VALUES (nextval('regex_object_type_handle_validation_checker_map_id_seq'),
        (SELECT id FROM enum_object_type WHERE name='keyset'),
        (SELECT id FROM regex_handle_validation_checker WHERE description='valid length')
    );
INSERT INTO regex_object_type_handle_validation_checker_map (id, type_id, checker_id)
	VALUES (
        nextval('regex_object_type_handle_validation_checker_map_id_seq'),
        (SELECT id FROM enum_object_type WHERE name='contact'),
        (SELECT id FROM regex_handle_validation_checker WHERE description='valid characters')
    );
INSERT INTO regex_object_type_handle_validation_checker_map (id, type_id, checker_id)
	VALUES (
        nextval('regex_object_type_handle_validation_checker_map_id_seq'),
        (SELECT id FROM enum_object_type WHERE name='contact'),
        (SELECT id FROM regex_handle_validation_checker WHERE description='valid length')
    );
