---
--- administrative domain blocking/unblocking
---
INSERT INTO request_type (service_id, id, name) VALUES
(4, 1341, 'DomainsBlock'),
(4, 1342, 'DomainsBlockUpdate'),
(4, 1343, 'DomainsUnblock'),
(4, 1344, 'DomainsBlacklistAndDelete');


---
--- Ticket #9339
---
INSERT INTO request_type (service_id, id, name) VALUES
(6, 1513, 'PublicProfileChange');

