---
--- messages templates
---
INSERT INTO mail_type (id, name, subject) VALUES (21, 'mojeid_identification', '[mojeID] Založení účtu - PIN1 pro aktivaci mojeID');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(21, 'plain', 1,
'
Vážený uživateli,

před tím, než Vám aktivujeme účet mojeID, musíme ověřit správnost Vašich
kontatních údajů, a to prostřednictvím kódů PIN1 a PIN2.

PIN1: <?cs var:passwd ?>
PIN2: Vám byl zaslán pomocí SMS.

Do formuláře pro zadání těchto kódů budete přesměrováni po kliknutí na
následující odkaz:

https://<?cs var:hostname ?>/identify/email-sms/<?cs var:identification ?>/?password1=<?cs var:passwd ?>

Po úspěšném odeslání formuláře budete moci začít Váš účet mojeID používat.
Zároveň Vám pošleme poštou dopis s kódem PIN3, po jehož zadání bude Váš
účet plně aktivní.

Základní údaje o Vašem účtu:

účet mojeID: <?cs var:handle ?>
jméno:       <?cs var:firstname ?>
příjmení:    <?cs var:lastname ?>
e-mail:      <?cs var:email ?>

Váš tým <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (21, 21);

INSERT INTO mail_type (id, name, subject) VALUES (22, 'mojeid_validation', 'Validace účtu mojeID <?cs if:status == #1 ?>provedena<?cs else ?>neprovedena<?cs /if ?>');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(22, 'plain', 1,
'
<?cs if:status == #1 ?>
Na základě žádosti číslo <?cs var:reqid ?> ze dne <?cs var:reqdate ?> byla provedena validace účtu mojeID.<?cs else ?>
Váš účet mojeID:<?cs /if ?>

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
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (22, 22);

INSERT INTO mail_type (id, name, subject) VALUES (24, 'mojeid_email_change', 'MojeID - změna emailu');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(24, 'plain', 1,
'Vážený uživateli,

k dokončení procedury změny emailu zadejte prosím kód PIN1: <?cs var:pin ?>

Váš tým CZ.NIC');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (24, 24);

INSERT INTO mail_type (id, name, subject) VALUES (27, 'mojeid_verified_contact_transfer', 'Založení účtu mojeID');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(27, 'plain', 1,
'
Vážený uživateli,

tento e-mail potvrzuje úspěšné založení účtu mojeID s těmito údaji:

účet mojeID: <?cs var:handle ?>
jméno:       <?cs var:firstname ?>
příjmení:    <?cs var:lastname ?>
e-mail:      <?cs var:email ?>

Pro aktivaci Vašeho účtu je nutné vložit kód PIN1.

PIN1: <?cs var:passwd ?>

Aktivaci účtu proveďte kliknutím na následující odkaz:

https://<?cs var:hostname ?>/identify/email/<?cs var:identification ?>/?password1=<?cs var:passwd ?>

Váš tým <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (27, 27);


---
--- sms types
---
INSERT INTO message_type (id, type) VALUES (2, 'mojeid_pin2');
INSERT INTO message_type (id, type) VALUES (3, 'mojeid_pin3');
INSERT INTO message_type (id, type) VALUES (4, 'mojeid_sms_change');
INSERT INTO message_type (id, type) VALUES (8, 'mojeid_pin3_reminder');

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
INSERT INTO enum_object_states VALUES (24,'mojeidContact','{1}','t','t');

INSERT INTO enum_object_states_desc VALUES (21, 'CS', 'Kontakt je podmínečně identifikován');
INSERT INTO enum_object_states_desc VALUES (21, 'EN', 'Contact is conditionally identified');
INSERT INTO enum_object_states_desc VALUES (22, 'CS', 'Kontakt je identifikován');
INSERT INTO enum_object_states_desc VALUES (22, 'EN', 'Contact is identified');
INSERT INTO enum_object_states_desc VALUES (23, 'CS', 'Kontakt je validován');
INSERT INTO enum_object_states_desc VALUES (23, 'EN', 'Contact is validated');
INSERT INTO enum_object_states_desc VALUES (24, 'CS', 'MojeID kontakt');
INSERT INTO enum_object_states_desc VALUES (24, 'EN', 'MojeID contact');


---
--- mail priority
---
INSERT INTO mail_type_priority VALUES
  ((SELECT id FROM mail_type WHERE name = 'mojeid_identification'), 1),
  ((SELECT id FROM mail_type WHERE name = 'mojeid_validation'), 1),
  ((SELECT id FROM mail_type WHERE name = 'mojeid_email_change'), 1),
  ((SELECT id FROM mail_type WHERE name = 'mojeid_verified_contact_transfer'), 1);

