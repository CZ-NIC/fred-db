---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.34.0' WHERE id = 1;


---
--- Public request types for sending personalinfo
---
INSERT INTO enum_public_request_type (id, name, description)
    VALUES (22, 'personalinfo_auto_pif', 'PersonalInfo (Web/Auto)');
INSERT INTO enum_public_request_type (id, name, description)
    VALUES (23, 'personalinfo_email_pif', 'PersonalInfo (Web/Email)');
INSERT INTO enum_public_request_type (id, name, description)
    VALUES (24, 'personalinfo_post_pif', 'PersonalInfo (Web/Post)');


CREATE TYPE enum_on_status_action_type AS ENUM ('scheduled', 'processed', 'failed');

ALTER TABLE public_request
      ADD COLUMN on_status_action enum_on_status_action_type
      NOT NULL DEFAULT 'scheduled'::enum_on_status_action_type;

COMMENT ON COLUMN public_request.on_status_action
        IS 'state of action performed during asynchronous processing of the public request';

CREATE INDEX public_request_on_status_action_index ON public_request (on_status_action)
       WHERE (on_status_action = 'scheduled'::enum_on_status_action_type);


INSERT INTO enum_filetype (id, name) VALUES (12, 'personal info csv');


INSERT INTO mail_type VALUES (36, 'sendpersonalinfo_pif');

INSERT INTO mail_template
(mail_type_id, version, subject, body_template, body_template_content_type,
 mail_template_footer_id, mail_template_default_id, mail_header_default_id, created_at)
VALUES
(36, 1, 'Zaslání osobních informací / Sending personal information',
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
Identification type: <?cs if:ident_type != "" ?><?cs if:ident_type == "RC"?>National Identity Number<?cs elif:ident_type == "OP"?>National Identity Card<?cs elif:ident_type == "PASS"?>Passport Number<?cs elif:ident_type == "ICO"?>Company Registration Number<?cs elif:ident_type == "MPSV"?>Social Security Number<?cs elif:ident_type == "BIRTHDAY"?>Birthdate<?cs /if ?>
<?cs /if ?>
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
', 'plain', 1, 1, 1, DEFAULT);

---
--- Ticket #21503
---   - little bit rework of mail template version trigger
---   - new version of conditional_contact_identification template
---
DROP TRIGGER set_next_mail_template_version_trigger ON mail_template;

DROP FUNCTION get_next_mail_template_version();

CREATE FUNCTION get_next_mail_template_version(_mail_type_id INTEGER) RETURNS INTEGER AS
$$
    SELECT COALESCE(get_current_mail_template_version(_mail_type_id), 0) + 1;
$$
LANGUAGE SQL;

CREATE FUNCTION check_next_mail_template_version() RETURNS TRIGGER AS
$$
DECLARE
    expected_new_version INTEGER;
BEGIN
    expected_new_version := get_next_mail_template_version(NEW.mail_type_id);
    IF NEW.version <> expected_new_version THEN
        RAISE EXCEPTION 'version must be %', expected_new_version;
    END IF;
    RETURN NEW;
END;
$$
LANGUAGE PLPGSQL;

CREATE TRIGGER check_next_mail_template_version_trigger
       BEFORE INSERT ON mail_template
       FOR EACH ROW EXECUTE PROCEDURE check_next_mail_template_version();

INSERT INTO mail_template (
    mail_type_id, version, subject, body_template, body_template_content_type,
    mail_template_footer_id, mail_template_default_id, mail_header_default_id, created_at
)
VALUES
    (25, get_next_mail_template_version(25),
'Podmíněná identifikace kontaktu / Conditional contact identification',
'Vážený uživateli,

tento e-mail potvrzuje úspěšné zahájení procesu ověření kontaktu v Centrálním registru:

ID kontaktu: <?cs var:handle ?>
jméno:       <?cs var:firstname ?>
příjmení:    <?cs var:lastname ?>
e-mail:      <?cs var:email ?>
telefon:     <?cs var:telephone ?>

Pro dokončení prvního ze dvou kroků ověření je nutné zadat kódy PIN1 a PIN2.

PIN1: <?cs var:passwd ?>
PIN2: Vám byl zaslán pomocí SMS na číslo <?cs var:telephone ?>.

Zadání PIN1 a PIN2 bude možné po kliknutí na následující odkaz:
https://<?cs var:hostname ?>/verification/identify/email-sms/<?cs var:identification ?>/?password1=<?cs var:passwd ?>

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear user,

This email confirms that the process of verifying your contact data in the Central Registry has been successfully initiated:

contact ID: <?cs var:handle ?>
first name: <?cs var:firstname ?>
last name:  <?cs var:lastname ?>
email:      <?cs var:email ?>
phone:      <?cs var:telephone ?>

To complete the first of the two verification steps, authorisation with your PIN1 and PIN2 codes is required.

PIN1: <?cs var:passwd ?>
PIN2: was sent to you in a text message (SMS) to phone number <?cs var:telephone ?>.

You will be able to enter your PIN1 and PIN2 by following this link:
https://<?cs var:hostname ?>/verification/identify/email-sms/<?cs var:identification ?>/?password1=<?cs var:passwd ?>

Yours sincerely
Support of <?cs var:defaults.company_en ?>
', 'plain', 1, 1, 1, DEFAULT);


INSERT INTO MessageType (id, name) VALUES (22, 'update_contact');

COMMENT ON TABLE MessageType IS
'table with message number codes and its names

id - name
01 - credit
02 - techcheck
03 - transfer_contact
04 - transfer_nsset
05 - transfer_domain
06 - delete_contact
07 - delete_nsset
08 - delete_domain
09 - imp_expiration
10 - expiration
11 - imp_validation
12 - validation
13 - outzone
14 - transfer_keyset
15 - idle_delete_keyset
17 - update_domain
18 - update_nsset
19 - update_keyset
20 - delete_contact
21 - delete_domain
22 - update_contact';
