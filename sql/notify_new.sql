-- notification processing rules - direct notifier what mails
-- need to be send and whom upon object state change
CREATE TABLE notify_statechange_map (
  id INTEGER CONSTRAINT notify_statechange_map_pkey PRIMARY KEY,
  state_id INTEGER NOT NULL CONSTRAINT notify_statechange_map_state_id_fkey REFERENCES enum_object_states (id),
  obj_type INTEGER NOT NULL,
  mail_type_id INTEGER NOT NULL CONSTRAINT notify_statechange_map_mail_type_id_fkey REFERENCES mail_type (id),
  emails INTEGER
);

comment on table notify_statechange_map is
'Notification processing rules - direct notifier what mails need to be send
and whom upon object state change';

comment on column notify_statechange_map.state_id is 'id of state to be notified by email';
comment on column notify_statechange_map.obj_type is 'type of object to be notified (1..contact, 2..nsset, 3..domain, 4..keyset)';
comment on column notify_statechange_map.mail_type_id is 'type of mail to be send';
comment on column notify_statechange_map.emails is 'type of contact group to be notified by email (1..admins, 2..techs)';

-- state: expiration, obj: domain, 
-- template: expiration_notify, emails: admins
INSERT INTO notify_statechange_map VALUES ( 1,  9, 3,  3, 1);
-- state: outzoneUnguarded, obj: domain, 
-- template: expiration_dns_owner, emails: admins
INSERT INTO notify_statechange_map VALUES ( 2, 20, 3,  4, 1);
-- state: deleteCandidate, obj: domain,
-- template: expiration_register_owner, emails: admins
INSERT INTO notify_statechange_map VALUES ( 3, 17, 3,  5, 1);
-- state: deleteCandidate, obj: nsset,
-- template: notification_unused, emails: admins
INSERT INTO notify_statechange_map VALUES ( 4, 17, 2, 14, 1);
-- state: deleteCandidate, obj: contact,
-- template: notification_unused, emails: admin
INSERT INTO notify_statechange_map VALUES ( 5, 17, 1, 14, 1);
-- state: outzoneUnguarded, obj: domain,
-- template: expiration_dns_tech, emails: techs
INSERT INTO notify_statechange_map VALUES ( 6, 20, 3,  6, 2);
-- state: deleteCandidate, obj: domain,
-- template: expiration_register_tech, emails: techs
INSERT INTO notify_statechange_map VALUES ( 7, 17, 3,  7, 2);
-- state: validationWarning2, obj: domain, 
-- template: expiration_validation_before, emails: admins
INSERT INTO notify_statechange_map VALUES ( 8, 12, 3,  8, 1);
-- state: validation, obj: domain, 
-- template: expiration_validation, emails: admins
INSERT INTO notify_statechange_map VALUES ( 9, 13, 3,  9, 1);
-- state: validation, obj: domain, 
-- template: expiration_tech_dns, emails: techs
INSERT INTO notify_statechange_map VALUES (10, 13, 3,  6, 2);
-- state: deleteCandidate, obj: keyset,
-- template: notification_unused, emails: admin
INSERT INTO notify_statechange_map VALUES (11, 17, 4, 14, 1);
-- state: outzoneUnguarded, obj: domain, 
-- template: expiration_dns_owner, emails: generic emails (like kontakt@... postmaster@... info@...)
INSERT INTO notify_statechange_map VALUES (12, 20, 3, 4, 3);

-- store information about successfull notification
CREATE TABLE notify_statechange (
  -- which statechange triggered notification
  state_id INTEGER NOT NULL CONSTRAINT notify_statechange_state_id_fkey REFERENCES object_state (id),
  -- what notificaton was done
  type INTEGER NOT NULL CONSTRAINT notify_statechange_type_fkey REFERENCES notify_statechange_map (id),
  -- email with result of notification (null if contacts have no email)
  mail_id INTEGER CONSTRAINT notify_statechange_mail_id_fkey REFERENCES mail_archive (id),
  CONSTRAINT notify_statechange_pkey PRIMARY KEY (state_id, type)
);

comment on table notify_statechange is 'store information about successfull notification';
comment on column notify_statechange.state_id is 'which statechnage triggered notification';
comment on column notify_statechange.type is 'what notification was done';
comment on column notify_statechange.mail_id is 'email with result of notification (null if contact have no email)';

--message_archive 

CREATE TABLE comm_type
(
  id  SERIAL CONSTRAINT comm_type_pkey PRIMARY KEY,
  type VARCHAR(64) -- email, letter, sms
);

comment on table comm_type is 'type of communication with contact';

INSERT INTO comm_type (id,type) VALUES (1,'email');
INSERT INTO comm_type (id,type) VALUES (2,'letter');
INSERT INTO comm_type (id,type) VALUES (3,'sms');
INSERT INTO comm_type (id,type) VALUES (4,'registered_letter');

CREATE TABLE message_type
(
  id  SERIAL CONSTRAINT message_type_pkey PRIMARY KEY,
  type VARCHAR(64) -- domain_expiration, mojeid_pin2, mojeid_pin3,...
);

comment on table message_type is 'type of message with respect to subject of message';

INSERT INTO message_type (id,type) VALUES (1,'domain_expiration');

-- #11241

CREATE TYPE message_forwarding_service AS ENUM ('MOBILEM', 'POSTSERVIS', 'OPTYS', 'MANUAL');

