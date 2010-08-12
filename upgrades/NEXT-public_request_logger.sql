---
--- don't forget to update database schema version
---
---

UPDATE enum_parameters SET val = '<insert version here>' WHERE id = 1;


---
--- #4365
---
---

ALTER TABLE public_request ADD COLUMN logd_request_id INTEGER;


