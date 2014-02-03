---
--- mapping for default header values selection
---

CREATE TABLE mail_type_mail_header_defaults_map
(
    mail_type_id INTEGER CONSTRAINT mail_type_mail_header_defaults_map_mail_type_id_key UNIQUE NULL CONSTRAINT mail_type_mail_header_defaults_map_mail_type_id_fkey REFERENCES mail_type(id),
    mail_header_defaults_id INTEGER NOT NULL CONSTRAINT mail_type_mail_header_defaults_map_mail_header_defaults_id_fkey REFERENCES mail_header_defaults(id)
);

