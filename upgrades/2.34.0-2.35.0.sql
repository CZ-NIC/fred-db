---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.35.0' WHERE id = 1;


--- Ticket #21692
UPDATE enum_public_request_status
   SET name = 'opened', description = 'Opened'
 WHERE name = 'new';

UPDATE enum_public_request_status
   SET name = 'resolved', description = 'Resolved'
 WHERE name = 'answered';


--- Ticket #21556
INSERT INTO enum_public_request_type (id, name, description)
     VALUES (25, 'authinfo_government_pif', 'AuthInfo (Web/Government)');
INSERT INTO enum_public_request_type (id, name, description)
     VALUES (26, 'block_changes_government_pif', 'Block changes (Web/Government)');
INSERT INTO enum_public_request_type (id, name, description)
     VALUES (27, 'block_transfer_government_pif', 'Block transfer (Web/Government)');
INSERT INTO enum_public_request_type (id, name, description)
     VALUES (28, 'unblock_changes_government_pif', 'Unblock changes (Web/Government)');
INSERT INTO enum_public_request_type (id, name, description)
     VALUES (29, 'unblock_transfer_government_pif', 'Unblock transfer (Web/Government)');
INSERT INTO enum_public_request_type (id, name, description)
     VALUES (30, 'personalinfo_government_pif', 'PersonalInfo (Web/Government)');


--- Ticket #22449
ALTER TABLE bank_payment ADD COLUMN uuid UUID;
UPDATE bank_payment
   SET uuid=(
        SELECT md5(random()::text || clock_timestamp()::text)::uuid
         WHERE id = id
       );
ALTER TABLE bank_payment ADD CONSTRAINT bank_payment_uuid_key UNIQUE (uuid);
ALTER TABLE bank_payment ALTER COLUMN uuid SET NOT NULL;

ALTER TABLE bank_payment_registrar_credit_transaction_map ADD COLUMN bank_payment_uuid UUID;
UPDATE bank_payment_registrar_credit_transaction_map
   SET bank_payment_uuid=(
        SELECT uuid
          FROM bank_payment
         WHERE bank_payment.id = bank_payment_registrar_credit_transaction_map.bank_payment_id
       );
ALTER TABLE bank_payment_registrar_credit_transaction_map ALTER COLUMN bank_payment_uuid SET NOT NULL;

-- DUMP
COPY(
    SELECT ROW_TO_JSON(payment)
      FROM (
            SELECT trim(both ' ' from bank_account.account_name) as account_name,
                   trim(both ' ' from bank_account.account_number) as account_number,
                   bank_payment.bank_code,
                   bank_payment.account_evid as account_payment_ident,
                   bank_payment.account_number AS counter_account_number,
                   bank_payment.bank_code AS counter_account_bank_code,
                   bank_payment.code,
                   bank_payment.type,
                   bank_payment.status,
                   bank_payment.konstsym AS constant_symbol,
                   bank_payment.varsymb AS variable_symbol,
                   bank_payment.specsymb AS specific_symbol,
                   bank_payment.price,
                   bank_payment.account_date as date,
                   bank_payment.account_memo as memo,
                   bank_payment.account_name as counter_account_name,
                   bank_payment.crtime AS creation_time,
                   bank_payment.uuid,
                   (SELECT json_object_agg(i.id, i.prefix)
                      FROM invoice_registrar_credit_transaction_map icm
                      JOIN bank_payment_registrar_credit_transaction_map bpcm
                        ON icm.registrar_credit_transaction_id = bpcm.registrar_credit_transaction_id
                      JOIN registrar_credit_transaction rct
                        ON rct.id = bpcm.registrar_credit_transaction_id
                      JOIN invoice i
                        ON i.id = icm.invoice_id
                      JOIN invoice_prefix ip
                        ON ip.id = i.invoice_prefix_id
                     WHERE bpcm.bank_payment_id = bank_payment.id
                       AND ip.typ = 0) as advance_invoice,
                   (SELECT json_object_agg(i.id, i.prefix)
                      FROM invoice_registrar_credit_transaction_map icm
                      JOIN bank_payment_registrar_credit_transaction_map bpcm
                        ON icm.registrar_credit_transaction_id = bpcm.registrar_credit_transaction_id
                      JOIN registrar_credit_transaction rct
                        ON rct.id = bpcm.registrar_credit_transaction_id
                      JOIN invoice i
                        ON i.id = icm.invoice_id
                      JOIN invoice_prefix ip
                        ON ip.id = i.invoice_prefix_id
                     WHERE bpcm.bank_payment_id = bank_payment.id
                       AND ip.typ = 1) as account_invoices,
                   payment_registrar.id AS registrar_id,
                   payment_registrar.handle AS registrar_handle
              FROM bank_payment
              LEFT JOIN bank_account
                ON bank_payment.account_id = bank_account.id
              LEFT JOIN (
                    SELECT sub_bank_payment.id as payment_id, registrar.id, registrar.handle
                      FROM bank_payment AS sub_bank_payment
                      JOIN bank_payment_registrar_credit_transaction_map bpcm
                        ON bpcm.bank_payment_id = sub_bank_payment.id
                      JOIN registrar_credit_transaction rct
                        ON rct.id = bpcm.registrar_credit_transaction_id
                      JOIN registrar_credit rc
                        ON rct.registrar_credit_id = rc.id
                      JOIN registrar
                        ON registrar.id = rc.registrar_id
                     LIMIT 1) AS payment_registrar
               ON payment_registrar.payment_id = bank_payment.id
           ) payment
)
TO '/var/tmp/payments-export-for-pain.json';

