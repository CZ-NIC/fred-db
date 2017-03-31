-- classifier of error messages  reason
CREATE TABLE enum_reason (
        id SERIAL CONSTRAINT enum_reason_pkey PRIMARY KEY,
        reason varchar(128) CONSTRAINT enum_reason_reason_key UNIQUE NOT NULL,
        reason_cs varchar(128) CONSTRAINT enum_reason_reason_cs_key UNIQUE  NOT NULL -- czech translation
        );


INSERT INTO enum_reason VALUES (1, 'An invalid format of the contact handle', 'Neplatný formát identifikátoru kontaktu');
INSERT INTO enum_reason VALUES (2, 'An invalid format of the nsset handle', 'Neplatný formát identifikátoru sady jmenných serverů');
INSERT INTO enum_reason VALUES (3, 'An invalid format of the domain name', 'Neplatný formát jména domény');

INSERT INTO enum_reason VALUES (4, 'The domain name not applicable', 'Nepříslušný název domény');

-- check related errors
INSERT INTO enum_reason VALUES (5, 'An invalid format', 'Neplatný formát');
INSERT INTO enum_reason VALUES (6, 'Registered already', 'Již zaregistrováno');
INSERT INTO enum_reason VALUES (7, 'Within the protection period', 'V ochranné lhůtě');

INSERT INTO enum_reason VALUES (8, 'An invalid IP address', 'Neplatná IP adresa');
INSERT INTO enum_reason VALUES (9, 'An invalid nameserver hostname', 'Neplatný název jmenného serveru');
INSERT INTO enum_reason VALUES (10, 'A duplicate nameserver address', 'Duplicitní adresa jmenného serveru');
INSERT INTO enum_reason VALUES (11, 'Glue IP address not applicable', 'Glue IP adresu zde nelze použít');

-- domain renew errors
INSERT INTO enum_reason VALUES (14, 'The validity period exceeds the allowed maximum', 'Doba platnosti přesahuje maximální povolenou mez');
INSERT INTO enum_reason VALUES (15, 'The validity period is not an integer multiple of the allowed step', 'Doba platnosti není celočíselným násobkem povoleného kroku');

INSERT INTO enum_reason VALUES (16, 'An unknown country code', 'Neznámý kód země');

INSERT INTO enum_reason VALUES (17, 'An unknown message ID', 'Neznámý identifikátor zprávy');

-- ENUM validation expiration
INSERT INTO enum_reason VALUES (18, 'A validation expiration date not applicable', 'Datum vypršení platnosti ověření zde nelze použít');
INSERT INTO enum_reason VALUES (19, 'The validation expiration date is not valid', 'Datum vypršení platnosti ověření je neplatné');

INSERT INTO enum_reason VALUES (23, 'The technical contact cannot be removed', 'Nelze odstranit technický kontakt');

-- domain / keyset / nsset related errors
INSERT INTO enum_reason VALUES (24, 'The technical contact is assigned to the object already', 'Tomuto objektu je uvedený technický kontakt již přiřazen');
INSERT INTO enum_reason VALUES (25, 'The technical contact does not exist', 'Technický kontakt neexistuje');
INSERT INTO enum_reason VALUES (26, 'The administrative contact is assigned to the object already', 'Tomuto objektu je uvedený administrativní kontakt již přiřazen');
INSERT INTO enum_reason VALUES (27, 'The administrative contact does not exist', 'Administrativní kontakt neexistuje');

-- domain related errors
INSERT INTO enum_reason VALUES (28, 'The nsset does not exist', 'Sada jmenných serverů neexistuje');
INSERT INTO enum_reason VALUES (29, 'The registrant contact does not exist', 'Kontakt držitele neexistuje');

-- nsset related errors
INSERT INTO enum_reason VALUES (30, 'The nameserver is included in the nsset already', 'Uvedený jmenný server je již obsažen v této sadě jmenných serverů');
INSERT INTO enum_reason VALUES (31, 'The nameserver is not included in the nsset', 'Uvedený jmenný server není obsažen v této sadě jmenných serverů');

