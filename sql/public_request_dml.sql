---
--- public request basic dml script
---

INSERT INTO enum_public_request_status (id, name, description) VALUES (0, 'opened', 'Opened');
INSERT INTO enum_public_request_status (id, name, description) VALUES (1, 'resolved', 'Resolved');
INSERT INTO enum_public_request_status (id, name, description) VALUES (2, 'invalidated', 'Invalidated');


