CREATE TABLE mail_template_messenger_migration
(
    mail_type_id INTEGER,
    mail_type TEXT NOT NULL,
    version INTEGER NOT NULL,
    subject TEXT NOT NULL CHECK (REPLACE(subject, ' ', '') = subject AND LENGTH(subject) > 0),
    subject_uuid UUID NOT NULL,
    body TEXT NOT NULL CHECK (REPLACE(body, ' ', '') = body AND LENGTH(body) > 0),
    body_uuid UUID NOT NULL
);

\COPY mail_template_messenger_migration (mail_type, version, subject, subject_uuid, body, body_uuid) FROM 'mail_template_messenger_migration_data.csv' WITH CSV DELIMITER ',' HEADER

UPDATE mail_template_messenger_migration mig
   SET mail_type_id = (SELECT id FROM mail_type WHERE name = mig.mail_type);

ALTER TABLE mail_template_messenger_migration
       DROP COLUMN mail_type;

ALTER TABLE mail_template_messenger_migration
      ALTER COLUMN mail_type_id SET NOT NULL;

ALTER TABLE mail_template_messenger_migration
        ADD CONSTRAINT mail_template_messenger_migration_pkey PRIMARY KEY (mail_type_id, version);

ALTER TABLE mail_template_messenger_migration
        ADD CONSTRAINT mail_template_messenger_migration_mail_type_id_version_fkey
            FOREIGN KEY (mail_type_id, version)
            REFERENCES mail_template(mail_type_id, version)
            DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE mail_template
        ADD CONSTRAINT mail_template_mail_type_id_version_fkey
            FOREIGN KEY (mail_type_id, version)
            REFERENCES mail_template_messenger_migration(mail_type_id, version)
            DEFERRABLE INITIALLY DEFERRED;
