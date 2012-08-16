---
--- Ticket #6164
---

UPDATE enum_public_request_type SET name='mojeid_contact_conditional_identification', description='MojeID conditional identification' WHERE id=12;
UPDATE enum_public_request_type SET name='mojeid_contact_identification', description='MojeID full identification' WHERE id=13;
UPDATE enum_public_request_type SET name='mojeid_contact_validation', description='MojeID validation' WHERE id=14;

INSERT INTO enum_public_request_type (id, name, description) VALUES (15, 'contact_conditional_identification', 'Conditional identification');
INSERT INTO enum_public_request_type (id, name, description) VALUES (16, 'contact_identification', 'Full identification');

--create in NEXT-enum_public_request_status-ddl.sql
INSERT INTO enum_public_request_status (id, name, description) VALUES (0, 'new', 'New');
INSERT INTO enum_public_request_status (id, name, description) VALUES (1, 'answered', 'Answered');
INSERT INTO enum_public_request_status (id, name, description) VALUES (2, 'invalidated', 'Invalidated');

ALTER TABLE public_request ADD CONSTRAINT public_request_status_fkey FOREIGN KEY(status) REFERENCES enum_public_request_status(id);
