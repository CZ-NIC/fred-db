INSERT INTO mail_template VALUES
(27, 1,
'Založení účtu mojeID',
'Vážený uživateli,

tento e-mail potvrzuje úspěšné založení účtu mojeID s těmito údaji:

účet mojeID: <?cs var:handle ?>
jméno:       <?cs var:firstname ?>
příjmení:    <?cs var:lastname ?>
e-mail:      <?cs var:email ?>

Pro aktivaci Vašeho účtu je nutné vložit kód PIN1.

PIN1: <?cs var:passwd ?>

Aktivaci účtu proveďte kliknutím na následující odkaz:

https://<?cs var:hostname ?>/identify/email/<?cs var:identification ?>/?password1=<?cs var:passwd ?>

S pozdravem
tým mojeID
', 'plain', 1, 1, 2, DEFAULT);
