-- Public requests

CREATE TABLE public_request (
  id serial NOT NULL PRIMARY KEY,
  request_type smallint NOT NULL, -- vsechny typy zadosti
-- further description in src/register/public_request.h, enum Type
  create_time timestamp without time zone DEFAULT now() NOT NULL,
  status smallint NOT NULL,
-- Request status, values: PRS_NEW,       ///< Request was created and waiting for autorization 
--                         PRS_ANSWERED,  ///< Email with answer was sent
--                         PRS_INVALID    ///< Time passed without authorization   
  resolve_time timestamp without time zone,
  reason character varying(512),
  email_to_answer character varying(255),
  answer_email_id integer REFERENCES mail_archive(id),
  registrar_id integer REFERENCES registrar(id),
  create_request_id bigint,
  resolve_request_id bigint
);

comment on table public_request is 'table of general requests give in by public users';
comment on column public_request.request_type is 'code of request';
comment on column public_request.create_time is 'request creation time';
comment on column public_request.status is 'code of request actual status';
comment on column public_request.resolve_time is 'time when request was processed (closed)';
comment on column public_request.reason is 'reason';
comment on column public_request.email_to_answer is 'manual entered email by user for sending answer (if it is automatic from object contact it is NULL)';
comment on column public_request.answer_email_id is 'reference to mail which was send after request was processed';
comment on column public_request.registrar_id is 'reference to registrar when request is submitted via EPP protocol (otherwise NULL)';

CREATE TABLE public_request_objects_map (
  request_id integer REFERENCES public_request(id) PRIMARY KEY,
  object_id integer REFERENCES object_registry(id)
);

comment on table public_request_objects_map is 'table with objects associated with given request';

CREATE TABLE public_request_state_request_map (
  state_request_id integer PRIMARY KEY REFERENCES object_state_request(id),
  block_request_id integer NOT NULL REFERENCES public_request(id),
  unblock_request_id integer REFERENCES public_request(id)
);

comment on table public_request_state_request_map is 'table with state request associated with given request';


CREATE TABLE public_request_auth (
      id integer PRIMARY KEY NOT NULL REFERENCES public_request(id),
      identification varchar(32) NOT NULL UNIQUE,
      password varchar(64) NOT NULL
);

CREATE TABLE public_request_messages_map
(
  id serial PRIMARY KEY NOT NULL,
  public_request_id INTEGER REFERENCES public_request (id),
  message_archive_id INTEGER, -- REFERENCES message_archive (id), 
  mail_archive_id INTEGER, -- REFERENCES mail_archive (id),
  UNIQUE (public_request_id, message_archive_id),
  UNIQUE (public_request_id, mail_archive_id)
);


CREATE TABLE enum_public_request_type
(
  id INTEGER PRIMARY KEY NOT NULL,
  name VARCHAR(64) UNIQUE NOT NULL,
  description VARCHAR(256)
);



CREATE TABLE enum_public_request_status
(
  id INTEGER PRIMARY KEY NOT NULL,
  name VARCHAR(32) UNIQUE NOT NULL,
  description VARCHAR(128)
);


