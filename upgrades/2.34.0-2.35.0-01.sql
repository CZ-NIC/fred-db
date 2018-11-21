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

--- Ticket #23065
ALTER TABLE public_request DISABLE TRIGGER trigger_lock_public_request;
--- we expect that all updates to public_requests are already commited
UPDATE public_request pr
   SET on_status_action = 'processed'::enum_on_status_action_type
 WHERE pr.request_type NOT IN (
        SELECT id
          FROM enum_public_request_type eprt
         WHERE eprt.name IN ('personalinfo_auto_pif', 'personalinfo_email_pif', 'personalinfo_post_pif', 'personalinfo_government_pif')
       );
ALTER TABLE public_request ENABLE TRIGGER trigger_lock_public_request;
--- do not update public_requests again until commit

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
