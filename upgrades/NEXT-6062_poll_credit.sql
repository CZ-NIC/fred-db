---
--- Ticket #6062
---

ALTER TABLE poll_credit ALTER COLUMN credit TYPE numeric(10,2);
ALTER TABLE poll_credit ALTER COLUMN credlimit TYPE numeric(10,2);

ALTER TABLE poll_credit_zone_limit ALTER COLUMN credlimit TYPE numeric(10,2);




