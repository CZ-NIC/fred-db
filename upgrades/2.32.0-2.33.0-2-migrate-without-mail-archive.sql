---
--- Fix template first to not create new version of it
---
UPDATE mail_templates SET template =
'<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs elif:lang == "ensmall" ?><?cs if:type == #3 ?>domain<?cs elif:type == #1 ?>contact<?cs elif:type == #2 ?>nsset<?cs elif:type == #4 ?>keyset<?cs /if ?><?cs /if ?><?cs /def ?>

<?cs def:print_value(which, varname) ?><?cs if:which == "old" ?><?cs set:lvarname = varname.old ?><?cs elif:which == "new" ?><?cs set:lvarname = varname.new ?><?cs /if ?><?cs alt:lvarname ?><?cs if:which == "old" ?>hodnota nenastavena / value not set<?cs elif:which == "new" ?>hodnota smazána / value deleted<?cs /if ?><?cs /alt ?><?cs /def ?>
<?cs def:print_value_bool(which, varname, if_true, if_false) ?><?cs if:which == "old" ?><?cs set:lvarname = varname.old ?><?cs elif:which == "new" ?><?cs set:lvarname = varname.new ?><?cs /if ?><?cs if:lvarname == "1" ?><?cs var:if_true ?><?cs elif:lvarname == "0" ?><?cs var:if_false ?><?cs /if ?><?cs /def ?>
<?cs def:print_value_list(which, varname, itemname) ?><?cs if:which == "old" ?><?cs each:item = varname.old ?><?cs var:itemname ?>: <?cs var:item ?>
<?cs /each ?><?cs elif:which == "new" ?><?cs each:item = varname.new ?><?cs var:itemname ?>: <?cs var:item ?>
<?cs /each ?><?cs /if ?><?cs /def ?>

<?cs def:objtype(ot) ?><?cs if:ot == #3 ?>domain<?cs elif:ot == #1 ?>contact<?cs elif:ot == #2 ?>nsset<?cs elif:ot == #4 ?>keyset<?cs /if ?><?cs /def ?>
<?cs def:whoislink(type,handle) ?><?cs var:defaults.whoispage ?>/<?cs call:objtype(type) ?>/<?cs var:handle ?>/<?cs /def ?>

