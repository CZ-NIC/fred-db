---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.38.0' WHERE id = 1;


INSERT INTO enum_operation (id, operation) VALUES (6, 'MonthlyFee'); -- registry contractual fee per month
