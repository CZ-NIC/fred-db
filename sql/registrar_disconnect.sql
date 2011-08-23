
CREATE TABLE registrar_disconnect (
    id SERIAL PRIMARY KEY,
    registrarid INTEGER NOT NULL REFERENCES registrar(id),
    blocked_from TIMESTAMP NOT NULL DEFAULT now(),
    blocked_to TIMESTAMP,
    unblock_request_id BIGINT
);

