---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.32.0' WHERE id = 1;

WITH to_preserve AS (
    SELECT registrarid,cert,MAX(id) AS id
    FROM registraracl
    GROUP BY 1,2
    HAVING 1<COUNT(*)),
     to_delete AS (
    SELECT r.id
    FROM to_preserve p
    JOIN registraracl r ON r.registrarid=p.registrarid AND
                           r.cert=p.cert AND
                           r.id<p.id)
DELETE FROM registraracl
WHERE id IN (SELECT id FROM to_delete);

ALTER TABLE registraracl
    ALTER COLUMN password SET DATA TYPE VARCHAR(1024),
    ADD CONSTRAINT registraracl_registrarid_cert_fkey UNIQUE (registrarid,cert);

COMMENT ON COLUMN registraracl.cert IS 'fingerprint of registrar''s certificate';
COMMENT ON COLUMN registraracl.password IS 'data generated by password hashing function';

UPDATE registraracl SET password = '$plaintext$' || password;