-- domain renew error
INSERT INTO enum_reason VALUES (32, 'The expiration date does not match the recorded data', 'Datum vypršení platnosti nesouhlasí se zaznamenanými údaji');

-- mod_eppd errors
INSERT INTO enum_reason VALUES (33, 'The "transfer" element is missing an "op" attribute', 'U elementu "transfer" chybí atribut "op"');
INSERT INTO enum_reason VALUES (34, 'The "ident" element is missing a "type" attribute', 'U elementu "ident" chybí atribut "type"');
INSERT INTO enum_reason VALUES (35, 'The "poll" element is missing an "msgID" attribute', 'U elementu "poll" chybí atribut "msgID"');

-- XML validation process failed
INSERT INTO enum_reason VALUES (37, 'XML validation error: ', 'Chyba validace XML schémat: ');

-- domain blacklist
INSERT INTO enum_reason VALUES (36, 'Registration is prohibited', 'Registrace je zakázána');

-- technical / administrative contatct
INSERT INTO enum_reason VALUES (38, 'A duplicate contact', 'Duplicitní kontakt');

--- keyset related errors
INSERT INTO enum_reason VALUES (39, 'An invalid format of the keyset handle', 'Neplatný formát identifikátoru keysetu');
INSERT INTO enum_reason VALUES (40, 'The keyset does not exist', 'Keyset neexistuje');

INSERT INTO enum_reason VALUES (48, 'Unauthorized access to the object', 'Neautorizovaný přístup k objektu');
INSERT INTO enum_reason VALUES (49, 'Too many administrative contacts', 'Příliš mnoho administrativních kontaktů');
INSERT INTO enum_reason VALUES (50, 'Too many DS records', 'Příliš mnoho DS záznamů');
INSERT INTO enum_reason VALUES (51, 'Too many DNSKEY records', 'Příliš mnoho DNSKEY záznamů');
INSERT INTO enum_reason VALUES (53, 'No DNSKEY record', 'Žádný DNSKEY záznam');
INSERT INTO enum_reason VALUES (54, 'The "flags" field must be 0, 256 or 257', 'Položka "flags" musí být 0, 256 nebo 257');
INSERT INTO enum_reason VALUES (55, 'The "protocol" field must be 3', 'Položka "protocol" musí být 3');
INSERT INTO enum_reason VALUES (56, 'An unsupported value of the "alg" field, see IANA DNS Security Algorithm Numbers', 'Nepodporovaná hodnota položky "alg", viz IANA DNS Security Algorithm Numbers');
INSERT INTO enum_reason VALUES (57, 'The "key" field has an invalid length', 'Položka "key" má nevyhovující délku');
INSERT INTO enum_reason VALUES (58, 'The "key" field contains an invalid character', 'Položka "key" obsahuje neplatný znak');
INSERT INTO enum_reason VALUES (59, 'The DNSKEY exists for the keyset already', 'DNSKEY již pro tento keyset existuje');
INSERT INTO enum_reason VALUES (60, 'The DNSKEY does not exist for the keyset', 'DNSKEY pro tento keyset neexistuje');
INSERT INTO enum_reason VALUES (61, 'A duplicate DNSKEY', 'Duplicitní záznam DNSKEY');
INSERT INTO enum_reason VALUES (62, 'The keyset must have a DNSKEY record or a DS record', 'Keyset musí mít DNSKEY záznam nebo DS záznam');
INSERT INTO enum_reason VALUES (63, 'A duplicate nameserver hostname', 'Duplicitní název jmenného serveru');
INSERT INTO enum_reason VALUES (64, 'The administrative contact is not assigned to the object', 'Tomuto objektu uvedený administrativní kontakt není přiřazen');
INSERT INTO enum_reason VALUES (65, 'Temporary contacts are discontinued', 'Dočasné kontakty již nejsou podporovány');
INSERT INTO enum_reason VALUES (66, 'The validity period is shorter than the allowed minimum', 'Doba platnosti je kratší než povolené minimum');

SELECT setval('enum_reason_id_seq', 66);

comment on table enum_reason is 'Table of error messages reason';
comment on column enum_reason.reason is 'reason in english language';
comment on column enum_reason.reason_cs is 'reason in native language';
