CREATE TABLE mail_archive (
    id integer NOT NULL,
    crdate timestamp without time zone DEFAULT now() NOT NULL,
    moddate timestamp without time zone,
    status integer,
    message text,
    attempt smallint DEFAULT 0 NOT NULL,
    response text,
    mail_type_id integer NOT NULL,
    mail_template_version integer NOT NULL,
    message_params jsonb,
    response_header jsonb
);


COMMENT ON TABLE mail_archive IS 'Here are stored emails which are going to be sent and email which have
already been sent (they differ in status value).';

COMMENT ON COLUMN mail_archive.crdate IS 'date and time of insertion in table';
COMMENT ON COLUMN mail_archive.moddate IS 'date and time of sending (event unsuccesfull)';
COMMENT ON COLUMN mail_archive.status IS 'status value has following meanings:
 0 - the email was successfully sent
 1 - the email is ready to be sent
 x - the email wait for manual confirmation which should change status value to 0
     when the email is desired to be sent. x represent any value different from
     0 and 1 (convention is number 2)';
COMMENT ON COLUMN mail_archive.message IS 'text of email which is asssumed to be notificaion about undelivered';
COMMENT ON COLUMN mail_archive.attempt IS 'failed attempt to send email message to be sent including headers
(except date and msgid header), without non-templated attachments';

CREATE SEQUENCE mail_archive_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE mail_archive_id_seq OWNED BY mail_archive.id;


CREATE TABLE mail_attachments (
    id integer NOT NULL,
    mailid integer,
    attachid integer
);

COMMENT ON TABLE mail_attachments IS 'list of attachment ids bound to email in mail_archive';
COMMENT ON COLUMN mail_attachments.mailid IS 'id of email in archive';
COMMENT ON COLUMN mail_attachments.attachid IS 'attachment id';

CREATE SEQUENCE mail_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE mail_attachments_id_seq OWNED BY mail_attachments.id;


CREATE TABLE mail_handles (
    id integer NOT NULL,
    mailid integer,
    associd character varying(255)
);

COMMENT ON TABLE mail_handles IS 'handles associated with email in mail_archive';
COMMENT ON COLUMN mail_handles.mailid IS 'id of email in archive';
COMMENT ON COLUMN mail_handles.associd IS 'handle of associated object';

CREATE SEQUENCE mail_handles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE mail_handles_id_seq OWNED BY mail_handles.id;


CREATE TABLE mail_header_default (
    id integer NOT NULL,
    h_from character varying(300),
    h_replyto character varying(300),
    h_errorsto character varying(300),
    h_organization character varying(300),
    h_contentencoding character varying(300),
    h_messageidserver character varying(300)
);

COMMENT ON TABLE mail_header_default IS 'E-mail headers default parameters, used if not set by client';

CREATE SEQUENCE mail_header_default_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE mail_header_default_id_seq OWNED BY mail_header_default.id;


CREATE TABLE mail_template (
    mail_type_id integer NOT NULL,
    version integer NOT NULL,
    subject text NOT NULL,
    body_template text NOT NULL,
    body_template_content_type character varying(100) NOT NULL,
    mail_template_footer_id integer NOT NULL,
    mail_template_default_id integer NOT NULL,
    mail_header_default_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);

COMMENT ON TABLE mail_template IS 'Map subject, body template, footer template, template default parameters and header default parameters to mail type and version';


CREATE TABLE mail_template_default (
    id integer NOT NULL,
    params jsonb
);

COMMENT ON TABLE mail_template_default IS 'default parameters for all e-mail templates';

CREATE SEQUENCE mail_template_default_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE mail_template_default_id_seq OWNED BY mail_template_default.id;


CREATE TABLE mail_template_footer (
    id integer NOT NULL,
    footer text NOT NULL
);

COMMENT ON TABLE mail_template_footer IS 'E-mail footer templates';


CREATE TABLE mail_type (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);

COMMENT ON TABLE mail_type IS 'Type of email gathers templates from which email is composed';
COMMENT ON COLUMN mail_type.name IS 'name of type';


CREATE TABLE mail_type_priority (
    mail_type_id integer NOT NULL,
    priority integer NOT NULL
);


CREATE TABLE mail_vcard (
    vcard text NOT NULL,
    id integer NOT NULL
);

COMMENT ON TABLE mail_vcard IS 'vcard is attached to every email message';

CREATE SEQUENCE mail_vcard_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE mail_vcard_id_seq OWNED BY mail_vcard.id;


ALTER TABLE ONLY mail_archive
      ALTER COLUMN id SET DEFAULT nextval('mail_archive_id_seq'::regclass);
ALTER TABLE ONLY mail_attachments
      ALTER COLUMN id SET DEFAULT nextval('mail_attachments_id_seq'::regclass);
ALTER TABLE ONLY mail_handles
      ALTER COLUMN id SET DEFAULT nextval('mail_handles_id_seq'::regclass);
ALTER TABLE ONLY mail_header_default
      ALTER COLUMN id SET DEFAULT nextval('mail_header_default_id_seq'::regclass);
ALTER TABLE ONLY mail_template_default
      ALTER COLUMN id SET DEFAULT nextval('mail_template_default_id_seq'::regclass);
ALTER TABLE ONLY mail_vcard
      ALTER COLUMN id SET DEFAULT nextval('mail_vcard_id_seq'::regclass);

ALTER TABLE ONLY mail_archive
    ADD CONSTRAINT mail_archive_pkey PRIMARY KEY (id);

