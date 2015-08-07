---
--- sms types
---

INSERT INTO message_type (id, type) VALUES (6, 'contact_verification_pin2');
INSERT INTO message_type (id, type) VALUES (7, 'contact_verification_pin3');

---
--- email types
---

INSERT INTO mail_type (id, name, subject) VALUES (25, 'conditional_contact_identification', 'Podmíněná identifikace kontaktu / Conditional contact identification');
INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id) VALUES ((SELECT id FROM mail_type WHERE name = 'conditional_contact_identification'), 1);
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(25, 'plain', 1,
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
PIN2: was sent to you by means of a text message (SMS).

You will be able to enter your PIN1 and PIN2 by following this link:
https://<?cs var:hostname ?>/verification/identify/email-sms/<?cs var:identification ?>/?password1=<?cs var:passwd ?>

Yours sincerely
Support of <?cs var:defaults.company_en ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (25, 25);



INSERT INTO mail_type (id, name, subject) VALUES (26, 'contact_identification', 'Identifikace kontaktu / Contact identification');
INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id) VALUES ((SELECT id FROM mail_type WHERE name = 'contact_identification'), 1);
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(26, 'plain', 1,
'Vážený uživateli,

úspěšně jste dokončil(a) první část ověření svého kontaktu
v Centrálním registru s následujícími údaji.

identifikátor: <?cs var:handle ?>
jméno:         <?cs var:firstname ?>
příjmení:      <?cs var:lastname ?>
e-mail:        <?cs var:email ?>

Zároveň Vám byl vygenerován a odeslán poštou kód PIN3, který obdržíte
v nejbližších dnech. Ověření kontaktu dokončíte zadáním kódu PIN3 na stránce
https://<?cs var:hostname ?>/verification/identify/letter/?handle=<?cs var:handle ?>

Rádi bychom Vám také připomněli, že až do okamžiku zadání kódu PIN3
nelze v kontaktu měnit jméno, organizaci, e-mail, telefon ani adresu.
Případná editace těchto údajů v této fázi ověřovacího procesu by měla
za následek jeho přerušení.

Děkujeme za pochopení.

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear user,

You have successfully completed the first step of verification
of your contact in Central registry using the following data.

contact ID: <?cs var:handle ?>
first name: <?cs var:firstname ?>
last name:  <?cs var:lastname ?>
e-mail:     <?cs var:email ?>

We have sent you a letter containing your PIN3 as well and you will receive it
in a few days. To complete your contact verification, submit your PIN3 on the page
https://<?cs var:hostname ?>/verification/identify/letter/?handle=<?cs var:handle ?>

Please, be aware that you should not change contact name, organization, email,
phone or address of the contact before submitting the PIN3. Any modification
of these entries would interrupt the verification process.

Thank you for your understanding.

Yours sincerely
Support of <?cs var:defaults.company_en ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (26, 26);


---
--- mail priority
---
INSERT INTO mail_type_priority VALUES
  ((SELECT id FROM mail_type WHERE name = 'conditional_contact_identification'), 2),
  ((SELECT id FROM mail_type WHERE name = 'contact_identification'), 2);

