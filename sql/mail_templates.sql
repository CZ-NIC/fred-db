
--
-- This script may be called only on just created mail tables, because
-- we assume that sequence numbers are reset to 1 in this script.
--

INSERT INTO mail_type (id, name, subject) VALUES (1, 'sendauthinfo_pif', 'Zaslání autorizační informace / Sending authorization information');
INSERT INTO mail_type_priority VALUES ((SELECT id FROM mail_type WHERE name = 'sendauthinfo_pif'), 2);
INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id) VALUES ((SELECT id FROM mail_type WHERE name = 'sendauthinfo_pif'), 1);
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(1, 'plain', 1,
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
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (1, 1);

INSERT INTO mail_type (id, name, subject) VALUES (2, 'sendauthinfo_epp', 'Zaslání autorizační informace / Sending authorization information');
INSERT INTO mail_type_priority VALUES ((SELECT id FROM mail_type WHERE name = 'sendauthinfo_epp'), 2);
INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id) VALUES ((SELECT id FROM mail_type WHERE name = 'sendauthinfo_epp'), 1);
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(2, 'plain', 1,
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
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (2, 2);

INSERT INTO mail_type (id, name, subject) VALUES (3, 'expiration_notify', 'Upozornění na nutnost úhrady domény <?cs var:domain ?> / Reminder to settle fees for the <?cs var:domain ?> domain');
INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id) VALUES ((SELECT id FROM mail_type WHERE name = 'expiration_notify'), 1);
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(3, 'plain', 1,
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

2. nebo si v seznamu na našich stránkách (<?cs var:defaults.registrarlistpage ?>)
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

2. Or choose another registrar from those listed on our pages (<?cs var:defaults.registrarlistpage ?>)
   in order to extend the registration of your domain name;

3. Or do not pay for the extension of the domain registration, the domain
   will be cancelled on the specified date.

Yours sincerely
Support of <?cs var:defaults.company_en ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (3, 3);


INSERT INTO mail_type (id, name, subject) VALUES (4, 'expiration_dns_owner', 'Oznámení o vyřazení domény <?cs var:domain ?> z DNS / Notification of the <?cs var:domain ?> domain exclusion from DNS');
INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id) VALUES ((SELECT id FROM mail_type WHERE name = 'expiration_dns_owner'), 1);
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(4, 'plain', 1,
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
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (4, 4);


INSERT INTO mail_type (id, name, subject) VALUES (5, 'expiration_register_owner', 'Oznámení o zrušení domény <?cs var:domain ?> / Notification of the <?cs var:domain ?> domain cancellation');
INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id) VALUES ((SELECT id FROM mail_type WHERE name = 'expiration_register_owner'), 1);
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(5, 'plain', 1,
'Vážený zákazníku,

dovolujeme si Vás upozornit, že Váš registrátor neprodloužil platnost registrace
doménového jména <?cs var:domain ?>. Vzhledem k této skutečnosti
a na základě Pravidel registrace doménových jmen rušíme registraci
tohoto doménového jména.

V případě zájmu o opětovnou registraci domény prosím kontaktujte kteréhokoli registrátora ze seznamu na našich stránkách (<?cs var:defaults.registrarlistpage ?>).

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear customer,

we would like to inform you that your registrar has not extended the registration
of the domain name <?cs var:domain ?>. Due to this fact and based on the Domain Name Registration Rules, we are cancelling the registration of this domain name.

If you are interested in the registration of the domain again, please contact any registrar listed
on our pages (<?cs var:defaults.registrarlistpage ?>).

Yours sincerely
Support of <?cs var:defaults.company_en ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (5, 5);

INSERT INTO mail_type (id, name, subject) VALUES (6, 'expiration_dns_tech', 'Oznámení o vyřazení domény <?cs var:domain ?> z DNS / Notification of the <?cs var:domain ?> domain exclusion from DNS');
INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id) VALUES ((SELECT id FROM mail_type WHERE name = 'expiration_dns_tech'), 1);
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(6, 'plain', 1,
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
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (6, 6);

INSERT INTO mail_type (id, name, subject) VALUES (7, 'expiration_register_tech', 'Oznámení o zrušení domény <?cs var:domain ?> / Notification of the <?cs var:domain ?> domain cancellation');
INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id) VALUES ((SELECT id FROM mail_type WHERE name = 'expiration_register_tech'), 1);
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(7, 'plain', 1,
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
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (7, 7);

INSERT INTO mail_type (id, name, subject) VALUES (8, 'expiration_validation_before', 'Oznámení vypršení validace domény ENUM <?cs var:domain ?> / Notification of expiration of the ENUM domain <?cs var:domain ?> validation');
INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id) VALUES ((SELECT id FROM mail_type WHERE name = 'expiration_validation_before'), 1);
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(8, 'plain', 1,
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
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (8, 8);

INSERT INTO mail_type (id, name, subject) VALUES (9, 'expiration_validation', 'Oznámení o vypršení validace domény ENUM <?cs var:domain ?> / Notification of expiration of the ENUM domain <?cs var:domain ?> validation');
INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id) VALUES ((SELECT id FROM mail_type WHERE name = 'expiration_validation'), 1);
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(9, 'plain', 1,
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
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (9, 9);

INSERT INTO mail_type (id, name, subject) VALUES (10, 'notification_create', '<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>Oznámení o registraci <?cs call:typesubst("cs") ?> <?cs var:handle ?> / <?cs call:typesubst("en") ?> <?cs var:handle ?> registration notification');
INSERT INTO mail_type_priority VALUES ((SELECT id FROM mail_type WHERE name = 'notification_create'), 3);
INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id) VALUES ((SELECT id FROM mail_type WHERE name = 'notification_create'), 1);
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(10, 'plain', 1,
'<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs elif:lang == "ensmall" ?><?cs if:type == #3 ?>domain<?cs elif:type == #1 ?>contact<?cs elif:type == #2 ?>nsset<?cs elif:type == #4 ?>keyset<?cs /if ?><?cs /if ?><?cs /def ?>

<?cs def:print_value(varname) ?><?cs set:lvarname = varname ?><?cs alt:lvarname ?>hodnota nenastavena / value not set<?cs /alt ?>  <?cs /def ?>

<?cs def:print_value_bool(varname, if_true, if_false) ?><?cs set:lvarname = varname ?><?cs if:lvarname == "1" ?><?cs var:if_true ?><?cs elif:lvarname == "0" ?><?cs var:if_false ?><?cs /if ?><?cs /def ?>

<?cs def:print_value_list(varname, itemname) ?><?cs set:count = #1 ?><?cs each:item = varname ?><?cs var:itemname ?><?cs var:count ?>:<?cs call:print_value(item) ?><?cs set:count = count + #1 ?> <?cs /each ?> <?cs /def ?> 

<?cs def:objtype(ot) ?><?cs if:ot == #3 ?>domain<?cs elif:ot == #1 ?>contact<?cs elif:ot == #2 ?>nsset<?cs elif:ot == #4 ?>keyset<?cs /if ?><?cs /def ?>
<?cs def:whoislink(type,handle) ?><?cs var:defaults.whoispage ?>/<?cs call:objtype(type) ?>/<?cs var:handle ?>/<?cs /def ?>

<?cs def:contact_value_list() ?>
<?cs if:fresh.object.authinfo ?>Heslo / Authinfo: důvěrný údaj / private value
<?cs /if ?><?cs if:fresh.contact.name ?>Jméno / Name: <?cs call:print_value(fresh.contact.name) ?>
<?cs /if ?><?cs if:fresh.contact.org ?>Organizace / Organization: <?cs call:print_value(fresh.contact.org) ?>
<?cs /if ?><?cs if:fresh.contact.address.permanent ?>Trvalá Adresa / Permanent Address: <?cs call:print_value(fresh.contact.address.permanent) ?>
<?cs /if ?><?cs if:fresh.contact.address.mailing ?>Korespondenční adresa / Mailing address: <?cs call:print_value(fresh.contact.address.mailing) ?>
<?cs /if ?><?cs if:fresh.contact.address.billing ?>Fakturační adresa / Billing address: <?cs call:print_value(fresh.contact.address.billing) ?>
<?cs /if ?><?cs if:fresh.contact.address.shipping ?>Dodací adresa / Shipping address: <?cs call:print_value(fresh.contact.address.shipping) ?>
<?cs /if ?><?cs if:fresh.contact.address.shipping_2 ?>Dodací adresa / Shipping address: <?cs call:print_value(fresh.contact.address.shipping_2) ?>
<?cs /if ?><?cs if:fresh.contact.address.shipping_3 ?>Dodací adresa / Shipping address: <?cs call:print_value(fresh.contact.address.shipping_3) ?>
<?cs /if ?><?cs if:fresh.contact.telephone ?>Telefon / Telephone: <?cs call:print_value(fresh.contact.telephone) ?>
<?cs /if ?><?cs if:fresh.contact.fax ?>Fax / Fax: <?cs call:print_value(fresh.contact.fax) ?>
<?cs /if ?><?cs if:fresh.contact.email ?>E-mail / Email: <?cs call:print_value(fresh.contact.email) ?>
<?cs /if ?><?cs if:fresh.contact.notify_email ?>Notifikační e-mail / Notification email: <?cs call:print_value(fresh.contact.notify_email) ?>
<?cs /if ?><?cs if:fresh.contact.ident_type ?>Typ identifikace / Identification type: <?cs call:print_value(fresh.contact.ident_type) ?>
<?cs /if ?><?cs if:fresh.contact.ident ?>Identifikační údaj / Identification data: <?cs call:print_value(fresh.contact.ident) ?>
<?cs /if ?><?cs if:fresh.contact.vat ?>DIČ / VAT number: <?cs call:print_value(fresh.contact.vat) ?>
<?cs /if ?><?cs if:subcount(fresh.contact.disclose) > #0 ?>Viditelnost údajů / Data visibility:
<?cs if:fresh.contact.disclose.name ?>  Jméno / Name: <?cs call:print_value_bool(fresh.contact.disclose.name, "veřejné / public", "skryté / hidden") ?>
<?cs /if ?><?cs if:fresh.contact.disclose.org ?>  Organizace / Organization: <?cs call:print_value_bool(fresh.contact.disclose.org, "veřejná / public", "skrytá / hidden") ?>
<?cs /if ?><?cs if:fresh.contact.disclose.email ?>  E-mail / Email: <?cs call:print_value_bool(fresh.contact.disclose.email, "veřejný / public", "skrytý / hidden") ?>
<?cs /if ?><?cs if:fresh.contact.disclose.address ?>  Adresa / Address: <?cs call:print_value_bool(fresh.contact.disclose.address, "veřejná / public", "skrytá / hidden") ?>
<?cs /if ?><?cs if:fresh.contact.disclose.notify_email ?>  Notifikační e-mail / Notification email: <?cs call:print_value_bool(fresh.contact.disclose.notify_email, "veřejný / public", "skrytý / hidden") ?>
<?cs /if ?><?cs if:fresh.contact.disclose.ident ?>  Identifikační údaj / Identification data: <?cs call:print_value_bool(fresh.contact.disclose.ident, "veřejný / public", "skrytý / hidden") ?>
<?cs /if ?><?cs if:fresh.contact.disclose.vat ?>  DIČ / VAT number: <?cs call:print_value_bool(fresh.contact.disclose.vat, "veřejné / public", "skryté / hidden") ?>
<?cs /if ?><?cs if:fresh.contact.disclose.telephone ?>  Telefon / Telephone: <?cs call:print_value_bool(fresh.contact.disclose.telephone, "veřejný / public", "skrytý / hidden") ?>
<?cs /if ?><?cs if:fresh.contact.disclose.fax ?>  Fax / Fax: <?cs call:print_value_bool(fresh.contact.disclose.fax, "veřejný / public", "skrytý / hidden") ?>
<?cs /if ?><?cs /if ?><?cs /def ?>


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

<?cs if:type != #1 ?>
Detaily <?cs call:typesubst("cs") ?> najdete na <?cs call:whoislink(type, handle) ?>
Details of <?cs call:typesubst("ensmall") ?> can be seen at <?cs call:whoislink(type, handle) ?>
<?cs else ?>
Detaily <?cs call:typesubst("cs") ?> jsou: / Details of the <?cs call:typesubst("ensmall") ?> are:
<?cs call:contact_value_list() ?>
<?cs /if ?>

S pozdravem / Yours sincerely
podpora <?cs var:defaults.company_cs ?> / Support of <?cs var:defaults.company_en ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (10, 10);

INSERT INTO mail_type (id, name, subject) VALUES (11, 'notification_update', '<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>domain<?cs elif:type == #1 ?>contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>keyset<?cs /if ?><?cs /if ?><?cs /def ?>Oznámení změn <?cs call:typesubst("cs") ?> <?cs var:handle ?>/ Notification of <?cs call:typesubst("en") ?> <?cs var:handle ?> changes');
INSERT INTO mail_type_priority VALUES ((SELECT id FROM mail_type WHERE name = 'notification_update'), 3);
INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id) VALUES ((SELECT id FROM mail_type WHERE name = 'notification_update'), 1);
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(11, 'plain', 1,
'<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs elif:lang == "ensmall" ?><?cs if:type == #3 ?>domain<?cs elif:type == #1 ?>contact<?cs elif:type == #2 ?>nsset<?cs elif:type == #4 ?>keyset<?cs /if ?><?cs /if ?><?cs /def ?>

<?cs def:print_value(which, varname) ?><?cs if:which == "old" ?><?cs set:lvarname = varname.old ?><?cs elif:which == "new" ?><?cs set:lvarname = varname.new ?><?cs /if ?><?cs alt:lvarname ?><?cs if:which == "old" ?>hodnota nenastavena / value not set<?cs elif:which == "new" ?>hodnota smazána / value deleted<?cs /if ?><?cs /alt ?><?cs /def ?>
<?cs def:print_value_bool(which, varname, if_true, if_false) ?><?cs if:which == "old" ?><?cs set:lvarname = varname.old ?><?cs elif:which == "new" ?><?cs set:lvarname = varname.new ?><?cs /if ?><?cs if:lvarname == "1" ?><?cs var:if_true ?><?cs elif:lvarname == "0" ?><?cs var:if_false ?><?cs /if ?><?cs /def ?>
<?cs def:print_value_list(which, varname, itemname) ?><?cs if:which == "old" ?><?cs each:item = varname.old ?><?cs var:itemname ?>: <?cs var:item ?>
<?cs /each ?><?cs elif:which == "new" ?><?cs each:item = varname.new ?><?cs var:itemname ?>: <?cs var:item ?>
<?cs /each ?><?cs /if ?><?cs /def ?>

<?cs def:objtype(ot) ?><?cs if:ot == #3 ?>domain<?cs elif:ot == #1 ?>contact<?cs elif:ot == #2 ?>nsset<?cs elif:ot == #4 ?>keyset<?cs /if ?><?cs /def ?>
<?cs def:whoislink(type,handle) ?><?cs var:defaults.whoispage ?>/<?cs call:objtype(type) ?>/<?cs var:handle ?>/<?cs /def ?>

<?cs def:value_list(which) ?><?cs if:changes.object.authinfo ?>Heslo / Authinfo: <?cs if:which == "old" ?>důvěrný údaj / private value<?cs elif:which == "new" ?>hodnota byla změněna / value was changed<?cs /if ?>
<?cs /if ?><?cs if:type == #1 ?><?cs if:changes.contact.name ?>Jméno / Name: <?cs call:print_value(which, changes.contact.name) ?>
<?cs /if ?><?cs if:changes.contact.org ?>Organizace / Organization: <?cs call:print_value(which, changes.contact.org) ?>
<?cs /if ?><?cs if:changes.contact.address.permanent ?>Trvalá Adresa / Permanent Address: <?cs call:print_value(which, changes.contact.address.permanent) ?>
<?cs /if ?><?cs if:changes.contact.address.mailing ?>Korespondenční adresa / Mailing address: <?cs call:print_value(which, changes.contact.address.mailing) ?>
<?cs /if ?><?cs if:changes.contact.address.billing ?>Fakturační adresa / Billing address: <?cs call:print_value(which, changes.contact.address.billing) ?>
<?cs /if ?><?cs if:changes.contact.address.shipping ?>Dodací adresa / Shipping address: <?cs call:print_value(which, changes.contact.address.shipping) ?>
<?cs /if ?><?cs if:changes.contact.address.shipping_2 ?>Dodací adresa / Shipping address: <?cs call:print_value(which, changes.contact.address.shipping_2) ?>
<?cs /if ?><?cs if:changes.contact.address.shipping_3 ?>Dodací adresa / Shipping address: <?cs call:print_value(which, changes.contact.address.shipping_3) ?>
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
<?cs /if ?><?cs if:changes.nsset.tech_c ?>Technické kontakty / Technical contacts: <?cs call:print_value(which, changes.nsset.tech_c) ?>
<?cs /if ?><?cs if:changes.nsset.dns ?><?cs call:print_value_list(which, changes.nsset.dns, "Jmenný server / Name server") ?>
<?cs /if ?><?cs elif:type == #3 ?><?cs if:changes.domain.registrant ?>Držitel / Holder: <?cs call:print_value(which, changes.domain.registrant) ?>
<?cs /if ?><?cs if:changes.domain.nsset ?>Sada jmenných serverů / Name server set: <?cs call:print_value(which, changes.domain.nsset) ?>
<?cs /if ?><?cs if:changes.domain.keyset ?>Sada klíčů / Key set: <?cs call:print_value(which, changes.domain.keyset) ?>
<?cs /if ?><?cs if:changes.domain.admin_c ?>Administrativní kontakty / Administrative contacts: <?cs call:print_value(which, changes.domain.admin_c) ?>
<?cs /if ?><?cs if:changes.domain.temp_c ?>Dočasné kontakty / Temporary contacts: <?cs call:print_value(which, changes.domain.temp_c) ?>
<?cs /if ?><?cs if:changes.domain.val_ex_date ?>Validováno do / Validation expiration date: <?cs call:print_value(which, changes.domain.val_ex_date) ?>
<?cs /if ?><?cs if:changes.domain.publish ?>Přidat do ENUM tel.sezn. / Include in ENUM dict: <?cs call:print_value_bool(which, changes.domain.publish, "ano / yes", "ne / no") ?>
<?cs /if ?><?cs elif:type == #4 ?><?cs if:changes.keyset.tech_c ?>Technické kontakty / Technical contacts: <?cs call:print_value(which, changes.keyset.tech_c) ?>
<?cs /if ?><?cs if:changes.keyset.dnskey ?><?cs call:print_value_list(which, changes.keyset.dnskey, "klíče DNS / DNS keys") ?>
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


Úplné detaily <?cs call:typesubst("cs") ?> najdete na <?cs call:whoislink(type, handle) ?>
The full details of <?cs call:typesubst("ensmall") ?> can be seen at <?cs call:whoislink(type, handle) ?>

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
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (11, 11);

INSERT INTO mail_type (id, name, subject) VALUES (12, 'notification_transfer', '<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>Oznámení o transferu <?cs call:typesubst("cs") ?> <?cs var:handle ?> / Notification of <?cs call:typesubst("en") ?> <?cs var:handle ?> transfer');
INSERT INTO mail_type_priority VALUES ((SELECT id FROM mail_type WHERE name = 'notification_transfer'), 3);
INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id) VALUES ((SELECT id FROM mail_type WHERE name = 'notification_transfer'), 1);
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(12, 'plain', 1,
'<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs elif:lang == "ensmall" ?><?cs if:type == #3 ?>domain<?cs elif:type == #1 ?>contact<?cs elif:type == #2 ?>nsset<?cs elif:type == #4 ?>keyset<?cs /if ?><?cs /if ?><?cs /def ?>
<?cs def:objtype(ot) ?><?cs if:ot == #3 ?>domain<?cs elif:ot == #1 ?>contact<?cs elif:ot == #2 ?>nsset<?cs elif:ot == #4 ?>keyset<?cs /if ?><?cs /def ?>
<?cs def:whoislink(type,handle) ?><?cs var:defaults.whoispage ?>/<?cs call:objtype(type) ?>/<?cs var:handle ?>/<?cs /def ?>
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

Detaily <?cs call:typesubst("cs") ?> najdete na <?cs call:whoislink(type, handle) ?>
Details of <?cs call:typesubst("ensmall") ?> can be seen at <?cs call:whoislink(type, handle) ?>

V případě dotazů se prosím obracejte na svého určeného registrátora,
u kterého byla změna provedena.
In case of any questions please contact your designated registrar
which performed the change.

S pozdravem / Yours sincerely
podpora <?cs var:defaults.company_cs ?> / Support of <?cs var:defaults.company_en ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (12, 12);

INSERT INTO mail_type (id, name, subject) VALUES (13, 'notification_renew', 'Oznámení o prodloužení platnosti domény <?cs var:handle ?> / Notification of <?cs var:handle ?> domain name renewal');
INSERT INTO mail_type_priority VALUES ((SELECT id FROM mail_type WHERE name = 'notification_renew'), 3);
INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id) VALUES ((SELECT id FROM mail_type WHERE name = 'notification_renew'), 1);
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(13, 'plain', 1,
'<?cs def:objtype(ot) ?><?cs if:ot == #3 ?>domain<?cs elif:ot == #1 ?>contact<?cs elif:ot == #2 ?>nsset<?cs elif:ot == #4 ?>keyset<?cs /if ?><?cs /def ?>
<?cs def:whoislink(type,handle) ?><?cs var:defaults.whoispage ?>/<?cs call:objtype(type) ?>/<?cs var:handle ?>/<?cs /def ?>
=====================================================================
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

Detail domény najdete na <?cs call:whoislink(3, handle) ?>
Details of the domain can be seen at <?cs call:whoislink(3, handle) ?>

S pozdravem / Yours sincerely
podpora <?cs var:defaults.company_cs ?> / Support of <?cs var:defaults.company_en ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (13, 13);

INSERT INTO mail_type (id, name, subject) VALUES (14, 'notification_unused', '<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>Oznámení o zrušení <?cs call:typesubst("cs") ?> <?cs var:handle ?> / Notification of <?cs call:typesubst("en") ?> <?cs var:handle ?> deletion');
INSERT INTO mail_type_priority VALUES ((SELECT id FROM mail_type WHERE name = 'notification_unused'), 3);
INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id) VALUES ((SELECT id FROM mail_type WHERE name = 'notification_unused'), 1);
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(14, 'plain', 1,
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
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (14, 14);

INSERT INTO mail_type (id, name, subject) VALUES (15, 'notification_delete', '<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>Oznámení o zrušení <?cs call:typesubst("cs") ?> <?cs var:handle ?> / Notification of <?cs call:typesubst("en") ?> <?cs var:handle ?> deletion');
INSERT INTO mail_type_priority VALUES ((SELECT id FROM mail_type WHERE name = 'notification_delete'), 3);
INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id) VALUES ((SELECT id FROM mail_type WHERE name = 'notification_delete'), 1);
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(15, 'plain', 1,
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
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (15, 15);

INSERT INTO mail_type (id, name, subject) VALUES (16, 'techcheck', 'Výsledek technické kontroly sady nameserverů <?cs var:handle ?> / Results of technical check on the NS set <?cs var:handle ?>');
INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id) VALUES ((SELECT id FROM mail_type WHERE name = 'techcheck'), 1);
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(16, 'plain', 1,
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
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (16, 16);

INSERT INTO mail_type (id, name, subject) VALUES (17, 'invoice_deposit', 'Potvrzení o přijaté záloze / Confirmation of received advance payment');
INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id) VALUES ((SELECT id FROM mail_type WHERE name = 'invoice_deposit'), 1);
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(17, 'plain', 1,
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
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (17, 17);

INSERT INTO mail_type (id, name, subject) VALUES (18, 'invoice_audit', 'Zaslání měsíčního vyúčtování / Monthly bill dispatching');
INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id) VALUES ((SELECT id FROM mail_type WHERE name = 'invoice_audit'), 1);
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(18, 'plain', 1,
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
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (18, 18);

INSERT INTO mail_type (id, name, subject) VALUES (19, 'invoice_noaudit', 'Zaslání měsíčního vyúčtování / Monthly bill dispatching');
INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id) VALUES ((SELECT id FROM mail_type WHERE name = 'invoice_noaudit'), 1);
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(19, 'plain', 1,
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
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (19, 19);

INSERT INTO mail_type (id, name, subject) VALUES (20, 'request_block', 'Informace o vyřízení žádosti / Information about request handling ');
INSERT INTO mail_type_priority VALUES ((SELECT id FROM mail_type WHERE name = 'request_block'), 3);
INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id) VALUES ((SELECT id FROM mail_type WHERE name = 'request_block'), 1);
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(20, 'plain', 1,
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
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (20, 20);

INSERT INTO mail_type (id, name, subject) VALUES (28, 'merge_contacts_auto', 'Oznámení o sloučení duplicitních záznamů / Information on the merging of duplicate entries');
INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id) VALUES ((SELECT id FROM mail_type WHERE name = 'merge_contacts_auto'), 1);
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(28, 'plain', 1,
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
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (28, 28);


---
--- Ticket #9475
---

INSERT INTO mail_type (id, name, subject) VALUES (29, 'contact_check_notice', 'Výzva k opravě či doložení správnosti údajů kontaktu <?cs var:contact_handle ?> / Notice to correct data of contact <?cs var:contact_handle ?>');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(29, 'plain', 1,
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
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (29, 29);


INSERT INTO mail_type (id, name, subject) VALUES (30, 'contact_check_warning', 'Druhá výzva k opravě či doložení správnosti údajů kontaktu <?cs var:contact_handle ?> / Second notice to correct data of contact <?cs var:contact_handle ?>');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(30, 'plain', 1,
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
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (30, 30);

