---
--- #8645, #8716
---
CREATE TABLE mail_type_priority
(
    mail_type_id integer primary key references mail_type(id),
    priority integer not null
);

--- setup
INSERT INTO mail_type_priority VALUES
  ((SELECT id FROM mail_type WHERE name = 'mojeid_identification'), 1),
  ((SELECT id FROM mail_type WHERE name = 'mojeid_validation'), 1),
  ((SELECT id FROM mail_type WHERE name = 'mojeid_email_change'), 1),
  ((SELECT id FROM mail_type WHERE name = 'mojeid_verified_contact_transfer'), 1),
  ((SELECT id FROM mail_type WHERE name = 'conditional_contact_identification'), 2),
  ((SELECT id FROM mail_type WHERE name = 'contact_identification'), 2),
  ((SELECT id FROM mail_type WHERE name = 'sendauthinfo_epp'), 2),
  ((SELECT id FROM mail_type WHERE name = 'sendauthinfo_pif'), 2),
  ((SELECT id FROM mail_type WHERE name = 'notification_create'), 3),
  ((SELECT id FROM mail_type WHERE name = 'notification_update'), 3),
  ((SELECT id FROM mail_type WHERE name = 'notification_transfer'), 3),
  ((SELECT id FROM mail_type WHERE name = 'notification_renew'), 3),
  ((SELECT id FROM mail_type WHERE name = 'notification_unused'), 3),
  ((SELECT id FROM mail_type WHERE name = 'notification_delete'), 3),
  ((SELECT id FROM mail_type WHERE name = 'request_block'), 3);

