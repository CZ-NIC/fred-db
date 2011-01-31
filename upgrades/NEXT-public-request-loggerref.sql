---
--- Ticket #4574
---
ALTER TABLE public_request RENAME COLUMN logd_request_id TO create_request_id;
ALTER TABLE public_request ALTER COLUMN create_request_id TYPE bigint;
ALTER TABLE public_request ADD COLUMN resolve_request_id bigint;

