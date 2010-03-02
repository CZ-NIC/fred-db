---
--- UPGRADE SCRIPT 2.2.0 -> 2.3.0 (data definition part)
---

---
--- Ticket #2099 Registrar refactoring
---

ALTER TABLE registrarinvoice ADD COLUMN toDate date;

---
--- Ticket #1670 Banking refactoring
---

\i ../sql/bank_ddl_new.sql

ALTER TABLE registrar ADD regex varchar(30) DEFAULT NULL;
ALTER TABLE invoice ALTER COLUMN zone DROP NOT NULL;
ALTER TABLE bank_account ALTER COLUMN balance SET DEFAULT 0.0;

