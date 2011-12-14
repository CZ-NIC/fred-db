---
--- Ticket #6298
---

INSERT INTO invoice_type (typ , description) VALUES (0,'advance');
INSERT INTO invoice_type (typ , description) VALUES (1,'account');

select setval('invoice_type_typ_seq', 1);