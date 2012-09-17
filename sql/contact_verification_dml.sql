---
--- sms types
---

INSERT INTO message_type (id, type) VALUES (6, 'contact_verification_pin2');
INSERT INTO message_type (id, type) VALUES (7, 'contact_verification_pin3');

---
--- email types
---

INSERT INTO mail_type (id, name, subject) VALUES (25, 'conditional_contact_identification', 'Podmíněná identifikace kontaktu');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(25, 'plain', 1,
'
English version of the e-mail is entered below the Czech version

Vážený uživateli,

tento e-mail potvrzuje úspěšné zahájení procesu verifikace kontaktu v centrálním registru:

ID kontaktu: <?cs var:handle ?>
jméno:       <?cs var:firstname ?>
příjmení:    <?cs var:lastname ?>
e-mail:      <?cs var:email ?>

Pro dokončení prvního ze dvou kroků verifikace je nutné ověření pomocí kódů PIN1 a PIN2.

PIN1: <?cs var:passwd ?>
PIN2: Vám byl zaslán pomocí SMS.

Zadání PIN1 a PIN2 bude možné po kliknutí na následující odkaz:
https://<?cs var:hostname ?>/verification/identify/email-sms/<?cs var:identification ?>/?password1=<?cs var:passwd ?>

Váš tým <?cs var:defaults.company ?>



Dear User,

This e-mail confirms that the process of verifying your contact data in the central registry has been successfully initiated:

contact ID: <?cs var:handle ?>
first name: <?cs var:firstname ?>
last name:  <?cs var:lastname ?>
e-mail:     <?cs var:email ?>

To complete the first of the two verification steps, authorisation with your PIN1 and PIN2 codes is required.

PIN1: <?cs var:passwd ?>
PIN2: was sent to you by a text message (SMS).

You will be able to enter your PIN1 and PIN2 by following this link:
https://<?cs var:hostname ?>/verification/identify/email-sms/<?cs var:identification ?>/?password1=<?cs var:passwd ?>

Your <?cs var:defaults.company ?> team
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (25, 25);



INSERT INTO mail_type (id, name, subject) VALUES (26, 'contact_identification', 'Identifikace kontaktu');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(26, 'plain', 1,
'
English version of the e-mail is entered below the Czech version

Vážený uživateli,

první část ověření kontaktu v Centrálním registru je úspěšně za Vámi.

identifikátor: <?cs var:handle ?>
jméno:         <?cs var:firstname ?>
příjmení:      <?cs var:lastname ?>
e-mail:        <?cs var:email ?>

V nejbližších dnech ještě očekávejte zásilku s kódem PIN3, jehož pomocí 
ověříme Vaši poštovní adresu. Zadáním kódu PIN3 do formuláře na <a href=
"https://<?cs var:hostname ?>/verification/finish/?handle=<?cs var:handle ?>">této 
stránce</a> dokončíte proces ověření kontaktu.

Rádi bychom Vás také upozornili, že až do okamžiku zadání kódu PIN3 
nelze údaje v kontaktu měnit. Případná editace údajů v této fázi 
ověřovacího procesu by měla za následek jeho přerušení.

Děkujeme za pochopení.

Váš tým <?cs var:defaults.company ?>



Dear User,

The first step of the verification of the central registry contact details provided below has been successfully completed.

contact ID: <?cs var:handle ?>
first name: <?cs var:firstname ?>
last name:  <?cs var:lastname ?>
e-mail:     <?cs var:email ?>

Your PIN3 has now also been generated; you will receive it by mail within a few days at the address listed in the contact.

Verification of this contact will be complete once you enter your PIN3 into the corresponding field at this address:
https://<?cs var:hostname ?>/verification/identify/letter/?handle=<?cs var:handle ?>

Your <?cs var:defaults.company ?> team
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (26, 26);



