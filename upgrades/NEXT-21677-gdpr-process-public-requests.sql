---
--- 21677 gdpr process public requests
---

CREATE TYPE enum_on_status_action_type AS ENUM ('scheduled', 'processed', 'failed');

ALTER TABLE public_request ADD COLUMN on_status_action enum_on_status_action_type NOT NULL DEFAULT 'scheduled'::enum_on_status_action_type;

comment on column public_request.on_status_action is 'state of action performed during asynchronous processing of the public request';


INSERT INTO mail_type VALUES (36, 'sendpersonalinfo_pif');

INSERT INTO mail_template
(mail_type_id, version, subject, body_template, body_template_content_type, mail_template_footer_id, mail_template_default_id, mail_header_default_id, created_at)
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
Adresa: <?cs var:address ?>
Doručovací adresa:  <?cs var:delivery_address ?>
<?cs if:ident_type != "" ?>
Typ identifikace:
<?cs if:ident_type == "RC"?>Datum narození
<?cs elif:ident_type == "OP"?>Číslo OP
<?cs elif:ident_type == "PASS"?>Číslo pasu
<?cs elif:ident_type == "ICO"?>IČO
<?cs elif:ident_type == "MPSV"?>Identifikátor MPSV
<?cs elif:ident_type == "BIRTHDAY"?>Datum narození
<?cs /if ?>
Identifikace: <?cs var:ident_value ?>
<?cs /if ?>
DIČ: <?cs var:dic ?>
Telefon: <?cs var:telephone ?>
Fax: <?cs var:fax ?>
E-mail: <?cs var:email ?>
Notifikační e-mail: <?cs var:notify_email ?>
Určený registrátor: <?cs var:registrar_name ?> (<?cs var:registrar_url ?>) <?cs if:registrar_memo_cz ?>Další informace poskytnuté registrátorem: <?cs var:registrar_memo_cz ?><?cs /if ?>



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
Delivery address:  <?cs var:delivery_address ?>
<?cs if:ident_type != "" ?>
Identification type:
<?cs if:ident_type == "RC"?>Birth date
<?cs elif:ident_type == "OP"?>Personal ID
<?cs elif:ident_type == "PASS"?>Passport number
<?cs elif:ident_type == "ICO"?>ID number
<?cs elif:ident_type == "MPSV"?>MSPV ID
<?cs elif:ident_type == "BIRTHDAY"?>Birth day
<?cs /if ?>
Identification: <?cs var:ident_value ?>
<?cs /if ?>
VAT No.: <?cs var:dic ?>
Phone: <?cs var:telephone ?>
Fax: <?cs var:fax ?>
E-mail: <?cs var:email ?>
Notification e-mail: <?cs var:notify_email ?>
Designated registrar: <?cs var:registrar_name ?> (<?cs var:registrar_url ?>) <?cs if:registrar_memo_en ?>Other information provided by your registrar: <?cs var:registrar_memo_en ?><?cs /if ?>



We would also like to inform you that in accordance with the Rules of Domain Name Registration for the .cz ccTLD, incorrect, false, incomplete or misleading information can be grounds for the cancellation of a domain name registration.

We also include your contact details in the csv format.

Kind regards,

Support of <?cs var:defaults.company_en ?>
', 'plain', 1, 1, 1, DEFAULT);