CREATE TABLE message_type_forwarding_service_map
(
  message_type_id BIGINT NOT NULL
    CONSTRAINT message_type_forwarding_service_map_message_type_id_fkey REFERENCES message_type(id),
    CONSTRAINT message_type_forwarding_service_map_message_type_id_unique UNIQUE (message_type_id),
  service_handle message_forwarding_service NOT NULL
);

CREATE TABLE message_archive
(
  id  SERIAL CONSTRAINT message_archive_pkey PRIMARY KEY,
  crdate timestamp without time zone NOT NULL DEFAULT now(), -- date of insertion in table
  moddate timestamp without time zone, -- date of sending (even if unsuccesfull)
  attempt smallint NOT NULL DEFAULT 0, -- failed attempts to send data
  status_id INTEGER CONSTRAINT message_archive_status_id_fkey REFERENCES enum_send_status (id), -- message_status
  comm_type_id INTEGER CONSTRAINT message_archive_comm_type_id_fkey REFERENCES comm_type (id), --  communication channel
  message_type_id INTEGER CONSTRAINT message_archive_message_type_id_fkey REFERENCES message_type (id), --  message type
  service_handle message_forwarding_service NOT NULL
);

CREATE INDEX message_archive_crdate_idx ON message_archive (crdate);
CREATE INDEX message_archive_status_id_idx ON message_archive (status_id);
CREATE INDEX message_archive_comm_type_id_idx ON message_archive (comm_type_id);

comment on column message_archive.crdate is 'date and time of insertion in table';
comment on column message_archive.moddate is 'date and time of sending (event unsuccesfull)';
comment on column message_archive.status_id is 'status';

CREATE TABLE message_contact_history_map
(
  id  SERIAL CONSTRAINT message_contact_history_map_pkey PRIMARY KEY,
  contact_object_registry_id INTEGER,-- REFERENCES object_registry (id), -- id type contact
  contact_history_historyid INTEGER, -- REFERENCES contact_history (historyid), -- historyid 
  message_archive_id INTEGER CONSTRAINT message_contact_history_map_message_archive_id_fkey REFERENCES message_archive (id) -- message
);

CREATE INDEX message_contact_history_map_contact_object_registry_id_idx
ON message_contact_history_map (contact_object_registry_id);

--sms archive
CREATE TABLE sms_archive
(
  id INTEGER CONSTRAINT sms_archive_pkey PRIMARY KEY
  CONSTRAINT sms_archive_id_fkey REFERENCES message_archive (id), -- message_archive id
  phone_number VARCHAR(64) NOT NULL, -- copy of phone number
  phone_number_id INTEGER, -- unused 
  content TEXT -- sms text content
);


-- letters sent electronically as PDF documents to postal service, address is included in the document

CREATE TABLE letter_archive
(
  id INTEGER CONSTRAINT letter_archive_pkey PRIMARY KEY
  CONSTRAINT letter_archive_id_fkey REFERENCES message_archive (id),
  file_id integer CONSTRAINT letter_archive_file_id_fkey REFERENCES files (id), -- file with pdf about notification (null for old)
  batch_id character varying(64), -- postservis batch id - multiple letters are bundled into batches
  postal_address_name character varying(1024),
  postal_address_organization character varying(1024),
  postal_address_street1 character varying(1024),
  postal_address_street2 character varying(1024),
  postal_address_street3 character varying(1024),
  postal_address_city character varying(1024),
  postal_address_stateorprovince character varying(1024),
  postal_address_postalcode character varying(32),
  postal_address_country character varying(1024) CONSTRAINT letter_archive_postal_address_country_fkey REFERENCES enum_country (country),
  postal_address_id integer
);

COMMENT ON TABLE letter_archive IS 'letters sent electronically as PDF documents to postal service, address is included in the document';
COMMENT ON COLUMN letter_archive.file_id IS 'file with pdf about notification (null for old)';
COMMENT ON COLUMN letter_archive.batch_id IS 'postservis batch id - multiple letters are bundled into batches';

CREATE INDEX letter_archive_batch_id ON letter_archive (batch_id);

CREATE TABLE notify_letters (
  -- which statechange triggered notification
  state_id INTEGER NOT NULL CONSTRAINT notify_letters_pkey PRIMARY KEY 
  CONSTRAINT notify_letters_state_id_fkey REFERENCES object_state (id),
  -- which message notifies the state change
  letter_id INTEGER CONSTRAINT notify_letters_letter_id_fkey REFERENCES letter_archive (id)
);  

CREATE INDEX notify_letters_status_idx ON notify_letters (state_id);
CREATE INDEX notify_letters_letter_id_idx ON notify_letters (letter_id);

comment on table notify_letters is 'notifications about deleteWarning state sent as PDF letters';
comment on column notify_letters.state_id is 'which statechange triggered notification';
comment on column notify_letters.letter_id is 'which message notifies the state change';


CREATE TABLE notify_request
(
    request_id BIGINT NOT NULL,
    message_id INTEGER NOT NULL
    CONSTRAINT notify_request_message_id_key UNIQUE
    CONSTRAINT notify_request_message_id_fkey REFERENCES mail_archive(id),
    CONSTRAINT notify_request_pkey PRIMARY KEY (request_id, message_id)
);

