
---
--- don't forget to update database schema version
---

UPDATE enum_parameters SET val = '<insert version here>' WHERE id = 1;



-- Tickets #4722, #4750
ALTER TABLE session ALTER COLUMN login_date DROP DEFAULT;

ALTER TABLE public_request ALTER COLUMN status SET DEFAULT 1;

