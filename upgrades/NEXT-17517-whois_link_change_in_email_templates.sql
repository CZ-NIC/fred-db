---
--- Ticket #17517 - whois link changes
---
UPDATE mail_templates SET template =
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
'
WHERE id = 10;


UPDATE mail_templates SET template =
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
'
WHERE id = 11;

UPDATE mail_templates SET template =
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
'
WHERE id = 12;

UPDATE mail_templates SET template =
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
'
WHERE id = 13;

UPDATE mail_defaults SET value = 'https://www.nic.cz/whois' WHERE name = 'whoispage';
