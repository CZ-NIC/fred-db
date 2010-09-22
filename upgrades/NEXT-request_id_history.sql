---
--- Ticket #4508 - logger request_id for history records
---

ALTER TABLE history ADD COLUMN request_id integer;
