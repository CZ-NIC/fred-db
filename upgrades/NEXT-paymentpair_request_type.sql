---
--- dont forget to update database schema version
---
UPDATE enum_parameters SET val = '<insert version here>' WHERE id = 1;


---
--- Ticket #3313: Pridat akci pro logovani parovani platby 
--- Ticket #3366: Pridat akci pro logovani pridani domeny do zony 
---

INSERT INTO request_type (id, status, service) VALUES (1332, 'PaymentPair', 4);
INSERT INTO request_type (id, status, service) VALUES (1333, 'SetInZoneStatus', 4);
