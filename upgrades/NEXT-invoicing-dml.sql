---
--- Ticket #6298
---

INSERT INTO invoice_type (id , name) VALUES (0,'advance');
INSERT INTO invoice_type (id , name) VALUES (1,'account');

select setval('invoice_type_id_seq', 1);