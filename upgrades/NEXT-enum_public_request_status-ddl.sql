---
--- Ticket #6164
---

CREATE TABLE enum_public_request_status
(
  id INTEGER PRIMARY KEY NOT NULL,
  name VARCHAR(32) UNIQUE NOT NULL,
  description VARCHAR(128)
);

-- data and constraint in NEXT-enum_public_request_status-dml.sql