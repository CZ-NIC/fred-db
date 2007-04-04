
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
INSERT INTO mail_defaults (name, value) VALUES ('company', 'CZ.NIC, z.s.p.o');
INSERT INTO mail_defaults (name, value) VALUES ('street', 'Americka 23');
INSERT INTO mail_defaults (name, value) VALUES ('postalcode', '120 00');
INSERT INTO mail_defaults (name, value) VALUES ('city', 'Praha 2');
INSERT INTO mail_defaults (name, value) VALUES ('tel', '+420 222 745 104');
INSERT INTO mail_defaults (name, value) VALUES ('fax', '+420 222 745 112');
INSERT INTO mail_defaults (name, value) VALUES ('emailsupport', 'support@nic.cz');
INSERT INTO mail_defaults (name, value) VALUES ('authinfopage', 'http://enum.nic.cz/');
INSERT INTO mail_defaults (name, value) VALUES ('whoispage', 'http://whois.enum.nic.cz/');

CREATE TABLE mail_footer (
	id integer PRIMARY KEY,
	footer text NOT NULL
);
INSERT INTO mail_footer (id, footer) VALUES (1,
'-- 
<?cs var:defaults.company ?>
<?cs var:defaults.street ?>
<?cs var:defaults.postalcode ?> <?cs var:defaults.city ?>
---------------------------------
tel.: <?cs var:defaults.tel ?>
fax : <?cs var:defaults.fax ?>
e-mail : <?cs var:defaults.emailsupport ?>
---------------------------------
');

CREATE TABLE mail_vcard (
	vcard text NOT NULL
);
INSERT INTO mail_vcard (vcard) VALUES
('BEGIN:VCARD
VERSION:2.1
N:podpora CZ. NIC, z.s.p.o.
FN:podpora CZ. NIC, z.s.p.o.
ORG:CZ.NIC, z.s.p.o.
TITLE:zakaznicka podpora
TEL;WORK;VOICE:+420 222 745 104
TEL;WORK;FAX:+420 222 745 112
ADR;WORK:;;Americka 23;Praha 2;;120 00;Česká republika
URL;WORK:http://www.nic.cz
EMAIL;PREF;INTERNET:podpora@nic.cz
REV:20070403T143928Z
END:VCARD
');

CREATE TABLE mail_header_defaults (
	id SERIAL PRIMARY KEY,
	h_from varchar(300),
	h_replyto varchar(300),
	h_errorsto varchar(300),
	h_organization varchar(300),
	h_contentencoding varchar(300),
	h_messageidserver varchar(300)
);

INSERT INTO mail_header_defaults
(h_from,
h_replyto,
h_errorsto,
h_organization,
h_contentencoding,
h_messageidserver)
VALUES
('podpora@nic.cz',
'podpora@nic.cz',
'podpora@nic.cz',
'CZ.NIC, z.s.p.o.',
'charset=UTF-8',
'nic.cz');

CREATE TABLE mail_templates (
	id integer PRIMARY KEY,
	contenttype varchar(100) NOT NULL,
	template text NOT NULL,
	footer integer REFERENCES mail_footer(id)
	);

CREATE TABLE mail_type (
	id integer PRIMARY KEY,
	name varchar(100) UNIQUE NOT NULL,
	subject varchar(300) NOT NULL
	);

CREATE TABLE mail_type_template_map (
	typeid integer references mail_type(id),
	templateid integer references mail_templates(id),
        PRIMARY KEY (  typeid  , templateid  )
	);

CREATE TABLE mail_archive (
	id SERIAL PRIMARY KEY,
	mailtype integer references mail_type(id),
	crdate timestamp NOT NULL DEFAULT now(),
	moddate timestamp,
	status integer,
	message text NOT NULL
	);

CREATE TABLE mail_attachments (
	id SERIAL PRIMARY KEY,
	mailid integer references mail_archive(id),
	attachid integer references files(id)
	);

CREATE TABLE mail_handles (
	id SERIAL PRIMARY KEY,
	mailid integer references mail_archive(id),
	associd varchar(255)
	);

