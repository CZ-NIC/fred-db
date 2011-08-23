---
--- Ticket #5666
---

CREATE TABLE registrar_disconnect (
    id SERIAL PRIMARY KEY,
    registrarid INTEGER NOT NULL REFERENCES registrar(id),
    blocked_from TIMESTAMP NOT NULL DEFAULT now(),
    blocked_to TIMESTAMP,
    unblock_request_id BIGINT
)

CREATE TABLE request_fee_registrar_parameter (
registrar_id INTEGER PRIMARY KEY REFERENCES registrar(id),
request_price_limit numeric(10, 2) NOT NULL,
email varchar(200) NOT NULL,
telephone varchar(64) NOT NULL
-- [ contact_id REFERENCES contact(id) ]
);


