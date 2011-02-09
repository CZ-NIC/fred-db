---
--- Ticket #4574
---

CREATE TABLE notify_request
(
    request_id BIGINT NOT NULL,
    message_id INTEGER REFERENCES mail_archive(id)
);

