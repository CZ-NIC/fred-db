---
--- add data migration request to admin service
---
INSERT INTO request_type (service_id, id, name) VALUES
    ((SELECT id FROM service WHERE name = 'Admin'), 4, 'DataMigration');

