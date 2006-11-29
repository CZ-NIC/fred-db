
--INSERT INTO header_template (template) VALUES (
--'To:           <?cs var:header.to ?>
--From:         <?cs var:header.from ?>
--Cc:           <?cs var:header.cc ?>
--Bcc:          <?cs var:header.bcc ?>
--Reply-To:     <?cs var:header.replyto ?>
--Errors-To:    <?cs var:header.errorsto ?>
--Organization: <?cs var:header.organization ?>
--Date:         <?cs var:header.date ?>
--Content-Type: <?cs var:header.contenttype ?>; <?cs var:header.contentencoding ?>
--Message-ID:   <?cs var:header.messageid ?>@<?cs var:header.messageidserver ?>
--Subject:      <?cs var:header.subject ?>
--'
--);

CREATE TABLE mail_defaults (
	id SERIAL PRIMARY KEY,
	name varchar(300) UNIQUE NOT NULL,
	value text NOT NULL
);
INSERT INTO mail_defaults (name, value) VALUES ('testdefault', 'xxx');

CREATE TABLE mail_header_defaults (
	id SERIAL PRIMARY KEY,
	h_from varchar(300),
	h_replyto varchar(300),
	h_errorsto varchar(300),
	h_organization varchar(300),
	h_contentencoding varchar(300),
	h_messageidserver varchar(300),
	h_subject varchar(300)
);

INSERT INTO mail_header_defaults
(h_from,
h_replyto,
h_errorsto,
h_organization,
h_contentencoding,
h_messageidserver,
h_subject)
VALUES
('notifications@nic.cz',
'help-desk@nic.cz',
'notification-errors@nic.cz',
'CZ.NIC, z.s.p.o.',
'charset=UTF-8',
'nic.cz',
'Default subject of CZ.NIC notification message');

CREATE TABLE mail_templates (
	id SERIAL PRIMARY KEY,
	name varchar(100) UNIQUE NOT NULL,
	contenttype varchar(100) NOT NULL,
	template text NOT NULL,
	moddate timestamp NOT NULL DEFAULT now()
	);

CREATE TABLE mail_archive (
	id SERIAL PRIMARY KEY,
	crdate timestamp NOT NULL DEFAULT now(),
	moddate timestamp,
	status integer,
	message text NOT NULL
	);

CREATE TABLE mail_attachments (
	id SERIAL PRIMARY KEY,
	mailid integer references mail_archive(id),
	attachid varchar(255)
	);

CREATE TABLE mail_handles (
	id SERIAL PRIMARY KEY,
	mailid integer references mail_archive(id),
	associd varchar(255)
	);

