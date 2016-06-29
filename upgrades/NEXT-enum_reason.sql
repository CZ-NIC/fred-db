---
--- Ticket #15032 - duplicated nameserver hostname reason
---
INSERT INTO enum_reason VALUES (63, 'Duplicated nameserver hostname', 'Duplicitní jméno jmenného serveru DNS');
SELECT setval('enum_reason_id_seq', 63);

