
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

CREATE TABLE header_defaults (
	id SERIAL PRIMARY KEY,
	h_from varchar(300),
	h_replyto varchar(300),
	h_errorsto varchar(300),
	h_organization varchar(300),
	h_contentencoding varchar(300),
	h_messageidserver varchar(300),
	h_subject varchar(300)
);

INSERT INTO header_defaults
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

CREATE TABLE templates (
	id SERIAL PRIMARY KEY,
	name varchar(100) UNIQUE NOT NULL,
	contenttype varchar(100) NOT NULL,
	template text NOT NULL,
	moddate timestamp NOT NULL DEFAULT now()
	);

INSERT INTO templates (name, contenttype, template) VALUES
('test_txt_template', 'plain',
'Hello <?cs var:body.name ?>,

this is test email for testing of email templates. It was generated
on <?cs var:header.date ?> by notification system.

                                                    Have a nice day!
                                                    NIC.CZ Team.
');

CREATE TABLE mailarchive (
	id SERIAL PRIMARY KEY,
	crdate timestamp NOT NULL DEFAULT now(),
	moddate timestamp,
	status integer,
	message text NOT NULL
	);

CREATE TABLE atachment_ids (
	id SERIAL PRIMARY KEY,
	mailid integer references mailarchive(id),
	atachid varchar(255)
	);

CREATE TABLE assoc_handles (
	id SERIAL PRIMARY KEY,
	mailid integer references mailarchive(id),
	associd varchar(255)
	);
