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
