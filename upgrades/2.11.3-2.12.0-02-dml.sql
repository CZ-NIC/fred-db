---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.12.0' WHERE id = 1;


---
--- Public request types for sending authinfo
---
INSERT INTO enum_public_request_type (id, name, description) VALUES (0, 'authinfo_auto_rif', 'AuthInfo (EPP/Auto)');
INSERT INTO enum_public_request_type (id, name, description) VALUES (1, 'authinfo_auto_pif', 'AuthInfo (Web/Auto)');
INSERT INTO enum_public_request_type (id, name, description) VALUES (2, 'authinfo_email_pif', 'AuthInfo (Web/Email)');
INSERT INTO enum_public_request_type (id, name, description) VALUES (3, 'authinfo_post_pif', 'AuthInfo (Web/Post)');
---
--- Public request types for block/unblock transfer/changes
---
INSERT INTO enum_public_request_type (id, name, description) VALUES (4, 'block_changes_email_pif', 'Block changes (Web/Email)');
INSERT INTO enum_public_request_type (id, name, description) VALUES (5, 'block_changes_post_pif', 'Block changes (Web/Post)');
INSERT INTO enum_public_request_type (id, name, description) VALUES (6, 'block_transfer_email_pif', 'Block transfer (Web/Email)');
INSERT INTO enum_public_request_type (id, name, description) VALUES (7, 'block_transfer_post_pif', 'Block transfer (Web/Post)');
INSERT INTO enum_public_request_type (id, name, description) VALUES (8, 'unblock_changes_email_pif', 'Unblock changes (Web/Email)');
INSERT INTO enum_public_request_type (id, name, description) VALUES (9, 'unblock_changes_post_pif', 'Unblock changes (Web/Post)');
INSERT INTO enum_public_request_type (id, name, description) VALUES (10, 'unblock_transfer_email_pif', 'Unblock transfer (Web/Email)');
INSERT INTO enum_public_request_type (id, name, description) VALUES (11, 'unblock_transfer_post_pif', 'Unblock transfer (Web/Post)');

---
--- Public request types for contact verification
---
INSERT INTO enum_public_request_type (id, name, description) VALUES (12, 'mojeid_contact_conditional_identification', 'MojeID conditional identification');
INSERT INTO enum_public_request_type (id, name, description) VALUES (13, 'mojeid_contact_identification', 'MojeID full identification');
INSERT INTO enum_public_request_type (id, name, description) VALUES (14, 'mojeid_contact_validation', 'MojeID validation');
INSERT INTO enum_public_request_type (id, name, description) VALUES (17, 'mojeid_conditionally_identified_contact_transfer', 'MojeID conditionally identified contact transfer');
INSERT INTO enum_public_request_type (id, name, description) VALUES (18, 'mojeid_identified_contact_transfer', 'MojeID identified contact transfer');

INSERT INTO enum_public_request_type (id, name, description) VALUES (15, 'contact_conditional_identification', 'Conditional identification');
INSERT INTO enum_public_request_type (id, name, description) VALUES (16, 'contact_identification', 'Full identification');





---
--- CIC, IC and VC states change to external
---
UPDATE enum_object_states SET external = True
  WHERE name in ('conditionallyIdentifiedContact', 'identifiedContact', 'validatedContact');



---
--- add mojeidContact state
---
INSERT INTO enum_object_states VALUES (24,'mojeidContact','{1}','t','t');
INSERT INTO enum_object_states_desc VALUES (24, 'CS', 'MojeID kontakt');
INSERT INTO enum_object_states_desc VALUES (24, 'EN', 'MojeID contact');



---
--- Ticket #6304
---
BEGIN;

CREATE TEMP TABLE tmp_object_state (object_id,state_id, valid_from, ohid_from, valid_to, ohid_to) AS
SELECT object_id, (SELECT id FROM enum_object_states WHERE name='mojeidContact') AS state_id
, valid_from, ohid_from 
, (CASE WHEN one_of_valid_to_is_null THEN null ELSE max_valid_to END) AS valid_to
, (CASE WHEN one_of_valid_to_is_null THEN null ELSE max_ohid_to END) AS ohid_to
FROM (SELECT object_id, MIN(valid_from) AS valid_from, MIN(ohid_from) AS ohid_from, MAX(ohid_to)AS max_ohid_to
, MAX(valid_to) AS max_valid_to, bool_or(valid_to is null) AS one_of_valid_to_is_null
FROM (SELECT os.object_id, os.valid_from, os.ohid_from, os.valid_to, os.ohid_to
FROM contact c JOIN object o ON o.id=c.id 
JOIN object_registry obr ON obr.id = o.id
JOIN registrar r ON r.id=o.clid
JOIN object_state os ON os.object_id = obr.id
JOIN enum_object_states eos ON eos.id=os.state_id
WHERE r.handle='REG-MOJEID'
AND (eos.name='conditionallyIdentifiedContact'
OR eos.name='identifiedContact'
OR eos.name='validatedContact')  
) AS tmp1
GROUP BY object_id
) AS tmp2;

