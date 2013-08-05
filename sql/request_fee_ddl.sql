---
--- table for poll messages used for request charging feature
---
CREATE TABLE poll_request_fee (
      msgid integer NOT NULL CONSTRAINT poll_request_fee_pkey PRIMARY KEY
      CONSTRAINT poll_request_fee_msgid_fkey REFERENCES message(id),
      period_from timestamp without time zone NOT NULL,
      period_to timestamp without time zone NOT NULL,
      total_free_count bigint NOT NULL,
      used_count bigint NOT NULL,
      price numeric(10, 2) NOT NULL
);

--- 
--- table with parameters for charging requests to registry
---
CREATE TABLE request_fee_parameter (
    id INTEGER CONSTRAINT request_fee_parameter_pkey PRIMARY KEY,
    valid_from timestamp NOT NULL,
    count_free_base INTEGER,
    count_free_per_domain INTEGER,
    zone_id INTEGER NOT NULL CONSTRAINT request_fee_parameter_zone_id_fkey REFERENCES zone(id)
);


CREATE TABLE request_fee_registrar_parameter (
registrar_id INTEGER CONSTRAINT request_fee_registrar_parameter_pkey PRIMARY KEY
CONSTRAINT request_fee_registrar_parameter_registrar_id_fkey REFERENCES registrar(id),
request_price_limit numeric(10, 2) NOT NULL,
email varchar(200) NOT NULL,
telephone varchar(64) NOT NULL
-- [ contact_id REFERENCES contact(id) ]
);


