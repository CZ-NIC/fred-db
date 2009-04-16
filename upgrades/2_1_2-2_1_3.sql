--
-- Ticket #1441 object names added to email subject (expiration and notification)
--

ALTER TABLE mail_type ALTER subject TYPE varchar(550);

UPDATE mail_type SET subject = 'Upozornění na nutnost úhrady domény <?cs var:domain ?> / Reminder of the need to settle fees for the domain <?cs var:domain ?>' WHERE name = 'expiration_notify';

UPDATE mail_type SET subject = 'Oznámení o vyřazení domény <?cs var:domain ?> z DNS / Notification about inactivation of the domain <?cs var:domain ?> from DNS' WHERE name = 'expiration_dns_owner';

UPDATE mail_type SET subject = 'Oznámení o zrušení domény <?cs var:domain ?> / Notification about cancellation of the domain <?cs var:domain ?>' WHERE name = 'expiration_register_owner';

UPDATE mail_type SET subject = 'Oznámení o vyřazení domény <?cs var:domain ?> z DNS / Notification about withdrawal of the domain <?cs var:domain ?> from DNS' WHERE name = 'expiration_dns_tech';

UPDATE mail_type SET subject = 'Oznámení o zrušení domény <?cs var:domain ?> / Notification about cancellation of the domain <?cs var:domain ?>' WHERE name = 'expiration_register_tech';

UPDATE mail_type SET subject = 'Oznámení vypršení validace enum domény <?cs var:domain ?> / Notification about expiration of the enum domain <?cs var:domain ?> validation' WHERE name = 'expiration_validation_before';

UPDATE mail_type SET subject = 'Oznámení o vypršení validace enum domény <?cs var:domain ?> / Notification about expiration of the enum domain <?cs var:domain ?> validation' WHERE name = 'expiration_validation';

UPDATE mail_type SET subject = '<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>Oznámení o registraci <?cs call:typesubst("cs") ?> <?cs var:handle ?> / <?cs call:typesubst("en") ?> <?cs var:handle ?> registration notification' WHERE name = 'notification_create';

UPDATE mail_type SET subject = '<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>domain<?cs elif:type == #1 ?>contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>keyset<?cs /if ?><?cs /if ?><?cs /def ?>Oznámení změn <?cs call:typesubst("cs") ?> <?cs var:handle ?>/ Notification of <?cs call:typesubst("en") ?> <?cs var:handle ?> changes' WHERE name = 'notification_update';

UPDATE mail_type SET subject = '<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>Oznámení o transferu <?cs call:typesubst("cs") ?> <?cs var:handle ?> / <?cs call:typesubst("en") ?> <?cs var:handle ?> transfer notification' WHERE name = 'notification_transfer';

UPDATE mail_type SET subject = 'Oznámení o prodloužení platnosti domény <?cs var:handle ?> / Domain name <?cs var:handle ?> renew notification' WHERE name = 'notification_renew';

UPDATE mail_type SET subject = '<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>Oznámení o zrušení <?cs call:typesubst("cs") ?> <?cs var:handle ?> / <?cs call:typesubst("en") ?> <?cs var:handle ?> delete notification' WHERE name = 'notification_unused';

UPDATE mail_type SET subject = '<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>Oznámení o zrušení <?cs call:typesubst("cs") ?> <?cs var:handle ?> / <?cs call:typesubst("en") ?> <?cs var:handle ?> delete notification' WHERE name = 'notification_delete';


--
-- Ticket #1353 epp update command changes added to email body
--

UPDATE mail_templates
SET template =
'<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>

<?cs def:print_value(which, varname) ?><?cs if:which == "old" ?><?cs set:varname = varname.old ?><?cs elif:which == "new" ?><?cs set:varname = varname.new ?><?cs /if ?><?cs alt:varname ?>hodnota nevyplněna / non-filled value<?cs /alt ?><?cs /def ?>

