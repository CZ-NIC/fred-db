---
--- constraints
---
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

ALTER TABLE mail_archive ADD CONSTRAINT mail_archive_mail_type_template_version_fkey
      FOREIGN KEY (mail_type_id, mail_template_version)
      REFERENCES mail_template(mail_type_id, version);

ALTER TABLE mail_archive ALTER COLUMN message_params SET NOT NULL;

---
--- drops
---
ALTER TABLE mail_type DROP COLUMN subject;
ALTER TABLE mail_archive DROP COLUMN mailtype;
ALTER TABLE mail_archive DROP COLUMN message;
ALTER TABLE mail_archive DROP COLUMN response;
DROP TABLE mail_type_template_map;
DROP TABLE mail_type_mail_header_defaults_map;
DROP TABLE mail_header_defaults;
DROP TABLE mail_defaults;
DROP TABLE mail_templates;
DROP TABLE mail_footer;
