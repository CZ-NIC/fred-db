---
--- Ticket #4578
---
CREATE TABLE public_request_auth (
      id integer NOT NULL REFERENCES public_request(id),
      identification varchar(32) NOT NULL UNIQUE,
      password varchar(255) NOT NULL
);