INSERT INTO mail_templates (name, contenttype, template) VALUES
('sendauthinfo_pif', 'plain',
'Vážený zákazníku,

   na základě Vaší žádosti podané prostřednictvím webového formuláře
na stránce <?cs var:wwwpage ?> dne <?cs var:reqdate ?>, které
bylo přiděleno identifikační číslo <?cs var:reqid ?>, Vám zasíláme požadované
heslo, příslušející <?cs var:handle ?>.

   Heslo je: <?cs var:authinfo ?>

   V případě, že jste tuto žádost nepodali, oznamte prosím tuto
skutečnost na adresu podpora@nic.cz.

                                                 S pozdravem
                                                 podpora CZ.NIC, z.s.p.o.

====================================================================

Anglická verze je zatím nedostupná.
');

INSERT INTO mail_templates (name, contenttype, template) VALUES
('sendauthinfo_epp', 'plain',
'Vážený zákazníku,

   na základě Vaší žádosti podané prostřednictvím registrátora 
<?cs var:registrar ?>, jejímž obsahem je žádost o zaslání hesla
příslušejícího <?cs var:handle ?>.

   Heslo je: <?cs var:authinfo ?>

   Tato zpráva je zaslána pouze na e-mailovou adresu uvedenou u příslušné
osoby v Centrálním registru doménových jmen.

   V případě, že jste tuto žádost nepodali, oznamte prosím tuto
skutečnost na adresu podpora@nic.cz.


                                                 S pozdravem
                                                 podpora CZ.NIC, z.s.p.o.

====================================================================

Anglická verze je zatím nedostupná.
');

INSERT INTO mail_templates (name, contenttype, template) VALUES
('expiration_warning', 'plain',
'Nedostupna ceska verze
====================================================================

Anglická verze je zatím nedostupná.
');

INSERT INTO mail_templates (name, contenttype, template) VALUES
('expiration_notify', 'plain',
'Vážený držiteli domény,

dovolujeme si Vás upozornit, že k <?cs var:checkdatetime ?> dosud nedošlo
k prodloužení registrace doménového jména <?cs var:domain ?>.
Vzhledem k tomu, že doménové jméno bylo za uplynulé období zaplaceno pouze
do <?cs var:exdate ?>, nachází se nyní v takzvané ochranné lhůtě.
V případě, že doménové jméno nebude včas uhrazeno, budou v souladu
s Pravidly registrace doménových jmen nasledovat tyto kroky:

<?cs var:dnsdate ?> - Znefunkčnění doménového jména (vyřazení z DNS).
<?cs var:exregdate ?> - Definitivní zrušení registrace doménového jména.

V této chvíli evidujeme následující údaje o doméně:

Doménové jméno: <?cs var:domain ?>
Držitel: <?cs var:owner ?>
Technický správce: <?cs var:tech ?>
Registrátor: <?cs var:registrator ?>

Vzhledem k této situaci máte nyní následující možnosti:

1. Kontaktujte prosím svého registrátora a ve spolupráci s ním zajistěte
   prodloužení registrace vašeho doménového jména

2. Nebo si vyberte jiného určeného registrátora a jeho prostřednictvím
   zajistěte prodloužení registrace vašeho doménového jména. Seznam
   registrátorů najdete na www.nic.cz (Seznam registratoru)

====================================================================

Dear domain holder,

We would like to inform you that as of <?cs var:checkdatetime ?>,
the registration of the domain name <?cs var:domain ?>
has not been extended. Concerning the fact that the fee for the domain name
in question has been paid only for a period ended on <?cs var:exdate ?>,
your domain name has now entered the so-called protective period. Unless
a registrar of your choice extends your registration, the following steps
will be adopted in accordance with the Domain Name Registration Rules:

<?cs var:dnsdate ?> - The domain name will not be accessible (exclusion from DNS).
<?cs var:exregdate ?> - Final cancellation of the domain name registration.

At present, our database includes the following details concerning your domain:

Domain name: <?cs var:domain ?>
Holder: <?cs var:owner ?>
Technical administrator: <?cs var:tech ?>
Registrar: <?cs var:registrator ?>

To ensure adequate remedy of the existing situation, you can choose
one of the following:

1. Please contact your registrar and make sure that the registration
   of your domain name is duly extended.

2. Or choose another registrar in order to extend the registration of your
   domain name. For a list of registrars, please visit www.nic.cz
   (List of Registrars)

');

INSERT INTO mail_templates (name, contenttype, template) VALUES
('expiration_dns_owner', 'plain',
'Vážený zákazníku,

dovolujeme si Vás tímto upozornit, že doposud nebyla uhrazena platba
za prodloužení či registraci doménového jména <?cs var:domain ?>.
Vzhledem k této skutečnosti a na základě Pravidel registrace doménových
jmen, CZ.NIC, z.s.p.o. pozastavuje registraci doménového jména a vyřazuje
ji ze zóny .CZ.

V případě, že do dne <?cs var:exdate ?> neobdrží CZ.NIC, z.s.p.o.
zálohu, bude doménové jméno definitivně uvolněno pro použití dalším
zájemcem.

Prosíme kontaktujte společnost <?cs var:owner ?> uvedenou
u Vaší domény jako plátce, případně Vašeho Určeného registrátora
<?cs var:registrator ?> a prověřte, proč záloha
není uhrazena.

V případě, že se domníváte, že platba byla provedena, prověřte nejdříve,
zda byla provedena pod spravným variabilním symbolem, na správné číslo
účtu a ve spravné výši ...

??? Co znamena toto ???
... a zda jste registrátorovi udělili souhlas s
Pravidly registrace (pokud byl požadován) a tyto informace svému
Určenému registrátorovi sdělte.

??? nebo toto ???
Pripadne dalsi informace k platbe pote sdelte na adresu fakt@nic.cz

                                                 S pozdravem
                                                 podpora CZ.NIC, z.s.p.o.

====================================================================

Dear customer,

we would like to inform you that you have not yet made the payment
for the registration extension for the domain <?cs var:domain ?>.
Due to this fact and based on the Domain Name Registration Rules
(Pravidla registrace domenovych jmen), CZ.NIC, z.s.p.o. is suspending
the domain name registration and removing the domain from the .CZ zone
(delegation cancellation). Unless a remedy is made before <?cs var:exdate ?>,
the domain name registration will be cancelled!

Please contact the designated registrar <?cs var:registrator ?>
for this domain and agree with him on further steps.

 !tato verze neni prelozena uplne, nektere vety z ceske verze chybeji!

');

INSERT INTO mail_templates (name, contenttype, template) VALUES
('expiration_dns_tech', 'plain',
'Vážený zákazníku,

dovolujeme si Vás tímto upozornit, že doposud nebyla uhrazena platba
za prodloužení či registraci doménového jména <?cs var:domain ?>.
Vzhledem k této skutečnosti a na základě Pravidel registrace doménových
jmen, CZ.NIC, z.s.p.o. pozastavuje registraci doménového jména a vyřazuje
ji ze zóny .CZ.

V případě, že do dne <?cs var:exdate ?> neobdrží CZ.NIC, z.s.p.o.
zálohu, bude doménové jméno definitivně uvolněno pro použití dalším
zájemcem.

Prosíme kontaktujte společnost <?cs var:owner ?> uvedenou
u Vaší domény jako plátce, případně Vašeho Určeného registrátora
<?cs var:registrator ?> a prověřte, proč záloha
není uhrazena.

V případě, že se domníváte, že platba byla provedena, prověřte nejdříve,
zda byla provedena pod spravným variabilním symbolem, na správné číslo
účtu a ve spravné výši ...

??? Co znamena toto ???
... a zda jste registrátorovi udělili souhlas s
Pravidly registrace (pokud byl požadován) a tyto informace svému
Určenému registrátorovi sdělte.

??? nebo toto ???
Pripadne dalsi informace k platbe pote sdelte na adresu fakt@nic.cz

                                                 S pozdravem
                                                 podpora CZ.NIC, z.s.p.o.

====================================================================

Dear customer,

we would like to inform you that you have not yet made the payment
for the registration extension for the domain <?cs var:domain ?>.
Due to this fact and based on the Domain Name Registration Rules
(Pravidla registrace domenovych jmen), CZ.NIC, z.s.p.o. is suspending
the domain name registration and removing the domain from the .CZ zone
(delegation cancellation). Unless a remedy is made before <?cs var:exdate ?>,
the domain name registration will be cancelled!

Please contact the designated registrar <?cs var:registrator ?>
for this domain and agree with him on further steps.

 !tato verze neni prelozena uplne, nektere vety z ceske verze chybeji!

');

INSERT INTO mail_templates (name, contenttype, template) VALUES
('expiration_register_owner', 'plain',
'Vážený zákazníku,

dovolujeme si Vás upozornit, že nebylo provedeno prodloužení registrace
pro doménové jméno <?cs var:domain ?>. Vzhledem k této skutečnosti
a na základě Pravidel registrace doménových jmen , CZ.NIC, z.s.p.o. ruší
registraci doménového jména.

                                                 S pozdravem
                                                 podpora CZ.NIC, z.s.p.o.

====================================================================

Dear customer,

we would like to inform you that the registration extension has not yet
been implemented for the domain name <?cs var:domain ?>. Due to
this fact and based on the Domain Name Registration Rules (Pravidla
registrace domenovych jmen), CZ.NIC, z.s.p.o. is cancelling the domain
name registration.

');

INSERT INTO mail_templates (name, contenttype, template) VALUES
('expiration_register_tech', 'plain',
'Vážený zákazníku,

dovolujeme si Vás upozornit, že nebylo provedeno prodloužení registrace
pro doménové jméno <?cs var:domain ?>. Vzhledem k této skutečnosti
a na základě Pravidel registrace doménových jmen , CZ.NIC, z.s.p.o. ruší
registraci doménového jména.

                                                 S pozdravem
                                                 podpora CZ.NIC, z.s.p.o.

====================================================================

Dear customer,

we would like to inform you that the registration extension has not yet
been implemented for the domain name <?cs var:domain ?>. Due to
this fact and based on the Domain Name Registration Rules (Pravidla
registrace domenovych jmen), CZ.NIC, z.s.p.o. is cancelling the domain
name registration.

');