<?cs def:value_list(which) ?><?cs if:subcount(changes.object.authinfo) ?>Heslo / Authinfo: <?cs if:which == "old" ?>důvěrný údaj / private value<?cs elif:which == "new" ?>hodnota byla změněna / value was changed<?cs /if ?>
<?cs /if ?><?cs if:type == #1 ?><?cs if:changes.contact.name ?>Jméno / Name: <?cs call:print_value(which, changes.contact.name) ?>
<?cs /if ?><?cs if:subcount(changes.contact.org) ?>Organizace / Organization: <?cs call:print_value(which, changes.contact.org) ?>
<?cs /if ?><?cs if:subcount(changes.contact.address.permanent) ?>Trvalá Adresa / Permanent Address: <?cs call:print_value(which, changes.contact.address.permanent) ?>
<?cs /if ?><?cs if:subcount(changes.contact.address.mailing) ?>Korespondenční adresa / Mailing address: <?cs call:print_value(which, changes.contact.address.mailing) ?>
<?cs /if ?><?cs if:subcount(changes.contact.address.billing) ?>Fakturační adresa / Billing address: <?cs call:print_value(which, changes.contact.address.billing) ?>
<?cs /if ?><?cs if:subcount(changes.contact.address.shipping) ?>Dodací adresa / Shipping address: <?cs call:print_value(which, changes.contact.address.shipping) ?>
<?cs /if ?><?cs if:subcount(changes.contact.address.shipping_2) ?>Dodací adresa / Shipping address: <?cs call:print_value(which, changes.contact.address.shipping_2) ?>
<?cs /if ?><?cs if:subcount(changes.contact.address.shipping_3) ?>Dodací adresa / Shipping address: <?cs call:print_value(which, changes.contact.address.shipping_3) ?>
<?cs /if ?><?cs if:subcount(changes.contact.telephone) ?>Telefon / Telephone: <?cs call:print_value(which, changes.contact.telephone) ?>
<?cs /if ?><?cs if:subcount(changes.contact.fax) ?>Fax / Fax: <?cs call:print_value(which, changes.contact.fax) ?>
<?cs /if ?><?cs if:subcount(changes.contact.email) ?>E-mail / Email: <?cs call:print_value(which, changes.contact.email) ?>
<?cs /if ?><?cs if:subcount(changes.contact.notify_email) ?>Notifikační e-mail / Notification email: <?cs call:print_value(which, changes.contact.notify_email) ?>
<?cs /if ?><?cs if:subcount(changes.contact.ident_type) ?>Typ identifikace / Identification type: <?cs call:print_value(which, changes.contact.ident_type) ?>
<?cs /if ?><?cs if:subcount(changes.contact.ident) ?>Identifikační údaj / Identification data: <?cs call:print_value(which, changes.contact.ident) ?>
<?cs /if ?><?cs if:subcount(changes.contact.vat) ?>DIČ / VAT number: <?cs call:print_value(which, changes.contact.vat) ?>
<?cs /if ?><?cs if:subcount(changes.contact.disclose) > #0 ?>Viditelnost údajů / Data visibility:
<?cs if:subcount(changes.contact.disclose.name) ?>  Jméno / Name: <?cs call:print_value_bool(which, changes.contact.disclose.name, "veřejné / public", "skryté / hidden") ?>
<?cs /if ?><?cs if:subcount(changes.contact.disclose.org) ?>  Organizace / Organization: <?cs call:print_value_bool(which, changes.contact.disclose.org, "veřejná / public", "skrytá / hidden") ?>
<?cs /if ?><?cs if:subcount(changes.contact.disclose.email) ?>  E-mail / Email: <?cs call:print_value_bool(which, changes.contact.disclose.email, "veřejný / public", "skrytý / hidden") ?>
<?cs /if ?><?cs if:subcount(changes.contact.disclose.address) ?>  Adresa / Address: <?cs call:print_value_bool(which, changes.contact.disclose.address, "veřejná / public", "skrytá / hidden") ?>
<?cs /if ?><?cs if:subcount(changes.contact.disclose.notify_email) ?>  Notifikační e-mail / Notification email: <?cs call:print_value_bool(which, changes.contact.disclose.notify_email, "veřejný / public", "skrytý / hidden") ?>
<?cs /if ?><?cs if:subcount(changes.contact.disclose.ident) ?>  Identifikační údaj / Identification data: <?cs call:print_value_bool(which, changes.contact.disclose.ident, "veřejný / public", "skrytý / hidden") ?>
<?cs /if ?><?cs if:subcount(changes.contact.disclose.vat) ?>  DIČ / VAT number: <?cs call:print_value_bool(which, changes.contact.disclose.vat, "veřejné / public", "skryté / hidden") ?>
<?cs /if ?><?cs if:subcount(changes.contact.disclose.telephone) ?>  Telefon / Telephone: <?cs call:print_value_bool(which, changes.contact.disclose.telephone, "veřejný / public", "skrytý / hidden") ?>
<?cs /if ?><?cs if:subcount(changes.contact.disclose.fax) ?>  Fax / Fax: <?cs call:print_value_bool(which, changes.contact.disclose.fax, "veřejný / public", "skrytý / hidden") ?>
<?cs /if ?><?cs /if ?><?cs elif:type == #2 ?><?cs if:subcount(changes.nsset.check_level) ?>Úroveň tech. kontrol / Check level: <?cs call:print_value(which, changes.nsset.check_level) ?>
<?cs /if ?><?cs if:subcount(changes.nsset.tech_c) ?>Technické kontakty / Technical contacts: <?cs call:print_value(which, changes.nsset.tech_c) ?>
<?cs /if ?><?cs if:subcount(changes.nsset.dns) ?><?cs call:print_value_list(which, changes.nsset.dns, "Jmenný server / Name server") ?>
<?cs /if ?><?cs elif:type == #3 ?><?cs if:subcount(changes.domain.registrant) ?>Držitel / Holder: <?cs call:print_value(which, changes.domain.registrant) ?>
<?cs /if ?><?cs if:subcount(changes.domain.nsset) ?>Sada jmenných serverů / Name server set: <?cs call:print_value(which, changes.domain.nsset) ?>
<?cs /if ?><?cs if:subcount(changes.domain.keyset) ?>Sada klíčů / Key set: <?cs call:print_value(which, changes.domain.keyset) ?>
<?cs /if ?><?cs if:subcount(changes.domain.admin_c) ?>Administrativní kontakty / Administrative contacts: <?cs call:print_value(which, changes.domain.admin_c) ?>
<?cs /if ?><?cs if:subcount(changes.domain.temp_c) ?>Dočasné kontakty / Temporary contacts: <?cs call:print_value(which, changes.domain.temp_c) ?>
<?cs /if ?><?cs if:subcount(changes.domain.val_ex_date) ?>Validováno do / Validation expiration date: <?cs call:print_value(which, changes.domain.val_ex_date) ?>
<?cs /if ?><?cs if:subcount(changes.domain.publish) ?>Přidat do ENUM tel.sezn. / Include in ENUM dict: <?cs call:print_value_bool(which, changes.domain.publish, "ano / yes", "ne / no") ?>
<?cs /if ?><?cs elif:type == #4 ?><?cs if:subcount(changes.keyset.tech_c) ?>Technické kontakty / Technical contacts: <?cs call:print_value(which, changes.keyset.tech_c) ?>
<?cs /if ?><?cs if:subcount(changes.keyset.dnskey) ?><?cs call:print_value_list(which, changes.keyset.dnskey, "klíče DNS / DNS keys") ?>
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
 