ALTER TABLE bank_payment_registrar_credit_transaction_map DROP COLUMN bank_payment_id;
DROP TABLE bank_payment;


--- Ticket #21893
UPDATE mail_template
SET    body_template =
'Vážená paní, vážený pane,

obdrželi jsme Váš požadavek na zaslání informací, které jsou aktuálně
vedeny u Vašeho kontaktu, který používáte pro registraci jmen domén. Tento
požadavek nám byl zaslán prostřednictvím webového rozhraní na www.nic.cz.
Pokud jste jej nepodal/a Vy, patrně tak učinil Váš registrátor či jiná
osoba, která se Vám o Vaše domény stará.

Proveďte, prosím, pečlivou kontrolu těchto údajů, protože aktuální, úplné
a správné informace v registru znamenají Vaši jistotu, že Vás důležité
zprávy o Vaší doméně zastihnou vždy a včas na správné adrese. Nedočkáte se
tak nepříjemného překvapení v podobě nefunkční či zrušené domény.

Jestliže budete chtít kterýkoliv z uvedených údajů změnit, upravit či
odstranit, obraťte se s důvěrou na Vašeho registrátora (údaj o něm
naleznete níže). Přímo prostřednictvím CZ.NIC není možné údaje u kontaktu
měnit.

ID kontaktu v registru: <?cs var:handle ?>
Organizace: <?cs var:organization ?>
Jméno: <?cs var:name ?>
Adresa trvalého bydliště / sídla firmy: <?cs var:address ?>
Korespondenční adresa: <?cs var:mailing_address ?>
Fakturační adresa: <?cs var:billing_address ?>
Dodací adresa 1: <?cs var:shipping_address_1 ?>
Dodací adresa 2: <?cs var:shipping_address_2 ?>
Dodací adresa 3: <?cs var:shipping_address_3 ?>
Typ identifikace: <?cs if:ident_type != "" ?><?cs if:ident_type == "RC"?>Rodné číslo<?cs elif:ident_type == "OP"?>Číslo OP<?cs elif:ident_type == "PASS"?>Číslo pasu<?cs elif:ident_type == "ICO"?>IČO<?cs elif:ident_type == "MPSV"?>Identifikátor MPSV<?cs elif:ident_type == "BIRTHDAY"?>Datum narození<?cs /if ?><?cs /if ?>
Identifikace: <?cs var:ident_value ?>
DIČ: <?cs var:dic ?>
Telefon: <?cs var:telephone ?>
Fax: <?cs var:fax ?>
E-mail: <?cs var:email ?>
Notifikační e-mail: <?cs var:notify_email ?>
Určený registrátor: <?cs var:registrar_name ?> (<?cs var:registrar_url ?>)



Dovolujeme si Vás rovněž upozornit, že nesprávné, nepravdivé, neúplné či
zavádějící údaje mohou být v souladu s Pravidly registrace jmen domén
v ccTLD .cz důvodem ke zrušení registrace jména domény.

Údaje o Vašem kontaktu přikládáme také ve formátu csv.

S pozdravem

podpora <?cs var:defaults.company_cs ?>




Dear Sir/Madam,

We have received your request for providing the information that is currently registered for your contact that you use for the domain name registration.
This request was sent to us via the web interface at www.nic.cz.
If you did not send it, it was probably sent by your registrar or another person who takes care of your domains.

Please review these data carefully because having current, complete and accurate information in the registry means you can be sure the important information about your domain is always available in time at the right address.
In this way you will avoid an unpleasant surprise in the form of a non-functioning or cancelled domain.

If you would like to change, modify or remove any of these data, please contact you registrar (see the details below).
The data cannot be changed directly via CZ.NIC.

Contact ID in the registry: <?cs var:handle ?>
Organisation: <?cs var:organization ?>
Name: <?cs var:name ?>
Address: <?cs var:address ?>
Mailing address: <?cs var:mailing_address ?>
Billing address: <?cs var:billing_address ?>
Shipping address 1: <?cs var:shipping_address_1 ?>
Shipping address 2: <?cs var:shipping_address_2 ?>
Shipping address 3: <?cs var:shipping_address_3 ?>
Identification type: <?cs if:ident_type != "" ?><?cs if:ident_type == "RC"?>National Identity Number<?cs elif:ident_type == "OP"?>National Identity Card<?cs elif:ident_type == "PASS"?>Passport Number<?cs elif:ident_type == "ICO"?>Company Registration Number<?cs elif:ident_type == "MPSV"?>Social Security Number<?cs elif:ident_type == "BIRTHDAY"?>Birthdate<?cs /if ?><?cs /if ?>
Identification: <?cs var:ident_value ?>
VAT No.: <?cs var:dic ?>
Phone: <?cs var:telephone ?>
Fax: <?cs var:fax ?>
E-mail: <?cs var:email ?>
Notification e-mail: <?cs var:notify_email ?>
Designated registrar: <?cs var:registrar_name ?> (<?cs var:registrar_url ?>)



We would also like to inform you that in accordance with the Rules of Domain Name Registration for the .cz ccTLD, incorrect, false, incomplete or misleading information can be grounds for the cancellation of a domain name registration.

We also include your contact details in the csv format.

Kind regards,

Support of <?cs var:defaults.company_en ?>
'
WHERE mail_type_id=(select id from mail_type where name='sendpersonalinfo_pif');
