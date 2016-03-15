---
--- Public request types for contact verification
---

INSERT INTO enum_public_request_type (id, name, description) VALUES (12, 'mojeid_contact_conditional_identification', 'MojeID conditional identification');
INSERT INTO enum_public_request_type (id, name, description) VALUES (13, 'mojeid_contact_identification', 'MojeID full identification');
INSERT INTO enum_public_request_type (id, name, description) VALUES (14, 'mojeid_contact_validation', 'MojeID validation');
INSERT INTO enum_public_request_type (id, name, description) VALUES (17, 'mojeid_conditionally_identified_contact_transfer', 'MojeID conditionally identified contact transfer');
INSERT INTO enum_public_request_type (id, name, description) VALUES (18, 'mojeid_identified_contact_transfer', 'MojeID identified contact transfer');
INSERT INTO enum_public_request_type (id, name, description) VALUES (19, 'mojeid_contact_reidentification', 'MojeID full identification repeated');
INSERT INTO enum_public_request_type (id, name, description) VALUES (20,'mojeid_prevalidated_unidentified_contact_transfer','MojeID pre-validated contact without identification transfer');
INSERT INTO enum_public_request_type (id, name, description) VALUES (21,'mojeid_prevalidated_contact_transfer','MojeID pre-validated contact transfer');

INSERT INTO enum_public_request_type (id, name, description) VALUES (15, 'contact_conditional_identification', 'Conditional identification');
INSERT INTO enum_public_request_type (id, name, description) VALUES (16, 'contact_identification', 'Full identification');
