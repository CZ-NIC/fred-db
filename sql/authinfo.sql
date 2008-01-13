-- Auth info requests

CREATE TABLE auth_info_requests (
    id serial NOT NULL PRIMARY KEY,
    object_id integer NOT NULL REFERENCES object_history(historyid),
    request_type smallint NOT NULL,
    epp_action_id integer REFERENCES action(id),
    create_time timestamp without time zone DEFAULT now() NOT NULL,
    status smallint DEFAULT 1 NOT NULL,
    resolve_time timestamp without time zone,
    reason character varying(512),
    email_to_answer character varying(255),
    answer_email_id integer REFERENCES mail_archive(id)
);