žádost byla úspěšně zpracována, <?cs if:subcount(changes) ?>požadované změny byly provedeny<?cs else ?>žádná změna nebyla požadována, údaje zůstaly beze změny<?cs /if ?>.
The request was processed successfully, <?cs if:subcount(changes) ?>the required changes have been applied<?cs else ?>no changes were requested, the data remains the same<?cs /if ?>.

<?cs if:subcount(changes) ?>
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


---
--- mail_defaults => mail_template_default
---
INSERT INTO mail_template_default
     VALUES (1, (SELECT json_object(array_agg('defaults.' || name), array_agg(value)) FROM mail_defaults));


---
--- mail_footer => mail_template_footer
---
INSERT INTO mail_template_footer (id, footer) SELECT id, footer FROM mail_footer;


---
--- mail_header_defaults => mail_header_default
---
INSERT INTO mail_header_default
       (id, h_from, h_replyto, h_errorsto, h_organization, h_contentencoding, h_messageidserver)
SELECT id, h_from, h_replyto, h_errorsto, h_organization, h_contentencoding, h_messageidserver
  FROM mail_header_defaults;


---
--- mail_templates, mail_type => mail_template
---
INSERT INTO mail_template
       (mail_type_id, subject, body_template, body_template_content_type,
        mail_template_footer_id, mail_template_default_id, mail_header_default_id)
SELECT mt.id, mt.subject, mts.template, mts.contenttype,
       mts.footer, 1, COALESCE(mtmhdm.mail_header_defaults_id, 1)
  FROM mail_type mt
  JOIN mail_type_template_map mttm ON mttm.typeid = mt.id
  JOIN mail_templates mts ON mts.id = mttm.templateid
  LEFT JOIN mail_type_mail_header_defaults_map mtmhdm ON mtmhdm.mail_type_id = mt.id;
