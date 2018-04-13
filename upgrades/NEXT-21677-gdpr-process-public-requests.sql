---
--- 21677 gdpr process public requests
---

CREATE TYPE enum_on_status_action_type AS ENUM ('scheduled', 'processed', 'failed');

ALTER TABLE public_request ADD COLUMN on_status_action enum_on_status_action_type NOT NULL DEFAULT 'scheduled'::enum_on_status_action_type;

comment on column public_request.on_status_action is 'state of action performed during asynchronous processing of the public request';

