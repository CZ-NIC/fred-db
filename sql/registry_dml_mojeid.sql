---
--- messages templates
---
INSERT INTO mail_type (id, name, subject) VALUES (21, 'mojeid_identification', 'Založení účtu mojeID');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(21, 'plain', 1,
'
Vážený uživateli,

tento e-mail potvrzuje úspěšné založení účtu mojeID s těmito údaji:

účet mojeID: <?cs var:handle ?>
jméno:       <?cs var:firstname ?>
příjmení:    <?cs var:lastname ?>
e-mail:      <?cs var:email ?>

Pro aktivaci Vašeho účtu je nutné vložit kódy PIN1 a PIN2.

PIN1: <?cs var:passwd ?>
PIN2: Vám byl zaslán <?cs if:rtype == #1 ?>pomocí SMS.<?cs elif:rtype == #2 ?>poštou.<?cs /if ?><?cs if:passwd2?>
V demo režimu není odesílání SMS a pošty aktivní. PIN2: <?cs var:passwd2 ?> <?cs /if ?><?cs if:passwd3?>
V demo režimu není odesílání SMS a pošty aktivní. PIN3: <?cs var:passwd3 ?> <?cs /if ?>

Aktivaci účtu proveďte kliknutím na následující odkaz:

<?cs var:url ?>?password1=<?cs var:passwd ?>

Váš tým <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (21, 21);

INSERT INTO mail_type (id, name, subject) VALUES (22, 'mojeid_validation', 'Validace účtu mojeID <?cs if:status == #1 ?>provedena<?cs else ?>neprovedena<?cs /if ?>');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(22, 'plain', 1,
'
<?cs if:status == #1 ?>
Na základě žádosti číslo <?cs var:reqid ?> ze dne <?cs var:reqdate ?> byla provedena validace účtu mojeID.
<?cs else ?>
Váš účet mojeID:
<?cs /if ?>

Jméno : <?cs var:name ?><?cs if:org ?>
Organizace : <?cs var:org ?><?cs /if ?><?cs if:ic ?>
IČ : <?cs var:ic ?><?cs /if ?><?cs if:birthdate ?>
Datum narození : <?cs var:birtdate ?><?cs /if ?>
Adresa : <?cs var:address ?>

<?cs if:status != #1 ?>u kterého bylo požádáno o validaci žádostí číslo <?cs var:reqid ?> ze dne <?cs var:reqdate ?> nebyl validován.
<?cs /if ?>

Váš tým <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (22, 22);


---
--- file types
---
INSERT INTO enum_filetype (id, name) VALUES (7, 'mojeid contact identification request');


---
--- contact states
---
INSERT INTO enum_object_states VALUES (21,'conditionallyIdentifiedContact','{1}','t','t');
INSERT INTO enum_object_states VALUES (22,'identifiedContact','{1}','t','t');
INSERT INTO enum_object_states VALUES (23,'validatedContact','{1}','t','t');

INSERT INTO enum_object_states_desc VALUES (21, 'CS', 'Kontakt je podmínečně identifikován');
INSERT INTO enum_object_states_desc VALUES (21, 'EN', 'Contact is conditionally identified');
INSERT INTO enum_object_states_desc VALUES (22, 'CS', 'Kontakt je identifikován');
INSERT INTO enum_object_states_desc VALUES (22, 'EN', 'Contact is identified');
INSERT INTO enum_object_states_desc VALUES (23, 'CS', 'Kontakt je validován');
INSERT INTO enum_object_states_desc VALUES (23, 'EN', 'Contact is validated');



