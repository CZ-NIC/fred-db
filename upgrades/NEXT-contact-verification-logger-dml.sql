---
--- Ticket #6814
---
INSERT INTO request_type (id, name, service_id) VALUES
    (1605, 'Verification', 2),
    (1606, 'ConditionalIdentification', 2),
    (1607, 'Identification', 2);

INSERT INTO result_code (service_id, result_code, name) VALUES
    (2, 2, 'Fail');

