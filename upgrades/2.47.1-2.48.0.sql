---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.48.0' WHERE id = 1;


CREATE TABLE enum_object_state_request_reason_external
(
    id INTEGER PRIMARY KEY,
    description TEXT NOT NULL
);

ALTER TABLE object_state_request_reason
 ADD COLUMN reason_creation_external_id INTEGER REFERENCES enum_object_state_request_reason_external(id) DEFAULT NULL;
