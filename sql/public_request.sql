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

-- #7122 lock public_request insert or update by its type and object to the end of db transaction

CREATE TABLE public_request_lock
(
    id bigserial PRIMARY KEY -- lock id
    , request_type smallint NOT NULL REFERENCES enum_public_request_type(id)
    , object_id integer NOT NULL REFERENCES object_registry (id)
);

CREATE OR REPLACE FUNCTION lock_public_request_lock( f_request_type_id BIGINT, f_object_id BIGINT)
RETURNS void AS $$
DECLARE
BEGIN
    PERFORM * FROM public_request_lock
    WHERE request_type = f_request_type_id
    AND object_id = f_object_id ORDER BY id FOR UPDATE; --wait if locked
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Failed to lock';
    END IF;
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
    PERFORM lock_public_request_lock( NEW.request_type, nobject.object_id);
  END LOOP;

  --try cleanup
  BEGIN
    PERFORM * FROM public_request_lock
      WHERE id < (NEW.id - 100) FOR UPDATE NOWAIT;
    IF FOUND THEN
      DELETE FROM public_request_lock
        WHERE id < (NEW.id - 100);
    END IF;
  EXCEPTION WHEN lock_not_available THEN
    RAISE NOTICE 'cleanup lock not available';
  END;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION lock_public_request()
IS 'lock changes of public requests by object and request type';

CREATE TRIGGER "trigger_lock_public_request"
  AFTER INSERT OR UPDATE ON public_request
  FOR EACH ROW EXECUTE PROCEDURE lock_public_request();