INSERT INTO object_state_request (object_id, state_id, valid_from, valid_to, crdate, canceled) 
SELECT object_id, state_id, valid_from, valid_to, valid_from, valid_to  
FROM tmp_object_state;

INSERT INTO object_state (object_id, state_id, valid_from, ohid_from, valid_to, ohid_to) 
SELECT object_id, state_id, valid_from, ohid_from, valid_to, ohid_to 
FROM tmp_object_state;

COMMIT;



---
--- Ticket #6164
---
INSERT INTO message_type (id, type) VALUES (6, 'contact_verification_pin2');
INSERT INTO message_type (id, type) VALUES (7, 'contact_verification_pin3');

INSERT INTO enum_public_request_status (id, name, description) VALUES (0, 'new', 'New');
INSERT INTO enum_public_request_status (id, name, description) VALUES (1, 'answered', 'Answered');
INSERT INTO enum_public_request_status (id, name, description) VALUES (2, 'invalidated', 'Invalidated');

INSERT INTO mail_type (id, name, subject) VALUES (25, 'conditional_contact_identification', 'Podmíněná identifikace kontaktu');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(25, 'plain', 1,
'
Vážený uživateli,

tento e-mail potvrzuje úspěšné zahájení procesu ověření kontaktu v centrálním registru:

ID kontaktu: <?cs var:handle ?>
jméno:       <?cs var:firstname ?>
příjmení:    <?cs var:lastname ?>
e-mail:      <?cs var:email ?>

Pro dokončení prvního ze dvou kroků ověření je nutné zadat kódy PIN1 a PIN2.

PIN1: <?cs var:passwd ?>
PIN2: Vám byl zaslán pomocí SMS.<?cs if:passwd2?>
V demo režimu není odesílání SMS a pošty aktivní. PIN2: <?cs var:passwd2 ?> <?cs /if ?><?cs if:passwd3?>
V demo režimu není odesílání SMS a pošty aktivní. PIN3: <?cs var:passwd3 ?> <?cs /if ?>

Zadání PIN1 a PIN2 bude možné po kliknutí na následující odkaz:
https://<?cs var:hostname ?>/verification/identify/email-sms/<?cs var:identification ?>/?password1=<?cs var:passwd ?>

Váš tým <?cs var:defaults.company ?>



Dear User,

This e-mail confirms that the process of verifying your contact data in the central registry has been successfully initiated:

contact ID: <?cs var:handle ?>
first name: <?cs var:firstname ?>
last name:  <?cs var:lastname ?>
e-mail:     <?cs var:email ?>

To complete the first of the two verification steps, authorisation with your PIN1 and PIN2 codes is required.

PIN1: <?cs var:passwd ?>
PIN2: was sent to you by a text message (SMS).

You will be able to enter your PIN1 and PIN2 by following this link:
https://<?cs var:hostname ?>/verification/identify/email-sms/<?cs var:identification ?>/?password1=<?cs var:passwd ?>

Your <?cs var:defaults.company ?> team
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (25, 25);



INSERT INTO mail_type (id, name, subject) VALUES (26, 'contact_identification', 'Identifikace kontaktu');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(26, 'plain', 1,
'
English version of the e-mail is entered below the Czech version

Vážený uživateli,

první část ověření kontaktu v Centrálním registru je úspěšně za Vámi.

identifikátor: <?cs var:handle ?>
jméno:         <?cs var:firstname ?>
příjmení:      <?cs var:lastname ?>
e-mail:        <?cs var:email ?>

V nejbližších dnech ještě očekávejte zásilku s kódem PIN3, jehož pomocí 
ověříme Vaši poštovní adresu. Zadáním kódu PIN3 do formuláře na <a href=
"https://<?cs var:hostname ?>/verification/finish/?handle=<?cs var:handle ?>">této 
stránce</a> dokončíte proces ověření kontaktu.

Rádi bychom Vás také upozornili, že až do okamžiku zadání kódu PIN3 
nelze údaje v kontaktu měnit. Případná editace údajů v této fázi 
ověřovacího procesu by měla za následek jeho přerušení.

Děkujeme za pochopení.

Váš tým <?cs var:defaults.company ?>



Dear User,

The first step of the verification of the central registry contact details provided below has been successfully completed.

contact ID: <?cs var:handle ?>
first name: <?cs var:firstname ?>
last name:  <?cs var:lastname ?>
e-mail:     <?cs var:email ?>

Your PIN3 has now also been generated; you will receive it by mail within a few days at the address listed in the contact.

Verification of this contact will be complete once you enter your PIN3 into the corresponding field at this address:
https://<?cs var:hostname ?>/verification/identify/letter/?handle=<?cs var:handle ?>

Your <?cs var:defaults.company ?> team
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (26, 26);



---
--- MojeID templates update - link
---
UPDATE mail_templates SET template =
'
Vážený uživateli,

tento e-mail potvrzuje úspěšné založení účtu mojeID s těmito údaji:

účet mojeID: <?cs var:handle ?>
jméno:       <?cs var:firstname ?>
příjmení:    <?cs var:lastname ?>
e-mail:      <?cs var:email ?>

Pro aktivaci Vašeho účtu je nutné vložit kódy PIN1 a PIN2.

PIN1: <?cs var:passwd ?>
PIN2: Vám byl zaslán pomocí SMS.

Aktivaci účtu proveďte kliknutím na následující odkaz:

https://<?cs var:hostname ?>/identify/email-sms/<?cs var:identification ?>/?password1=<?cs var:passwd ?>

Váš tým <?cs var:defaults.company ?>
'
WHERE id = 21;



---
--- Verified contact transfer to MojeID
---
INSERT INTO mail_type (id, name, subject) VALUES (27, 'mojeid_verified_contact_transfer', 'Založení účtu mojeID');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(27, 'plain', 1,
'
Vážený uživateli,

tento e-mail potvrzuje úspěšné založení účtu mojeID s těmito údaji:

účet mojeID: <?cs var:handle ?>
jméno:       <?cs var:firstname ?>
příjmení:    <?cs var:lastname ?>
e-mail:      <?cs var:email ?>

Pro aktivaci Vašeho účtu je nutné vložit kód PIN1.

PIN1: <?cs var:passwd ?>

Aktivaci účtu proveďte kliknutím na následující odkaz:

https://<?cs var:hostname ?>/identify/email/<?cs var:identification ?>/?password1=<?cs var:passwd ?>

Váš tým <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (27, 27);



---
--- Ticket #6467
---
UPDATE mail_templates SET template = '
<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>
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

Detail <?cs call:typesubst("cs") ?> najdete na <?cs var:defaults.whoispage ?>?q=<?cs var:handle ?>
For detail information about <?cs call:typesubst("en") ?> visit <?cs var:defaults.whoispage ?>?q=<?cs var:handle ?>


                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>
' WHERE id = 10;



UPDATE mail_templates SET template = '
<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>

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


Úplný detail <?cs call:typesubst("cs") ?> najdete na <?cs var:defaults.whoispage ?>?q=<?cs var:handle ?>
For full detail information about <?cs call:typesubst("en") ?> visit <?cs var:defaults.whoispage ?>?q=<?cs var:handle ?>


<?cs if:type == #1 ?>
Chcete mít snadnější přístup ke správě Vašich údajů? Založte si mojeID. Kromě 
nástroje, kterým můžete snadno a bezpečně spravovat údaje v centrálním 
registru, získáte také prostředek pro jednoduché přihlašování k Vašim 
oblíbeným webovým službám jediným jménem a heslem.
<?cs /if ?>

                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>
' WHERE id = 11;



UPDATE mail_templates SET template = '
<?cs def:typesubst(lang) ?><?cs if:lang == "cs" ?><?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu<?cs elif:type == #2 ?>sady nameserverů<?cs elif:type == #4 ?>sady klíčů<?cs /if ?><?cs elif:lang == "en" ?><?cs if:type == #3 ?>Domain<?cs elif:type == #1 ?>Contact<?cs elif:type == #2 ?>NS set<?cs elif:type == #4 ?>Keyset<?cs /if ?><?cs /if ?><?cs /def ?>
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

Detail <?cs call:typesubst("cs") ?> najdete na <?cs var:defaults.whoispage ?>?q=<?cs var:handle ?>
For detail information about <?cs call:typesubst("en") ?> visit <?cs var:defaults.whoispage ?>?q=<?cs var:handle ?>


                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>
' WHERE id = 12;



UPDATE mail_templates SET template = '
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

Detail domény najdete na <?cs var:defaults.whoispage ?>?q=<?cs var:handle ?>
For detail information about domain visit <?cs var:defaults.whoispage ?>?q=<?cs var:handle ?>


                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>
' WHERE id = 13;

