INSERT INTO mail_template VALUES
(22, 1,
'Validace účtu mojeID <?cs if:status == #1 ?>provedena<?cs else ?>neprovedena<?cs /if ?>',
'Vážený uživateli,
<?cs if:status == #1 ?>
na základě žádosti číslo <?cs var:reqid ?> ze dne <?cs var:reqdate ?> byla provedena validace účtu mojeID.<?cs else ?>
Váš účet mojeID:<?cs /if ?>

Jméno: <?cs var:name ?><?cs if:org ?>
Organizace: <?cs var:org ?><?cs /if ?><?cs if:ic ?>
IČ: <?cs var:ic ?><?cs /if ?><?cs if:birthdate ?>
Datum narození: <?cs var:birthdate ?><?cs /if ?>
Adresa: <?cs var:address ?>
<?cs if:status != #1 ?>
u kterého bylo požádáno o validaci žádostí číslo <?cs var:reqid ?> ze dne <?cs var:reqdate ?>, nebyl validován.
<?cs /if ?>
S pozdravem
tým mojeID
', 'plain', 1, 1, 2, DEFAULT);
