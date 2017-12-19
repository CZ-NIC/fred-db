---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.21.6' WHERE id = 1;

---
--- Ticket #13425
---

---
--- From contact_verification_dml.sql
---

UPDATE mail_type SET subject = 'Podmíněná identifikace kontaktu / Conditional contact identification' WHERE id = 25;
UPDATE mail_templates SET template =
'Vážený uživateli,

tento e-mail potvrzuje úspěšné zahájení procesu ověření kontaktu v Centrálním registru:

ID kontaktu: <?cs var:handle ?>
jméno:       <?cs var:firstname ?>
příjmení:    <?cs var:lastname ?>
e-mail:      <?cs var:email ?>

Pro dokončení prvního ze dvou kroků ověření je nutné zadat kódy PIN1 a PIN2.

PIN1: <?cs var:passwd ?>
PIN2: Vám byl zaslán pomocí SMS.

Zadání PIN1 a PIN2 bude možné po kliknutí na následující odkaz:
https://<?cs var:hostname ?>/verification/identify/email-sms/<?cs var:identification ?>/?password1=<?cs var:passwd ?>

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear user,

This email confirms that the process of verifying your contact data in the Central Registry has been successfully initiated:

contact ID: <?cs var:handle ?>
first name: <?cs var:firstname ?>
last name:  <?cs var:lastname ?>
email:      <?cs var:email ?>

To complete the first of the two verification steps, authorisation with your PIN1 and PIN2 codes is required.

PIN1: <?cs var:passwd ?>
PIN2: was sent to you in a text message (SMS).

You will be able to enter your PIN1 and PIN2 by following this link:
https://<?cs var:hostname ?>/verification/identify/email-sms/<?cs var:identification ?>/?password1=<?cs var:passwd ?>

Yours sincerely
Support of <?cs var:defaults.company_en ?>
' WHERE id = 25;


UPDATE mail_type SET subject = 'Identifikace kontaktu / Contact identification' WHERE id = 26;
UPDATE mail_templates SET template =
'Vážený uživateli,

úspěšně jste dokončil(a) první část ověření svého kontaktu
v Centrálním registru s následujícími údaji.

identifikátor: <?cs var:handle ?>
jméno:         <?cs var:firstname ?>
příjmení:      <?cs var:lastname ?>
e-mail:        <?cs var:email ?>

Zároveň Vám byl vygenerován a odeslán poštou kód PIN3, který obdržíte
v nejbližších dnech. Ověření kontaktu dokončíte zadáním kódu PIN3 na stránce
https://<?cs var:hostname ?>/verification/identify/letter/?handle=<?cs var:handle ?>

Rádi bychom Vám také připomněli, že až do okamžiku zadání kódu PIN3
nelze v kontaktu měnit jméno, organizaci, e-mail, telefon ani adresu.
Případná editace těchto údajů v této fázi ověřovacího procesu by měla
za následek jeho přerušení.

Děkujeme za pochopení.

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear user,

You have successfully completed the first step of verification
of your contact in the Central registry using the following data.

contact ID: <?cs var:handle ?>
first name: <?cs var:firstname ?>
last name:  <?cs var:lastname ?>
e-mail:     <?cs var:email ?>

We have also sent you a letter containing your PIN3 and you will receive it
in a few days. To complete your contact verification, submit your PIN3 on the page
https://<?cs var:hostname ?>/verification/identify/letter/?handle=<?cs var:handle ?>

Please, be aware that you should not change contact name, organization, email,
phone or address of the contact before you submit the PIN3. Any modification
of these entries would interrupt the verification process.

Thank you for your understanding.

Yours sincerely
Support of <?cs var:defaults.company_en ?>
' WHERE id = 26;


---
--- From mail_notify.sql
---

UPDATE mail_defaults SET value = 'CZ.NIC, z. s. p. o.' WHERE name = 'company';
INSERT INTO mail_defaults (name, value) VALUES ('company_cs', 'CZ.NIC, správce domény CZ');
INSERT INTO mail_defaults (name, value) VALUES ('company_en', 'CZ.NIC, the CZ domain registry');

UPDATE mail_vcard SET vcard =
'BEGIN:VCARD
VERSION:2.1
N:podpora CZ.NIC, z. s. p. o.
FN:podpora CZ.NIC, z. s. p. o.
ORG:CZ.NIC, z. s. p. o.
TITLE:zákaznická podpora
TEL;WORK;VOICE:+420 222 745 111
TEL;WORK;FAX:+420 222 745 112
ADR;WORK:;;Milešovská 1136/5;Praha 3;;130 00;Česká republika
URL;WORK:http://www.nic.cz
EMAIL;PREF;INTERNET:podpora@nic.cz
REV:20150818T150541Z
END:VCARD
' WHERE id = 1;

UPDATE mail_header_defaults SET h_organization = 'CZ.NIC, z. s. p. o.' WHERE h_organization = 'CZ.NIC, z.s.p.o.';


---
--- From mail_templates.sql
---

UPDATE mail_templates SET template =
'Vážený zákazníku,

na základě Vaší žádosti podané prostřednictvím webového formuláře
na našich stránkách dne <?cs var:reqdate ?>, které
bylo přiděleno identifikační číslo <?cs var:reqid ?>, Vám zasíláme požadované
heslo příslušející <?cs if:type == #3 ?>k doméně<?cs elif:type == #1 ?>ke kontaktu s identifikátorem<?cs elif:type == #2 ?>k sadě nameserverů s identifikátorem<?cs elif:type == #4 ?>k sadě klíčů s identifikátorem<?cs /if ?> <?cs var:handle ?>.

Heslo je: <?cs var:authinfo ?>

V případě, že jste tuto žádost nepodali, oznamte nám prosím tuto
skutečnost na adresu <?cs var:defaults.emailsupport ?>.

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear customer,

Based on your request submitted via the web form on our pages on
<?cs var:reqdate ?>, which was assigned
the identification number <?cs var:reqid ?>, we are sending you the requested
password belonging to the <?cs if:type == #3 ?>domain name<?cs elif:type == #1 ?>contact identified with<?cs elif:type == #2 ?>NS set identified with<?cs elif:type == #4 ?>keyset identified with<?cs /if ?> <?cs var:handle ?>.

The password is: <?cs var:authinfo ?>

If you did not submit the aforementioned request, please notify us of
this fact at the address <?cs var:defaults.emailsupport ?>.

Yours sincerely
Support of <?cs var:defaults.company_en ?>
' WHERE id = 1;

UPDATE mail_templates SET template =
'Vážený zákazníku,

na základě Vaší žádosti, podané prostřednictvím registrátora
<?cs var:registrar ?>, Vám zasíláme požadované heslo
příslušející <?cs if:type == #3 ?>k doméně<?cs elif:type == #1 ?>ke kontaktu s identifikátorem<?cs elif:type == #2 ?>k sadě nameserverů s identifikátorem<?cs elif:type == #4 ?>k sadě klíčů s identifikátorem<?cs /if ?> <?cs var:handle ?>.

Heslo je: <?cs var:authinfo ?>

Tato zpráva je zaslána pouze na e-mailovou adresu uvedenou u příslušné
osoby v Centrálním registru doménových jmen.

V případě, že jste tuto žádost nepodali, oznamte nám prosím tuto
skutečnost na adresu <?cs var:defaults.emailsupport ?>.

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear customer,

Based on your request submitted via the registrar <?cs var:registrar ?>,
we are sending you the requested password belonging to
the <?cs if:type == #3 ?>domain name<?cs elif:type == #1 ?>contact identified with<?cs elif:type == #2 ?>NS set identified with<?cs elif:type == #4 ?>keyset identified with<?cs /if ?> <?cs var:handle ?>.

