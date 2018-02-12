---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.33.0' WHERE id = 1;


---
--- mail_defaults => mail_template_default
---
CREATE TABLE mail_template_default (
    id SERIAL PRIMARY KEY,
    params JSONB
);

COMMENT ON TABLE mail_template_default
     IS 'default parameters for all e-mail templates';


---
--- mail_footer => mail_template_footer
---
CREATE TABLE mail_template_footer (
    id INTEGER CONSTRAINT mail_template_footer_pkey PRIMARY KEY,
    footer TEXT NOT NULL
);

COMMENT ON TABLE mail_template_footer
     IS 'E-mail footer templates';


---
--- mail_header_defaults => mail_header_default
---
CREATE TABLE mail_header_default (
    id SERIAL CONSTRAINT mail_header_default_pkey PRIMARY KEY,
    h_from VARCHAR(300),
    h_replyto VARCHAR(300),
    h_errorsto VARCHAR(300),
    h_organization VARCHAR(300),
    h_contentencoding VARCHAR(300),
    h_messageidserver VARCHAR(300)
);

COMMENT ON TABLE mail_header_default
     IS 'E-mail headers default parameters, used if not set by client';
COMMENT ON COLUMN mail_header_default.h_from
     IS '''From:'' header';
COMMENT ON COLUMN mail_header_default.h_replyto
     IS '''Reply-to:'' header';
COMMENT ON COLUMN mail_header_default.h_errorsto
     IS '''Errors-to:'' header';
COMMENT ON COLUMN mail_header_default.h_organization
     IS '''Organization:'' header';
COMMENT ON COLUMN mail_header_default.h_contentencoding
     IS '''Content-encoding:'' header';
COMMENT ON COLUMN mail_header_default.h_messageidserver
     IS 'Used to generate ''Message-ID'' (<email-id>.<timestamp>@<messageidserver>) ';


---
--- mail_templates, mail_type => mail_template
---
CREATE TABLE mail_template (
    mail_type_id INTEGER NOT NULL REFERENCES mail_type(id),
    version INTEGER NOT NULL,
    subject TEXT NOT NULL,
    body_template TEXT NOT NULL,
    body_template_content_type VARCHAR(100) NOT NULL,
    mail_template_footer_id INTEGER NOT NULL REFERENCES mail_template_footer(id),
    mail_template_default_id INTEGER NOT NULL REFERENCES mail_template_default(id),
    mail_header_default_id INTEGER NOT NULL REFERENCES mail_header_default(id),
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now(),
    PRIMARY KEY (mail_type_id, version)
);

COMMENT ON TABLE mail_template
     IS 'Map subject, body template, footer template, template default parameters'
        ' and header default parameters to mail type and version';

CREATE INDEX mail_template_mail_template_footer_id_idx ON mail_template(mail_template_footer_id);
CREATE INDEX mail_template_mail_template_default_id_idx ON mail_template(mail_template_default_id);
CREATE INDEX mail_template_mail_header_default_id_idx ON mail_template(mail_header_default_id);

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

CREATE TRIGGER set_next_mail_template_version_trigger
       BEFORE INSERT ON mail_template
       FOR EACH ROW EXECUTE PROCEDURE get_next_mail_template_version();


---
--- mail_archive
---
ALTER TABLE mail_archive ADD COLUMN IF NOT EXISTS mail_type_id INTEGER NOT NULL;
ALTER TABLE mail_archive ADD COLUMN IF NOT EXISTS mail_template_version INTEGER NOT NULL;
ALTER TABLE mail_archive ADD COLUMN IF NOT EXISTS message_params JSONB;
ALTER TABLE mail_archive ADD COLUMN IF NOT EXISTS response_header JSONB;

DO
$$
BEGIN
    BEGIN
        ALTER TABLE mail_archive ADD CONSTRAINT mail_archive_mail_type_id_fkey FOREIGN KEY (mail_type_id) REFERENCES mail_type(id);
    EXCEPTION
        WHEN duplicate_object THEN
            RAISE NOTICE 'Constraint `mail_archive_mail_type_id_fkey` already exists';
    END;
END
$$;

ALTER TABLE mail_archive ADD CONSTRAINT mail_archive_mail_type_template_version_fkey FOREIGN KEY (mail_type_id, mail_template_version)
      REFERENCES mail_template(mail_type_id, version);

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

CREATE INDEX mail_archive_mail_type_id_idx ON mail_archive(mail_type_id);
CREATE INDEX mail_archive_mail_type_id_mail_template_version_idx ON mail_archive(mail_type_id, mail_template_version);
