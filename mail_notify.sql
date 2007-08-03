-- Defaults used in templates which change rarely
-- The default names must be prefixed with 'defaults' namespace when used
--   in template
CREATE TABLE mail_defaults (
	id SERIAL PRIMARY KEY,
	name varchar(300) UNIQUE NOT NULL, -- key of default
	value text NOT NULL                -- value of default
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

-- mail footer is defined here and not in templates in order to reduce
-- size of templates
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

-- vcard is attached to every email message
--   in future it should be templated as footer is, in order to minimize
--   duplicated information
CREATE TABLE mail_vcard (
	vcard text NOT NULL,
	id SERIAL PRIMARY KEY
);
INSERT INTO mail_vcard (vcard) VALUES
('BEGIN:VCARD
VERSION:2.1
N:podpora CZ. NIC, z.s.p.o.
FN:podpora CZ. NIC, z.s.p.o.
ORG:CZ.NIC, z.s.p.o.
TITLE:zákaznická podpora
TEL;WORK;VOICE:+420 222 745 104
TEL;WORK;FAX:+420 222 745 112
ADR;WORK:;;Americká 23;Praha 2;;120 00;Česká republika
URL;WORK:http://www.nic.cz
EMAIL;PREF;INTERNET:podpora@nic.cz
REV:20070403T143928Z
END:VCARD
');

-- some header defaults which are likely not a subject to change are specified 
-- in database and used in absence
CREATE TABLE mail_header_defaults (
	id SERIAL PRIMARY KEY,
	h_from varchar(300),           -- 'From:' header
	h_replyto varchar(300),        -- 'Reply-to:' header
	h_errorsto varchar(300),       -- 'Errors-to:' header
	h_organization varchar(300),   -- 'Organization:' header
	h_contentencoding varchar(300),-- 'Content-encoding:' header
	h_messageidserver varchar(300) -- Message id cannot be overriden by
	                               --   client, in db is stored only the
	                               --   part after '@' character
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

-- Here are stored email templates which represent one text attachment of
-- email message
CREATE TABLE mail_templates (
	id integer PRIMARY KEY,
	contenttype varchar(100) NOT NULL, -- subtype of content type text
	template text NOT NULL,            -- clearsilver template
	footer integer REFERENCES mail_footer(id) -- should footer be
	                                          -- concatenated with template?
	);

-- Type of email gathers templates from which email is composed
CREATE TABLE mail_type (
	id integer PRIMARY KEY,
	name varchar(100) UNIQUE NOT NULL, -- name of type
	subject varchar(300) NOT NULL      -- template of email subject
	);

-- One type may consists from multiple templates and one template may be
-- part of multiple mailtypes. This is binding table.
CREATE TABLE mail_type_template_map (
	typeid integer references mail_type(id),
	templateid integer references mail_templates(id),
        PRIMARY KEY (  typeid  , templateid  )
	);

-- Here are stored emails which are going to be sent and email which have
-- already been sent (they differ in status value).
CREATE TABLE mail_archive (
	id SERIAL PRIMARY KEY,
	mailtype integer references mail_type(id),-- email type
	crdate timestamp NOT NULL DEFAULT now(),  -- date of insertion in table
	moddate timestamp,    -- date of sending (even if unsuccesfull)
	-- status value has following meanings:
	--    0: The email was successfully sent
	--    1: The email is ready to be sent
	--    x: The email waits for manual confirmation which should change
	--       status value to 0 when the email is desired to be sent.
	--       x represents any value different from 0 and 1 (convention is
	--       number 2).
	status integer,
	attempt smallint NOT NULL DEFAULT 0, -- failed attempts to send email
	-- message to be sent including headers (except date and msgid header), 	-- without non-templated attachments.
	message text NOT NULL,
	-- text of email which is assummed to be notification about undelivered
	-- mail.
	response text
	);

-- List of attachment ids bound to email in mail_archive
CREATE TABLE mail_attachments (
	id SERIAL PRIMARY KEY,
	mailid integer references mail_archive(id), -- id of email in archive
	attachid integer references files(id)       -- Attachment id
	);

-- Handles associated with email in mail_archive
CREATE TABLE mail_handles (
	id SERIAL PRIMARY KEY,
	mailid integer references mail_archive(id),-- id of email in archive
	associd varchar(255)                       -- handle of associated object
	);

