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
    handle VARCHAR(64) CONSTRAINT dnssec_algorithm_handle_idx UNIQUE,
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
       ( 15,'ED25519',           'Edwards-curve Digital Security Algorithm (EdDSA), curve Ed25519'),
       ( 16,'ED448',             'Edwards-curve Digital Security Algorithm (EdDSA), curve Ed448'),
       (252,'INDIRECT',          'Reserved for Indirect Keys'),
       (253,'PRIVATEDNS',        'private algorithm'),
       (254,'PRIVATEOID',        'private algorithm OID'),
       (  0,NULL,'Delete DS'),
       (  4,NULL,'Reserved'),
       (  9,NULL,'Reserved'),
       ( 11,NULL,'Reserved'),
       ( 17,NULL,'Unassigned'),( 18,NULL,'Unassigned'),( 19,NULL,'Unassigned'),
       ( 20,NULL,'Unassigned'),( 21,NULL,'Unassigned'),( 22,NULL,'Unassigned'),( 23,NULL,'Unassigned'),( 24,NULL,'Unassigned'),
       ( 25,NULL,'Unassigned'),( 26,NULL,'Unassigned'),( 27,NULL,'Unassigned'),( 28,NULL,'Unassigned'),( 29,NULL,'Unassigned'),
       ( 30,NULL,'Unassigned'),( 31,NULL,'Unassigned'),( 32,NULL,'Unassigned'),( 33,NULL,'Unassigned'),( 34,NULL,'Unassigned'),
       ( 35,NULL,'Unassigned'),( 36,NULL,'Unassigned'),( 37,NULL,'Unassigned'),( 38,NULL,'Unassigned'),( 39,NULL,'Unassigned'),
       ( 40,NULL,'Unassigned'),( 41,NULL,'Unassigned'),( 42,NULL,'Unassigned'),( 43,NULL,'Unassigned'),( 44,NULL,'Unassigned'),
       ( 45,NULL,'Unassigned'),( 46,NULL,'Unassigned'),( 47,NULL,'Unassigned'),( 48,NULL,'Unassigned'),( 49,NULL,'Unassigned'),
       ( 50,NULL,'Unassigned'),( 51,NULL,'Unassigned'),( 52,NULL,'Unassigned'),( 53,NULL,'Unassigned'),( 54,NULL,'Unassigned'),
       ( 55,NULL,'Unassigned'),( 56,NULL,'Unassigned'),( 57,NULL,'Unassigned'),( 58,NULL,'Unassigned'),( 59,NULL,'Unassigned'),
       ( 60,NULL,'Unassigned'),( 61,NULL,'Unassigned'),( 62,NULL,'Unassigned'),( 63,NULL,'Unassigned'),( 64,NULL,'Unassigned'),
       ( 65,NULL,'Unassigned'),( 66,NULL,'Unassigned'),( 67,NULL,'Unassigned'),( 68,NULL,'Unassigned'),( 69,NULL,'Unassigned'),
       ( 70,NULL,'Unassigned'),( 71,NULL,'Unassigned'),( 72,NULL,'Unassigned'),( 73,NULL,'Unassigned'),( 74,NULL,'Unassigned'),
       ( 75,NULL,'Unassigned'),( 76,NULL,'Unassigned'),( 77,NULL,'Unassigned'),( 78,NULL,'Unassigned'),( 79,NULL,'Unassigned'),
       ( 80,NULL,'Unassigned'),( 81,NULL,'Unassigned'),( 82,NULL,'Unassigned'),( 83,NULL,'Unassigned'),( 84,NULL,'Unassigned'),
       ( 85,NULL,'Unassigned'),( 86,NULL,'Unassigned'),( 87,NULL,'Unassigned'),( 88,NULL,'Unassigned'),( 89,NULL,'Unassigned'),
       ( 90,NULL,'Unassigned'),( 91,NULL,'Unassigned'),( 92,NULL,'Unassigned'),( 93,NULL,'Unassigned'),( 94,NULL,'Unassigned'),
       ( 95,NULL,'Unassigned'),( 96,NULL,'Unassigned'),( 97,NULL,'Unassigned'),( 98,NULL,'Unassigned'),( 99,NULL,'Unassigned'),
       (100,NULL,'Unassigned'),(101,NULL,'Unassigned'),(102,NULL,'Unassigned'),(103,NULL,'Unassigned'),(104,NULL,'Unassigned'),
       (105,NULL,'Unassigned'),(106,NULL,'Unassigned'),(107,NULL,'Unassigned'),(108,NULL,'Unassigned'),(109,NULL,'Unassigned'),
       (110,NULL,'Unassigned'),(111,NULL,'Unassigned'),(112,NULL,'Unassigned'),(113,NULL,'Unassigned'),(114,NULL,'Unassigned'),
       (115,NULL,'Unassigned'),(116,NULL,'Unassigned'),(117,NULL,'Unassigned'),(118,NULL,'Unassigned'),(119,NULL,'Unassigned'),
       (120,NULL,'Unassigned'),(121,NULL,'Unassigned'),(122,NULL,'Unassigned'),
       (123,NULL,'Reserved'),(124,NULL,'Reserved'),
       (125,NULL,'Reserved'),(126,NULL,'Reserved'),(127,NULL,'Reserved'),(128,NULL,'Reserved'),(129,NULL,'Reserved'),
       (130,NULL,'Reserved'),(131,NULL,'Reserved'),(132,NULL,'Reserved'),(133,NULL,'Reserved'),(134,NULL,'Reserved'),
       (135,NULL,'Reserved'),(136,NULL,'Reserved'),(137,NULL,'Reserved'),(138,NULL,'Reserved'),(139,NULL,'Reserved'),
       (140,NULL,'Reserved'),(141,NULL,'Reserved'),(142,NULL,'Reserved'),(143,NULL,'Reserved'),(144,NULL,'Reserved'),
       (145,NULL,'Reserved'),(146,NULL,'Reserved'),(147,NULL,'Reserved'),(148,NULL,'Reserved'),(149,NULL,'Reserved'),
       (150,NULL,'Reserved'),(151,NULL,'Reserved'),(152,NULL,'Reserved'),(153,NULL,'Reserved'),(154,NULL,'Reserved'),
       (155,NULL,'Reserved'),(156,NULL,'Reserved'),(157,NULL,'Reserved'),(158,NULL,'Reserved'),(159,NULL,'Reserved'),
       (160,NULL,'Reserved'),(161,NULL,'Reserved'),(162,NULL,'Reserved'),(163,NULL,'Reserved'),(164,NULL,'Reserved'),
       (165,NULL,'Reserved'),(166,NULL,'Reserved'),(167,NULL,'Reserved'),(168,NULL,'Reserved'),(169,NULL,'Reserved'),
       (170,NULL,'Reserved'),(171,NULL,'Reserved'),(172,NULL,'Reserved'),(173,NULL,'Reserved'),(174,NULL,'Reserved'),
       (175,NULL,'Reserved'),(176,NULL,'Reserved'),(177,NULL,'Reserved'),(178,NULL,'Reserved'),(179,NULL,'Reserved'),
       (180,NULL,'Reserved'),(181,NULL,'Reserved'),(182,NULL,'Reserved'),(183,NULL,'Reserved'),(184,NULL,'Reserved'),
       (185,NULL,'Reserved'),(186,NULL,'Reserved'),(187,NULL,'Reserved'),(188,NULL,'Reserved'),(189,NULL,'Reserved'),
       (190,NULL,'Reserved'),(191,NULL,'Reserved'),(192,NULL,'Reserved'),(193,NULL,'Reserved'),(194,NULL,'Reserved'),
       (195,NULL,'Reserved'),(196,NULL,'Reserved'),(197,NULL,'Reserved'),(198,NULL,'Reserved'),(199,NULL,'Reserved'),
       (200,NULL,'Reserved'),(201,NULL,'Reserved'),(202,NULL,'Reserved'),(203,NULL,'Reserved'),(204,NULL,'Reserved'),
       (205,NULL,'Reserved'),(206,NULL,'Reserved'),(207,NULL,'Reserved'),(208,NULL,'Reserved'),(209,NULL,'Reserved'),
       (210,NULL,'Reserved'),(211,NULL,'Reserved'),(212,NULL,'Reserved'),(213,NULL,'Reserved'),(214,NULL,'Reserved'),
       (215,NULL,'Reserved'),(216,NULL,'Reserved'),(217,NULL,'Reserved'),(218,NULL,'Reserved'),(219,NULL,'Reserved'),
       (220,NULL,'Reserved'),(221,NULL,'Reserved'),(222,NULL,'Reserved'),(223,NULL,'Reserved'),(224,NULL,'Reserved'),
       (225,NULL,'Reserved'),(226,NULL,'Reserved'),(227,NULL,'Reserved'),(228,NULL,'Reserved'),(229,NULL,'Reserved'),
       (230,NULL,'Reserved'),(231,NULL,'Reserved'),(232,NULL,'Reserved'),(233,NULL,'Reserved'),(234,NULL,'Reserved'),
       (235,NULL,'Reserved'),(236,NULL,'Reserved'),(237,NULL,'Reserved'),(238,NULL,'Reserved'),(239,NULL,'Reserved'),
       (240,NULL,'Reserved'),(241,NULL,'Reserved'),(242,NULL,'Reserved'),(243,NULL,'Reserved'),(244,NULL,'Reserved'),
       (245,NULL,'Reserved'),(246,NULL,'Reserved'),(247,NULL,'Reserved'),(248,NULL,'Reserved'),(249,NULL,'Reserved'),
       (250,NULL,'Reserved'),(251,NULL,'Reserved'),
       (255,NULL,'Reserved');


