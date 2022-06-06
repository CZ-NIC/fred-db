CREATE SCHEMA IF NOT EXISTS notification AUTHORIZATION fred;

CREATE TYPE notification.CONTACT_TYPE AS ENUM
(
    'email_address',
    'phone_number'
);

CREATE TABLE notification.object_state_additional_contact
(
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    object_id INTEGER NOT NULL CONSTRAINT object_state_additional_contact_object_id_fkey REFERENCES object_registry(id),
    state_flag_id INTEGER NOT NULL CONSTRAINT object_state_additional_contact_state_flag_id_fkey REFERENCES enum_object_states(id),
    valid_from TIMESTAMP NOT NULL,
    type notification.CONTACT_TYPE NOT NULL,
    contacts VARCHAR[] NOT NULL,
    object_state_id INTEGER CONSTRAINT object_state_additional_contact_object_state_id_fkey REFERENCES object_state(id)
);

CREATE UNIQUE INDEX object_state_additional_conta_object_id_state_flag_id_valid_idx
                 ON notification.object_state_additional_contact (object_id, state_flag_id, valid_from, type);
