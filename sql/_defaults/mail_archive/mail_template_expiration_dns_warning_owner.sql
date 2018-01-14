INSERT INTO mail_template VALUES
(31, 1,
'Upozornění na blížící se vyřazení domény <?cs var:domain ?> z DNS / Notification on the oncoming exclusion of the <?cs var:domain ?> domain from DNS',
'The English version of the email follows the Czech version

Vážený zákazníku,

dovolujeme si Vás tímto upozornit, že jste dosud neprodloužil registraci
doménového jména <?cs var:domain ?>. Vzhledem k této skutečnosti tak na
základě Pravidel registrace doménových jmen rušíme ke dni <?cs var:dnsdate ?>
delegaci doménového jména a vyřazujeme Vaši doménu ze zóny <?cs var:zone ?>.

Pokud nejpozději do <?cs var:day_before_exregdate ?> neprodloužíte prostřednictvím
určeného registrátora registraci doménového jména, dojde následujícího dne
definitivně k zániku jeho registrace a toto doménové jméno bude k dispozici
pro registraci i ostatním zájemcům.

Jestliže se domníváte, že jste o prodloužení registrace domény u určeného
registrátora již žádal, neváhejte ho neprodleně kontaktovat a zjistit
příčinu, proč dosud k prodloužení registrace nedošlo. Připomínáme, že
určeného registrátora můžete kdykoliv změnit.

Co se bude dít, pokud k prodloužení nedojde:

<?cs var:dnsdate ?> - Znefunkčnění doménového jména (vyřazení z DNS).
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

We would like to notify you that you still have not extended the registration
of the domain name <?cs var:domain ?>. With regard to that fact
and in accordance with the Domain Name Registration Rules, we are
suspending the domain name registration and excluding it from the
<?cs var:zone ?> zone on <?cs var:dnsdate ?>.

Unless you extend the registration of your domain name through your
designated registrar by <?cs var:day_before_exregdate ?>,
the registration will be cancelled definitely
and your domain name will be released for use by another applicant.

If you believe that you have already asked your designated registrar
to extend the registration, do not hesitate to contact them again
and find out why the extension has not occurred. Let us remind you
that you can switch to another registrar any time.

What is going to happen unless the domain is extended:

<?cs var:dnsdate ?> - The domain name will become inaccessible (exclusion from DNS).
<?cs var:exregdate ?> - The final cancellation of the domain name registration.

At present, we keep the following details concerning your domain:

Domain name: <?cs var:domain ?>
Owner: <?cs var:owner ?>
Designated registrar: <?cs var:registrar ?>
<?cs each:item = administrators ?>Administrative contact: <?cs var:item ?>
<?cs /each ?>

Yours sincerely
Support of <?cs var:defaults.company_en ?>
', 'plain', 1, 1, 1, DEFAULT);
