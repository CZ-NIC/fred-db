CREATE TABLE enum_object_state_request_reason_external
(
    id INTEGER PRIMARY KEY,
    description TEXT NOT NULL
);

ALTER TABLE object_state_request_reason
 ADD COLUMN reason_creation_external_id INTEGER REFERENCES enum_object_state_request_reason_external(id) DEFAULT NULL;
