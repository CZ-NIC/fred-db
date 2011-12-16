---
--- Ticket #6298
---

INSERT INTO invoice_type (id , name) VALUES (0,'advance');
INSERT INTO invoice_type (id , name) VALUES (1,'account');

select setval('invoice_type_id_seq', 1);

INSERT INTO invoice_number_prefix ( prefix, zone_id, invoice_type_id) 
VALUES (24 , (select id from zone where fqdn='cz')
, (select id from invoice_type where name='advance'));

INSERT INTO invoice_number_prefix ( prefix, zone_id, invoice_type_id) 
VALUES (23 , (select id from zone where fqdn='cz')
, (select id from invoice_type where name='account'));

INSERT INTO invoice_number_prefix ( prefix, zone_id, invoice_type_id) 
VALUES (11 , (select id from zone where fqdn='0.2.4.e164.arpa')
, (select id from invoice_type where name='advance'));

INSERT INTO invoice_number_prefix ( prefix, zone_id, invoice_type_id) 
VALUES (12 , (select id from zone where fqdn='0.2.4.e164.arpa')
, (select id from invoice_type where name='account'));
