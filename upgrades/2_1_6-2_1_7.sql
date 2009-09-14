---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.1.7' WHERE id = 1;

--Ticket #2099
ALTER TABLE registrarinvoice ADD COLUMN toDate date;
