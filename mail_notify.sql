
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
('notifications@nic.cz',
'help-desk@nic.cz',
'notification-errors@nic.cz',
'CZ.NIC, z.s.p.o.',
'charset=UTF-8',
'nic.cz');

CREATE TABLE mail_templates (
	id SERIAL PRIMARY KEY,
	contenttype varchar(100) NOT NULL,
	template text NOT NULL
	);

CREATE TABLE mail_type (
	id SERIAL PRIMARY KEY,
	name varchar(100) UNIQUE NOT NULL,
	subject varchar(300) NOT NULL
	);

CREATE TABLE mail_type_template_map (
	id SERIAL PRIMARY KEY,
	typeid integer references mail_type(id),
	templateid integer references mail_templates(id)
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

