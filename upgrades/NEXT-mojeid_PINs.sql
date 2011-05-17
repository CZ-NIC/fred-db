INSERT INTO mail_type (id, name, subject) VALUES (23, 'mojeid_email_change', 'MojeID - PIN pro změnu emailu / MojeID email change PIN');
INSERT INTO mail_templates (id, contenttype, template, footer) VALUES (23, 'plain', 
'PIN pro změnu emailu k mojeID účtu <?cs var:username ?> je: <?cs var:pin ?>
PIN for changing your email of mojeID account <?cs var:username ?> is: <?cs var:pin ?>', 1);
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (23, 23);

INSERT INTO message_type (id, type) VALUES (4, 'mojeid_sms_change');