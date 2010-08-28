---
--- don't forget to update database schema version
---

UPDATE enum_parameters SET val = '<insert version here>' WHERE id = 1;


---
--- #4402
--- 
---

--drop table sms_archive;
--drop table message_contact_history_map;
--ALTER TABLE letter_archive DROP CONSTRAINT letter_archive_id_fkey;
--drop table message_archive;
--drop table comm_type;

CREATE TABLE comm_type
(
  id  SERIAL PRIMARY KEY,
  type VARCHAR(64) -- email, letter, sms
);

comment on table comm_type is 'type of communication with contact';

INSERT INTO comm_type (id,type) VALUES (1,'email');
INSERT INTO comm_type (id,type) VALUES (2,'letter');
INSERT INTO comm_type (id,type) VALUES (3,'sms');

CREATE TABLE message_type
(
  id  SERIAL PRIMARY KEY,
  type VARCHAR(64) -- domain_expiration, password_reset, notification_about_change,...
);

comment on table message_type is 'type of message with respect to subject of message';

INSERT INTO message_type (id,type) VALUES (1,'domain_expiration');
INSERT INTO message_type (id,type) VALUES (2,'password_reset');
INSERT INTO message_type (id,type) VALUES (3,'notification_about_change');

CREATE TABLE message_archive
(
  id  SERIAL PRIMARY KEY,
  crdate timestamp without time zone NOT NULL DEFAULT now(), -- date of insertion in table
  moddate timestamp without time zone, -- date of sending (even if unsuccesfull)
  attempt smallint NOT NULL DEFAULT 0, -- failed attempts to send data
  status INTEGER,
  comm_type_id INTEGER REFERENCES comm_type (id), --  communication channel
  message_type_id INTEGER REFERENCES message_type (id) --  message type
);

CREATE INDEX message_archive_crdate_idx ON message_archive (crdate);
CREATE INDEX message_archive_status_idx ON message_archive (status);
CREATE INDEX message_archive_comm_type_id_idx ON message_archive (comm_type_id);

comment on column message_archive.crdate is 'date and time of insertion in table';
comment on column message_archive.moddate is 'date and time of sending (event unsuccesfull)';
comment on column message_archive.status is 'status';

CREATE TABLE message_contact_history_map
(
  id  SERIAL PRIMARY KEY,
  contact_object_registry_id INTEGER REFERENCES object_registry (id), -- id type contact
  contact_history_historyid INTEGER REFERENCES contact_history (historyid), -- historyid 
  message_archive_id INTEGER REFERENCES message_archive (id) -- message
);

--sms archive
CREATE TABLE sms_archive
(
  id INTEGER PRIMARY KEY REFERENCES message_archive (id), -- message_archive id
  phone_number VARCHAR(64) NOT NULL, -- copy of phone number
  phone_number_id INTEGER, -- unused 
  content TEXT -- sms text content
);

INSERT INTO message_archive (id, status, crdate, moddate, attempt, comm_type_id) SELECT id, status, crdate, moddate, attempt 
, (SELECT id FROM comm_type WHERE type='letter') as comm_type
FROM letter_archive;

ALTER TABLE letter_archive ADD CONSTRAINT letter_archive_id_fkey FOREIGN KEY (id) REFERENCES message_archive(id);

ALTER TABLE letter_archive ADD COLUMN postal_address_name VARCHAR(1024);
ALTER TABLE letter_archive ADD COLUMN postal_address_organization VARCHAR(1024);
ALTER TABLE letter_archive ADD COLUMN postal_address_street1 VARCHAR(1024);
ALTER TABLE letter_archive ADD COLUMN postal_address_street2 VARCHAR(1024);
ALTER TABLE letter_archive ADD COLUMN postal_address_street3 VARCHAR(1024);
ALTER TABLE letter_archive ADD COLUMN postal_address_city VARCHAR(1024);
ALTER TABLE letter_archive ADD COLUMN postal_address_stateorprovince VARCHAR(1024);
ALTER TABLE letter_archive ADD COLUMN postal_address_postalcode VARCHAR(32);
ALTER TABLE letter_archive ADD COLUMN postal_address_country CHARACTER(2);

ALTER TABLE letter_archive ADD COLUMN  postal_address_id INTEGER; --unused

ALTER TABLE letter_archive DROP COLUMN status;
ALTER TABLE letter_archive DROP COLUMN crdate;
ALTER TABLE letter_archive DROP COLUMN moddate;
ALTER TABLE letter_archive DROP COLUMN attempt;

