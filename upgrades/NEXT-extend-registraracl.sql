ALTER TABLE registraracl
    ADD COLUMN uuid UUID NOT NULL UNIQUE DEFAULT gen_random_uuid(),
    ADD create_time TIMESTAMP,
    ADD cert_data_pem VARCHAR(16384),
    ALTER create_time SET DEFAULT CURRENT_TIMESTAMP;

CREATE UNIQUE INDEX registraracl_registrarid_hexcert_fkey
       ON registraracl (registrarid, DECODE(REGEXP_REPLACE(cert, ':', '', 'g'), 'hex'));

COMMENT ON COLUMN registraracl.cert IS 'MD5 fingerprint of registrar''s certificate in HEX format ''FA:09:...:73''';
COMMENT ON COLUMN registraracl.uuid IS 'uuid for external reference';
COMMENT ON COLUMN registraracl.create_time IS 'when the record was created';
COMMENT ON COLUMN registraracl.cert_data_pem IS 'certificate data in PEM format';
