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
https://<?cs var:hostname ?>/verification/identification/<?cs var:identification ?>/?password1=<?cs var:passwd ?>

Váš tým <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (25, 25);



INSERT INTO mail_type (id, name, subject) VALUES (26, 'contact_identification', 'Identifikace kontaktu');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(26, 'plain', 1,
'
Vážený uživateli,

pro dokončení procesu verifikace kontaktu s následujícími údaji

ID kontaktu: <?cs var:handle ?>
jméno:       <?cs var:firstname ?>
příjmení:    <?cs var:lastname ?>
e-mail:      <?cs var:email ?>

<?cs if:passwd3?>
budete potřebovat tento kód PIN3: <?cs var:passwd3 ?>
<?cs /if ?>

Navštivte prosím adresu https://<?cs var:hostname ?>/verification/finish/?handle=<?cs var:handle ?> a zadejte PIN3 do příslušného pole.

Váš tým <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (26, 26);



