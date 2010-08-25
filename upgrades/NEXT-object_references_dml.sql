--- don't forget to update database schema version
---
---



UPDATE enum_parameters SET val = '<insert version here>' WHERE id = 1;


-- Ticket #4392

INSERT INTO request_object_type (id, name) VALUES (1, 'contact');
INSERT INTO request_object_type (id, name) VALUES (2, 'nsset');
INSERT INTO request_object_type (id, name) VALUES (3, 'domain');
INSERT INTO request_object_type (id, name) VALUES (4, 'keyset');
INSERT INTO request_object_type (id, name) VALUES (5, 'registrar');
INSERT INTO request_object_type (id, name) VALUES (6, 'mail');
INSERT INTO request_object_type (id, name) VALUES (7, 'file');
INSERT INTO request_object_type (id, name) VALUES (8, 'publicrequest');
INSERT INTO request_object_type (id, name) VALUES (9, 'invoice');
INSERT INTO request_object_type (id, name) VALUES (10, 'bankstatement');
INSERT INTO request_object_type (id, name) VALUES (11, 'request');



