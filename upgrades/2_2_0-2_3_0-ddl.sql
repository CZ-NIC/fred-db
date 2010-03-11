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

---
--- Drop references to action table
---
ALTER TABLE history DROP CONSTRAINT history_action_fkey;
ALTER TABLE public_request DROP CONSTRAINT public_request_epp_action_id_fkey;
ALTER TABLE auth_info_requests DROP CONSTRAINT auth_info_requests_epp_action_id_fkey;
