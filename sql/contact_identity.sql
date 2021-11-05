---
--- Ticket #30595 - add contact_identity table
---
CREATE TABLE IF NOT EXISTS contact_identity (
    id BIGSERIAL CONSTRAINT contact_identity_pkey PRIMARY KEY,
    contact_id BIGINT NOT NULL,
    identity_provider VARCHAR NOT NULL,
    subject VARCHAR NOT NULL CONSTRAINT contact_identity_subject_nonempty CHECK (0 < LENGTH(subject)),
    valid_from TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valid_to TIMESTAMP NULL DEFAULT NULL CONSTRAINT contact_identity_valid_to_not_before_valid_from CHECK (valid_from <= valid_to),
    CONSTRAINT contact_identity_contact_id_fkey FOREIGN KEY (contact_id) REFERENCES object_registry (id));

CREATE UNIQUE INDEX IF NOT EXISTS contact_identity_contact_id_valid_idx ON contact_identity (contact_id) WHERE valid_to IS NULL;

