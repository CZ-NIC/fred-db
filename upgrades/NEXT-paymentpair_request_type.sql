---
--- dont forget to update database schema version
---
UPDATE enum_parameters SET val = '<insert version here>' WHERE id = 1;


---
--- Ticket #3313: Pridat akci pro logovani parovani platby 
---

INSERT INTO request_type (id, status, service) VALUES (1332, 'PaymentPair', 4);


