---
--- #19108 - logger requests - record statement request
---
INSERT INTO request_type (id, name, service_id)
    VALUES (1353, 'RecordStatement', 4);  -- Webadmin


---
--- Ticket #17765 - Create expired domain
---
INSERT INTO request_type (id, name, service_id)
    VALUES
        (13, 'CreateExpiredDomain', 8);
