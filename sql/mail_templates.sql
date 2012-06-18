
--
-- This script may be called only on just created mail tables, because
-- we assume that sequence numbers are reset to 1 in this script.
--

INSERT INTO mail_type (id, name, subject) VALUES (1, 'sendauthinfo_pif', 'Zaslání autorizační informace / Sending authorization information');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(1, 'plain', 1,
'English version of the e-mail is entered below the Czech version

Zaslání autorizační informace

Vážený zákazníku,

   na základě Vaší žádosti podané prostřednictvím webového formuláře
na stránkách sdružení dne <?cs var:reqdate ?>, které
bylo přiděleno identifikační číslo <?cs var:reqid ?>, Vám zasíláme požadované
heslo, příslušející <?cs if:type == #3 ?>k doméně<?cs elif:type == #1 ?>ke kontaktu s identifikátorem<?cs elif:type == #2 ?>k sadě nameserverů s identifikátorem<?cs elif:type == #4 ?>k sadě klíčů s identifikátorem<?cs /if ?> <?cs var:handle ?>.

   Heslo je: <?cs var:authinfo ?>

   V případě, že jste tuto žádost nepodali, oznamte prosím tuto
skutečnost na adresu <?cs var:defaults.emailsupport ?>.

                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>



Sending authorization information

Dear customer,

   Based on your request submitted via the web form on the association
pages on <?cs var:reqdate ?>, which received
the identification number <?cs var:reqid ?>, we are sending you the requested
password that belongs to the <?cs if:type == #3 ?>domain name<?cs elif:type == #1 ?>contact with identifier<?cs elif:type == #2 ?>NS set with identifier<?cs elif:type == #4 ?>Keyset with identifier<?cs /if ?> <?cs var:handle ?>.

   The password is: <?cs var:authinfo ?>

   If you did not submit the aforementioned request, please notify us about
this fact at the following address <?cs var:defaults.emailsupport ?>.


                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (1, 1);

INSERT INTO mail_type (id, name, subject) VALUES (2, 'sendauthinfo_epp', 'Zaslání autorizační informace / Sending authorization information');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(2, 'plain', 1,
' English version of the e-mail is entered below the Czech version

Zaslání autorizační informace

Vážený zákazníku,

   na základě Vaší žádosti, podané prostřednictvím registrátora
<?cs var:registrar ?>, Vám zasíláme požadované heslo
příslušející <?cs if:type == #3 ?>k doméně<?cs elif:type == #1 ?>ke kontaktu s identifikátorem<?cs elif:type == #2 ?>k sadě nameserverů s identifikátorem<?cs elif:type == #4 ?>k sadě klíčů s identifikátorem<?cs /if ?> <?cs var:handle ?>.

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
we are sending the requested password that belongs to
the <?cs if:type == #3 ?>domain name<?cs elif:type == #1 ?>contact with identifier<?cs elif:type == #2 ?>NS set with identifier<?cs elif:type == #4 ?>Keyset with identifier<?cs /if ?> <?cs var:handle ?>.

   The password is: <?cs var:authinfo ?>

   This message is being sent only to the e-mail address that we have on file
for a particular person in the Central Registry of Domain Names.

   If you did not submit the aforementioned request, please notify us about
this fact at the following address <?cs var:defaults.emailsupport ?>.


                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (2, 2);

INSERT INTO mail_type (id, name, subject) VALUES (3, 'expiration_notify', 'Upozornění na nutnost úhrady domény <?cs var:domain ?> / Reminder of the need to settle fees for the domain <?cs var:domain ?>');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(3, 'plain', 1,
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
   registrátorů najdete na stránkách sdružení (Seznam registrátorů)


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
   domain name. For a list of registrars, please visit association pages
   (List of Registrars)


                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (3, 3);


INSERT INTO mail_type (id, name, subject) VALUES (4, 'expiration_dns_owner', 'Oznámení o vyřazení domény <?cs var:domain ?> z DNS / Notification about inactivation of the domain <?cs var:domain ?> from DNS');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(4, 'plain', 1,
'English version of the e-mail is entered below the Czech version

Oznámení o vyřazení domény <?cs var:domain?> z DNS

Vážený zákazníku,

dovolujeme si Vás tímto upozornit, že doposud nebyla uhrazena platba
za prodloužení doménového jména <?cs var:domain ?>. Vzhledem k této
skutečnosti a na základě Pravidel registrace doménových jmen,
<?cs var:defaults.company ?> pozastavuje registraci doménového jména a vyřazuje
ji ze zóny <?cs var:zone ?>.

V případě, že do dne <?cs var:exregdate ?> neobdrží <?cs var:defaults.company ?> od vašeho
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

In case that by <?cs var:exregdate ?>, <?cs var:defaults.company ?> will not receive the payment
for extension of the domain name from your registrar, your domain name will
be definitely released for a use by another applicant on <?cs var:exregdate ?>.

Please, contact your designated registrar <?cs var:registrar ?>
for a purpose of extension of the domain name.

If you believe that the payment was made, please, check first if the payment
was made with the correct variable symbol, to the correct account number, and
with the correct amount, and convey this information to your designated
registrar.

Time-schedule of planned events:

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


INSERT INTO mail_type (id, name, subject) VALUES (5, 'expiration_register_owner', 'Oznámení o zrušení domény <?cs var:domain ?> / Notification about cancellation of the domain <?cs var:domain ?>');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(5, 'plain', 1,
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

INSERT INTO mail_type (id, name, subject) VALUES (6, 'expiration_dns_tech', 'Oznámení o vyřazení domény <?cs var:domain ?> z DNS / Notification about withdrawal of the domain <?cs var:domain ?> from DNS');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(6, 'plain', 1,
'English version of the e-mail is entered below the Czech version

Oznámení o vyřazení domény <?cs var:domain ?> z DNS

Vážený technický správce,

vzhledem k tomu, že jste vedený jako technický kontakt u sady nameserverů
<?cs var:nsset ?>, která je přiřazena k doménovému jménu <?cs var:domain ?>,
dovolujeme si Vás upozornit, že toto doménové jméno bylo ke dni
<?cs var:statechangedate ?> vyřazeno z DNS.


                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>



Notification about withdrawal of the domain <?cs var:domain ?> from DNS

Dear technical administrator,

With regard to the fact that you are named the technical contact for the set
<?cs var:nsset ?> of nameservers, which is assigned to the <?cs var:domain ?>
domain name, we would like to notify you that the aforementioned domain name
was withdrawn from DNS as of <?cs var:statechangedate ?>.


                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (6, 6);

INSERT INTO mail_type (id, name, subject) VALUES (7, 'expiration_register_tech', 'Oznámení o zrušení domény <?cs var:domain ?> / Notification about cancellation of the domain <?cs var:domain ?>');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(7, 'plain', 1,
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

INSERT INTO mail_type (id, name, subject) VALUES (8, 'expiration_validation_before', 'Oznámení vypršení validace enum domény <?cs var:domain ?> / Notification about expiration of the enum domain <?cs var:domain ?> validation');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(8, 'plain', 1,
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

INSERT INTO mail_type (id, name, subject) VALUES (9, 'expiration_validation', 'Oznámení o vypršení validace enum domény <?cs var:domain ?> / Notification about expiration of the enum domain <?cs var:domain ?> validation');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(9, 'plain', 1,
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

INSERT INTO mail_type (id, name, subject) VALUES (10, 'notification_create', '<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>Oznámení o registraci <?cs call:typesubst("cs") ?> <?cs var:handle ?> / <?cs call:typesubst("en") ?> <?cs var:handle ?> registration notification');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(10, 'plain', 1,
'<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>
======================================================================
Oznámení o registraci / Registration notification
======================================================================
Registrace <?cs call:typesubst("cs") ?> / <?cs call:typesubst("en") ?> create 
Identifikátor <?cs call:typesubst("cs") ?> / <?cs call:typesubst("en") ?> handle : <?cs var:handle ?>
Číslo žádosti / Ticket :  <?cs var:ticket ?>
Registrátor / Registrar : <?cs var:registrar ?>
======================================================================

Žádost byla úspěšně zpracována, požadovaná registrace byla provedena. 
The request was completed successfully, required registration was done.<?cs if:type == #3 ?>

Při každé změně doporučujeme aktualizovat údaje o doméně, vyhnete se 
tak možným problémům souvisejícím s prodlužováním platnosti či manipulací 
s doménou osobami, které již nejsou oprávněny je provádět.
Update domain data in the registry after any changes to avoid possible 
problems with domain renewal or with domain manipulation done by persons 
who are not authorized anymore.<?cs /if ?>

Detail <?cs call:typesubst("cs") ?> najdete na <?cs var:defaults.whoispage ?>.
For detail information about <?cs call:typesubst("en") ?> visit <?cs var:defaults.whoispage ?>.


                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (10, 10);

INSERT INTO mail_type (id, name, subject) VALUES (11, 'notification_update', '<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>domain<?cs elif:type == #1 ?>contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>keyset<?cs /if ?><?cs /if ?><?cs /def ?>Oznámení změn <?cs call:typesubst("cs") ?> <?cs var:handle ?>/ Notification of <?cs call:typesubst("en") ?> <?cs var:handle ?> changes');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(11, 'plain', 1,
'<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>

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
<?cs /if ?><?cs if:changes.contact.email ?>Email / Email: <?cs call:print_value(which, changes.contact.email) ?>
<?cs /if ?><?cs if:changes.contact.notify_email ?>Notifikační email / Notify email: <?cs call:print_value(which, changes.contact.notify_email) ?>
<?cs /if ?><?cs if:changes.contact.ident_type ?>Typ identifikace / Identification type: <?cs call:print_value(which, changes.contact.ident_type) ?>
<?cs /if ?><?cs if:changes.contact.ident ?>Identifikační údaj / Identification data: <?cs call:print_value(which, changes.contact.ident) ?>
<?cs /if ?><?cs if:changes.contact.vat ?>DIČ / VAT number: <?cs call:print_value(which, changes.contact.vat) ?>
<?cs /if ?><?cs if:subcount(changes.contact.disclose) > #0 ?>Viditelnost údajů / Data visibility:
<?cs if:changes.contact.disclose.name ?>  Jméno / Name: <?cs call:print_value_bool(which, changes.contact.disclose.name, "veřejné / public", "skryté / hidden") ?>
<?cs /if ?><?cs if:changes.contact.disclose.org ?>  Organizace / Organization: <?cs call:print_value_bool(which, changes.contact.disclose.org, "veřejná / public", "skrytá / hidden") ?>
<?cs /if ?><?cs if:changes.contact.disclose.email ?>  Email / Email: <?cs call:print_value_bool(which, changes.contact.disclose.email, "veřejný / public", "skrytý / hidden") ?>
<?cs /if ?><?cs if:changes.contact.disclose.address ?>  Adresa / Address: <?cs call:print_value_bool(which, changes.contact.disclose.address, "veřejná / public", "skrytá / hidden") ?>
<?cs /if ?><?cs if:changes.contact.disclose.notify_email ?>  Notifikační email / Notify email: <?cs call:print_value_bool(which, changes.contact.disclose.notify_email, "veřejný / public", "skrytý / hidden") ?>
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
<?cs /if ?><?cs if:changes.domain.admin_c ?>Administrativní  kontakty / Administrative contacts: <?cs call:print_value(which, changes.domain.admin_c) ?>
<?cs /if ?><?cs if:changes.domain.temp_c ?>Dočasné kontakty / Temporary contacts: <?cs call:print_value(which, changes.domain.temp_c) ?>
<?cs /if ?><?cs if:changes.domain.val_ex_date ?>Validováno do / Validation expiration date: <?cs call:print_value(which, changes.domain.val_ex_date) ?>
<?cs /if ?><?cs if:changes.domain.publish ?>Přidat do ENUM tel.sezn. / Include into ENUM dict: <?cs call:print_value_bool(which, changes.domain.publish, "ano / yes", "ne / no") ?>
<?cs /if ?><?cs elif:type == #4 ?><?cs if:changes.keyset.admin_c ?>Technické kontakty / Technical contacts: <?cs call:print_value(which, changes.keyset.admin_c) ?>
<?cs /if ?><?cs if:subcount(changes.keyset.ds) > #0 ?><?cs call:print_value_list(which, changes.keyset.ds, "DS záznam / DS record") ?>
<?cs /if ?><?cs if:subcount(changes.keyset.dnskey) > #0 ?><?cs call:print_value_list(which, changes.keyset.dnskey, "DNS klíče / DNS keys") ?>
<?cs /if ?><?cs /if ?><?cs /def ?>
=====================================================================
Oznámení změn / Notification of changes 
=====================================================================
Změna údajů <?cs call:typesubst("cs") ?> / <?cs call:typesubst("en") ?> data change 
Identifikátor <?cs call:typesubst("cs") ?> / <?cs call:typesubst("en") ?> handle : <?cs var:handle ?>
Číslo žádosti / Ticket :  <?cs var:ticket ?>
Registrátor / Registrar : <?cs var:registrar ?>
=====================================================================
 
Žádost byla úspěšně zpracována, <?cs if:changes == #1 ?>požadované změny byly provedeny<?cs else ?>žádná změna nebyla požadována, údaje zůstaly beze změny<?cs /if ?>.
The request was completed successfully, <?cs if:changes == #1 ?>required changes were done<?cs else ?>no changes were found in the request.<?cs /if ?>

<?cs if:changes == #1 ?>
Původní hodnoty / Original values:
=====================================================================
<?cs call:value_list("old") ?>


Nové hodnoty / New values:
=====================================================================
<?cs call:value_list("new") ?>

Ostatní hodnoty zůstaly beze změny. 
Other data wasn''t modified.
<?cs /if ?>


Úplný detail <?cs call:typesubst("cs") ?> najdete na <?cs var:defaults.whoispage ?>.
For full detail information about <?cs call:typesubst("en") ?> visit <?cs var:defaults.whoispage ?>.

<?cs if:type == #1 ?>
Chcete mít snadnější přístup ke správě Vašich údajů? Založte si mojeID. Kromě 
nástroje, kterým můžete snadno a bezpečně spravovat údaje v centrálním 
registru, získáte také prostředek pro jednoduché přihlašování k Vašim 
oblíbeným webovým službám jediným jménem a heslem.
<?cs /if ?>

                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (11, 11);

INSERT INTO mail_type (id, name, subject) VALUES (12, 'notification_transfer', '<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>Oznámení o transferu <?cs call:typesubst("cs") ?> <?cs var:handle ?> / <?cs call:typesubst("en") ?> <?cs var:handle ?> transfer notification');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(12, 'plain', 1,
'<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>
=====================================================================
Oznámení o transferu / Transfer notification
=====================================================================
Transfer <?cs call:typesubst("cs") ?> / <?cs call:typesubst("en") ?> transfer
Identifikátor <?cs call:typesubst("cs") ?> / <?cs call:typesubst("en") ?> handle : <?cs var:handle ?>
Číslo žádosti / Ticket :  <?cs var:ticket ?>
Registrátor / Registrar : <?cs var:registrar ?>
=====================================================================
 
Žádost byla úspěšně zpracována, transfer byl proveden. 
The request was completed successfully, transfer was completed. 

Detail <?cs call:typesubst("cs") ?> najdete na <?cs var:defaults.whoispage ?>.
For detail information about <?cs call:typesubst("en") ?> visit <?cs var:defaults.whoispage ?>.


                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (12, 12);

INSERT INTO mail_type (id, name, subject) VALUES (13, 'notification_renew', 'Oznámení o prodloužení platnosti domény <?cs var:handle ?> / Domain name <?cs var:handle ?> renew notification');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(13, 'plain', 1,
'
=====================================================================
Oznámení o prodloužení platnosti / Notification about renewal
===================================================================== 
Obnovení domény / Domain renew
Domény / Domain : <?cs var:handle ?>
Číslo žádosti / Ticket :  <?cs var:ticket ?>
Registrátor / Registrar : <?cs var:registrar ?>
=====================================================================

Žádost byla úspěšně zpracována, prodloužení platnosti bylo provedeno. 
The request was completed successfully, domain was renewed. 

Při každé změně doporučujeme aktualizovat údaje o doméně, vyhnete se 
tak možným problémům souvisejícím s prodlužováním platnosti či manipulací 
s doménou osobami, které již nejsou oprávněny je provádět.
Update domain data in the registry after any changes to avoid possible 
problems with domain renewal or with domain manipulation done by persons 
who are not authorized anymore.

Detail domény najdete na <?cs var:defaults.whoispage ?>.
For detail information about domain visit <?cs var:defaults.whoispage ?>.


                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (13, 13);

INSERT INTO mail_type (id, name, subject) VALUES (14, 'notification_unused', '<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>Oznámení o zrušení <?cs call:typesubst("cs") ?> <?cs var:handle ?> / <?cs call:typesubst("en") ?> <?cs var:handle ?> delete notification');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(14, 'plain', 1,
'
=====================================================================
Oznámení o zrušení / Delete notification 
=====================================================================
Vzhledem ke skutečnosti, že <?cs if:type == #1 ?>kontaktní osoba<?cs elif:type == #2 ?>sada nameserverů<?cs elif:type == #4 ?>sada klíčů<?cs /if ?> <?cs var:handle ?> 
nebyla po stanovenou dobu používána, <?cs var:defaults.company ?> 
ruší ke dni <?cs var:deldate ?> uvedenou <?cs if:type == #1 ?>kontaktní osobu<?cs elif:type == #2 ?>sadu nameserverů<?cs elif:type == #4 ?>sadu klíčů<?cs /if ?>.

Zrušení <?cs if:type == #1 ?>kontaktní osoby<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?> nemá žádný vliv na funkčnost Vašich 
zaregistrovaných doménových jmen.

With regard to the fact that the <?cs if:type == #1 ?>contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>keyset<?cs /if ?> <?cs var:handle ?>
was not used during the fixed period, <?cs var:defaults.company ?>
is cancelling the aforementioned <?cs if:type == #1 ?>contact<?cs elif:type == #2 ?>set of nameservers<?cs elif:type == #4 ?>set of keysets<?cs /if ?> as of <?cs var:deldate ?>.

Cancellation of <?cs if:type == #1 ?>contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?> has no influence on functionality of your
registred domains.
=====================================================================


                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (14, 14);

INSERT INTO mail_type (id, name, subject) VALUES (15, 'notification_delete', '<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>Oznámení o zrušení <?cs call:typesubst("cs") ?> <?cs var:handle ?> / <?cs call:typesubst("en") ?> <?cs var:handle ?> delete notification');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(15, 'plain', 1,
'<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>
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


                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (15, 15);

INSERT INTO mail_type (id, name, subject) VALUES (16, 'techcheck', 'Výsledek technického testu / Technical check result');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(16, 'plain', 1,
'
Výsledek technické kontroly sady nameserverů <?cs var:handle ?>
Result of technical check on NS set <?cs var:handle ?>

Datum kontroly / Date of the check: <?cs var:checkdate ?>
Typ kontroly / Control type : periodická / periodic 
Číslo kontroly / Ticket: <?cs var:ticket ?>

<?cs def:printtest(par_test) ?><?cs if:par_test.name == "existence" ?>Následující nameservery v sadě nameserverů nejsou dosažitelné:
Following nameservers in NS set are not reachable:
<?cs each:ns = par_test.ns ?>    <?cs var:ns ?>
<?cs /each ?><?cs /if ?><?cs if:par_test.name == "autonomous" ?>Sada nameserverů neobsahuje minimálně dva nameservery v různých
autonomních systémech.
In NS set are no two nameservers in different autonomous systems.

<?cs /if ?><?cs if:par_test.name == "presence" ?><?cs each:ns = par_test.ns ?>Nameserver <?cs var:ns ?> neobsahuje záznam pro domény:
Nameserver <?cs var:ns ?> does not contain record for domains:
<?cs each:fqdn = ns.fqdn ?>    <?cs var:fqdn ?>
<?cs /each ?><?cs if:ns.overfull ?>    ...
<?cs /if ?><?cs /each ?><?cs /if ?><?cs if:par_test.name == "authoritative" ?><?cs each:ns = par_test.ns ?>Nameserver <?cs var:ns ?> není autoritativní pro domény:
Nameserver <?cs var:ns ?> is not authoritative for domains:
<?cs each:fqdn = ns.fqdn ?>    <?cs var:fqdn ?>
<?cs /each ?><?cs if:ns.overfull ?>    ...
<?cs /if ?><?cs /each ?><?cs /if ?><?cs if:par_test.name == "heterogenous" ?>Všechny nameservery v sadě nameserverů používají stejnou implementaci
DNS serveru.
All nameservers in NS set use the same implementation of DNS server.

<?cs /if ?><?cs if:par_test.name == "notrecursive" ?>Následující nameservery v sadě nameserverů jsou rekurzivní:
Following nameservers in NS set are recursive:
<?cs each:ns = par_test.ns ?>    <?cs var:ns ?>
<?cs /each ?><?cs /if ?><?cs if:par_test.name == "notrecursive4all" ?>Následující nameservery v sadě nameserverů zodpověděly rekurzivně dotaz:
Following nameservers in NS set answered recursively a query:
<?cs each:ns = par_test.ns ?>    <?cs var:ns ?>
<?cs /each ?><?cs /if ?><?cs if:par_test.name == "dnsseckeychase" ?>Pro následující domény přislušející sadě nameserverů nebylo možno
ověřit validitu DNSSEC podpisu:
For following domains belonging to NS set was unable to validate
DNSSEC signature:
<?cs each:domain = par_test.ns ?>    <?cs var:domain ?>
<?cs /each ?><?cs /if ?><?cs /def ?>
=== Chyby / Errors ==================================================

<?cs each:item = tests ?><?cs if:item.type == "error" ?><?cs call:printtest(item) ?><?cs /if ?><?cs /each ?>
=== Varování / Warnings =============================================

<?cs each:item = tests ?><?cs if:item.type == "warning" ?><?cs call:printtest(item) ?><?cs /if ?><?cs /each ?>
=== Upozornění / Notice =============================================

<?cs each:item = tests ?><?cs if:item.type == "notice" ?><?cs call:printtest(item) ?><?cs /if ?><?cs /each ?>
=====================================================================


                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (16, 16);

INSERT INTO mail_type (id, name, subject) VALUES (17, 'invoice_deposit', 'Přijatá záloha / Accepted advance payment');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(17, 'plain', 1,
'English version of the e-mail is entered below the Czech version

Zaslání potvrzení o přijaté záloze

Vážený obchodní přátelé,

  v příloze zasíláme daňový doklad na přijatou zálohu pro zónu <?cs var:zone ?>. Tento daňový doklad 
slouží k uplatnění nároku na odpočet DPH přijaté zálohy

                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>



Accepted Advance Payment Confirmation

Dear business partners,

  Enclosed with this letter, we are sending a tax document for the advance
payment accepted for the zone <?cs var:zone ?>. This tax document can be used to claim VAT deduction for
the advance payment.

                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (17, 17);

INSERT INTO mail_type (id, name, subject) VALUES (18, 'invoice_audit', 'Měsíční vyúčtování / Monthly billing');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(18, 'plain', 1,
'English version of the e-mail is entered below the Czech version

Zaslání měsíčního vyúčtování

Vážený obchodní přátelé,

  v příloze zasíláme daňový doklad za služby registrací doménových jmen a 
udržování záznamů o doménových jménech za období od <?cs var:fromdate ?>
do <?cs var:todate ?> pro zónu <?cs var:zone ?>.

                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>



Monthly Bill Dispatching

Dear business partners,

  Enclosed with this letter, we are sending a tax document for the domain name
registration services and the maintenance of domain name records for the period
from <?cs var:fromdate ?> to <?cs var:todate ?> for the zone <?cs var:zone ?>.

                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (18, 18);

INSERT INTO mail_type (id, name, subject) VALUES (19, 'invoice_noaudit', 'Měsíční vyúčtování / Monthly billing');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(19, 'plain', 1,
'English version of the e-mail is entered below the Czech version

Zaslání měsíčního vyúčtování

Vážený obchodní přátelé,

  jelikož v období od <?cs var:fromdate ?> do <?cs var:todate ?> v zóně <?cs var:zone ?> Vaše společnost neprovedla
žádnou registraci doménového jména ani prodloužení platnosti doménového
jména a nedošlo tak k čerpání žádných placených služeb, nebude pro toto
období vystaven daňový doklad.

                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>



Monthly Bill Dispatching

Dear business partners,

  Since your company has not performed any domain name registration or domain
name validity extension in the period from <?cs var:fromdate ?> to <?cs var:todate ?> for the zone <?cs var:zone ?>,
hence not drawing any paid services, no tax document will be issued for this
period.

                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (19, 19);

INSERT INTO mail_type (id, name, subject) VALUES (20, 'request_block', 'Informace o vyřízení žádosti / Information about processing of request ');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(20, 'plain', 1,
'English version of the e-mail is entered below the Czech version

Informace o vyřízení žádosti

Vážený zákazníku,

   na základě Vaší žádosti podané prostřednictvím webového formuláře
na stránkách sdružení dne <?cs var:reqdate ?>, které bylo přiděleno identifikační 
číslo <?cs var:reqid ?>, Vám oznamujeme, že požadovaná žádost o <?cs if:otype == #1 ?>zablokování<?cs elif:otype == #2 ?>odblokování<?cs /if ?>
<?cs if:rtype == #1 ?>změny dat<?cs elif:rtype == #2 ?>transferu k jinému registrátorovi<?cs /if ?> pro <?cs if:type == #3 ?>doménu<?cs elif:type == #1 ?>kontakt s identifikátorem<?cs elif:type == #2 ?>sadu nameserverů s identifikátorem<?cs elif:type == #4 ?>sadu klíčů s identifikátorem<?cs /if ?> <?cs var:handle ?> 
byla úspěšně realizována.  
<?cs if:otype == #1 ?>
U <?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu s identifikátorem<?cs elif:type == #2 ?>sady nameserverů s identifikátorem<?cs elif:type == #4 ?>sady klíčů s identifikátorem<?cs /if ?> <?cs var:handle ?> nebude možné provést 
<?cs if:rtype == #1 ?>změnu dat<?cs elif:rtype == #2 ?>transfer k jinému registrátorovi <?cs /if ?> až do okamžiku, kdy tuto blokaci 
zrušíte pomocí příslušného formuláře na stránkách sdružení.
<?cs /if?>
                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>

Information about processing of request

Dear customer,

   based on your request submitted via the web form on the association
pages on <?cs var:reqdate ?>, which received the identification number 
<?cs var:reqid ?>, we are announcing that your request for <?cs if:otype == #1 ?>blocking<?cs elif:otype == #2 ?>unblocking<?cs /if ?>
<?cs if:rtype == #1 ?>data changes<?cs elif:rtype == #2 ?>transfer to other registrar<?cs /if ?> for <?cs if:type == #3 ?>domain name<?cs elif:type == #1 ?>contact with identifier<?cs elif:type == #2 ?>NS set with identifier<?cs elif:type == #4 ?>Keyset with identifier<?cs /if ?> <?cs var:handle ?> 
has been realized.
<?cs if:otype == #1 ?>
No <?cs if:rtype == #1 ?>data changes<?cs elif:rtype == #2 ?>transfer to other registrar<?cs /if ?> of <?cs if:type == #3 ?>domain name<?cs elif:type == #1 ?>contact with identifier<?cs elif:type == #2 ?>NS set with identifier<?cs elif:type == #4 ?>Keyset with identifier<?cs /if ?> <?cs var:handle ?> 
will be possible until you cancel the blocking option using the 
applicable form on association pages. 
<?cs /if?>
                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (20, 20);
