INSERT INTO mail_template VALUES
(9, 1, 'Oznámení o vypršení validace domény ENUM <?cs var:domain ?> / Notification of expiration of the ENUM domain <?cs var:domain ?> validation',
'Vážený zákazníku,

dovolujeme si Vás upozornit, že k <?cs var:checkdate ?> dosud nedošlo k prodloužení
validace doménového jména <?cs var:domain ?>. Vzhledem k této skutečnosti
a na základě Pravidel registrace doménových jmen ji vyřazujeme ze zóny.
Doménové jméno je i nadále registrováno. V případě, že
hodláte obnovit validaci uvedeného doménového jména, kontaktujte prosím svého
registrátora a ve spolupráci s ním zajistěte prodloužení validace
doménového jména.

V této chvíli evidujeme o doméně následující údaje:

Doménové jméno: <?cs var:domain ?>
Držitel: <?cs var:owner ?>
Registrátor: <?cs var:registrar ?>
<?cs each:item = administrators ?>Administrativní kontakt: <?cs var:item ?>
<?cs /each ?>

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear customer,

We would like to notify you that as of <?cs var:checkdate ?>,
the <?cs var:domain ?> domain name validation has not been extended.
With regard to this fact and in accordance with the Domain Name Registration Rules,
we are excluding it from the zone. The domain
name remains registered. If you plan to renew validation of the
aforementioned domain name, please, contact your registrar, and
perform the extension of validation of your domain name together.

At present, we keep the following details concerning your domain:

Domain name: <?cs var:domain ?>
Owner: <?cs var:owner ?>
Registrar: <?cs var:registrar ?>
<?cs each:item = administrators ?>Admin contact: <?cs var:item ?>
<?cs /each ?>

Yours sincerely
Support of <?cs var:defaults.company_en ?>
', 'plain', 1, 1, 1, DEFAULT);
