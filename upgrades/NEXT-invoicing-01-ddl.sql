---
--- Ticket #6298
---

CREATE TABLE invoice_type
(
id serial NOT NULL PRIMARY KEY
, name text
);

comment on table invoice_type is
'invoice types list';


CREATE TABLE invoice_number_prefix
(
id serial NOT NULL PRIMARY KEY
, prefix integer NOT NULL
, zone_id bigint NOT NULL REFERENCES zone(id)
, invoice_type_id bigint NOT NULL REFERENCES invoice_type (id)
, CONSTRAINT invoice_number_prefix_unique_key UNIQUE (zone_id, invoice_type_id)
);

comment on table invoice_number_prefix is
'prefixes to invoice number, next year prefixes are generated according to records in this table';

comment on column invoice_number_prefix.prefix is 'two-digit number';