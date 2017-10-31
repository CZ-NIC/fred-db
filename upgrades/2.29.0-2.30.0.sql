---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.30.0' WHERE id = 1;

---
--- Ticket #17090
---
UPDATE enum_reason SET
    (reason, reason_cs) = ('An invalid format of the contact handle', 'Neplatný formát identifikátoru kontaktu')
 WHERE id = 1;
UPDATE enum_reason SET
    (reason, reason_cs) = ('An invalid format of the nsset handle', 'Neplatný formát identifikátoru sady jmenných serverů')
 WHERE id = 2;
UPDATE enum_reason SET
    (reason, reason_cs) = ('An invalid format of the domain name', 'Neplatný formát jména domény')
 WHERE id = 3;
UPDATE enum_reason SET
    (reason, reason_cs) = ('The domain name not applicable', 'Nepříslušný název domény')
 WHERE id = 4;
UPDATE enum_reason SET
    (reason, reason_cs) = ('An invalid format', 'Neplatný formát')
 WHERE id = 5;
UPDATE enum_reason SET
    (reason, reason_cs) = ('Registered already', 'Již zaregistrováno')
 WHERE id = 6;
UPDATE enum_reason SET
    (reason, reason_cs) = ('Within the protection period', 'V ochranné lhůtě')
 WHERE id = 7;
UPDATE enum_reason SET
    (reason, reason_cs) = ('An invalid IP address', 'Neplatná IP adresa')
 WHERE id = 8;
UPDATE enum_reason SET
    (reason, reason_cs) = ('An invalid nameserver hostname', 'Neplatný název jmenného serveru')
 WHERE id = 9;
UPDATE enum_reason SET
    (reason, reason_cs) = ('A duplicate nameserver address', 'Duplicitní adresa jmenného serveru')
 WHERE id = 10;
UPDATE enum_reason SET
    (reason, reason_cs) = ('Glue IP address not applicable', 'Glue IP adresu zde nelze použít')
 WHERE id = 11;
UPDATE enum_reason SET
    (reason, reason_cs) = ('The validity period exceeds the allowed maximum', 'Doba platnosti přesahuje maximální povolenou mez')
 WHERE id = 14;
UPDATE enum_reason SET
    (reason, reason_cs) = (
        'The validity period is not an integer multiple of the allowed step',
        'Doba platnosti není celočíselným násobkem povoleného kroku')
 WHERE id = 15;
UPDATE enum_reason SET
    (reason, reason_cs) = ('An unknown country code', 'Neznámý kód země')
 WHERE id = 16;
UPDATE enum_reason SET
    (reason, reason_cs) = ('An unknown message ID', 'Neznámý identifikátor zprávy')
 WHERE id = 17;
UPDATE enum_reason SET
    (reason, reason_cs) = ('A validation expiration date not applicable', 'Datum vypršení platnosti ověření zde nelze použít')
 WHERE id = 18;
UPDATE enum_reason SET
    (reason, reason_cs) = ('The validation expiration date is not valid', 'Datum vypršení platnosti ověření je neplatné')
 WHERE id = 19;
UPDATE enum_reason SET
    (reason, reason_cs) = ('The technical contact cannot be removed', 'Nelze odstranit technický kontakt')
 WHERE id = 23;
UPDATE enum_reason SET
    (reason, reason_cs) = (
        'The technical contact is assigned to the object already',
        'Tomuto objektu je uvedený technický kontakt již přiřazen')
 WHERE id = 24;
UPDATE enum_reason SET
    (reason, reason_cs) = ('The technical contact does not exist', 'Technický kontakt neexistuje')
 WHERE id = 25;
UPDATE enum_reason SET
    (reason, reason_cs) = (
        'The administrative contact is assigned to the object already',
        'Tomuto objektu je uvedený administrativní kontakt již přiřazen')
 WHERE id = 26;
UPDATE enum_reason SET
    (reason, reason_cs) = ('The administrative contact does not exist', 'Administrativní kontakt neexistuje')
 WHERE id = 27;
UPDATE enum_reason SET
    (reason, reason_cs) = ('The nsset does not exist', 'Sada jmenných serverů neexistuje')
 WHERE id = 28;
