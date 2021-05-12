---
--- Ticket #30595 - add contact_identity table
---
CREATE TABLE IF NOT EXISTS contact_identity (
    id BIGSERIAL CONSTRAINT contact_identity_pkey PRIMARY KEY,
    contact_id BIGINT NOT NULL,
    identity_provider VARCHAR NOT NULL,
    subject VARCHAR NOT NULL CONSTRAINT contact_identity_subject_nonempty CHECK (0 < LENGTH(subject)),
    valid_from TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valid_to TIMESTAMP NULL DEFAULT NULL CONSTRAINT contact_identity_valid_to_not_ahead_of_valid_from CHECK (NOT (valid_to < valid_from)),
    CONSTRAINT contact_identity_contact_id_fkey FOREIGN KEY (contact_id) REFERENCES object_registry (id));

CREATE UNIQUE INDEX IF NOT EXISTS contact_identity_identity_provider_subject_contact_id_valid_idx ON contact_identity (identity_provider, subject, contact_id) WHERE valid_to IS NULL;

