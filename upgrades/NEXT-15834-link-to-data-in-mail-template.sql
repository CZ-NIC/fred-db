---
--- Ticket #15834 - change link of created contact to full description
---
UPDATE mail_templates SET template =
'
<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs elif:lang == "ensmall" ?><?cs if:type == #3 ?>domain<?cs elif:type == #1 ?>contact<?cs elif:type == #2 ?>nsset<?cs elif:type == #4 ?>keyset<?cs /if ?><?cs /if ?><?cs /def ?>

<?cs def:print_value(varname) ?><?cs set:lvarname = varname ?><?cs alt:lvarname ?>hodnota nenastavena / value not set<?cs /alt ?>  <?cs /def ?>

<?cs def:print_value_bool(varname, if_true, if_false) ?><?cs set:lvarname = varname ?><?cs if:lvarname == "1" ?><?cs var:if_true ?><?cs elif:lvarname == "0" ?><?cs var:if_false ?><?cs /if ?><?cs /def ?>

<?cs def:print_value_list(varname, itemname) ?><?cs set:count = #1 ?><?cs each:item = varname ?><?cs var:itemname ?><?cs var:count ?>:<?cs call:print_value(item) ?><?cs set:count = count + #1 ?> <?cs /each ?> <?cs /def ?> 

<?cs def:value_list() ?>
<?cs if:fresh.object.authinfo ?>Heslo / Authinfo: důvěrný údaj / private value
<?cs /if ?><?cs if:type == #1 ?><?cs if:fresh.contact.name ?>Jméno / Name: <?cs call:print_value(fresh.contact.name) ?>
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
<?cs /if ?><?cs /if ?><?cs elif:type == #2 ?><?cs if:fresh.nsset.check_level ?>Úroveň tech. kontrol / Check level: <?cs call:print_value(fresh.nsset.check_level) ?>
<?cs /if ?><?cs if:fresh.nsset.admin_c ?>Technické kontakty / Technical contacts: <?cs call:print_value(fresh.nsset.admin_c) ?>
<?cs /if ?><?cs if:subcount(fresh.nsset.dns) > #0 ?><?cs call:print_value_list(fresh.nsset.dns, "Jmenný server / Name server") ?>
<?cs /if ?><?cs elif:type == #3 ?><?cs if:fresh.domain.registrant ?>Držitel / Holder: <?cs call:print_value(fresh.domain.registrant) ?>
<?cs /if ?><?cs if:fresh.domain.nsset ?>Sada jmenných serverů / Name server set: <?cs call:print_value(fresh.domain.nsset) ?>
<?cs /if ?><?cs if:fresh.domain.keyset ?>Sada klíčů / Key set: <?cs call:print_value(fresh.domain.keyset) ?>
<?cs /if ?><?cs if:fresh.domain.admin_c ?>Administrativní kontakty / Administrative contacts: <?cs call:print_value(fresh.domain.admin_c) ?>
<?cs /if ?><?cs if:fresh.domain.temp_c ?>Dočasné kontakty / Temporary contacts: <?cs call:print_value(fresh.domain.temp_c) ?>
<?cs /if ?><?cs if:fresh.domain.val_ex_date ?>Validováno do / Validation expiration date: <?cs call:print_value(fresh.domain.val_ex_date) ?>
<?cs /if ?><?cs if:fresh.domain.publish ?>Přidat do ENUM tel.sezn. / Include in ENUM dict: <?cs call:print_value_bool(fresh.domain.publish, "ano / yes", "ne / no") ?>
<?cs /if ?><?cs elif:type == #4 ?><?cs if:fresh.keyset.admin_c ?>Technické kontakty / Technical contacts: <?cs call:print_value(fresh.keyset.admin_c) ?>
<?cs /if ?><?cs if:subcount(fresh.keyset.ds) > #0 ?><?cs call:print_value_list(fresh.keyset.ds, "záznam DS / DS record") ?>
<?cs /if ?><?cs if:subcount(fresh.keyset.dnskey) > #0 ?><?cs call:print_value_list(fresh.keyset.dnskey, "klíče DNS / DNS keys") ?>
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
Detaily <?cs call:typesubst("cs") ?> najdete na <?cs var:defaults.whoispage ?>?q=<?cs var:handle ?>
Details of <?cs call:typesubst("ensmall") ?> can be seen at <?cs var:defaults.whoispage ?>?q=<?cs var:handle ?>
<?cs else ?>
Detaily <?cs call:typesubst("cs") ?> jsou: / Details of the <?cs call:typesubst("ensmall") ?> are:
<?cs call:value_list() ?>
<?cs /if ?>

S pozdravem / Yours sincerely
podpora <?cs var:defaults.company_cs ?> / Support of <?cs var:defaults.company_en ?>
'
WHERE id = 10;