ALTER TABLE ONLY mail_attachments
    ADD CONSTRAINT mail_attachments_pkey PRIMARY KEY (id);

ALTER TABLE ONLY mail_handles
    ADD CONSTRAINT mail_handles_pkey PRIMARY KEY (id);

ALTER TABLE ONLY mail_header_default
    ADD CONSTRAINT mail_header_default_pkey PRIMARY KEY (id);

ALTER TABLE ONLY mail_template_default
    ADD CONSTRAINT mail_template_default_pkey PRIMARY KEY (id);

ALTER TABLE ONLY mail_template_footer
    ADD CONSTRAINT mail_template_footer_pkey PRIMARY KEY (id);

ALTER TABLE ONLY mail_template
    ADD CONSTRAINT mail_template_pkey PRIMARY KEY (mail_type_id, version);

ALTER TABLE ONLY mail_type
    ADD CONSTRAINT mail_type_name_key UNIQUE (name);

ALTER TABLE ONLY mail_type
    ADD CONSTRAINT mail_type_pkey PRIMARY KEY (id);

ALTER TABLE ONLY mail_type_priority
    ADD CONSTRAINT mail_type_priority_pkey PRIMARY KEY (mail_type_id);

ALTER TABLE ONLY mail_vcard
    ADD CONSTRAINT mail_vcard_pkey PRIMARY KEY (id);


CREATE INDEX mail_archive_crdate_idx ON mail_archive USING btree (crdate);
CREATE INDEX mail_archive_mail_type_id_idx ON mail_archive USING btree (mail_type_id);
CREATE INDEX mail_archive_mail_type_id_mail_template_version_idx ON mail_archive USING btree (mail_type_id, mail_template_version);
CREATE INDEX mail_archive_status_idx ON mail_archive USING btree (status);

CREATE INDEX mail_attachments_mailid_idx ON mail_attachments USING btree (mailid);

CREATE INDEX mail_template_mail_header_default_id_idx ON mail_template USING btree (mail_header_default_id);
CREATE INDEX mail_template_mail_template_default_id_idx ON mail_template USING btree (mail_template_default_id);
CREATE INDEX mail_template_mail_template_footer_id_idx ON mail_template USING btree (mail_template_footer_id);

CREATE FUNCTION get_current_mail_template_version(mail_type_id INTEGER) RETURNS INTEGER AS
$$
    SELECT MAX(mtt.version) FROM mail_type mt LEFT JOIN mail_template mtt ON mtt.mail_type_id = mt.id WHERE mt.id = $1;
$$
LANGUAGE SQL;

CREATE FUNCTION get_next_mail_template_version() RETURNS TRIGGER AS
$$
BEGIN
    NEW.version := (SELECT COALESCE(get_current_mail_template_version(NEW.mail_type_id), 0) + 1);
    RETURN NEW;
END;
$$
LANGUAGE PLPGSQL;

CREATE FUNCTION set_current_mail_template_version() RETURNS TRIGGER AS
$$
BEGIN
    NEW.mail_template_version := get_current_mail_template_version(NEW.mail_type_id);
    RETURN NEW;
END;
$$
LANGUAGE PLPGSQL;

CREATE TRIGGER set_current_mail_template_version_trigger
       BEFORE INSERT ON mail_archive
       FOR EACH ROW EXECUTE PROCEDURE set_current_mail_template_version();

CREATE TRIGGER set_next_mail_template_version_trigger
       BEFORE INSERT ON mail_template
       FOR EACH ROW EXECUTE PROCEDURE get_next_mail_template_version();

ALTER TABLE ONLY mail_archive
    ADD CONSTRAINT mail_archive_mail_type_id_fkey FOREIGN KEY (mail_type_id)
        REFERENCES mail_type(id);
ALTER TABLE ONLY mail_archive
    ADD CONSTRAINT mail_archive_mail_type_id_fkey1 FOREIGN KEY (mail_type_id, mail_template_version)
        REFERENCES mail_template(mail_type_id, version);

ALTER TABLE ONLY mail_attachments
    ADD CONSTRAINT mail_attachments_attachid_fkey FOREIGN KEY (attachid)
        REFERENCES files(id);
ALTER TABLE ONLY mail_attachments
    ADD CONSTRAINT mail_attachments_mailid_fkey FOREIGN KEY (mailid)
        REFERENCES mail_archive(id);

ALTER TABLE ONLY mail_handles
    ADD CONSTRAINT mail_handles_mailid_fkey FOREIGN KEY (mailid)
        REFERENCES mail_archive(id);

ALTER TABLE ONLY mail_template
    ADD CONSTRAINT mail_template_mail_header_default_id_fkey
        FOREIGN KEY (mail_header_default_id)
        REFERENCES mail_header_default(id);
ALTER TABLE ONLY mail_template
    ADD CONSTRAINT mail_template_mail_template_default_id_fkey
        FOREIGN KEY (mail_template_default_id)
        REFERENCES mail_template_default(id);
ALTER TABLE ONLY mail_template
    ADD CONSTRAINT mail_template_mail_template_footer_id_fkey
        FOREIGN KEY (mail_template_footer_id)
        REFERENCES mail_template_footer(id);
ALTER TABLE ONLY mail_template
    ADD CONSTRAINT mail_template_mail_type_id_fkey
        FOREIGN KEY (mail_type_id)
        REFERENCES mail_type(id);

ALTER TABLE ONLY mail_type_priority
    ADD CONSTRAINT mail_type_priority_mail_type_id_fkey
        FOREIGN KEY (mail_type_id)
        REFERENCES mail_type(id);
