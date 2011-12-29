---
--- Ticket #6306
---

INSERT INTO mail_type (id, name, subject) VALUES (25, 'contact_identification', 'Založení kontaktu');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(25, 'plain', 1,
'
Vážený uživateli,

tento e-mail potvrzuje úspěšné založení kontaktu s těmito údaji:

kontakt: <?cs var:handle ?>
jméno:       <?cs var:firstname ?>
příjmení:    <?cs var:lastname ?>
e-mail:      <?cs var:email ?>

Pro aktivaci Vašeho kontaktu je nutné vložit kódy PIN1 a PIN2.

PIN1: <?cs var:passwd ?>
PIN2: Vám byl zaslán <?cs if:rtype == #1 ?>pomocí SMS.<?cs elif:rtype == #2 ?>poštou.<?cs /if ?><?cs if:passwd2?>
V demo režimu není odesílání SMS a pošty aktivní. PIN2: <?cs var:passwd2 ?> <?cs /if ?><?cs if:passwd3?>
V demo režimu není odesílání SMS a pošty aktivní. PIN3: <?cs var:passwd3 ?> <?cs /if ?>

Aktivaci kontaktu proveďte kliknutím na následující odkaz:

<?cs var:url ?>?password1=<?cs var:passwd ?>

Váš tým <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (25, 25);

INSERT INTO mail_type (id, name, subject) VALUES (26, 'contact_validation', 'Validace kontaktu <?cs if:status == #1 ?>provedena<?cs else ?>neprovedena<?cs /if ?>');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(26, 'plain', 1,
'
<?cs if:status == #1 ?>
Na základě žádosti číslo <?cs var:reqid ?> ze dne <?cs var:reqdate ?> byla provedena validace kontaktu.<?cs else ?>
Váš kontakt:<?cs /if ?>

Jméno : <?cs var:name ?><?cs if:org ?>
Organizace : <?cs var:org ?><?cs /if ?><?cs if:ic ?>
IČ : <?cs var:ic ?><?cs /if ?><?cs if:birthdate ?>
Datum narození : <?cs var:birthdate ?><?cs /if ?>
Adresa : <?cs var:address ?>
<?cs if:status != #1 ?>
u kterého bylo požádáno o validaci žádostí číslo <?cs var:reqid ?> ze dne <?cs var:reqdate ?> nebyl validován.
<?cs /if ?>
Váš tým <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (26, 26);
