---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.26.0' WHERE id = 1;

---
--- epp domain rewrite
---
INSERT INTO enum_reason VALUES
    (
        64,
        'Administrative contact not assigned to this object',
        'Administrátorský kontakt není přiřazen k tomuto objektu'
    );
INSERT INTO enum_reason VALUES
    (
        65,
        'Temporary contacts are obsolete',
        'Dočasné kontakty již nejsou podporovány'
    );
SELECT setval('enum_reason_id_seq', 65);

---
--- Ticket #15099 - ENUM validation magic number
---
--- opportunity window in days before current ENUM domain validation expiration
--- for new ENUM domain validation to be appended after current ENUM domain validation
---
INSERT INTO enum_parameters (id, name, val) VALUES
    (19, 'enum_validation_continuation_window', '14');

---
--- Ticket #15031 - price_list changes
---
ALTER TABLE price_list ALTER COLUMN quantity SET NOT NULL;
ALTER TABLE price_list ALTER COLUMN enable_postpaid_operation SET NOT NULL;

CREATE OR REPLACE FUNCTION check_price_list()
    RETURNS trigger AS
$BODY$
BEGIN
    IF NEW.valid_from > COALESCE(NEW.valid_to, 'infinity'::timestamp) THEN
        RAISE EXCEPTION 'invalid price_list item: valid_from > valid_to';
    END IF;
    IF EXISTS (
        SELECT 1 FROM price_list
          WHERE id <> NEW.id
          AND zone_id = NEW.zone_id
          AND operation_id=NEW.operation_id
          AND (valid_from , COALESCE(valid_to, 'infinity'::timestamp))
            OVERLAPS (NEW.valid_from , COALESCE(NEW.valid_to, 'infinity'::timestamp))
    ) THEN
        RAISE EXCEPTION 'price_list item overlaps';
    END IF;
    RETURN NEW;
END;
$BODY$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_price_list
  AFTER INSERT OR UPDATE ON price_list
  FOR EACH ROW EXECUTE PROCEDURE check_price_list();


---
--- Ticket #16019 - Add dnskey.alg constraint
---
CREATE TABLE dnssec_algorithm (
    id INTEGER CONSTRAINT dnssec_algorithm_pkey PRIMARY KEY,
    handle VARCHAR(64) NOT NULL CONSTRAINT dnssec_algorithm_handle_idx UNIQUE,
    description TEXT
);

COMMENT ON TABLE dnssec_algorithm
    IS 'list of DNSSEC algorithms; see http://www.iana.org/assignments/dns-sec-alg-numbers/dns-sec-alg-numbers.xhtml';
COMMENT ON COLUMN dnssec_algorithm.id
    IS 'algorithm number';
COMMENT ON COLUMN dnssec_algorithm.handle
    IS 'mnemonic';

INSERT INTO dnssec_algorithm (id, handle, description)
VALUES (  1,'RSAMD5',            'RSA/MD5 (deprecated, see 5)'),
       (  2,'DH',                'Diffie-Hellman'),
       (  3,'DSA',               'DSA/SHA1'),
       (  5,'RSASHA1',           'RSA/SHA-1'),
       (  6,'DSA-NSEC3-SHA1',    'DSA-NSEC3-SHA1'),
       (  7,'RSASHA1-NSEC3-SHA1','RSASHA1-NSEC3-SHA1'),
       (  8,'RSASHA256',         'RSA/SHA-256'),
       ( 10,'RSASHA512',         'RSA/SHA-512'),
       ( 12,'ECC-GOST',          'GOST R 34.10-2001'),
       ( 13,'ECDSAP256SHA256',   'ECDSA Curve P-256 with SHA-256'),
       ( 14,'ECDSAP384SHA384',   'ECDSA Curve P-384 with SHA-384'),
       (252,'INDIRECT',          'Reserved for Indirect Keys'),
       (253,'PRIVATEDNS',        'private algorithm'),
       (254,'PRIVATEOID',        'private algorithm OID');

CREATE TABLE dnssec_algorithm_blacklist (
    alg_number INTEGER CONSTRAINT dnssec_algorithm_usability_pkey PRIMARY KEY REFERENCES dnssec_algorithm(id)
);

COMMENT ON TABLE dnssec_algorithm_blacklist
    IS 'list of deprecated DNSSEC algorithms';

INSERT INTO dnssec_algorithm_blacklist (alg_number) VALUES (1),(2),(252);

ALTER TABLE dnskey
    ADD CONSTRAINT dnskey_alg_fkey FOREIGN KEY (alg) REFERENCES dnssec_algorithm(id) ON UPDATE CASCADE;

CREATE OR REPLACE FUNCTION dnskey_alg_change_check()
RETURNS "trigger" AS $$
BEGIN
    IF TG_OP='INSERT' THEN
        IF EXISTS(SELECT 1 FROM dnssec_algorithm_blacklist WHERE alg_number=NEW.alg) THEN
            RAISE EXCEPTION 'Blacklisted alg';
        END IF;
    ELSIF (TG_OP='UPDATE') AND (OLD.alg<>NEW.alg) THEN
        IF EXISTS(SELECT 1 FROM dnssec_algorithm_blacklist WHERE alg_number=NEW.alg) THEN
            RAISE EXCEPTION 'Blacklisted alg';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION dnskey_alg_change_check()
    IS 'check dnskey.alg is blacklisted';

CREATE TRIGGER "trigger_dnskey"
    AFTER INSERT OR UPDATE ON dnskey
    FOR EACH ROW EXECUTE PROCEDURE dnskey_alg_change_check();

UPDATE enum_reason VALUES
   SET reason = 'Unsupported value of field "alg", see http://www.iana.org/assignments/dns-sec-alg-numbers',
       reason_cs = 'Nepodporovaná hodnota pole "alg", viz http://www.iana.org/assignments/dns-sec-alg-numbers'
 WHERE id = 56;


---
--- Ticket #17824
---
INSERT INTO enum_domain_name_validation_checker (id, name, description)
    VALUES (8, 'dncheck_no_idn_punycode', 'forbid idn punycode encoding');