<?cs def:value_list(which) ?><?cs if:changes.object.authinfo ?>Heslo / Authinfo: <?cs call:print_value(which, changes.object.authinfo) ?>
<?cs /if ?><?cs if:type == #1 ?>  <?cs if:changes.contact.name ?>Jméno / Name: <?cs call:print_value(which, changes.contact.name) ?>
<?cs /if ?>  <?cs if:changes.contact.org ?>Organizace / Organization: <?cs call:print_value(which, changes.contact.org) ?>
<?cs /if ?>  <?cs if:changes.contact.telephone ?>Telefon / Telephone: <?cs call:print_value(which, changes.contact.telephone) ?>
<?cs /if ?>  <?cs if:changes.contact.fax ?>Fax / Fax: <?cs call:print_value(which, changes.contact.fax) ?>
<?cs /if ?>  <?cs if:changes.contact.email ?>Email / Email: <?cs call:print_value(which, changes.contact.email) ?>
<?cs /if ?>  <?cs if:changes.contact.notify_email ?>Notifikační email / Notify email: <?cs call:print_value(which, changes.contact.notify_email) ?>
<?cs /if ?>  <?cs if:changes.contact.ident_type ?>Typ identifikace / Identification type: <?cs call:print_value(which, changes.contact.ident_type) ?>
<?cs /if ?>  <?cs if:changes.contact.ident ?>Identifikační údaj / Identification data: <?cs call:print_value(which, changes.contact.ident) ?>
<?cs /if ?>  <?cs if:changes.contact.vat ?>DIĆ / VAT number: <?cs call:print_value(which, changes.contact.vat) ?>
<?cs /if ?>  <?cs if:changes.contact.disclose_name ?>Zveřejnit jméno / Disclose name: <?cs call:print_value(which, changes.contact.disclose_name) ?>
<?cs /if ?>  <?cs if:changes.contact.disclose_org ?>Zveřejnit organizaci / Disclose organization: <?cs call:print_value(which, changes.contact.disclose_org) ?>
<?cs /if ?>  <?cs if:changes.contact.disclose_email ?>Zveřejnit email / Disclose email: <?cs call:print_value(which, changes.contact.disclose_email) ?>
<?cs /if ?>  <?cs if:changes.contact.disclose_notify_email ?>Zveřejnit notifikační email / Disclose notify email: <?cs call:print_value(which, changes.contact.disclose_notify_email) ?>
<?cs /if ?>  <?cs if:changes.contact.disclose_ident ?>Zveřejnit identifikační údaj / Disclose identification: <?cs call:print_value(which, changes.contact.disclose_ident) ?>
<?cs /if ?>  <?cs if:changes.contact.disclose_vat ?>Zveřejnit DIĆ / Disclose VAT number: <?cs call:print_value(which, changes.contact.disclose_vat) ?>
<?cs /if ?>  <?cs if:changes.contact.disclose_telephone ?>Zveřejnit telefon / Disclose telepohone: <?cs call:print_value(which, changes.contact.disclose_telephone) ?>
<?cs /if ?>  <?cs if:changes.contact.disclose_fax ?>Zveřejnit fax / Disclose fax: <?cs call:print_value(which, changes.contact.disclose_fax) ?>
<?cs /if ?><?cs elif:type == #2 ?>  <?cs if:changes.nsset.check_level ?>Úroveň tech. kontrol / Check level: <?cs call:print_value(which, changes.nsset.check_level) ?>
<?cs /if ?>  <?cs if:changes.nsset.admin-c ?>Technické kontakty / Technical contacts: <?cs call:print_value(which, changes.nsset.admin-c) ?>
<?cs /if ?>  <?cs if:changes.nsset.dns ?>Jmenné servery / Name servers: <?cs call:print_value(which, changes.nsset.dns) ?>
<?cs /if ?><?cd elif:type == #3 ?>  <?cs if:changes.domain.registrant ?>Držitel / Holder: <?cs call:print_value(which, changes.domain.registrant) ?>
<?cs /if ?>  <?cs if:changes.domain.nsset ?>Sada jmenných serverů / Name server set: <?cs call:print_value(which, changes.domain.nsset) ?>
<?cs /if ?>  <?cs if:changes.domain.keyset ?>Sada klíčů / Key set: <?cs call:print_value(which, changes.domain.keyset) ?>
<?cs /if ?>  <?cs if:changes.domain.admin-c ?>Administrativní  kontakty / Administrative contacts: <?cs call:print_value(which, changes.domain.admin-c) ?>
<?cs /if ?>  <?cs if:changes.domain.temp-c ?>Dočasné kontakty / Temporary contacts: <?cs call:print_value(which, changes.domain.temp-c) ?>
<?cs /if ?><?cd elif:type == #4 ?>  <?cs if:changes.domain.admin-c ?>Administrativní  kontakty / Administrative contacts: <?cs call:print_value(which, changes.domain.admin-c) ?>
<?cs /if ?><?cs /if ?><?cs /def ?>
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

Původní hodnoty / Original values:
<?cs call:value_list("old") ?>

Nové hodnoty / New values:
<?cs call:value_list("new") ?>


Detail <?cs call:typesubst("cs") ?> najdete na <?cs var:defaults.whoispage ?>.
For detail information about <?cs call:typesubst("en") ?> visit <?cs var:defaults.whoispage ?>.


                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>
'
WHERE id = 11;


--
-- Ticket #1346 zone parameter added to invoicing emails
--

UPDATE mail_templates SET template =
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
' WHERE id = 17;

UPDATE mail_templates SET template = 
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
' WHERE id = 18;

UPDATE mail_templates SET template =
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
' WHERE id = 19;
