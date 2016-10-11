DELETE FROM mail_defaults WHERE name = 'fax';

UPDATE mail_footer SET footer =
'--
<?cs var:defaults.company ?>
<?cs var:defaults.street ?>
<?cs var:defaults.postalcode ?> <?cs var:defaults.city ?>
---------------------------------
tel.: <?cs var:defaults.tel ?>
e-mail : <?cs var:defaults.emailsupport ?>
---------------------------------
' WHERE id = 1;

UPDATE mail_vcard SET vcard = 
'BEGIN:VCARD
VERSION:2.1
N:podpora CZ.NIC, z. s. p. o.
FN:podpora CZ.NIC, z. s. p. o.
ORG:CZ.NIC, z. s. p. o.
TITLE:zákaznická podpora
TEL;WORK;VOICE:+420 222 745 111
ADR;WORK:;;Milešovská 1136/5;Praha 3;;130 00;Česká republika
URL;WORK:http://www.nic.cz
EMAIL;PREF;INTERNET:podpora@nic.cz
REV:20150818T150541Z
END:VCARD
';
