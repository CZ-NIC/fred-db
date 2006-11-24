
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
');