UPDATE enum_reason SET
    (reason, reason_cs) = ('The registrant contact does not exist', 'Kontakt držitele neexistuje')
 WHERE id = 29;
UPDATE enum_reason SET
    (reason, reason_cs) = (
        'The nameserver is included in the nsset already',
        'Uvedený jmenný server je již obsažen v této sadě jmenných serverů')
 WHERE id = 30;
UPDATE enum_reason SET
    (reason, reason_cs) = (
        'The nameserver is not included in the nsset',
        'Uvedený jmenný server není obsažen v této sadě jmenných serverů')
 WHERE id = 31;
UPDATE enum_reason SET
    (reason, reason_cs) = (
        'The domain expiration date does not match recorded data',
        'Datum expirace domény nesouhlasí se zaznamenanými údaji')
 WHERE id = 32;
UPDATE enum_reason SET
    (reason, reason_cs) = (
        'The "transfer" element is missing an "op" attribute',
        'U elementu "transfer" chybí atribut "op"')
 WHERE id = 33;
UPDATE enum_reason SET
    (reason, reason_cs) = (
        'The "ident" element is missing a "type" attribute',
        'U elementu "ident" chybí atribut "type"')
 WHERE id = 34;
UPDATE enum_reason SET
    (reason, reason_cs) = (
        'The "poll" element is missing an "msgID" attribute',
        'U elementu "poll" chybí atribut "msgID"')
 WHERE id = 35;
UPDATE enum_reason SET
    (reason, reason_cs) = ('Registration is prohibited', 'Registrace je zakázána')
 WHERE id = 36;
UPDATE enum_reason SET
    (reason, reason_cs) = ('XML validation error: ', 'Chyba validace XML: ')
 WHERE id = 37;
UPDATE enum_reason SET
    (reason, reason_cs) = ('A duplicate contact', 'Duplicitní kontakt')
 WHERE id = 38;
UPDATE enum_reason SET
    (reason, reason_cs) = ('An invalid format of the keyset handle', 'Neplatný formát identifikátoru keysetu')
 WHERE id = 39;
UPDATE enum_reason SET
    (reason, reason_cs) = ('The keyset does not exist', 'Keyset neexistuje')
 WHERE id = 40;
UPDATE enum_reason SET
    (reason, reason_cs) = ('Unauthorized access to the object', 'Neautorizovaný přístup k objektu')
 WHERE id = 48;
UPDATE enum_reason SET
    (reason, reason_cs) = ('Too many administrative contacts', 'Příliš mnoho administrativních kontaktů')
 WHERE id = 49;
UPDATE enum_reason SET
    (reason, reason_cs) = ('Too many DS records', 'Příliš mnoho DS záznamů')
 WHERE id = 50;
UPDATE enum_reason SET
    (reason, reason_cs) = ('Too many DNSKEY records', 'Příliš mnoho DNSKEY záznamů')
 WHERE id = 51;
UPDATE enum_reason SET
    (reason, reason_cs) = ('No DNSKEY record', 'Žádný DNSKEY záznam')
 WHERE id = 53;
UPDATE enum_reason SET
    (reason, reason_cs) = ('The "flags" field must be 0, 256 or 257', 'Položka "flags" musí být 0, 256 nebo 257')
 WHERE id = 54;
UPDATE enum_reason SET
    (reason, reason_cs) = ('The "protocol" field must be 3', 'Položka "protocol" musí být 3')
 WHERE id = 55;
UPDATE enum_reason SET
    (reason, reason_cs) = (
        'An unsupported value of the "alg" field, see IANA DNS Security Algorithm Numbers',
        'Nepodporovaná hodnota položky "alg", viz IANA DNS Security Algorithm Numbers')
 WHERE id = 56;
UPDATE enum_reason SET
    (reason, reason_cs) = ('The "key" field has an invalid length', 'Položka "key" má nevyhovující délku')
 WHERE id = 57;
UPDATE enum_reason SET
    (reason, reason_cs) = (
        'The "key" field contains an invalid character',
        'Položka "key" obsahuje neplatný znak')
 WHERE id = 58;
UPDATE enum_reason SET
    (reason, reason_cs) = ('The DNSKEY exists for the keyset already', 'DNSKEY již pro tento keyset existuje')
 WHERE id = 59;
