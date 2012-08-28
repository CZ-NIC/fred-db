UPDATE mail_templates SET template =
'
Vážený uživateli,

tento e-mail potvrzuje úspěšné založení účtu mojeID s těmito údaji:

účet mojeID: <?cs var:handle ?>
jméno:       <?cs var:firstname ?>
příjmení:    <?cs var:lastname ?>
e-mail:      <?cs var:email ?>

Pro aktivaci Vašeho účtu je nutné vložit kódy PIN1 a PIN2.

PIN1: <?cs var:passwd ?>
PIN2: Vám byl zaslán pomocí SMS.

Aktivaci účtu proveďte kliknutím na následující odkaz:

https://<?cs var:hostname ?>/identify/email-sms/<?cs var:identification ?>/?password1=<?cs var:passwd ?>

Váš tým <?cs var:defaults.company ?>
'
WHERE id = 21;


UPDATE mail_templates SET template =
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
'
WHERE id = 27;