CREATE TABLE dnssec_algorithm_blacklist (
    alg_number INTEGER CONSTRAINT dnssec_algorithm_usability_pkey PRIMARY KEY REFERENCES dnssec_algorithm(id)
);

COMMENT ON TABLE dnssec_algorithm_blacklist
    IS 'list of deprecated DNSSEC algorithms';

INSERT INTO dnssec_algorithm_blacklist (alg_number) VALUES (0),(1),(2),(252);

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

DELETE FROM zone_domain_name_validation_checker_map
    WHERE checker_id IN (
        SELECT id FROM enum_domain_name_validation_checker
            WHERE name IN (
                'dncheck_letters_digits_hyphen_chars_only',
                'dncheck_no_label_beginning_hyphen',
                'dncheck_no_label_ending_hyphen'
            )
    );

DELETE FROM enum_domain_name_validation_checker
    WHERE name IN (
        'dncheck_letters_digits_hyphen_chars_only',
        'dncheck_no_label_beginning_hyphen',
        'dncheck_no_label_ending_hyphen'
    );

SELECT setval(
    'enum_domain_name_validation_checker_id_seq',
    (SELECT MAX(id) FROM enum_domain_name_validation_checker)
);
SELECT setval(
    'zone_domain_name_validation_checker_map_id_seq',
    (SELECT MAX(id) FROM zone_domain_name_validation_checker_map)
);
