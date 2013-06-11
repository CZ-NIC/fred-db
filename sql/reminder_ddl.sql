---
--- Ticket #5102 - contact reminder
---

CREATE TABLE reminder_registrar_parameter (
    registrar_id integer NOT NULL CONSTRAINT reminder_registrar_parameter_pkey PRIMARY KEY
    CONSTRAINT reminder_registrar_parameter_registrar_id_fkey REFERENCES registrar(id),
    template_memo text,
    reply_to varchar(200)
);



CREATE TABLE reminder_contact_message_map (
    reminder_date date NOT NULL,
    contact_id integer NOT NULL CONSTRAINT reminder_contact_message_map_contact_id_fkey REFERENCES object_registry(id),
    message_id integer CONSTRAINT reminder_contact_message_map_message_id_fkey REFERENCES mail_archive(id),
    CONSTRAINT reminder_contact_message_map_pkey PRIMARY KEY(reminder_date, contact_id)
);


