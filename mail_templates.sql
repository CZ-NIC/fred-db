\encoding       UTF8

--
-- This script may be called only on just created mail tables, because
-- we assume that sequence numbers are reset to 1 in this script.
--

INSERT INTO mail_type (name, subject) VALUES ('sendauthinfo_pif', 'Zaslání autorizační informace / Sending authorization information');
INSERT INTO mail_templates (contenttype, footer, template) VALUES
('plain', 1,
'English version of the e-mail is entered below the Czech version

Zaslání autorizační informace

Vážený zákazníku,

   na základě Vaší žádosti podané prostřednictvím webového formuláře
na stránce <?cs var:wwwpage ?> dne <?cs var:reqdate ?>, které
bylo přiděleno identifikační číslo <?cs var:reqid ?>, Vám zasíláme požadované
heslo, příslušející <?cs if:type == #3 ?>k doméně<?cs elif:type == #1 ?>ke kontaktu s identifikátorem<?cs elif:type == #2 ?>k sadě nameserverů s identifikátorem<?cs /if ?> <?cs var:handle ?>.

   Heslo je: <?cs var:authinfo ?>

   V případě, že jste tuto žádost nepodali, oznamte prosím tuto
skutečnost na adresu <?cs var:defaults.emailsupport ?>.

                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>



Sending authorization information

Dear customer,

   Based on your request submitted via the web form on the
<?cs var:wwwpage ?> page on <?cs var:reqdate ?>, which received
the identification number <?cs var:reqid ?>, we are sending you the requested
password that belongs to the <?cs if:type == #3 ?>domain name<?cs elif:type == #1 ?>contact with identifier<?cs elif:type == #2 ?>NS set with identifier<?cs /if ?> <?cs var:handle ?>.

   The password is: <?cs var:authinfo ?>

   If you did not submit the aforementioned request, please, notify us about
this fact at the following address <?cs var:defaults.emailsupport ?>.


                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (1, 1);

INSERT INTO mail_type (name, subject) VALUES ('sendauthinfo_epp', 'Zaslání autorizační informace / Sending authorization information');
INSERT INTO mail_templates (contenttype, footer, template) VALUES
('plain', 1,
'English version of the e-mail is entered below the Czech version

Zaslání autorizační informace

Vážený zákazníku,

   na základě Vaší žádosti podané prostřednictvím registrátora
<?cs var:registrar ?>, jejímž obsahem je žádost o zaslání hesla
příslušející <?cs if:type == #3 ?>k doméně<?cs elif:type == #1 ?>ke kontaktu s identifikátorem<?cs elif:type == #2 ?>k sadě nameserverů s identifikátorem<?cs /if ?> <?cs var:handle ?>.

   Heslo je: <?cs var:authinfo ?>

   Tato zpráva je zaslána pouze na e-mailovou adresu uvedenou u příslušné
osoby v Centrálním registru doménových jmen.

   V případě, že jste tuto žádost nepodali, oznamte prosím tuto
skutečnost na adresu <?cs var:defaults.emailsupport ?>.


                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>



Sending authorization information

Dear customer,

   Based on your request submitted via the registrar <?cs var:registrar ?>,
which contains your request for sending you the password that belongs to
the <?cs if:type == #3 ?>domain name<?cs elif:type == #1 ?>contact with identifier<?cs elif:type == #2 ?>NS set with identifier<?cs /if ?> <?cs var:handle ?>.

   The password is: <?cs var:authinfo ?>

   This message is being sent only to the e-mail address that we have on file
for a particular person in the Central Registry of Domain Names.

   If you did not submit the aforementioned request, please, notify us about
this fact at the following address <?cs var:defaults.emailsupport ?>.


                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (2, 2);

INSERT INTO mail_type (name, subject) VALUES ('expiration_notify', 'Upozornění na nutnost úhrady domény / Reminder of the need to settle fees for the domain');
INSERT INTO mail_templates (contenttype, footer, template) VALUES
('plain', 1,
'English version of the e-mail is entered below the Czech version

Upozornění na nutnost úhrady domény <?cs var:domain ?>

Vážený zákazníku,

dovolujeme si Vás upozornit, že k <?cs var:checkdate ?> dosud nedošlo k prodloužení
registrace doménového jména <?cs var:domain ?>. Vzhledem k tomu, že doménové
jméno bylo za uplynulé období zaplaceno pouze do <?cs var:exdate ?>, nachází se
nyní v takzvané ochranné lhůtě. V případě, že doménové jméno nebude včas
uhrazeno, budou v souladu s Pravidly registrace doménových jmen nasledovat
tyto kroky:

<?cs var:dnsdate ?> - Znefunkčnění doménového jména (vyřazení z DNS).
<?cs var:exregdate ?> - Definitivní zrušení registrace doménového jména.

V této chvíli evidujeme následující údaje o doméně:

Doménové jméno: <?cs var:domain ?>
Držitel: <?cs var:owner ?>
Registrátor: <?cs var:registrar ?>
<?cs each:item = administrators ?>Administrativní kontakt: <?cs var:item ?>
<?cs /each ?>
Vzhledem k této situaci máte nyní následující možnosti:

1. Kontaktujte prosím svého registrátora a ve spolupráci s ním zajistěte
   prodloužení registrace vašeho doménového jména

2. Nebo si vyberte jiného určeného registrátora a jeho prostřednictvím
   zajistěte prodloužení registrace vašeho doménového jména. Seznam
   registrátorů najdete na www.nic.cz (Seznam registrátorů)


                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>



Reminder of the need to settle fees for the <?cs var:domain ?> domain name

Dear customer,

We would like to inform you that as of <?cs var:checkdate ?>, the registration
of the domain name <?cs var:domain ?> has not been extended. Concerning
the fact that the fee for the domain name in question has been paid only
for a period ended on <?cs var:exdate ?>, your domain name has now entered
the so-called protective period. Unless a registrar of your choice extends
your registration, the following steps will be adopted in accordance with
the Domain Name Registration Rules:

<?cs var:dnsdate ?> - The domain name will not be accessible (exclusion from DNS).
<?cs var:exregdate ?> - Final cancellation of the domain name registration.

At present, our database includes the following details concerning your domain:

Domain name: <?cs var:domain ?>
Holder: <?cs var:owner ?>
Registrar: <?cs var:registrar ?>
<?cs each:item = administrators ?>Admin contact: <?cs var:item ?>
<?cs /each ?>
To ensure adequate remedy of the existing situation, you can choose
one of the following:

1. Please contact your registrar and make sure that the registration
   of your domain name is duly extended.

2. Or choose another registrar in order to extend the registration of your
   domain name. For a list of registrars, please visit www.nic.cz
   (List of Registrars)


                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (3, 3);


INSERT INTO mail_type (name, subject) VALUES ('expiration_dns_owner', 'Oznámení o vyřazení domény z DNS / Notification about inactivation of the domain from DNS');
INSERT INTO mail_templates (contenttype, footer, template) VALUES
('plain', 1,
'English version of the e-mail is entered below the Czech version

Oznámení o vyřazení domény <?cs var:domain?> z DNS

Vážený zákazníku,

dovolujeme si Vás tímto upozornit, že doposud nebyla uhrazena platba
za prodloužení doménového jména <?cs var:domain ?>. Vzhledem k této
skutečnosti a na základě Pravidel registrace doménových jmen,
<?cs var:defaults.company ?> pozastavuje registraci doménového jména a vyřazuje
ji ze zóny <?cs var:zone ?>.

V případě, že do dne <?cs var:exdate ?> neobdrží <?cs var:defaults.company ?> od vašeho
registrátora platbu za prodloužení platnosti doménového jména, bude
doménové jméno definitivně uvolněno pro použití dalším zájemcem, a to
ke dni <?cs var:exregdate ?>.

Prosíme kontaktujte Vašeho Určeného registrátora <?cs var:registrar ?>
za účelem prodloužení doménového jména.

V případě, že se domníváte, že platba byla provedena, prověřte nejdříve,
zda byla provedena pod spravným variabilním symbolem, na správné číslo
účtu a ve spravné výši a tyto informace svému Určenému registrátorovi
sdělte.

Harmonogram plánovaných akcí:

<?cs var:dnsdate ?> - Znefunkčnění doménového jména (vyřazení z DNS).
<?cs var:exregdate ?> - Definitivní zrušení registrace doménového jména.

V této chvíli evidujeme následující údaje o doméně:

Doménové jméno: <?cs var:domain ?>
Držitel: <?cs var:owner ?>
Registrátor: <?cs var:registrar ?>
<?cs each:item = administrators ?>Administrativní kontakt: <?cs var:item ?>
<?cs /each ?>

                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>



Notification about inactivation of the <?cs var:domain?> domain from DNS

Dear customer,

We would like to notify you that the payment for extension of the domain name
<?cs var:domain ?> has not been received yet. With regard to that fact
and in accordance with Rules for domain names registrations, <?cs var:defaults.company ?>
is suspending the domain name registration and is withdrawing it from the
<?cs var:zone ?> zone.

In case that by <?cs var:exdate ?>, <?cs var:defaults.company ?> will not receive the payment
for extension of the domain name from your registrar, your domain name will
be definitely released for a use by another applicant on <?cs var:exregdate ?>.

Please, contact your designated registrar <?cs var:registrar ?>
for a purpose of extension of the domain name.

If you believe that the payment was made, please, check first if the payment
was made with the correct variable symbol, to the correct account number, and
with the correct amount, and convey this information to your designated
registrar.

Time-schedule of planned events:

<?cs var:dnsdate ?> - Domain name blocking (withdrawal from DNS).
<?cs var:exregdate ?> - Definitive cancellation of the domain name registration.

At this moment, we have the following information about the domain in our
records:

Domain name: <?cs var:domain ?>
Owner: <?cs var:owner ?>
Registrar: <?cs var:registrar ?>
<?cs each:item = administrators ?>Admin contact: <?cs var:item ?>
<?cs /each ?>

                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (4, 4);


INSERT INTO mail_type (name, subject) VALUES ('expiration_register_owner', 'Oznámení o zrušení domény / Notification about cancellation of the domain');
INSERT INTO mail_templates (contenttype, footer, template) VALUES
('plain', 1,
'English version of the e-mail is entered below the Czech version

Oznámení o zrušení domény <?cs var:domain ?>

Vážený zákazníku,

dovolujeme si Vás upozornit, že nebylo provedeno prodloužení registrace
pro doménové jméno <?cs var:domain ?>. Vzhledem k této skutečnosti
a na základě Pravidel registrace doménových jmen, <?cs var:defaults.company ?>
ruší registraci doménového jména.


                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>



Notification about cancellation of the domain <?cs var:domain ?>

Dear customer,

we would like to inform you that the registration extension has not yet been
implemented for the domain name <?cs var:domain ?>. Due to this fact and
based on the Domain Name Registration Rules (Pravidla registrace domenovych
jmen), <?cs var:defaults.company ?> is cancelling the domain name registration.


                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (5, 5);

INSERT INTO mail_type (name, subject) VALUES ('expiration_dns_tech', 'Oznámení o vyřazení domény z DNS / Notification about withdrawal of the domain from DNS');
INSERT INTO mail_templates (contenttype, footer, template) VALUES
('plain', 1,
'English version of the e-mail is entered below the Czech version

Oznámení o vyřazení domény <?cs var:domain ?> z DNS

Vážený technický správce,

vzhledem k tomu, že jste vedený jako technický kontakt u sady nameserverů
<?cs var:nsset ?>, která je přiřazena k doménovému jménu <?cs var:domain ?>,
dovolujeme si Vás upozornit, že toto doménové jméno bylo ke dni
<?cs var:exdate ?> vyřazeno z DNS.


                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>



Notification about withdrawal of the domain <?cs var:domain ?> from DNS

Dear technical administrator,

With regard to the fact that you are named the technical contact for the set
<?cs var:nsset ?> of nameservers, which is assigned to the <?cs var:domain ?>
domain name, we would like to notify you that the aforementioned domain name
was withdrawn from DNS as of <?cs var:exdate ?>.


                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (6, 6);

INSERT INTO mail_type (name, subject) VALUES ('expiration_register_tech', 'Oznámení o zrušení domény / Notification about cancellation of the domain');
INSERT INTO mail_templates (contenttype, footer, template) VALUES
('plain', 1,
'English version of the e-mail is entered below the Czech version

Oznámení o zrušení domény <?cs var:domain ?>

Vážený technický správce,

vzhledem k tomu, že jste vedený jako technický kontakt u sady nameserverů
<?cs var:nsset ?>, která je přiřazena k doménovému jménu <?cs var:domain ?>,
dovolujeme si Vás upozornit, že toto doménové jméno bylo ke dni
<?cs var:exregdate ?> zrušeno.


                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>



Notification about cancellation of the domain <?cs var:domain ?>

Dear technical administrator,

With regard to the fact that you are named the technical contact for the set
of <?cs var:nsset ?> nameservers, which is assigned to the <?cs var:domain ?>
domain name, we would like to notify you that the aforementioned domain name
was cancelled as of <?cs var:exregdate ?>.


                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (7, 7);

INSERT INTO mail_type (name, subject) VALUES ('expiration_validation_before', 'Oznámení vypršení validace enum domény / Notification about expiration of the enum domain validation');
INSERT INTO mail_templates (contenttype, footer, template) VALUES
('plain', 1,
'English version of the e-mail is entered below the Czech version

Oznámení o blížícím se vypršení validace enum domény.

Vážený zákazníku,

dovolujeme si Vás upozornit, že k <?cs var:checkdate ?> dosud nedošlo k prodloužení
validace doménového jména <?cs var:domain ?>, která je platná do <?cs var:valdate ?>.
V případě, že hodláte obnovit validaci uvedeného doménového jména, kontaktujte
prosím svého registrátora a ve spolupráci s ním zajistěte prodloužení validace
vašeho doménového jména před tímto datem.

V této chvíli evidujeme následující údaje o doméně:

Doménové jméno: <?cs var:domain ?>
Držitel: <?cs var:owner ?>
Registrátor: <?cs var:registrar ?>
<?cs each:item = administrators ?>Administrativní kontakt: <?cs var:item ?>
<?cs /each ?>

                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>



Notification about approaching expiration of the enum domain validation

Dear customer,

We would like to notify you that as of <?cs var:checkdate ?>, extension of
the <?cs var:domain ?> domain name validation has not been made, yet.
Validation will expire on <?cs var:valdate ?>. If you plan to renew validation
of the aforementioned domain name, please, contact your registrar, and
together execute the extension of validation of your domain name before
this date.

At this moment, we have the following information about the domain in our
records:

Domain name: <?cs var:domain ?>
Owner: <?cs var:owner ?>
Registrar: <?cs var:registrar ?>
<?cs each:item = administrators ?>Admin contact: <?cs var:item ?>
<?cs /each ?>

                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (8, 8);

INSERT INTO mail_type (name, subject) VALUES ('expiration_validation', 'Oznámení o vypršení validace enum domény / Notification about expiration of the enum domain validation');
INSERT INTO mail_templates (contenttype, footer, template) VALUES
('plain', 1,
'English version of the e-mail is entered below the Czech version

Oznámení o vypršení validace enum domény.

Vážený zákazníku,

dovolujeme si Vás upozornit, že k <?cs var:checkdate ?> dosud nedošlo k prodloužení
validace doménového jména <?cs var:domain ?>. Vzhledem k této skutečnosti
a na základě Pravidel registrace doménových jmen, ji <?cs var:defaults.company ?>
vyřazuje ze zóny. Doménové jméno je i nadále registrováno. V případě, že
hodláte obnovit validaci uvedeného doménového jména, kontaktujte prosím svého
registrátora a ve spolupráci s ním zajistěte prodloužení validace vašeho
doménového jména.

V této chvíli evidujeme následující údaje o doméně:

Doménové jméno: <?cs var:domain ?>
Držitel: <?cs var:owner ?>
Registrátor: <?cs var:registrar ?>
<?cs each:item = administrators ?>Administrativní kontakt: <?cs var:item ?>
<?cs /each ?>

                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>



Notification about expiration of the enum domain validation

Dear customer,

We would like to notify you that as of <?cs var:checkdate ?>, extension of
the <?cs var:domain ?> domain name validation has not been made, yet.
With regard to this fact and in accordance with Rules for domain names
registrations, <?cs var:defaults.company ?> is withdrawing it from the zone. The domain
name continues to be registered. If you plan to renew validation of the
aforementioned domain name, please, contact your registrar, and together
execute the extension of validation of your domain name.

At this moment, we have the following information about the domain in our
records:

Domain name: <?cs var:domain ?>
Owner: <?cs var:owner ?>
Registrar: <?cs var:registrar ?>
<?cs each:item = administrators ?>Admin contact: <?cs var:item ?>
<?cs /each ?>


                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (9, 9);

INSERT INTO mail_type (name, subject) VALUES ('notification_create', 'Oznámení o registraci / Registration notification');
INSERT INTO mail_templates (contenttype, footer, template) VALUES
('plain', 1,
'<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs /if ?><?cs /if ?><?cs /def ?>
======================================================================
Oznámení o registraci / Registration notification
======================================================================
Registrace <?cs call:typesubst("cs") ?> / <?cs call:typesubst("en") ?> create 
Identifikátor <?cs call:typesubst("cs") ?> / <?cs call:typesubst("en") ?> handle : <?cs var:handle ?>
Číslo žádosti / Ticket :  <?cs var:ticket ?>
Registrátor / Registrar : <?cs var:registrar ?>
======================================================================

Žádost byla úspešně zpracována, požadovaná registrace byla provedena. 
The request was completed successfully, required registration was done. 


                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (10, 10);

INSERT INTO mail_type (name, subject) VALUES ('notification_update', 'Oznámení změn / Notification of changes');
INSERT INTO mail_templates (contenttype, footer, template) VALUES
('plain', 1,
'<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs /if ?><?cs /if ?><?cs /def ?>
=====================================================================
Oznámení změn / Notification of changes 
=====================================================================
Změna údajů <?cs call:typesubst("cs") ?> / <?cs call:typesubst("en") ?> data change 
Identifikátor <?cs call:typesubst("cs") ?> / <?cs call:typesubst("en") ?> handle : <?cs var:handle ?>
Číslo žádosti / Ticket :  <?cs var:ticket ?>
Registrátor / Registrar : <?cs var:registrar ?>
=====================================================================
 
Žádost byla úspešně zpracována, požadované změny byly provedeny. 
The request was completed successfully, required changes were done. 
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (11, 11);

INSERT INTO mail_type (name, subject) VALUES ('notification_transfer', 'Oznámení o transferu / Transfer notification');
INSERT INTO mail_templates (contenttype, footer, template) VALUES
('plain', 1,
'<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs /if ?><?cs /if ?><?cs /def ?>
=====================================================================
Oznámení o transferu / Transfer notification
=====================================================================
Transfer <?cs call:typesubst("cs") ?> / <?cs call:typesubst("en") ?> transfer
Identifikátor <?cs call:typesubst("cs") ?> / <?cs call:typesubst("en") ?> handle : <?cs var:handle ?>
Číslo žádosti / Ticket :  <?cs var:ticket ?>
Registrátor / Registrar : <?cs var:registrar ?>
=====================================================================
 
Žádost byla úspešně zpracována, transfer byl proveden. 
The request was completed successfully, transfer was completed. 
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (12, 12);

INSERT INTO mail_type (name, subject) VALUES ('notification_renew', 'Oznámení o prodloužení platnosti / Domain name renew notification');
INSERT INTO mail_templates (contenttype, footer, template) VALUES
('plain', 1,
'
=====================================================================
Oznámení o prodloužení platnosti / Notification about renewal
===================================================================== 
Obnovení domény / Domain renew
Domény / Domain : <?cs var:handle ?>
Číslo žádosti / Ticket :  <?cs var:ticket ?>
Registrátor / Registrar : <?cs var:registrar ?>
=====================================================================

Žádost byla úspešně zpracována, prodloužení platnosti bylo provedeno. 
The request was completed successfully, domain was renewed. 
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (13, 13);

INSERT INTO mail_type (name, subject) VALUES ('notification_unused', 'Oznámení o zrušení / Delete notification');
INSERT INTO mail_templates (contenttype, footer, template) VALUES
('plain', 1,
'
=====================================================================
Oznámení o zrušení / Delete notification 
=====================================================================
Vzhledem ke skutečnosti, že <?cs if:type == #1 ?>kontaktní osoba<?cs elif:type == #2 ?>sada nameserverů<?cs /if ?> <?cs var:handle ?>
<?cs var:name ?> nebyla po stanovenou dobu aktivní, <?cs var:defaults.company ?>
na základě Pravidel registrace ruší ke dni <?cs var:deldate ?> uvedenou
<?cs if:type == #1 ?>kontaktní osobu<?cs elif:type == #2 ?>sadu nameserverů<?cs /if ?>.

With regard to the fact that the <?cs if:type == #1 ?>contact<?cs elif:type == #2 ?>NS set<?cs /if ?> <?cs var:handle ?>
<?cs var:name ?> was not active during the past 2 months, <?cs var:defaults.company ?>
is cancelling the aforementioned <?cs if:type == #1 ?>contact<?cs elif:type == #2 ?>set of nameservers<?cs /if ?> as of <?cs var:deldate ?>.
=====================================================================
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (14, 14);

INSERT INTO mail_type (name, subject) VALUES ('notification_delete', 'Oznámení o zrušení / Delete notification');
INSERT INTO mail_templates (contenttype, footer, template) VALUES
('plain', 1,
'<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs /if ?><?cs /if ?><?cs /def ?>
=====================================================================
Oznámení o zrušení / Delete notification 
=====================================================================
Zrušení <?cs call:typesubst("cs") ?> / <?cs call:typesubst("en") ?> deletion
Identifikator <?cs call:typesubst("cs") ?> / <?cs call:typesubst("en") ?> handle : <?cs var:handle ?>
Cislo zadosti / Ticket :  <?cs var:ticket ?>
Registrator / Registrar : <?cs var:registrar ?>
=====================================================================
 
Žádost byla úspěšně zpracována, požadované zrušení bylo provedeno. 
The request was completed successfully, required delete was done. 
 
=====================================================================
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (15, 15);

INSERT INTO mail_type (name, subject) VALUES ('techcheck', 'Výsledek technického testu / Technical check result');
INSERT INTO mail_templates (contenttype, footer, template) VALUES
('plain', 1,
'
Výsledek technické kontroly sady nameserverů <?cs var:handle ?>
Result of technical check on NS set <?cs var:handle ?>

Datum kontroly / Date of the check: <?cs var:checkdate ?>
Číslo žádosti / Ticket: <?cs var:ticket ?>

<?cs def:printtest(par_test) ?><?cs if:par_test.name == "existance" ?>Následující nameservery v sadě nameserverů nejsou dosažitelné:
Following nameservers in NS set are not reachable:
    <?cs each:ns = par_test.ns ?><?cs var:ns ?>
<?cs /each ?><?cs /if ?><?cs if:par_test.name == "autonomous" ?>Sada nameserverů neobsahuje minimálně dva nameservery v různých
autonomních systémech.
In NS set are no two nameservers in different autonomous systems.<?cs /if ?><?cs if:par_test.name == "presence" ?><?cs each:ns = par_test.ns ?>Nameserver <?cs var:ns ?> neobsahuje záznam pro domény:
Nameserver <?cs var:ns ?> does not contain record for domains:
      <?cs each:fqdn = ns.fqdn ?><?cs var:fqdn ?>
      <?cs /each ?><?cs if:ns.overfull ?>...<?cs /if ?>
<?cs /each ?><?cs /if ?><?cs if:par_test.name == "authoritative" ?><?cs each:ns = par_test.ns ?>Nameserver <?cs var:ns ?> není autoritativní pro domény:
Nameserver <?cs var:ns ?> is not authoritative for domains:
      <?cs each:fqdn = ns.fqdn ?><?cs var:fqdn ?>
      <?cs /each ?><?cs if:ns.overfull ?>...<?cs /if ?>
<?cs /each ?><?cs /if ?><?cs if:par_test.name == "heterogenous" ?>Všechny nameservery v sadě nameserverů používají stejnou implementaci
DNS serveru.
All nameservers in NS set use the same implementation of DNS server.<?cs /if ?><?cs if:par_test.name == "recursive" ?>Následující nameservery v sadě nameserverů jsou rekurzivní:
Following nameservers in NS set are recursive:
    <?cs each:ns = par_test.ns ?><?cs var:ns ?>
    <?cs /each ?><?cs /if ?><?cs if:par_test.name == "recursive4all" ?>Následující nameservery v sadě nameserverů zodpověděli rekurzivně dotaz:
Following nameservers in NS set answered recursively a query:
    <?cs each:ns = par_test.ns ?><?cs var:ns ?>
    <?cs /each ?><?cs /if ?><?cs /def ?>
=====================================================================
Chyby / Errors:
<?cs each:item = tests ?><?cs if:item.type == "error" ?><?cs call:printtest(item) ?><?cs /if ?>
<?cs /each ?>
=====================================================================
Varování / Warnings:
<?cs each:item = tests ?><?cs if:item.type == "warning" ?><?cs call:printtest(item) ?><?cs /if ?>
<?cs /each ?>
=====================================================================
Upozornění / Notice:
<?cs each:item = tests ?><?cs if:item.type == "notice" ?><?cs call:printtest(item) ?><?cs /if ?>
<?cs /each ?>
=====================================================================
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (16, 16);

INSERT INTO mail_type (name, subject) VALUES ('invoice_deposit', 'Přijatá záloha / xxx');
INSERT INTO mail_templates (contenttype, footer, template) VALUES
('plain', 1,
'English version of the e-mail is entered below the Czech version

Zaslání potvrzení o přijaté záloze

Vážený obchodní přátelé,

  v příloze zasíláme daňový doklad na přijatou zálohu. Tento daňový doklad 
slouží k uplatnění nároku na odpočet DPH přijaté zálohy

                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>



English version is not available yet.

                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (17, 17);

INSERT INTO mail_type (name, subject) VALUES ('invoice_audit', 'Měsíční vyúčtování / xxx');
INSERT INTO mail_templates (contenttype, footer, template) VALUES
('plain', 1,
'English version of the e-mail is entered below the Czech version

Zaslání měsíčního vyúčtování

Vážený obchodní přátelé,

  v příloze zasíláme daňový doklad za služby registrací doménových jmen a 
udržování záznamů o doménových jménech za období od <?cs var:fromdate ?>
do <?cs var:todate ?>.

                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>



English version is not available yet.

                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (18, 18);

INSERT INTO mail_type (name, subject) VALUES ('invoice_noaudit', 'Měsíční vyúčtování / xxx');
INSERT INTO mail_templates (contenttype, footer, template) VALUES
('plain', 1,
'English version of the e-mail is entered below the Czech version

Zaslání měsíčního vyúčtování

Vážený obchodní přátelé,

  jelikož v období od <?cs var:fromdate ?> do <?cs var:todate ?> Vaše společnost neprovedla
žádnou registraci doménového jména ani prodloužení platnosti doménového
jména a nedošlo tak k čerpání žádných placených služeb, nebude pro toto
období vystaven daňový doklad.

                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>



English version is not available yet.

                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (19, 19);

