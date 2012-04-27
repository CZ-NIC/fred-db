---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.10' WHERE id = 1;

---
--- Ticket #6655
---

CREATE SEQUENCE epp_login_id_seq;


