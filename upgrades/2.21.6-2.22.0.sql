---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.22.0' WHERE id = 1;


--- Ticket #13341
--- remove trigger AFTER INSERT, preserve trigger AFTER UPDATE
DROP TRIGGER "trigger_lock_public_request"
  ON public_request;

CREATE TRIGGER "trigger_lock_public_request"
  AFTER UPDATE ON public_request
  FOR EACH ROW EXECUTE PROCEDURE lock_public_request();


--- Ticket #13440
--- Helps to write query using conditional index like type = 1
CREATE FUNCTION get_object_type_id(TEXT)
RETURNS integer AS
'SELECT id FROM enum_object_type WHERE name = $1'
LANGUAGE SQL IMMUTABLE RETURNS NULL ON NULL INPUT;

--- Add public requests used in MojeID function update_transfer_contact_prepare
INSERT INTO
    enum_public_request_type (id, name, description)
  VALUES
    (20, 'mojeid_prevalidated_unidentified_contact_transfer', 'MojeID pre-validated contact without identification transfer'),
    (21, 'mojeid_prevalidated_contact_transfer', 'MojeID pre-validated contact transfer');

--- parameter 15 can disable asynchronous generation of SMS messages.
--- possible values for disabling are 'disabled', 'disable', 'false', 'f' or '0'
--- other value or missing parameter leads to enable this option
INSERT INTO enum_parameters (id, name, val)
VALUES (15, 'mojeid_async_sms_generation', 'enabled');
--- parameter 16 can disable asynchronous generation of letters.
--- possible values for disabling are 'disabled', 'disable', 'false', 'f' or '0'
--- other value or missing parameter leads to enable this option
INSERT INTO enum_parameters (id, name, val)
VALUES (16, 'mojeid_async_letter_generation', 'enabled');
--- parameter 17 can disable asynchronous generation of e-mails.
--- possible values for disabling are 'disabled', 'disable', 'false', 'f' or '0'
--- other value or missing parameter leads to enable this option
INSERT INTO enum_parameters (id, name, val) 
VALUES (17, 'mojeid_async_email_generation', 'enabled');

--- used for mojeid asynchronous generation of messages
CREATE INDEX public_request_status_create_time_idx ON public_request(status, create_time);


---
--- Async object notification
---
CREATE TYPE notified_event AS ENUM (
    'created', 'updated', 'transferred', 'deleted', 'renewed'
);

CREATE TABLE notification_queue (
    change                  notified_event NOT NULL,
    done_by_registrar       integer NOT NULL references registrar(id),
    historyid_post_change   integer NOT NULL references history(id),
    svtrid                  text NOT NULL
);


---
--- Ticket #14340 - change to the template of notification_update email
---
UPDATE mail_templates SET template =
'<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs elif:lang == "ensmall" ?><?cs if:type == #3 ?>domain<?cs elif:type == #1 ?>contact<?cs elif:type == #2 ?>nsset<?cs elif:type == #4 ?>keyset<?cs /if ?><?cs /if ?><?cs /def ?>

<?cs def:print_value(which, varname) ?><?cs if:which == "old" ?><?cs set:lvarname = varname.old ?><?cs elif:which == "new" ?><?cs set:lvarname = varname.new ?><?cs /if ?><?cs alt:lvarname ?><?cs if:which == "old" ?>hodnota nenastavena / value not set<?cs elif:which == "new" ?>hodnota smazána / value deleted<?cs /if ?><?cs /alt ?><?cs /def ?>
<?cs def:print_value_bool(which, varname, if_true, if_false) ?><?cs if:which == "old" ?><?cs set:lvarname = varname.old ?><?cs elif:which == "new" ?><?cs set:lvarname = varname.new ?><?cs /if ?><?cs if:lvarname == "1" ?><?cs var:if_true ?><?cs elif:lvarname == "0" ?><?cs var:if_false ?><?cs /if ?><?cs /def ?>
<?cs def:print_value_list(which, varname, itemname) ?><?cs if:which == "old" ?><?cs each:item = varname.old ?><?cs var:itemname ?>: <?cs var:item ?>
<?cs /each ?><?cs elif:which == "new" ?><?cs each:item = varname.new ?><?cs var:itemname ?>: <?cs var:item ?>
<?cs /each ?><?cs /if ?><?cs /def ?>

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
'
WHERE id = 11;


---
--- Ticket #14153 - pin1 email fix
---
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

Pokud jste o aktivaci tohoto účtu mojeID nežádali, prosíme, tento e-mail ignorujte.
' WHERE id = 21;
