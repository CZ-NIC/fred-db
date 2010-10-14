---
--- #4365
---
---

ALTER TABLE public_request ADD COLUMN logd_request_id INTEGER;

---
--- Ticket #4578
---
CREATE TABLE public_request_auth (
      id integer PRIMARY KEY NOT NULL REFERENCES public_request(id),
      identification varchar(32) NOT NULL UNIQUE,
      password varchar(64) NOT NULL
);

---
--- Ticket #4639
---
CREATE TABLE public_request_messages_map
(
  id serial PRIMARY KEY NOT NULL,
  public_request_id INTEGER REFERENCES public_request (id),
  message_archive_id INTEGER, -- REFERENCES message_archive (id), 
  mail_archive_id INTEGER, -- REFERENCES mail_archive (id),
  UNIQUE (public_request_id, message_archive_id),
  UNIQUE (public_request_id, mail_archive_id)
);
