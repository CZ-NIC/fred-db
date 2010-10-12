---
--- messages templates
---
INSERT INTO mail_type (id, name, subject) VALUES (21, 'mojeid_identification', 'Informace k žádosti o identifikaci / Information about identification request ');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(21, 'plain', 1,
'
Ověření nového uživatele mojeID


Vážený uživateli,

    tento e-mail potvrzuje úspěšné založení mojeID s těmito údaji:

    účet mojeID: <?cs var:handle ?>
    jméno:       <?cs var:firstname ?>
    příjmení:    <?cs var:lastname ?>
    e-mail:      <?cs var:email ?>


    Pro další užívání účtu mojeID je nutné provést ověření Vaší
    totožnosti pomocí dvou kódů PIN1 a PIN2.

    <?cs if:passwd2 ?>Z důvodu zapnutého demo módu na serveru Vám zasíláme oba
    kódy PIN1 a PIN2 na email.<?cs else ?><?cs if:rtype == #1 ?>Jelikož jste zvolili ověření prostřednictvím e-mailu a SMS,
    zasíláme Vám touto cestou kód PIN1. Současně Vám zasíláme kód
    PIN2 pomocí SMS do Vašeho mobilního telefonu.<?cs elif:rtype == #2 ?>Jelikož jste zvolili ověření prostřednictvím e-mailu a dopisu,
    zasíláme Vám touto cestou kód PIN1. Současně Vám zasíláme kód
    PIN2 formou doporučeného dopisu na Vaši poštovní adresu.<?cs /if ?><?cs /if ?>

    Váš PIN1 je: <?cs var:passwd ?><?cs if:passwd2 ?>
    Váš PIN2 je: <?cs var:passwd2 ?> (demo mód)<?cs /if ?>

    <?cs if:rtype == #1 ?>Prosím klikněte na níže uvedený odkaz, který Vás přesměruje
    na stránku s ověřením:<?cs elif:rtype == #2 ?>V okamžiku, kdy získáte PIN2, klikněte prosím na níže uvedený
    odkaz, který Vás přesměruje na stránku s ověřením:<?cs /if ?>

    <?cs var:url ?>?password1=<?cs var:passwd ?>


    Přejeme Vám mnoho radosti při používání služby mojeID.


    Váš tým CZ.NIC.


                                   podpora <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (21, 21);


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



