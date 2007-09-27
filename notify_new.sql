-- notification processing rules - direct notifier what mails
-- need to be send and whom upon object state change
CREATE TABLE notify_statechange_map (
  id INTEGER PRIMARY KEY, 
  state_id INTEGER NOT NULL REFERENCES enum_object_states (id), 
  obj_type INTEGER NOT NULL, 
  mail_type_id INTEGER NOT NULL REFERENCES mail_type (id),
  emails INTEGER
);

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

-- store information about successfull notification
CREATE TABLE notify_statechange (
  -- which statechange triggered notification
  state_id INTEGER NOT NULL REFERENCES object_state (id),
  -- what notificaton was done
  type INTEGER NOT NULL REFERENCES notify_statechange_map (id),
  -- email with result of notification
  mail_id INTEGER NOT NULL REFERENCES mail_archive (id),
  PRIMARY KEY (state_id, type)
);

-- notifications about deleteWarning state by PDF letter
-- multiple states is stored in one PDF document
CREATE TABLE notify_letters (
  -- which statechange triggered notification
  state_id INTEGER  PRIMARY KEY REFERENCES object_state (id),
  -- file with pdf about notification
  file_id INTEGER NOT NULL REFERENCES files (id)
);
