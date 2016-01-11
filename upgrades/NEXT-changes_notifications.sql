CREATE TYPE notificated_event AS ENUM (
    'created', 'updated', 'transferred', 'deleted', 'renewed'
);

CREATE TABLE notification_queue (
    change                  notificated_event NOT NULL,
    done_by_registrar       integer NOT NULL references registrar(id),
    historyid_post_change   integer NOT NULL references history(id),
    svtrid                  text NOT NULL
);
