---
--- table for poll messages used for request charging feature
---
CREATE TABLE poll_request_fee (
      msgid integer NOT NULL REFERENCES message(id),
      period_from timestamp without time zone NOT NULL,
      period_to timestamp without time zone NOT NULL,
      total_free_count bigint NOT NULL,
      used_count bigint NOT NULL,
      price numeric(10, 2) NOT NULL
);

