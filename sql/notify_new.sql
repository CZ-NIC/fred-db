-- notification processing rules - direct notifier what mails
-- need to be send and whom upon object state change
CREATE TABLE notify_statechange_map (
  id INTEGER PRIMARY KEY, 
  state_id INTEGER NOT NULL REFERENCES enum_object_states (id), 
  obj_type INTEGER NOT NULL, 
  mail_type_id INTEGER NOT NULL REFERENCES mail_type (id),
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
  state_id INTEGER NOT NULL REFERENCES object_state (id),
  -- what notificaton was done
  type INTEGER NOT NULL REFERENCES notify_statechange_map (id),
  -- email with result of notification (null if contacts have no email)
  mail_id INTEGER REFERENCES mail_archive (id),
  PRIMARY KEY (state_id, type)
);

comment on table notify_statechange is 'store information about successfull notification';
comment on column notify_statechange.state_id is 'which statechnage triggered notification';
comment on column notify_statechange.type is 'what notification was done';
comment on column notify_statechange.mail_id is 'email with result of notification (null if contact have no email)';

-- notifications about deleteWarning state by PDF letter
-- multiple states is stored in one PDF document
CREATE TABLE notify_letters (
  -- which statechange triggered notification
  state_id INTEGER  PRIMARY KEY REFERENCES object_state (id),
  -- file with pdf about notification (null for old)
  file_id INTEGER REFERENCES files (id)
);

comment on table notify_letters is 'notification about deleteWarning state by PDF letter, multiple states is stored in one PDF document';
comment on column notify_letters.state_id is 'which statechange triggered notification';
comment on column notify_letters.file_id is 'file with pdf about notification (null for old)';
