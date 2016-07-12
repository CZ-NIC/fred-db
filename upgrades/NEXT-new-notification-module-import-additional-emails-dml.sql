-- Ticket #16107 - new-notification-module-import-additional-emails

-- state: outzoneUnguardedWarning, obj: domain,
-- template: expiration_dns_owner FIXME, emails: additional domain notification emails
INSERT INTO notify_statechange_map VALUES (13, 28, 3, 4, 4);

-- parameter 18 is used to generate email with warning
-- value is number of days relative to domain.exdate
INSERT INTO enum_parameters (id, name, val)
VALUES (18, 'outzone_unguarded_email_warning_period', '25');

INSERT INTO enum_object_states
  VALUES (28,'outzoneUnguardedWarning','{3}','f','f', NULL);
