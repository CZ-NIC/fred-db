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



---
--- remove duplicate elements from array
---
CREATE OR REPLACE FUNCTION array_uniq(anyarray)
RETURNS anyarray as $$
SELECT array(SELECT DISTINCT $1[i] FROM
    generate_series(array_lower($1,1), array_upper($1,1)) g(i));
$$ LANGUAGE SQL STRICT IMMUTABLE;


---
--- remove null elements from array
---
CREATE OR REPLACE FUNCTION array_filter_null(anyarray)
RETURNS anyarray as $$
SELECT array(SELECT $1[i] FROM
    generate_series(array_lower($1,1), array_upper($1,1)) g(i) WHERE $1[i] IS NOT NULL) ;
$$ LANGUAGE SQL STRICT IMMUTABLE;

