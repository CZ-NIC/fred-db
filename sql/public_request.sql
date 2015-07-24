-- Public requests

CREATE TABLE public_request (
  id serial NOT NULL CONSTRAINT public_request_pkey PRIMARY KEY,
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
  answer_email_id integer CONSTRAINT public_request_answer_email_id_fkey REFERENCES mail_archive(id),
  registrar_id integer CONSTRAINT public_request_registrar_id_fkey REFERENCES registrar(id),
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
  request_id integer CONSTRAINT public_request_objects_map_request_id_fkey REFERENCES public_request(id)
  CONSTRAINT public_request_objects_map_pkey PRIMARY KEY,
  object_id integer CONSTRAINT public_request_objects_map_object_id_fkey REFERENCES object_registry(id)
);

CREATE INDEX public_request_objects_map_object_id_index ON public_request_objects_map (object_id);

comment on table public_request_objects_map is 'table with objects associated with given request';

CREATE TABLE public_request_auth (
      id integer CONSTRAINT public_request_auth_pkey PRIMARY KEY NOT NULL
      CONSTRAINT public_request_auth_id_fkey REFERENCES public_request(id),
      identification varchar(32) NOT NULL CONSTRAINT public_request_auth_identification_key UNIQUE,
      password varchar(64) NOT NULL
);

CREATE TABLE public_request_messages_map
(
  id serial CONSTRAINT public_request_messages_map_pkey PRIMARY KEY NOT NULL,
  public_request_id INTEGER CONSTRAINT public_request_messages_map_public_request_id_fkey REFERENCES public_request (id),
  message_archive_id INTEGER, -- REFERENCES message_archive (id),
  mail_archive_id INTEGER, -- REFERENCES mail_archive (id),
  CONSTRAINT public_request_messages_map_public_request_id_message_archi_key UNIQUE (public_request_id, message_archive_id),
  CONSTRAINT public_request_messages_map_public_request_id_mail_archive__key UNIQUE (public_request_id, mail_archive_id)
);

CREATE TABLE enum_public_request_type
(
  id INTEGER CONSTRAINT enum_public_request_type_pkey PRIMARY KEY NOT NULL,
  name VARCHAR(64) CONSTRAINT enum_public_request_type_name_key UNIQUE NOT NULL,
  description VARCHAR(256)
);

CREATE TABLE enum_public_request_status
(
  id INTEGER CONSTRAINT enum_public_request_status_pkey PRIMARY KEY NOT NULL,
  name VARCHAR(32) CONSTRAINT enum_public_request_status_name_key UNIQUE NOT NULL,
  description VARCHAR(128)
);

-- #7122 lock public_request insert or update by its type and object to the end of db transaction
-- #8135 lock public_request insert or update by object to the end of db transaction

CREATE TABLE public_request_lock
(
    object_id integer PRIMARY KEY --REFERENCES object_registry (id) --temporarily commented out because of a lack of time to test implicit locking of object_registry row
);

CREATE OR REPLACE FUNCTION lock_public_request_lock(f_object_id BIGINT)
RETURNS void AS $$
DECLARE
BEGIN
    INSERT INTO public_request_lock (object_id) VALUES (f_object_id);
    DELETE FROM public_request_lock WHERE object_id = f_object_id;
END;
$$ LANGUAGE plpgsql;

-- lock public request
CREATE OR REPLACE FUNCTION lock_public_request() 
RETURNS "trigger" AS $$
DECLARE
  nobject RECORD;
BEGIN
  RAISE NOTICE 'lock_public_request start NEW.id: % NEW.request_type: %'
  , NEW.id, NEW.request_type;

  FOR nobject IN SELECT prom.object_id
    FROM public_request_objects_map prom
    JOIN object_registry obr ON obr.id = prom.object_id
    WHERE prom.request_id = NEW.id
  LOOP
    RAISE NOTICE 'lock_public_request nobject.object_id: %'
    , nobject.object_id;
    PERFORM lock_public_request_lock(nobject.object_id);
  END LOOP;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION lock_public_request()
IS 'lock changes of public requests by object';

CREATE TRIGGER "trigger_lock_public_request"
  AFTER UPDATE ON public_request
  FOR EACH ROW EXECUTE PROCEDURE lock_public_request();

