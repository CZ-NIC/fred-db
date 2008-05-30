-- Public requests

CREATE TABLE public_request (
  id serial NOT NULL PRIMARY KEY,
  request_type smallint NOT NULL, -- vsechny typy zadosti
  epp_action_id integer REFERENCES action(id),
  create_time timestamp without time zone DEFAULT now() NOT NULL,
  status smallint DEFAULT 1 NOT NULL,
  resolve_time timestamp without time zone,
  reason character varying(512),
  email_to_answer character varying(255),
  answer_email_id integer REFERENCES mail_archive(id)
);

comment on table public_request is 'table of general requests give in by public users';
comment on column public_request.request_type is 'code of request';
comment on column public_request.epp_action_id is 'reference on action when request is submitted by registrar via EPP protocol (otherwise NULL)';
comment on column public_request.create_time is 'request creation time';
comment on column public_request.status is 'code of request actual status';
comment on column public_request.resolve_time is 'time when request was processed (closed)';
comment on column public_request.reason is 'reason';
comment on column public_request.email_to_answer is 'manual entered email by user for sending answer (if it is automatic from object contact it is NULL)';
comment on column public_request.answer_email_id is 'reference to mail which was send after request was processed';


CREATE TABLE public_request_objects_map (
  request_id integer REFERENCES public_request(id),
  object_id integer REFERENCES object_registry(id)
);

comment on table public_request_objects_map is 'table with objects associated with given request';

CREATE TABLE public_request_state_request_map (
  state_request_id integer PRIMARY KEY REFERENCES object_state_request(id),
  block_request_id integer NOT NULL REFERENCES public_request(id),
  unblock_request_id integer REFERENCES public_request(id)
);

comment on table public_request_state_request_map is 'table with state request associated with given request';