UPDATE enum_reason SET
    (reason, reason_cs) = ('The DNSKEY does not exist for the keyset', 'DNSKEY pro tento keyset neexistuje')
 WHERE id = 60;
UPDATE enum_reason SET
    (reason, reason_cs) = ('A duplicate DNSKEY', 'Duplicitní DNSKEY záznam')
 WHERE id = 61;
UPDATE enum_reason SET
    (reason, reason_cs) = (
        'The keyset must have a DNSKEY record or a DS record',
        'Keyset musí mít DNSKEY záznam nebo DS záznam')
 WHERE id = 62;
UPDATE enum_reason SET
    (reason, reason_cs) = ('A duplicate nameserver hostname', 'Duplicitní název jmenného serveru')
 WHERE id = 63;
UPDATE enum_reason SET
    (reason, reason_cs) = (
        'The administrative contact is not assigned to the object',
        'Tomuto objektu uvedený administrativní kontakt není přiřazen')
 WHERE id = 64;
UPDATE enum_reason SET
    (reason, reason_cs) = ('Temporary contacts are discontinued', 'Dočasné kontakty již nejsou podporovány')
 WHERE id = 65;
INSERT INTO enum_reason (id, reason, reason_cs)
     VALUES (66, 'The validity period is shorter than the allowed minimum', 'Doba platnosti je kratší než povolené minimum');

DELETE FROM enum_reason WHERE id = 12;
DELETE FROM enum_reason WHERE id = 13;
DELETE FROM enum_reason WHERE id = 20;
DELETE FROM enum_reason WHERE id = 21;
DELETE FROM enum_reason WHERE id = 22;
DELETE FROM enum_reason WHERE id = 41;
DELETE FROM enum_reason WHERE id = 42;
DELETE FROM enum_reason WHERE id = 43;
DELETE FROM enum_reason WHERE id = 44;
DELETE FROM enum_reason WHERE id = 45;
DELETE FROM enum_reason WHERE id = 46;
DELETE FROM enum_reason WHERE id = 47;
DELETE FROM enum_reason WHERE id = 52;

---
--- Ticket #17723
---
DROP INDEX message_clid_idx;
DROP INDEX message_seen_idx;
CREATE INDEX message_clid_id_unseen_idx ON message(clid,id) WHERE NOT seen;
COMMENT ON TABLE message IS 'Message queue for registrars which can be fetched from by epp poll functions';
CREATE INDEX check_result_checkid_idx ON check_result(checkid);

---
--- Ticket #18680 - registry record statement printout
---
INSERT INTO enum_filetype (id, name) VALUES (11, 'record statement');

INSERT INTO mail_type (id, name, subject) VALUES (35, 'record_statement', 'Výpis z registru / Registry record statement');
INSERT INTO mail_type_mail_header_defaults_map (mail_type_id,mail_header_defaults_id) VALUES ((SELECT id FROM mail_type WHERE name = 'record_statement'), 1);
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(35, 'plain', 1,
'Vážený zákazníku,

na základě Vaší žádosti podané prostřednictvím webového formuláře na našich stránkách dne <?cs var:request_day ?>.<?cs var:request_month ?>.<?cs var:request_year ?>, Vám v příloze zasíláme požadovaný výpis z registru doménových jmen.

V případě, že jste tuto žádost nepodali, oznamte nám prosím tuto skutečnost na adresu podpora@nic.cz.

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear customer,

based on the request, you submitted through a web form on our website on <?cs var:request_day ?>.<?cs var:request_month ?>.<?cs var:request_year ?>,
we are sending the requested domain registry record statement attached to this email.

If you did not make the request, please report this matter to us at podpora@nic.cz.

Yours sincerely
Support of <?cs var:defaults.company_en ?>

');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (35, 35);


---
--- Ticket #19117
---
UPDATE mail_templates SET template =
'The English version of the email follows the Czech version

Vážený zákazníku,

z důvodu zjednodušení administrace a správy kontaktů v registru byly v souladu s Pravidly registrace doménových jmen, čl. 13.1, provedeny následující změny:

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

To simplify the administration and management of contact data in the registry, the following changes have been implemented in accordance with the Domain Name Registration Rules, Article 13.1:

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
