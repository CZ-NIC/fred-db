---
--- Issue #2 - add object_authinfo table
---
CREATE TABLE object_authinfo
(
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    object_id INTEGER NOT NULL CONSTRAINT object_authinfo_object_id_fkey REFERENCES object_registry(id),
    registrar_id INTEGER NOT NULL CONSTRAINT object_authinfo_registrar_id_fkey REFERENCES registrar(id),
    password VARCHAR NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL CONSTRAINT object_authinfo_expires_at_check CHECK (created_at < expires_at),
    canceled_at TIMESTAMP NULL DEFAULT NULL CONSTRAINT object_authinfo_canceled_at_check
                CHECK (canceled_at IS NULL OR (created_at <= canceled_at AND COALESCE(password, '') = '')),
    use_count INTEGER NOT NULL DEFAULT 0
);

CREATE UNIQUE INDEX object_authinfo_object_id_registrar_id_idx
    ON object_authinfo (object_id, registrar_id)
 WHERE password <> '';

CREATE INDEX object_authinfo_expires_at_idx
    ON object_authinfo (expires_at)
 WHERE password <> '' AND
       canceled_at IS NULL;