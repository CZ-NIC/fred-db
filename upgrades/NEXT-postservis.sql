---
--- don't forget to update database schema version
---

UPDATE enum_parameters SET val = '<insert version here>' WHERE id = 1;

ALTER TABLE zone ADD COLUMN warning_letter BOOLEAN NOT NULL DEFAULT TRUE;

---
--- extend TABLE notify_letters for postservis - include
--- contact reference and status of the item 
---


-- letters sent electronically as PDF documents to postal service, address is included in the document
CREATE TABLE letter_archive (
  id SERIAL PRIMARY KEY,
   -- initial (default) status is 'file generated & ready for processing'
  status INTEGER NOT NULL DEFAULT 1 REFERENCES enum_send_status(id),
  -- file with pdf about notification (null for old)
  file_id INTEGER REFERENCES files (id),
  crdate timestamp NOT NULL DEFAULT now(),  -- date of insertion in table
  moddate timestamp,    -- date of sending (even if unsuccesfull), it is the time when the send attempt finished
  attempt smallint NOT NULL DEFAULT 0 -- failed attempts to send data
);

comment on table letter_archive is 'letters sent electronically as PDF documents to postal service, address is included in the document';
comment on table letter_archive.status is 'initial (default) status is ''file generated & ready for processing'' ';
comment on table letter_archive.file_id is 'file with pdf about notification (null for old)';
comment on table letter_archive.crdate is 'date of insertion in table';
comment on table letter_archive.moddate is 'date of sending (even if unsuccesfull), it is the time when the send attempt finished';
comment on table letter_archive.attempt is 'failed attempts to send data';

-- TODO upgrade script to fill data into letter_archive and evacuate file_id in notify_letters which should be dropped


ALTER TABLE notify_letters DROP COLUMN file_id;

ALTER TABLE notify_letters ADD COLUMN status INTEGER NOT NULL DEFAULT 1;
ALTER TABLE notify_letters ADD COLUMN contact_history_id INTEGER;
-- there has to be some foreign key declared - but not this
ALTER TABLE notify_letters ADD FOREIGN KEY (contact_history_id) REFERENCES contact_history(historyid);
ALTER TABLE notify_letters ADD COLUMN letter_id INTEGER;
ALTER TABLE notify_letters ADD FOREIGN KEY (letter_id) REFERENCES letter_archive(id);

comment on column notify_letters.contact_history_id is 'which contact is the file sent to';
comment on column notify_letters.letter_id is 'which message notifies the state change';


CREATE INDEX notify_letters_status_idx ON notify_letters (status);
CREATE INDEX notify_letters_contact_id_idx ON notify_letters(contact_id);