The password is: <?cs var:authinfo ?>

This message is being sent only to the e-mail address of the relevant person that we have on file in the Central Registry of Domain Names.

If you did not submit the aforementioned request, please notify us of this fact at the address <?cs var:defaults.emailsupport ?>.

Yours sincerely
Support of <?cs var:defaults.company_en ?>
' WHERE id = 2;

UPDATE mail_type SET subject = 'Upozornění na nutnost úhrady domény <?cs var:domain ?> / Reminder to settle fees for the <?cs var:domain ?> domain' WHERE id = 3;
UPDATE mail_templates SET template =
'The English version of the email follows the Czech version

Vážený zákazníku,

dovolujeme si Vás upozornit, že k <?cs var:checkdate ?> dosud Váš registrátor neprodloužil
platnost doménového jména <?cs var:domain ?>. Vzhledem k tomu, že doménové
jméno bylo za uplynulé období zaplaceno pouze do <?cs var:exdate ?>, nachází se
nyní v takzvané ochranné lhůtě. V případě, že platba za doménové jméno nebude včas
uhrazena, budou v souladu s Pravidly registrace doménových jmen následovat
tyto kroky:

<?cs var:dnsdate ?> - Znefunkčnění doménového jména (vyřazení z DNS).
<?cs var:exregdate ?> - Definitivní zrušení registrace doménového jména.

V této chvíli evidujeme o doméně následující údaje:

Doménové jméno: <?cs var:domain ?>
Držitel: <?cs var:owner ?>
Registrátor: <?cs var:registrar ?>
<?cs each:item = administrators ?>Administrativní kontakt: <?cs var:item ?>
<?cs /each ?>

V této situaci máte následující možnosti:

1. Kontaktujte prosím svého registrátora a ve spolupráci s ním zajistěte
   prodloužení registrace doménového jména,

