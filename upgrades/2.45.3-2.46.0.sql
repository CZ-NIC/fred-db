---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.46.0' WHERE id = 1;

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


---
--- contact states
---
INSERT INTO enum_object_states (id, name, types, manual, external, importance)
VALUES (29, 'serverContactNameChangeProhibited', '{1}', 't', 't', NULL),
       (30, 'serverContactOrganizationChangeProhibited', '{1}', 't', 't', NULL),
       (31, 'serverContactIdentChangeProhibited', '{1}', 't', 't', NULL),
       (32, 'serverContactPermanentAddressChangeProhibited', '{1}', 't', 't', NULL);

INSERT INTO enum_object_states_desc (state_id, lang, description)
VALUES (29, 'CS', 'Není povolena změna jména'),
       (29, 'EN', 'Name update forbidden'),
       (30, 'CS', 'Není povolena změna organizace'),
       (30, 'EN', 'Organization update forbidden'),
       (31, 'CS', 'Není povolena změna dodatečného identifikátoru'),
       (31, 'EN', 'Ident update forbidden'),
       (32, 'CS', 'Není povolena změna adresy trvalého bydliště'),
       (32, 'EN', 'Permanent address update forbidden');
