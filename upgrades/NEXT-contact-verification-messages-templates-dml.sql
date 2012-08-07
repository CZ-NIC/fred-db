---
--- Ticket #6164
---

INSERT INTO mail_type (id, name, subject) VALUES (25, 'conditional_contact_identification', 'Podmíněná identifikace kontaktu');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(25, 'plain', 1,
'
Vážený uživateli,

podmíněná identifikace kontaktu s těmito údaji:

kontakt: <?cs var:handle ?>
jméno:       <?cs var:firstname ?>
příjmení:    <?cs var:lastname ?>
e-mail:      <?cs var:email ?>

Pro aktivaci Vašeho kontaktu je nutné vložit kódy PIN1 a PIN2.

PIN1: <?cs var:passwd ?>
PIN2: Vám byl zaslán pomocí SMS.<?cs if:passwd2?>
V demo režimu není odesílání SMS a pošty aktivní. PIN2: <?cs var:passwd2 ?> <?cs /if ?><?cs if:passwd3?>
V demo režimu není odesílání SMS a pošty aktivní. PIN3: <?cs var:passwd3 ?> <?cs /if ?>

Aktivaci kontaktu proveďte kliknutím na následující odkaz:

<?cs var:url ?>?handle=<?cs var:handle ?>

Váš tým <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (25, 25);



INSERT INTO mail_type (id, name, subject) VALUES (26, 'contact_identification', 'Identifikace kontaktu');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(26, 'plain', 1,
'
Vážený uživateli,

identifikace kontaktu kontaktu s těmito údaji:

kontakt: <?cs var:handle ?>
jméno:       <?cs var:firstname ?>
příjmení:    <?cs var:lastname ?>
e-mail:      <?cs var:email ?>

Pro aktivaci Vašeho kontaktu je nutné vložit kódy PIN1 a PIN2.

PIN1: <?cs var:passwd ?>
PIN2: Vám byl zaslán pomocí SMS.<?cs if:passwd2?>
V demo režimu není odesílání SMS a pošty aktivní. PIN2: <?cs var:passwd2 ?> <?cs /if ?><?cs if:passwd3?>
V demo režimu není odesílání SMS a pošty aktivní. PIN3: <?cs var:passwd3 ?> <?cs /if ?>

Aktivaci kontaktu proveďte kliknutím na následující odkaz:

<?cs var:url ?>?password1=<?cs var:passwd ?>

Váš tým <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (26, 26);

