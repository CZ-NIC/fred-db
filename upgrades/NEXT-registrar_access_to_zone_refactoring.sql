---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '<insert version here>' WHERE id = 1;

---
--- Ticket #2099
---
ALTER TABLE registrarinvoice ADD COLUMN toDate date;

