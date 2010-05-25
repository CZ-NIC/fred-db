---
--- don't forget to update database schema version
---

UPDATE enum_parameters SET val = '<insert version here>' WHERE id = 1;

ALTER TABLE zone ADD COLUMN warning_letter BOOLEAN NOT NULL DEFAULT TRUE;

---
--- extend TABLE notify_letters for postservis - include
--- contact reference and status of the item 
---

ALTER TABLE notify_letters ADD COLUMN status INTEGER NOT NULL DEFAULT 1;
ALTER TABLE notify_letters ADD COLUMN contact_id INTEGER
-- there has to be some foreign key declared - but not this
ALTER TABLE notify_letters ADD FOREIGN KEY (contact_id) REFERENCES object_registry(id);

CREATE INDEX notify_letters_status_idx ON notify_letters (status);
CREATE INDEX notify_letters_contact_id_idx ON notify_letters(contact_id);
