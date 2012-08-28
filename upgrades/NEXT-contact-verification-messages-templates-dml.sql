---
--- Ticket #6164
---

INSERT INTO mail_type (id, name, subject) VALUES (25, 'conditional_contact_identification', 'Podmíněná identifikace kontaktu');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(25, 'plain', 1,
'
Vážený uživateli,

tento e-mail potvrzuje úspěšné zahájení procesu verifikace kontaktu v centrálním registru:

ID kontaktu: <?cs var:handle ?>
jméno:       <?cs var:firstname ?>
příjmení:    <?cs var:lastname ?>
e-mail:      <?cs var:email ?>

Pro dokončení prvního ze dvou kroků verifikace je nutné ověření pomocí kódů PIN1 a PIN2.

PIN1: <?cs var:passwd ?>
PIN2: Vám byl zaslán pomocí SMS.<?cs if:passwd2?>
V demo režimu není odesílání SMS a pošty aktivní. PIN2: <?cs var:passwd2 ?> <?cs /if ?><?cs if:passwd3?>
V demo režimu není odesílání SMS a pošty aktivní. PIN3: <?cs var:passwd3 ?> <?cs /if ?>

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
Vážený uživateli,

první krok verifikace níže uvedeného kontaktu v centrálním registru je úspěšně za Vámi.

ID kontaktu: <?cs var:handle ?>
jméno:       <?cs var:firstname ?>
příjmení:    <?cs var:lastname ?>
e-mail:      <?cs var:email ?>

Současně Vám byl vygenerován PIN3, který v následujících několika dnech obdržíte poštou na adresu uvedenou v kontaktu.

Verifikaci tohoto kontaktu dokončíte zadáním PIN3 do příslušného pole na této adrese:
https://<?cs var:hostname ?>/verification/identify/letter/?handle=<?cs var:handle ?>

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