2. nebo si v seznamu na našich stránkách (https://www.nic.cz/whois/registrars/list/)
   vyberte jiného určeného registrátora a jeho prostřednictvím zajistěte
   prodloužení registrace doménového jména.

3. Za prodloužení platnosti domény neplaťte, doména bude zrušena automaticky
   ve stanoveném termínu.

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear customer,

We would like to inform you that as of <?cs var:checkdate ?>, your registrar
did not extend the registration of the domain name <?cs var:domain ?>. Concerning
the fact that the fee for the domain name in question has been paid only
for a period ending on <?cs var:exdate ?>, your domain name has now entered
the so-called protection period. Unless a registrar of your choice extends
your registration, the following steps will be adopted in accordance with
the Domain Name Registration Rules:

<?cs var:dnsdate ?> - The domain name will become inaccessible (exclusion from DNS).
<?cs var:exregdate ?> - The final cancellation of the domain name registration.

At present, we keep the following details concerning your domain:

Domain name: <?cs var:domain ?>
Holder: <?cs var:owner ?>
Registrar: <?cs var:registrar ?>
<?cs each:item = administrators ?>Admin contact: <?cs var:item ?>
<?cs /each ?>

To remedy the existing situation, you can choose one of the following:

1. Please contact your registrar and make sure that the registration
   of your domain name is duly extended;

2. Or choose another registrar from those listed on our pages (https://www.nic.cz/whois/registrars/list/)
   in order to extend the registration of your domain name;

3. Or do not pay for the extension of the domain registration, the domain
   will be cancelled on the specified date.

Yours sincerely
Support of <?cs var:defaults.company_en ?>
' WHERE id = 3;


UPDATE mail_type SET subject = 'Oznámení o vyřazení domény <?cs var:domain ?> z DNS / Notification of the <?cs var:domain ?> domain exclusion from DNS' WHERE id = 4;
UPDATE mail_templates SET template =
'The English version of the email follows the Czech version

Vážený zákazníku,

dovolujeme si Vás tímto upozornit, že Váš registrátor dosud neprodloužil
platnost doménového jména <?cs var:domain ?>. Vzhledem k této
skutečnosti a na základě Pravidel registrace doménových jmen
pozastavujeme registraci doménového jména a vyřazujeme
doménu ze zóny <?cs var:zone ?>.

V případě, že do dne <?cs var:exregdate ?> neobdržíme od Vašeho
registrátora platbu za prodloužení platnosti doménového jména, bude
doménové jméno definitivně uvolněno pro použití dalším zájemcem, a to
ke dni <?cs var:exregdate ?>.

V případě zájmu o doménu kontaktujte svého určeného registrátora <?cs var:registrar ?>
a platnost domény s ním prodlužte.

Pokud se domníváte, že platba byla provedena, prověřte nejdříve,
zda byla provedena pod správným variabilním symbolem, na správné číslo
účtu a ve správné výši, a tyto informace svému určenému registrátorovi
sdělte.

Harmonogram plánovaných akcí:

<?cs var:exregdate ?> - Definitivní zrušení registrace doménového jména.

V této chvíli evidujeme o doméně následující údaje:

Doménové jméno: <?cs var:domain ?>
Držitel: <?cs var:owner ?>
Registrátor: <?cs var:registrar ?>
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
' WHERE id = 4;


UPDATE mail_type SET subject = 'Oznámení o zrušení domény <?cs var:domain ?> / Notification of the <?cs var:domain ?> domain cancellation' WHERE id = 5;
UPDATE mail_templates SET template =
'Vážený zákazníku,

dovolujeme si Vás upozornit, že Váš registrátor neprodloužil platnost registrace
doménového jména <?cs var:domain ?>. Vzhledem k této skutečnosti
a na základě Pravidel registrace doménových jmen rušíme registraci
tohoto doménového jména.

V případě zájmu o opětovnou registraci domény prosím kontaktujte jakéhokoli registrátora ze seznamu na našich stránkách (https://www.nic.cz/whois/registrars/list/).

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear customer,

we would like to inform you that your registrar has not extended the registration
of the domain name <?cs var:domain ?>. Due to this fact and based on the Domain Name Registration Rules, we are cancelling the registration of this domain name.

If you are interested in the registration of the domain again, please contact any registrar listed
on our pages (https://www.nic.cz/whois/registrars/list/).

Yours sincerely
Support of <?cs var:defaults.company_en ?>
' WHERE id = 5;

UPDATE mail_type SET subject = 'Oznámení o vyřazení domény <?cs var:domain ?> z DNS / Notification of the <?cs var:domain ?> domain exclusion from DNS' WHERE id = 6;
UPDATE mail_templates SET template =
'Vážený zákazníku,

vzhledem k tomu, že jste veden jako technický kontakt u sady nameserverů
<?cs var:nsset ?>, která je přiřazena k doménovému jménu <?cs var:domain ?>,
dovolujeme si Vás upozornit, že toto doménové jméno bylo ke dni
<?cs var:statechangedate ?> vyřazeno z DNS.

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear customer,

With regard to the fact that you are stated as the technical contact for the set
<?cs var:nsset ?> of nameservers assigned to the <?cs var:domain ?>
domain name, we would like to notify you that the aforementioned domain name
was excluded from DNS as of <?cs var:statechangedate ?>.

Yours sincerely
Support of <?cs var:defaults.company_en ?>
' WHERE id = 6;

UPDATE mail_type SET subject = 'Oznámení o zrušení domény <?cs var:domain ?> / Notification of the <?cs var:domain ?> domain cancellation' WHERE id = 7;
UPDATE mail_templates SET template =
'Vážený zákazníku,

vzhledem k tomu, že jste vedený jako technický kontakt u sady nameserverů
<?cs var:nsset ?>, která je přiřazena k doménovému jménu <?cs var:domain ?>,
dovolujeme si Vás upozornit, že toto doménové jméno bylo ke dni
<?cs var:exregdate ?> zrušeno.

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear customer,

With regard to the fact that you are stated as the technical contact for the set
<?cs var:nsset ?> of nameservers assigned to the <?cs var:domain ?>
domain name, we would like to notify you that the aforementioned domain name
was cancelled as of <?cs var:exregdate ?>.

Yours sincerely
Support of <?cs var:defaults.company_en ?>
' WHERE id = 7;

UPDATE mail_type SET subject = 'Oznámení vypršení validace domény ENUM <?cs var:domain ?> / Notification of expiration of the ENUM domain <?cs var:domain ?> validation' WHERE id = 8;
UPDATE mail_templates SET template =
'Vážený zákazníku,

dovolujeme si Vás upozornit, že k <?cs var:checkdate ?> dosud nedošlo k prodloužení
validace doménového jména <?cs var:domain ?>, která je platná do <?cs var:valdate ?>.
V případě, že hodláte obnovit validaci uvedeného doménového jména, kontaktujte
prosím svého registrátora a ve spolupráci s ním zajistěte prodloužení validace
doménového jména před tímto datem.

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
The validation will expire on <?cs var:valdate ?>. If you plan to renew validation
of the aforementioned domain name, please, contact your registrar, and
perform the extension of validation of your domain name together before
this date.

At present, we keep the following details concerning your domain:

Domain name: <?cs var:domain ?>
Owner: <?cs var:owner ?>
Registrar: <?cs var:registrar ?>
<?cs each:item = administrators ?>Admin contact: <?cs var:item ?>
<?cs /each ?>

Yours sincerely
Support of <?cs var:defaults.company_en ?>
' WHERE id = 8;

UPDATE mail_type SET subject = 'Oznámení o vypršení validace domény ENUM <?cs var:domain ?> / Notification of expiration of the ENUM domain <?cs var:domain ?> validation' WHERE id = 9;
UPDATE mail_templates SET template =
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
' WHERE id = 9;

UPDATE mail_templates SET template =
'<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs elif:lang == "ensmall" ?><?cs if:type == #3 ?>domain<?cs elif:type == #1 ?>contact<?cs elif:type == #2 ?>nsset<?cs elif:type == #4 ?>keyset<?cs /if ?><?cs /if ?><?cs /def ?>
======================================================================
Oznámení o registraci / Notification of registration
======================================================================
Registrace <?cs call:typesubst("cs") ?> / <?cs call:typesubst("en") ?> creation
Identifikátor <?cs call:typesubst("cs") ?> / <?cs call:typesubst("en") ?> handle : <?cs var:handle ?>
Číslo žádosti / Ticket :  <?cs var:ticket ?>
Registrátor / Registrar : <?cs var:registrar ?>
======================================================================

Vážený zákazníku,
Dear customer,

žádost byla úspěšně zpracována, požadovaná registrace byla provedena. 
The request was processed successfully, the required registration
has been performed.<?cs if:type == #3 ?>

Při každé změně doporučujeme aktualizovat údaje o doméně, vyhnete se
tak možným problémům souvisejícím s prodlužováním platnosti či manipulací
s doménou osobami, které již nejsou oprávněny je provádět.
We recommend updating domain data in the registry after every change
to avoid possible problems with domain renewal or with domain manipulation
done by persons who are not authorized anymore.<?cs /if ?>

Detaily <?cs call:typesubst("cs") ?> najdete na <?cs var:defaults.whoispage ?>?q=<?cs var:handle ?>
Details of <?cs call:typesubst("ensmall") ?> can be seen at <?cs var:defaults.whoispage ?>?q=<?cs var:handle ?>

S pozdravem / Yours sincerely
podpora <?cs var:defaults.company_cs ?> / Support of <?cs var:defaults.company_en ?>
' WHERE id = 10;

UPDATE mail_templates SET template =
'<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs elif:lang == "ensmall" ?><?cs if:type == #3 ?>domain<?cs elif:type == #1 ?>contact<?cs elif:type == #2 ?>nsset<?cs elif:type == #4 ?>keyset<?cs /if ?><?cs /if ?><?cs /def ?>

<?cs def:print_value(which, varname) ?><?cs if:which == "old" ?><?cs set:lvarname = varname.old ?><?cs elif:which == "new" ?><?cs set:lvarname = varname.new ?><?cs /if ?><?cs alt:lvarname ?><?cs if:which == "old" ?>hodnota nenastavena / value not set<?cs elif:which == "new" ?>hodnota smazána / value deleted<?cs /if ?><?cs /alt ?><?cs /def ?>
<?cs def:print_value_bool(which, varname, if_true, if_false) ?><?cs if:which == "old" ?><?cs set:lvarname = varname.old ?><?cs elif:which == "new" ?><?cs set:lvarname = varname.new ?><?cs /if ?><?cs if:lvarname == "1" ?><?cs var:if_true ?><?cs elif:lvarname == "0" ?><?cs var:if_false ?><?cs /if ?><?cs /def ?>
<?cs def:print_value_list(which, varname, itemname) ?><?cs set:count = #1 ?><?cs each:item = varname ?><?cs var:itemname ?> <?cs var:count ?>: <?cs call:print_value(which, item) ?><?cs set:count = count + #1 ?>
<?cs /each ?><?cs /def ?>

<?cs def:value_list(which) ?><?cs if:changes.object.authinfo ?>Heslo / Authinfo: <?cs if:which == "old" ?>důvěrný údaj / private value<?cs elif:which == "new" ?>hodnota byla změněna / value was changed<?cs /if ?>
<?cs /if ?><?cs if:type == #1 ?><?cs if:changes.contact.name ?>Jméno / Name: <?cs call:print_value(which, changes.contact.name) ?>
<?cs /if ?><?cs if:changes.contact.org ?>Organizace / Organization: <?cs call:print_value(which, changes.contact.org) ?>
<?cs /if ?><?cs if:changes.contact.address ?>Adresa / Address: <?cs call:print_value(which, changes.contact.address) ?>
<?cs /if ?><?cs if:changes.contact.telephone ?>Telefon / Telephone: <?cs call:print_value(which, changes.contact.telephone) ?>
<?cs /if ?><?cs if:changes.contact.fax ?>Fax / Fax: <?cs call:print_value(which, changes.contact.fax) ?>
<?cs /if ?><?cs if:changes.contact.email ?>E-mail / Email: <?cs call:print_value(which, changes.contact.email) ?>
<?cs /if ?><?cs if:changes.contact.notify_email ?>Notifikační e-mail / Notification email: <?cs call:print_value(which, changes.contact.notify_email) ?>
<?cs /if ?><?cs if:changes.contact.ident_type ?>Typ identifikace / Identification type: <?cs call:print_value(which, changes.contact.ident_type) ?>
<?cs /if ?><?cs if:changes.contact.ident ?>Identifikační údaj / Identification data: <?cs call:print_value(which, changes.contact.ident) ?>
<?cs /if ?><?cs if:changes.contact.vat ?>DIČ / VAT number: <?cs call:print_value(which, changes.contact.vat) ?>
<?cs /if ?><?cs if:subcount(changes.contact.disclose) > #0 ?>Viditelnost údajů / Data visibility:
<?cs if:changes.contact.disclose.name ?>  Jméno / Name: <?cs call:print_value_bool(which, changes.contact.disclose.name, "veřejné / public", "skryté / hidden") ?>
<?cs /if ?><?cs if:changes.contact.disclose.org ?>  Organizace / Organization: <?cs call:print_value_bool(which, changes.contact.disclose.org, "veřejná / public", "skrytá / hidden") ?>
<?cs /if ?><?cs if:changes.contact.disclose.email ?>  E-mail / Email: <?cs call:print_value_bool(which, changes.contact.disclose.email, "veřejný / public", "skrytý / hidden") ?>
<?cs /if ?><?cs if:changes.contact.disclose.address ?>  Adresa / Address: <?cs call:print_value_bool(which, changes.contact.disclose.address, "veřejná / public", "skrytá / hidden") ?>
<?cs /if ?><?cs if:changes.contact.disclose.notify_email ?>  Notifikační e-mail / Notification email: <?cs call:print_value_bool(which, changes.contact.disclose.notify_email, "veřejný / public", "skrytý / hidden") ?>
<?cs /if ?><?cs if:changes.contact.disclose.ident ?>  Identifikační údaj / Identification data: <?cs call:print_value_bool(which, changes.contact.disclose.ident, "veřejný / public", "skrytý / hidden") ?>
<?cs /if ?><?cs if:changes.contact.disclose.vat ?>  DIČ / VAT number: <?cs call:print_value_bool(which, changes.contact.disclose.vat, "veřejné / public", "skryté / hidden") ?>
<?cs /if ?><?cs if:changes.contact.disclose.telephone ?>  Telefon / Telephone: <?cs call:print_value_bool(which, changes.contact.disclose.telephone, "veřejný / public", "skrytý / hidden") ?>
<?cs /if ?><?cs if:changes.contact.disclose.fax ?>  Fax / Fax: <?cs call:print_value_bool(which, changes.contact.disclose.fax, "veřejný / public", "skrytý / hidden") ?>
<?cs /if ?><?cs /if ?><?cs elif:type == #2 ?><?cs if:changes.nsset.check_level ?>Úroveň tech. kontrol / Check level: <?cs call:print_value(which, changes.nsset.check_level) ?>
<?cs /if ?><?cs if:changes.nsset.admin_c ?>Technické kontakty / Technical contacts: <?cs call:print_value(which, changes.nsset.admin_c) ?>
<?cs /if ?><?cs if:subcount(changes.nsset.dns) > #0 ?><?cs call:print_value_list(which, changes.nsset.dns, "Jmenný server / Name server") ?>
<?cs /if ?><?cs elif:type == #3 ?><?cs if:changes.domain.registrant ?>Držitel / Holder: <?cs call:print_value(which, changes.domain.registrant) ?>
<?cs /if ?><?cs if:changes.domain.nsset ?>Sada jmenných serverů / Name server set: <?cs call:print_value(which, changes.domain.nsset) ?>
<?cs /if ?><?cs if:changes.domain.keyset ?>Sada klíčů / Key set: <?cs call:print_value(which, changes.domain.keyset) ?>
<?cs /if ?><?cs if:changes.domain.admin_c ?>Administrativní kontakty / Administrative contacts: <?cs call:print_value(which, changes.domain.admin_c) ?>
<?cs /if ?><?cs if:changes.domain.temp_c ?>Dočasné kontakty / Temporary contacts: <?cs call:print_value(which, changes.domain.temp_c) ?>
<?cs /if ?><?cs if:changes.domain.val_ex_date ?>Validováno do / Validation expiration date: <?cs call:print_value(which, changes.domain.val_ex_date) ?>
<?cs /if ?><?cs if:changes.domain.publish ?>Přidat do ENUM tel.sezn. / Include in ENUM dict: <?cs call:print_value_bool(which, changes.domain.publish, "ano / yes", "ne / no") ?>
<?cs /if ?><?cs elif:type == #4 ?><?cs if:changes.keyset.admin_c ?>Technické kontakty / Technical contacts: <?cs call:print_value(which, changes.keyset.admin_c) ?>
<?cs /if ?><?cs if:subcount(changes.keyset.ds) > #0 ?><?cs call:print_value_list(which, changes.keyset.ds, "záznam DS / DS record") ?>
<?cs /if ?><?cs if:subcount(changes.keyset.dnskey) > #0 ?><?cs call:print_value_list(which, changes.keyset.dnskey, "klíče DNS / DNS keys") ?>
<?cs /if ?><?cs /if ?><?cs /def ?>
=====================================================================
Oznámení změn / Notification of changes 
=====================================================================
Změna údajů <?cs call:typesubst("cs") ?> / <?cs call:typesubst("en") ?> data change 
Identifikátor <?cs call:typesubst("cs") ?> / <?cs call:typesubst("en") ?> handle : <?cs var:handle ?>
Číslo žádosti / Ticket :  <?cs var:ticket ?>
Registrátor / Registrar : <?cs var:registrar ?>
=====================================================================

Vážený zákazníku,
Dear customer,
 
žádost byla úspěšně zpracována, <?cs if:changes == #1 ?>požadované změny byly provedeny<?cs else ?>žádná změna nebyla požadována, údaje zůstaly beze změny<?cs /if ?>.
The request was processed successfully, <?cs if:changes == #1 ?>the required changes have been applied<?cs else ?>no changes were requested, the data remains the same<?cs /if ?>.

<?cs if:changes == #1 ?>
Původní hodnoty / Original values:
=====================================================================
<?cs call:value_list("old") ?>


Nové hodnoty / New values:
=====================================================================
<?cs call:value_list("new") ?>

Ostatní hodnoty zůstaly beze změny.
Other data has not been modified.
<?cs /if ?>


Úplné detaily <?cs call:typesubst("cs") ?> najdete na <?cs var:defaults.whoispage ?>?q=<?cs var:handle ?>
The full details of <?cs call:typesubst("ensmall") ?> can be seen at <?cs var:defaults.whoispage ?>?q=<?cs var:handle ?>

V případě dotazů se prosím obracejte na svého určeného registrátora,
u kterého byly změny provedeny.
In case of any questions please contact your designated registrar
which performed the changes.

<?cs if:type == #1 ?>
Chcete mít snadnější přístup ke správě svých údajů? Založte si účet mojeID.
Kromě nástroje, kterým můžete snadno a bezpečně spravovat údaje v centrálním
registru, získáte také prostředek pro jednoduché přihlašování ke svým
oblíbeným webovým službám jediným jménem a heslem.
<?cs /if ?>

S pozdravem / Yours sincerely
podpora <?cs var:defaults.company_cs ?> / Support of <?cs var:defaults.company_en ?>
' WHERE id = 11;

UPDATE mail_type SET subject = '<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>Oznámení o transferu <?cs call:typesubst("cs") ?> <?cs var:handle ?> / Notification of <?cs call:typesubst("en") ?> <?cs var:handle ?> transfer' WHERE id = 12;
UPDATE mail_templates SET template =
'<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs elif:lang == "ensmall" ?><?cs if:type == #3 ?>domain<?cs elif:type == #1 ?>contact<?cs elif:type == #2 ?>nsset<?cs elif:type == #4 ?>keyset<?cs /if ?><?cs /if ?><?cs /def ?>
=====================================================================
Oznámení o transferu / Notification of transfer
=====================================================================
Transfer <?cs call:typesubst("cs") ?> / <?cs call:typesubst("en") ?> transfer
Identifikátor <?cs call:typesubst("cs") ?> / <?cs call:typesubst("en") ?> handle : <?cs var:handle ?>
Číslo žádosti / Ticket :  <?cs var:ticket ?>
Registrátor / Registrar : <?cs var:registrar ?>
=====================================================================

Vážený zákazníku,
Dear customer,
 
žádost byla úspěšně zpracována, transfer byl proveden. 
The request was processed successfully, the transfer has been completed. 

Detaily <?cs call:typesubst("cs") ?> najdete na <?cs var:defaults.whoispage ?>?q=<?cs var:handle ?>
Details of <?cs call:typesubst("ensmall") ?> can be seen at <?cs var:defaults.whoispage ?>?q=<?cs var:handle ?>

V případě dotazů se prosím obracejte na svého určeného registrátora,
u kterého byla změna provedena.
In case of any questions please contact your designated registrar
which performed the change.

S pozdravem / Yours sincerely
podpora <?cs var:defaults.company_cs ?> / Support of <?cs var:defaults.company_en ?>
' WHERE id = 12;

UPDATE mail_type SET subject = 'Oznámení o prodloužení platnosti domény <?cs var:handle ?> / Notification of <?cs var:handle ?> domain name renewal' WHERE id = 13;
UPDATE mail_templates SET template =
'=====================================================================
Oznámení o prodloužení platnosti / Notification of renewal
===================================================================== 
Obnovení domény / Domain renewal
Domény / Domain : <?cs var:handle ?>
Číslo žádosti / Ticket :  <?cs var:ticket ?>
Registrátor / Registrar : <?cs var:registrar ?>
=====================================================================

Vážený zákazníku,
Dear customer,

žádost byla úspěšně zpracována, prodloužení platnosti bylo provedeno. 
The request was processed successfully, the domain has been renewed. 

Při každé změně doporučujeme aktualizovat údaje o doméně, vyhnete se
tak možným problémům souvisejícím s prodlužováním platnosti či manipulací
s doménou osobami, které již nejsou oprávněny je provádět.
We recommend updating domain data in the registry after every change
to avoid possible problems with domain renewal or with domain manipulation
done by persons who are not authorized anymore.

Dovolujeme si Vás rovněž upozornit, že nesprávné, nepravdivé, neúplné
či zavádějící údaje mohou být v souladu s Pravidly registrace doménových jmen
v ccTLD .cz důvodem ke zrušení registrace doménového jména.
We would also like to inform you that in accordance with the
Domain Name Registration Rules for the .cz ccTLD, incorrect, false, incomplete or misleading
information can be grounds for the cancellation of a domain name registration.

Detail domény najdete na <?cs var:defaults.whoispage ?>?q=<?cs var:handle ?>
Details of the domain can be seen at <?cs var:defaults.whoispage ?>?q=<?cs var:handle ?>

S pozdravem / Yours sincerely
podpora <?cs var:defaults.company_cs ?> / Support of <?cs var:defaults.company_en ?>
' WHERE id = 13;

UPDATE mail_type SET subject = '<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>Oznámení o zrušení <?cs call:typesubst("cs") ?> <?cs var:handle ?> / Notification of <?cs call:typesubst("en") ?> <?cs var:handle ?> deletion' WHERE id = 14;
UPDATE mail_templates SET template =
'Vážený zákazníku,

vzhledem ke skutečnosti, že <?cs if:type == #1 ?>kontaktní osoba<?cs elif:type == #2 ?>sada nameserverů<?cs elif:type == #4 ?>sada klíčů<?cs /if ?> s identifikátorem <?cs var:handle ?>
nebyla po stanovenou dobu používána, tedy připojena k doméně<?cs if:type == #1 ?> nebo používána jako účet mojeID<?cs /if ?>, uvedenou <?cs if:type == #1 ?>kontaktní osobu<?cs elif:type == #2 ?>sadu nameserverů<?cs elif:type == #4 ?>sadu klíčů<?cs /if ?> ke dni <?cs var:deldate ?> rušíme.

Zrušení této <?cs if:type == #1 ?>kontaktní osoby<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?> nemá žádný vliv na funkčnost Vašich
zaregistrovaných doménových jmen, protože není možné zrušit <?cs if:type == #1 ?>kontaktní osobu<?cs elif:type == #2 ?>sadu nameserverů<?cs elif:type == #4 ?>sadu klíčů<?cs /if ?>, která se nachází u některé domény.

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear customer,

With regard to the fact that the <?cs if:type == #1 ?>contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>keyset<?cs /if ?> identified with <?cs var:handle ?>
was not used during the determined period, i.e. attached to a domain<?cs if:type == #1 ?> or used as mojeID account<?cs /if ?>, we are
cancelling the aforementioned <?cs if:type == #1 ?>contact<?cs elif:type == #2 ?>set of nameservers<?cs elif:type == #4 ?>set of keysets<?cs /if ?> as of <?cs var:deldate ?>.

Cancellation of the <?cs if:type == #1 ?>contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>keyset<?cs /if ?> has no influence on functionality of your
registred domains, since it is impossible to cancel a <?cs if:type == #1 ?>contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>keyset<?cs /if ?> assigned to a domain.

Yours sincerely
Support of <?cs var:defaults.company_en ?>
' WHERE id = 14;

UPDATE mail_type SET subject = '<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>Oznámení o zrušení <?cs call:typesubst("cs") ?> <?cs var:handle ?> / Notification of <?cs call:typesubst("en") ?> <?cs var:handle ?> deletion' WHERE id = 15;
UPDATE mail_templates SET template =
'<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>
=====================================================================
Oznámení o zrušení / Notification of deletion
=====================================================================
Zrušení <?cs call:typesubst("cs") ?> / <?cs call:typesubst("en") ?> deletion
Identifikátor <?cs call:typesubst("cs") ?> / <?cs call:typesubst("en") ?> handle : <?cs var:handle ?>
Číslo žádosti / Ticket :  <?cs var:ticket ?>
Registrátor / Registrar : <?cs var:registrar ?>
=====================================================================
 
Žádost byla úspěšně zpracována, požadované zrušení bylo provedeno. 
The request was processed successfully, the required deletion
has been performed. 
 
=====================================================================

S pozdravem / Your sincerely
podpora <?cs var:defaults.company_cs ?> / Support of <?cs var:defaults.company_en ?>
' WHERE id = 15;

UPDATE mail_type SET subject = 'Výsledek technické kontroly sady nameserverů <?cs var:handle ?> / Results of technical check on the NS set <?cs var:handle ?>' WHERE id = 16;
UPDATE mail_templates SET template =
'Sada nameserverů / NS set: <?cs var:handle ?>

Datum kontroly / Date of the check: <?cs var:checkdate ?>
Typ kontroly / Check type: periodická / periodic
Číslo kontroly / Ticket: <?cs var:ticket ?>

<?cs def:printtest(par_test) ?><?cs if:par_test.name == "glue_ok" ?>U následujících nameserverů chybí povinný glue záznam:
The required glue record is missing for the following nameservers:
<?cs each:ns = par_test.ns ?>    <?cs var:ns ?>
<?cs /each ?><?cs /if ?><?cs if:par_test.name == "existence" ?>Následující nameservery v sadě nameserverů nejsou dosažitelné:
Following nameservers in the NS set are unreachable:
<?cs each:ns = par_test.ns ?>    <?cs var:ns ?>
<?cs /each ?><?cs /if ?><?cs if:par_test.name == "autonomous" ?>Sada nameserverů neobsahuje minimálně dva nameservery v různých
autonomních systémech.
The NS set does not contain at least two nameservers in different autonomous systems.

<?cs /if ?><?cs if:par_test.name == "presence" ?><?cs each:ns = par_test.ns ?>Nameserver <?cs var:ns ?> neobsahuje záznam pro domény:
Nameserver <?cs var:ns ?> does not contain a record for any of the domains:
<?cs each:fqdn = ns.fqdn ?>    <?cs var:fqdn ?>
<?cs /each ?><?cs if:ns.overfull ?>    ...
<?cs /if ?><?cs /each ?><?cs /if ?><?cs if:par_test.name == "authoritative" ?><?cs each:ns = par_test.ns ?>Nameserver <?cs var:ns ?> není autoritativní pro domény:
Nameserver <?cs var:ns ?> is not authoritative for domains:
<?cs each:fqdn = ns.fqdn ?>    <?cs var:fqdn ?>
<?cs /each ?><?cs if:ns.overfull ?>    ...
<?cs /if ?><?cs /each ?><?cs /if ?><?cs if:par_test.name == "heterogenous" ?>Všechny nameservery v sadě nameserverů používají stejnou implementaci
DNS serveru.
All nameservers in the NS set use the same implementation of DNS server.

<?cs /if ?><?cs if:par_test.name == "notrecursive" ?>Následující nameservery v sadě nameserverů jsou rekurzivní:
Following nameservers in the NS set are recursive:
<?cs each:ns = par_test.ns ?>    <?cs var:ns ?>
<?cs /each ?><?cs /if ?><?cs if:par_test.name == "notrecursive4all" ?>Následující nameservery v sadě nameserverů zodpověděly dotaz rekurzivně:
Following nameservers in the NS set answered a query recursively:
<?cs each:ns = par_test.ns ?>    <?cs var:ns ?>
<?cs /each ?><?cs /if ?><?cs if:par_test.name == "dnsseckeychase" ?>Pro následující domény přislušející sadě nameserverů nebylo možno
ověřit validitu podpisu DNSSEC:
For the following domains belonging to the NS set, the DNSSEC signature
could not be validated:
<?cs each:domain = par_test.ns ?>    <?cs var:domain ?>
<?cs /each ?><?cs /if ?><?cs /def ?>
=== Chyby / Errors ==================================================

<?cs each:item = tests ?><?cs if:item.type == "error" ?><?cs call:printtest(item) ?><?cs /if ?><?cs /each ?>
=== Varování / Warnings =============================================

<?cs each:item = tests ?><?cs if:item.type == "warning" ?><?cs call:printtest(item) ?><?cs /if ?><?cs /each ?>
=== Upozornění / Notices ============================================

<?cs each:item = tests ?><?cs if:item.type == "notice" ?><?cs call:printtest(item) ?><?cs /if ?><?cs /each ?>
=====================================================================


S pozdravem / Your sincerely
podpora <?cs var:defaults.company_cs ?> / Support of <?cs var:defaults.company_en ?>
' WHERE id = 16;

UPDATE mail_type SET subject = 'Potvrzení o přijaté záloze / Confirmation of received advance payment' WHERE id = 17;
UPDATE mail_templates SET template =
'Vážení obchodní přátelé,

v příloze zasíláme daňový doklad na přijatou zálohu pro zónu <?cs var:zone ?>.
Tento daňový doklad slouží k uplatnění nároku na odpočet DPH přijaté zálohy

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear business partners,

Enclosed with this letter, we are sending you a tax document for the advance
payment received for the <?cs var:zone ?> zone. This tax document can be used
to claim VAT deduction for the advance payment.

Yours sincerely
Support of <?cs var:defaults.company_en ?>
' WHERE id = 17;

UPDATE mail_type SET subject = 'Zaslání měsíčního vyúčtování / Monthly bill dispatching' WHERE id = 18;
UPDATE mail_templates SET template =
'Vážení obchodní přátelé,

v příloze zasíláme daňový doklad za služby registrací doménových jmen
a udržování záznamů o doménových jménech za období od <?cs var:fromdate ?>
do <?cs var:todate ?> pro zónu <?cs var:zone ?>.

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear business partners,

Enclosed with this letter, we are sending a tax document for domain name
registration services and the maintenance of domain name records in the period
from <?cs var:fromdate ?> to <?cs var:todate ?> for the <?cs var:zone ?> zone.

Yours sincerely
Support of <?cs var:defaults.company_en ?>
' WHERE id = 18;

UPDATE mail_type SET subject = 'Zaslání měsíčního vyúčtování / Monthly bill dispatching' WHERE id = 19;
UPDATE mail_templates SET template =
'Vážení obchodní přátelé,

jelikož Vaše společnost neprovedla v období od <?cs var:fromdate ?> do <?cs var:todate ?> v zóně <?cs var:zone ?>
žádnou registraci doménového jména ani prodloužení platnosti doménového
jména, a nedošlo tak k čerpání žádných placených služeb, nebude pro toto
období vystaven daňový doklad.

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear business partners,

Since your company has not performed any domain name registration or domain
name validity extension in the period from <?cs var:fromdate ?> to <?cs var:todate ?> for the <?cs var:zone ?> zone,
hence not drawing any paid services, no tax document will be issued for this
period.

Yours sincerely
Support of <?cs var:defaults.company_en ?>
' WHERE id = 19;

UPDATE mail_type SET subject = 'Informace o vyřízení žádosti / Information about request handling ' WHERE id = 20;
UPDATE mail_templates SET template =
'Vážený zákazníku,

na základě Vaší žádosti podané prostřednictvím webového formuláře
na našich stránkách dne <?cs var:reqdate ?>, které bylo přiděleno identifikační
číslo <?cs var:reqid ?>, Vám oznamujeme, že požadovaná žádost o <?cs if:otype == #1 ?>zablokování<?cs elif:otype == #2 ?>odblokování<?cs /if ?>
<?cs if:rtype == #1 ?>změny dat<?cs elif:rtype == #2 ?>transferu k jinému registrátorovi<?cs /if ?> pro <?cs if:type == #3 ?>doménu<?cs elif:type == #1 ?>kontakt s identifikátorem<?cs elif:type == #2 ?>sadu nameserverů s identifikátorem<?cs elif:type == #4 ?>sadu klíčů s identifikátorem<?cs /if ?> <?cs var:handle ?>
byla vyřízena.
<?cs if:otype == #1 ?>
U <?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu s identifikátorem<?cs elif:type == #2 ?>sady nameserverů s identifikátorem<?cs elif:type == #4 ?>sady klíčů s identifikátorem<?cs /if ?> <?cs var:handle ?> nebude možné provést
<?cs if:rtype == #1 ?>změnu dat<?cs elif:rtype == #2 ?>transfer k jinému registrátorovi <?cs /if ?> až do okamžiku, kdy tuto blokaci
zrušíte pomocí příslušného formuláře na našich stránkách.
<?cs /if?>
S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear customer,

based on your request submitted via the web form on our
pages on <?cs var:reqdate ?>, which received the identification number
<?cs var:reqid ?>, we are announcing that your request for <?cs if:otype == #1 ?>blocking<?cs elif:otype == #2 ?>unblocking<?cs /if ?>
<?cs if:rtype == #1 ?>data changes<?cs elif:rtype == #2 ?>transfer to other registrar<?cs /if ?> for <?cs if:type == #3 ?>domain name<?cs elif:type == #1 ?>contact identified with<?cs elif:type == #2 ?>NS set identified with<?cs elif:type == #4 ?>keyset identified with<?cs /if ?> <?cs var:handle ?>
has been dealt with.
<?cs if:otype == #1 ?>
No <?cs if:rtype == #1 ?>data changes<?cs elif:rtype == #2 ?>transfer to other registrar<?cs /if ?> of <?cs if:type == #3 ?>domain name<?cs elif:type == #1 ?>contact identified with<?cs elif:type == #2 ?>NS set identified with<?cs elif:type == #4 ?>Keyset identified with<?cs /if ?> <?cs var:handle ?>
will be possible until you cancel the blocking option using the
applicable form on our pages.
<?cs /if?>
Yours sincerely
Support of <?cs var:defaults.company_en ?>
' WHERE id = 20;

UPDATE mail_type SET subject = 'Oznámení o sloučení duplicitních záznamů / Information on the merging of duplicate entries' WHERE id = 28;
UPDATE mail_templates SET template =
'The English version of the email follows the Czech version

Vážený zákazníku,

z důvodu zjednodušení administrace a správy kontaktů v registru byly v souladu s Pravidly registrace doménových jmen, odstavec 11.10, provedeny následující změny:

Došlo ke sjednocení duplicitních kontaktů, které mají různé identifikátory, a přitom obsahují shodné údaje. Všechny duplicitní kontakty byly převedeny pod jediný s identifikátorem <?cs var:dst_contact_handle ?>.

<?cs if:domain_registrant_list.0 ?>Držitel byl změněn u domén:<?cs each:item = domain_registrant_list ?>
    <?cs var:item ?><?cs /each ?><?cs /if ?><?cs if:domain_admin_list.0 ?>

Administrativní kontakt byl změněn u domén:<?cs each:item = domain_admin_list ?>
    <?cs var:item ?><?cs /each ?><?cs /if ?><?cs if:nsset_tech_list.0 ?>

Technický kontakt byl změněn u sad nameserverů:<?cs each:item = nsset_tech_list ?>
    <?cs var:item ?><?cs /each ?><?cs /if ?><?cs if:keyset_tech_list.0 ?>

Technický kontakt byl změněn u sad klíčů:<?cs each:item = keyset_tech_list ?>
    <?cs var:item ?><?cs /each ?><?cs /if ?><?cs if:removed_list.0 ?>

Následující duplicitní kontakty byly odstraněny:<?cs each:item = removed_list ?>
    <?cs var:item ?><?cs /each ?><?cs /if ?>

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear Customer,

To simplify the administration and management of contact data in the registry, the following changes have been implemented in accordance with the Domain Name Registration Rules, Section 11.10:

Duplicate contact entries having different identifiers but identical contents have been unified. All duplicate contact details were merged into a single entry carrying the identifier <?cs var:dst_contact_handle ?>.

<?cs if:domain_registrant_list.0 ?>Holders were changed for the following domains:<?cs each:item = domain_registrant_list ?>
    <?cs var:item ?><?cs /each ?><?cs /if ?><?cs if:domain_admin_list.0 ?>

Administrative contacts were changed for the following domains:<?cs each:item = domain_admin_list ?>
    <?cs var:item ?><?cs /each ?><?cs /if ?><?cs if:nsset_tech_list.0 ?>

Technical contacts were changed for the following nameserver sets:<?cs each:item = nsset_tech_list ?>
    <?cs var:item ?><?cs /each ?><?cs /if ?><?cs if:keyset_tech_list.0 ?>

Technical contacts were changed for the following key sets:<?cs each:item = keyset_tech_list ?>
    <?cs var:item ?><?cs /each ?><?cs /if ?><?cs if:removed_list.0 ?>

The following duplicate contact entries were removed:<?cs each:item = removed_list ?>
    <?cs var:item ?><?cs /each ?><?cs /if ?>

Yours sincerely
Support of <?cs var:defaults.company_en ?>
' WHERE id = 28;


UPDATE mail_type SET subject = 'Výzva k opravě či doložení správnosti údajů kontaktu <?cs var:contact_handle ?> / Notice to correct data of contact <?cs var:contact_handle ?>' WHERE id = 29;
UPDATE mail_templates SET template =
'Vážený zákazníku,

v příloze Vám zasíláme výzvu k opravě či doložení správnosti údajů, které jsou uvedeny u kontaktu s identifikátorem <?cs var:contact_handle ?> (Originál dopisu odchází s mezinárodní dodejkou prostřednictvím pošty.)

V případě jakýchkoliv dotazů či nejasností nás neprodleně kontaktujte.

S pozdravem,
podpora <?cs var:defaults.company_cs ?>



Dear customer,

In the attachment, you can find a notice to correct or provide evidence of accuracy of data assigned to the contact identified with <?cs var:contact_handle ?> (The original letter has been sent with international confirmation of delivery.)

In case of any questions do not hesitate to contact us.

Yours sincerely
Support of <?cs var:defaults.company_en ?>
' WHERE id = 29;


UPDATE mail_type SET subject = 'Druhá výzva k opravě či doložení správnosti údajů kontaktu <?cs var:contact_handle ?> / Second notice to correct data of contact <?cs var:contact_handle ?>' WHERE id = 30;
UPDATE mail_templates SET template =
'Vážený zákazníku,

do dnešního dne nedošlo k opravě údajů, které jsou uvedeny u kontaktu s identifikátorem <?cs var:contact_handle ?>. Zásilka odeslaná na adresu uvedenou v centrálním registru u tohoto kontaktu se vrátila.

Nebudou-li údaje kontaktu <?cs var:contact_handle ?> opraveny (případně doložena jejich správnost) do <?cs var:contact_update_till ?>, můžeme v souladu s Pravidly registrace doménových jmen v ccTLD .cz zrušit registraci doménových jmen, u kterých je tento kontakt uveden jako držitel.

S pozdravem,
podpora <?cs var:defaults.company_cs ?>



Dear customer,

Let us inform you that the data assigned to the contact identified with <?cs var:contact_handle ?> has not been corrected up to this day. The letter sent to the address assigned to the contact in the Central registry has returned.

In case the data assigned to the contact <?cs var:contact_handle ?> are not corrected (nor the evidence of their accuracy is provided) till <?cs var:contact_update_till ?>, we can, in accordance with the Domain Name Registration Rules under ccTLD .cz, cancel registration of domain names where this contact is the owner.

Yours sincerely
Support of <?cs var:defaults.company_en ?>
' WHERE id = 30;


---
--- From registry_dml_mojeid.sql
---

UPDATE mail_header_defaults SET h_organization = 'CZ.NIC, z. s. p. o.' WHERE id = 2;


---
--- messages templates
---
UPDATE mail_type SET subject = 'Založení účtu mojeID - PIN1 pro aktivaci mojeID' WHERE id = 21;
UPDATE mail_templates SET template =
'Vážený uživateli,

před tím, než Vám aktivujeme účet mojeID, musíme ověřit správnost Vašich
kontaktních údajů, a to prostřednictvím kódů PIN1 a PIN2.

PIN1: <?cs var:passwd ?>
PIN2: Vám byl zaslán pomocí SMS.

Do formuláře pro zadání těchto kódů budete přesměrováni po kliknutí na
následující odkaz:

https://<?cs var:hostname ?>/identify/email-sms/<?cs var:identification ?>/?password1=<?cs var:passwd ?>

Po úspěšném odeslání formuláře budete moci začít svůj účet mojeID používat.
Zároveň Vám pošleme poštou dopis s kódem PIN3, po jehož zadání bude Váš
účet plně aktivní.

Základní údaje o Vašem účtu:

účet mojeID: <?cs var:handle ?>
jméno:       <?cs var:firstname ?>
příjmení:    <?cs var:lastname ?>
e-mail:      <?cs var:email ?>

S pozdravem
tým mojeID
' WHERE id = 21;

UPDATE mail_type SET subject = 'Validace účtu mojeID <?cs if:status == #1 ?>provedena<?cs else ?>neprovedena<?cs /if ?>' WHERE id = 22;
UPDATE mail_templates SET template =
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
' WHERE id = 22;

UPDATE mail_templates SET template =
'Vážený uživateli,

k dokončení procedury změny e-mailu zadejte prosím kód PIN1: <?cs var:pin ?>

S pozdravem
tým mojeID
' WHERE id = 24;

UPDATE mail_templates SET template =
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
' WHERE id = 27;


---
--- From reminder_dml.sql
---

UPDATE mail_templates SET template =
'The English version of the email follows the Czech version

Vážený zákazníku,

dovolujeme si Vás zdvořile požádat o kontrolu správnosti údajů,
které nyní evidujeme u Vašeho kontaktu v Centrálním registru
doménových jmen.

Kontaktní osoba je potřebná pro registraci domény či domén, jejichž seznam uvádíme níže.

V případě nesrovnalostí v údajích se prosím spojte přímo s určeným registrátorem kontaktu, kterého naleznete v následujícím výpisu, neboť my změny údajů neprovádíme.

ID kontaktu v registru: <?cs var:handle ?>
Organizace: <?cs var:organization ?>
Jméno: <?cs var:name ?>
Adresa: <?cs var:address ?><?cs if:ident_type != "" ?>
<?cs if:ident_type == "RC"?>Datum narození: <?cs 
elif:ident_type == "OP"?>Číslo OP: <?cs 
elif:ident_type == "PASS"?>Číslo pasu: <?cs 
elif:ident_type == "ICO"?>IČO: <?cs 
elif:ident_type == "MPSV"?>Identifikátor MPSV: <?cs 
elif:ident_type == "BIRTHDAY"?>Datum narození: <?cs 
/if ?> <?cs var:ident_value ?><?cs 
/if ?>
DIČ: <?cs var:dic ?>
Telefon: <?cs var:telephone ?>
Fax: <?cs var:fax ?>
E-mail: <?cs var:email ?>
Notifikační e-mail: <?cs var:notify_email ?>
Určený registrátor: <?cs var:registrar_name ?> (<?cs var:registrar_url ?>)
<?cs if:registrar_memo_cz ?>Další informace poskytnuté registrátorem:
<?cs var:registrar_memo_cz ?><?cs /if ?>

V případě, že jsou údaje správné, nereagujte prosím na tento e-mail.

Aktuální, úplné a správné informace v registru znamenají Vaši jistotu,
že Vás důležité informace o Vaší doméně zastihnou vždy a včas na správné adrese.
Nedočkáte se tak nepříjemného překvapení v podobě nefunkční či zrušené domény.

Dovolujeme si Vás rovněž upozornit, že nesprávné, nepravdivé, neúplné
či zavádějící údaje mohou být v souladu s Pravidly registrace doménových jmen
v ccTLD .cz důvodem ke zrušení registrace doménového jména.

Úplný výpis z registru obsahující všechny domény a další objekty přiřazené
k shora uvedenému kontaktu naleznete v příloze.

S pozdravem
podpora <?cs var:defaults.company_cs ?>


Příloha:

<?cs if:domains.0 ?>Seznam domén, kde je kontakt v roli držitele nebo administrativního
kontaktu:<?cs each:item = domains ?>
<?cs var:item ?><?cs /each ?><?cs else ?>Kontakt není uveden u žádného doménového jména.<?cs /if ?><?cs if:nssets.0 ?>

Seznam sad jmenných serverů, kde je kontakt v roli technického kontaktu:<?cs each:item = nssets ?>
<?cs var:item ?><?cs /each ?><?cs /if ?><?cs if:keysets.0 ?>

Seznam sad klíčů, kde je kontakt v roli technického kontaktu:<?cs each:item = keysets ?>
<?cs var:item ?><?cs /each ?><?cs /if ?>



Dear customer,

Please check that your contact information we currently have on file
in the Central Registry of Domain Names, is correct.

The contact is required for the registration of the domain(s) listed below.

Do not hesitate to contact your designated registrar in the case the data are incorrect, since we do not perform changes of the data.

Contact ID in the registry: <?cs var:handle ?>
Organization: <?cs var:organization ?>
Name: <?cs var:name ?>
Address: <?cs var:address ?><?cs if:ident_type != "" ?>
<?cs if:ident_type == "RC"?>Birth date: <?cs 
elif:ident_type == "OP"?>Personal ID: <?cs 
elif:ident_type == "PASS"?>Passport number: <?cs 
elif:ident_type == "ICO"?>ID number: <?cs 
elif:ident_type == "MPSV"?>MSPV ID: <?cs 
elif:ident_type == "BIRTHDAY"?>Birth day: <?cs 
/if ?> <?cs var:ident_value ?><?cs 
/if ?>
VAT No.: <?cs var:dic ?>
Phone: <?cs var:telephone ?>
Fax: <?cs var:fax ?>
Email: <?cs var:email ?>
Notification email: <?cs var:notify_email ?>
Designated registrar: <?cs var:registrar_name ?> (<?cs var:registrar_url ?>)
<?cs if:registrar_memo_en ?>Other information provided by your registrar:
<?cs var:registrar_memo_en ?><?cs /if ?>

Please, do not take any measures if your data are correct.

Having up-to-date, complete and correct information in the registry is crucial
to reach you with all the important information about your domain name in time
and at the correct contact address. Check your contact details now and avoid unpleasant
surprises such as a non-functional or expired domain.

We would also like to inform you that in accordance with the Rules of Domain Name
Registration for the .cz ccTLD, incorrect, false, incomplete or misleading
information can be grounds for the cancellation of a domain name registration.

You can find a complete listing of your domain names and other objects
associated with your contact attached below.

Yours sincerely
Support of <?cs var:defaults.company_en ?>


Attachment:

<?cs if:domains.0 ?>Domains where the contact is their holder or administrative contact:<?cs each:item = domains ?>
<?cs var:item ?><?cs /each ?><?cs else ?>The contact is not linked to any domain name.<?cs /if ?><?cs if:nssets.0 ?>

Sets of name servers where the contact is their technical contact:<?cs each:item = nssets ?>
<?cs var:item ?><?cs /each ?><?cs /if ?><?cs if:keysets.0 ?>

Keysets where the contact is their technical contact:<?cs each:item = keysets ?>
<?cs var:item ?><?cs /each ?><?cs /if ?>
' WHERE id = 23;


---
--- domain name validator - checkers
---
INSERT INTO enum_domain_name_validation_checker (id, name, description)
    VALUES (1, 'dncheck_letters_digits_hyphen_chars_only', 'enforces letter, digit or hyphen characters');
INSERT INTO enum_domain_name_validation_checker (id, name, description)
    VALUES (2, 'dncheck_no_consecutive_hyphens', 'forbid consecutive hyphens');
INSERT INTO enum_domain_name_validation_checker (id, name, description)
    VALUES (3, 'dncheck_no_label_beginning_hyphen', 'forbid hyphen at the label beginning');
INSERT INTO enum_domain_name_validation_checker (id, name, description)
    VALUES (4, 'dncheck_no_label_ending_hyphen', 'forbid hyphen at the label ending');
INSERT INTO enum_domain_name_validation_checker (id, name, description)
    VALUES (5, 'dncheck_not_empty_domain_name', 'forbid empty domain name');
INSERT INTO enum_domain_name_validation_checker (id, name, description)
    VALUES (6, 'dncheck_rfc1035_preferred_syntax', 'enforces rfc1035 preferred syntax');
INSERT INTO enum_domain_name_validation_checker (id, name, description)
    VAlUES (7, 'dncheck_single_digit_labels_only', 'enforces single digit labels (for enum domains)');

INSERT INTO zone_domain_name_validation_checker_map (checker_id, zone_id)
SELECT ec.id, z.id
  FROM enum_domain_name_validation_checker ec,
       zone z
 WHERE z.enum_zone IS FALSE
       AND ec.name IN (
           'dncheck_letters_digits_hyphen_chars_only',
           'dncheck_no_label_beginning_hyphen',
           'dncheck_no_label_ending_hyphen',
           'dncheck_no_consecutive_hyphens'
       );

INSERT INTO zone_domain_name_validation_checker_map (checker_id, zone_id)
SELECT ec.id, z.id
  FROM enum_domain_name_validation_checker ec,
       zone z
 WHERE z.enum_zone IS TRUE
       AND ec.name IN (
           'dncheck_single_digit_labels_only'
       );
