-- classifier of error messages  reason
CREATE TABLE enum_reason (
        id SERIAL PRIMARY KEY,
        reason varchar(128) UNIQUE NOT NULL,
        reason_cs varchar(128)  UNIQUE  NOT NULL -- czech translation
        );


INSERT INTO enum_reason VALUES(  1 ,  'bad format contact handle'   , 'neplatný formát ukazatele kontaktu' );
INSERT INTO enum_reason VALUES(  2 ,  'bad format nsset handle' ,  'neplatný formát ukazatele nssettu' );
INSERT INTO enum_reason VALUES(  3 ,  'bad format of fqdn domain'  , 'neplatný formát  názevu domény' );

INSERT INTO enum_reason VALUES(  4 ,  'Domain name not applicable.'  , 'nepoužitelný název domény' );

-- for check
INSERT INTO enum_reason VALUES(  5 , 'invalid format'  , 'neplatný formát' );
INSERT INTO enum_reason VALUES(  6 ,  'already registered.'   , 'již zaregistrováno' );
INSERT INTO enum_reason VALUES(  7 , 'within protection peridod.' , 'je v ochrané lhůtě' );


INSERT INTO enum_reason VALUES( 8 , 'Invalid IP address.' , 'neplatná ip adresa'  );
INSERT INTO enum_reason VALUES(  9 ,  'Invalid nameserver hostname.'  ,  'neplatný formát názvu jmeného servru DNS' );
INSERT INTO enum_reason VALUES(  10 ,  'Duplicate nameserver address.' , 'duplicitní adresa jmeného servru DNS'  );
INSERT INTO enum_reason VALUES(  11 ,  'Glue IP address not allowed here.'  , 'nepovolená  ip adresa glue záznamu' );
INSERT INTO enum_reason VALUES(  12 ,  'At least two nameservers required.'  , 'minimálně dva DNS servry' );


-- badly entered period in domain renew 
INSERT INTO enum_reason VALUES(  13 , 'invalid date of period' ,  'neplatná hodnota periody' );
INSERT INTO enum_reason VALUES( 14 , 'period exceedes maximal allowed validity time.' , 'perioda je nad maximalní dovolenou hodnotou' );
INSERT INTO enum_reason VALUES( 15 , 'period is not aligned with allowed step.' , 'perioda neodpovída dovolenému intervalu' );


-- country code doesn't exist
INSERT INTO enum_reason VALUES(  16 , 'Unknown country code'  , 'neznámý kód země' );

-- unknown msgID doesn't exist
INSERT INTO enum_reason VALUES(  17 , 'Unknown message ID' ,  'neznámé  msgID' );


-- for ENUMval	
INSERT INTO enum_reason VALUES(  18 , 'Validation expiration date can not be used here.' ,  'datum vypršení platnosti  se nepoužívá'  );
INSERT INTO enum_reason VALUES(  19 , 'Validation expiration date does not match registry data.' , 'datum vypršení platnosti je neplatné' );
INSERT INTO enum_reason VALUES(  20 , 'Validation expiration date is required.' , 'datum vypršení platnosti je požadováno' );

-- Update NSSET it can not be removed or added  DNS host or replaced tech contact 1 tech is minimum 
INSERT INTO enum_reason VALUES(  21 , 'Can not remove nameserver.'  , 'nelze odstranit jmený server DNS' );
INSERT INTO enum_reason VALUES(  22 , 'Can not add nameserver'  , 'nelze přidat jmený server DNS' );

INSERT INTO enum_reason VALUES(  23 ,  'Can not remove  technical contact'  , 'nelze vymazat  technický kontakt'  );

INSERT INTO enum_reason VALUES(  24 , 'Technical contact is already set to this nsset.'  , 'technický kontakt je již přiřazen k  sadě jmených servrů' );
INSERT INTO enum_reason VALUES(  25 , 'Technical contact is not set to this nsset.' ,  'technický kontakt není přiřazen k sadě jmených servrů'   );

INSERT INTO enum_reason VALUES(  26 , 'Administrative contact is already set to this domain.'  , 'administrátorký kontakt je již přiřazen k doméně' );
INSERT INTO enum_reason VALUES(  27 , 'Administravite contact is not set to this domain.' ,  'administrátorký kontakt není přiřazen k doméně'   );
 
-- for domain when owner or nsset doesn't exist
INSERT INTO enum_reason VALUES( 28 ,  'handle of nsset does not exist.' , 'sada jmených servrů není vytvořena' );
INSERT INTO enum_reason VALUES( 29 ,  'contact handle of registrant does not exist.' , 'ukazatel kontaktu vlastníka není vytvořen' );

-- if dns host cannot be added or removed
INSERT INTO enum_reason VALUES( 30 , 'Nameserver is already set to this nsset.' , 'jmený server DNS je již přiřazen v sadě jmených servrů' );
INSERT INTO enum_reason VALUES( 31 , 'Nameserver is not set to this nsset.'  , 'jmený server DNS není přiřazen v sadě jmených servrů' );

-- for domain renew when entered date of epiration doesn't fit 
INSERT INTO enum_reason VALUES( 32 ,  'Expiration date does not match registry data.' , 'nesouhlasí datum expirace' );
 
-- error from mod_eppd, if it is missing 'op' attribute in transfer command 
INSERT INTO enum_reason VALUES( 33 ,  'Attribute op in element transfer is missing', 'Chybi atribut op u elementu transfer' );
-- error from mod_eppd, if it is missing a type of ident element
INSERT INTO enum_reason VALUES( 34 ,  'Attribute type in element ident is missing', 'Chybi atribut type u elementu ident' );
-- error from z mod_eppd, if it is missing attribute msgID in element poll
INSERT INTO enum_reason VALUES( 35 ,  'Attribute msgID in element poll is missing', 'Chybi atribut msgID u elementu poll' );

-- blacklist domain
INSERT INTO enum_reason VALUES( 36 ,  'registratration is prohibited'  , 'registrace je  zakázána' );
-- XML validation process failed
INSERT INTO enum_reason VALUES( 37 ,  'Schemas validity error: ' , 'Chyba validace XML schemat: ' );

-- duplicate contact for tech or admin 
INSERT INTO enum_reason VALUES(  38 , 'Duplicity contact' , 'Duplicitnitni kontakt' );

comment on table enum_reason is 'Table of error messages reason';
comment on column enum_reason.reason is 'reason in english language';
comment on column enum_reason.reason_cs is 'reason in native language';
