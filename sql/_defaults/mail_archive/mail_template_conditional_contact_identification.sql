INSERT INTO mail_template
(mail_type_id, version, subject, body_template, body_template_content_type, mail_template_footer_id, mail_template_default_id, mail_header_default_id, created_at)
VALUES
(25, 1,
'Podmíněná identifikace kontaktu / Conditional contact identification',
'Vážený uživateli,

tento e-mail potvrzuje úspěšné zahájení procesu ověření kontaktu v Centrálním registru:

ID kontaktu: <?cs var:handle ?>
jméno:       <?cs var:firstname ?>
příjmení:    <?cs var:lastname ?>
e-mail:      <?cs var:email ?>

Pro dokončení prvního ze dvou kroků ověření je nutné zadat kódy PIN1 a PIN2.

PIN1: <?cs var:passwd ?>
PIN2: Vám byl zaslán pomocí SMS.

Zadání PIN1 a PIN2 bude možné po kliknutí na následující odkaz:
https://<?cs var:hostname ?>/verification/identify/email-sms/<?cs var:identification ?>/?password1=<?cs var:passwd ?>

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear user,

This email confirms that the process of verifying your contact data in the Central Registry has been successfully initiated:

contact ID: <?cs var:handle ?>
first name: <?cs var:firstname ?>
last name:  <?cs var:lastname ?>
email:      <?cs var:email ?>

To complete the first of the two verification steps, authorisation with your PIN1 and PIN2 codes is required.

PIN1: <?cs var:passwd ?>
PIN2: was sent to you in a text message (SMS).

You will be able to enter your PIN1 and PIN2 by following this link:
https://<?cs var:hostname ?>/verification/identify/email-sms/<?cs var:identification ?>/?password1=<?cs var:passwd ?>

Yours sincerely
Support of <?cs var:defaults.company_en ?>
', 'plain', 1, 1, 1, DEFAULT);

INSERT INTO mail_template
(mail_type_id, version, subject, body_template, body_template_content_type, mail_template_footer_id, mail_template_default_id, mail_header_default_id, created_at)
VALUES
(25, 2,
'Podmíněná identifikace kontaktu / Conditional contact identification',
'Vážený uživateli,

tento e-mail potvrzuje úspěšné zahájení procesu ověření kontaktu v Centrálním registru:

ID kontaktu: <?cs var:handle ?>
jméno:       <?cs var:firstname ?>
příjmení:    <?cs var:lastname ?>
e-mail:      <?cs var:email ?>
telefon:     <?cs var:telephone ?>

Pro dokončení prvního ze dvou kroků ověření je nutné zadat kódy PIN1 a PIN2.

PIN1: <?cs var:passwd ?>
PIN2: Vám byl zaslán pomocí SMS na číslo <?cs var:telephone ?>.

Zadání PIN1 a PIN2 bude možné po kliknutí na následující odkaz:
https://<?cs var:hostname ?>/verification/identify/email-sms/<?cs var:identification ?>/?password1=<?cs var:passwd ?>

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear user,

This email confirms that the process of verifying your contact data in the Central Registry has been successfully initiated:

contact ID: <?cs var:handle ?>
first name: <?cs var:firstname ?>
last name:  <?cs var:lastname ?>
email:      <?cs var:email ?>
phone:      <?cs var:telephone ?>

To complete the first of the two verification steps, authorisation with your PIN1 and PIN2 codes is required.

PIN1: <?cs var:passwd ?>
PIN2: was sent to you in a text message (SMS) to phone number <?cs var:telephone ?>.

You will be able to enter your PIN1 and PIN2 by following this link:
https://<?cs var:hostname ?>/verification/identify/email-sms/<?cs var:identification ?>/?password1=<?cs var:passwd ?>

Yours sincerely
Support of <?cs var:defaults.company_en ?>
', 'plain', 1, 1, 1, DEFAULT);
