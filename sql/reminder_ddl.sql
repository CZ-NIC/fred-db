---
--- Ticket #5102 - contact reminder
---

CREATE TABLE reminder_registrar_parameter (
    registrar_id integer NOT NULL PRIMARY KEY REFERENCES registrar(id),
    template_memo text,
    reply_to varchar(200)
);



CREATE TABLE reminder_contact_message_map (
    reminder_date date NOT NULL,
    contact_id integer NOT NULL REFERENCES object_registry(id),
    message_id integer REFERENCES mail_archive(id),
    PRIMARY KEY(reminder_date, contact_id)
);


