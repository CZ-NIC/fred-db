---
--- Ticket #14538 Fix domain exclusion mail template
---
UPDATE mail_templates
SET template=
'The English version of the email follows the Czech version

Vážený zákazníku,

dovolujeme si Vás tímto upozornit, že jste dosud neprodloužil registraci
doménového jména <?cs var:domain ?>. Vzhledem k této skutečnosti tak na
základě Pravidel registrace doménových jmen rušíme delegaci doménového
jména a vyřazujeme Vaši doménu ze zóny <?cs var:zone ?>.

Pokud nejpozději do <?cs var:day_before_exregdate ?> neprodloužíte prostřednictvím
určeného registrátora registraci doménového jména, dojde následujícího dne
definitivně k zániku jeho registrace a toto doménové jméno bude k dispozici
pro registraci i ostatním zájemcům.

Jestliže se domníváte, že jste o prodloužení registrace domény u určeného
registrátora již žádal, neváhejte ho neprodleně kontaktovat a zjistit
příčinu, proč dosud k prodloužení registrace nedošlo. Připomínáme, že
určeného registrátora můžete kdykoliv změnit.

Co se bude dít, pokud k prodloužení nedojde:

<?cs var:exregdate ?> - Definitivní zrušení registrace doménového jména.

V této chvíli evidujeme o Vaší doméně následující údaje:

Doménové jméno: <?cs var:domain ?>
Držitel: <?cs var:owner ?>
Určený registrátor: <?cs var:registrar ?>
<?cs each:item = administrators ?>Administrativní kontakt: <?cs var:item ?>
<?cs /each ?>

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear customer,

We would like to notify you that your registrar did not extend the registration
of the domain name <?cs var:domain ?>. With regard to that fact
and in accordance with the Domain Name Registration Rules, we are
suspending the domain name registration and excluding it from the
<?cs var:zone ?> zone.

In case that by <?cs var:exregdate ?> we will not receive the payment
for extension of the domain name from your registrar, your domain name will
be definitely released for a use by another applicant on <?cs var:exregdate ?>.

In case you are interested in the domain, contact your designated registrar
<?cs var:registrar ?> and extend the domain name registration together.

If you believe that the payment was made, please, check first if the payment
was made using the correct variable symbol, to the correct account number, and
with the correct amount, and convey this information to your designated
registrar.

Schedule of planned events:

<?cs var:exregdate ?> - The final cancellation of the domain name registration.

At present, we keep the following details concerning your domain:

Domain name: <?cs var:domain ?>
Owner: <?cs var:owner ?>
Registrar: <?cs var:registrar ?>
<?cs each:item = administrators ?>Admin contact: <?cs var:item ?>
<?cs /each ?>

Yours sincerely
Support of <?cs var:defaults.company_en ?>
'
WHERE id=4;