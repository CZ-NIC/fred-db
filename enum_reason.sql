-- ciselnik chybovych hlaseni reason
CREATE TABLE enum_reason (
        id SERIAL PRIMARY KEY,
        reason varchar(128) UNIQUE NOT NULL,
        reason_cs varchar(128)  UNIQUE  NOT NULL -- český překlad
        );


INSERT INTO enum_reason VALUES(  1 ,  'bad format contact handle'   , 'neplatný formát ukazatele kontaktu' );
INSERT INTO enum_reason VALUES(  2 ,  'bad format nsset handle' ,  'neplatný formát ukazatele nssettu' );
INSERT INTO enum_reason VALUES(  3 ,  'bad format of fqdn domain'  , 'neplatný formát  názevu domény' );

INSERT INTO enum_reason VALUES(  4 ,  'Domain name not applicable.'  , 'nepoužitelný název domény' );

-- pro check
INSERT INTO enum_reason VALUES(  5 , 'invalid format'  , 'neplatný formát' );
INSERT INTO enum_reason VALUES(  6 ,  'already registered.'   , 'již zaregistrováno' );
INSERT INTO enum_reason VALUES(  7 , 'within protection peridod.' , 'je v ochrané lhůtě' );


INSERT INTO enum_reason VALUES( 8 , 'Invalid IP address.' , 'neplatná ip adresa'  );
INSERT INTO enum_reason VALUES(  9 ,  'Invalid nameserver hostname.'  ,  'neplatný formát názvu jmeného servru DNS' );
INSERT INTO enum_reason VALUES(  10 ,  'Duplicate nameserver address.' , 'duplicitní adresa jmeného servru DNS'  );
INSERT INTO enum_reason VALUES(  11 ,  'Glue IP address not allowed here.'  , 'nepovolená  ip adresa glue záznamu' );
INSERT INTO enum_reason VALUES(  12 ,  'At least two nameservers required.'  , 'minimálně dva DNS servry' );


-- spatne zadana perioda pri domain renew
INSERT INTO enum_reason VALUES(  13 , 'invalid date of period' ,  'neplatná hodnota periody' );
INSERT INTO enum_reason VALUES( 14 , 'period exceedes maximal allowed validity time.' , 'perioda je nad maximalní dovolenou hodnotou' );
INSERT INTO enum_reason VALUES( 15 , 'period is not aligned with allowed step.' , 'perioda neodpovída dovolenému intervalu' );


-- country code neexistuje
INSERT INTO enum_reason VALUES(  16 , 'Unknown country code'  , 'neznámý kód země' );

-- nezmame msgID neexistuje
INSERT INTO enum_reason VALUES(  17 , 'Unknown message ID' ,  'neznámé  msgID' );


-- pro ENUMval	
INSERT INTO enum_reason VALUES(  18 , 'Validation expiration date can not be used here.' ,  'datum vypršení platnosti  se nepoužívá'  );
INSERT INTO enum_reason VALUES(  19 , 'Validation expiration date does not match registry data.' , 'datum vypršení platnosti je neplatné' );
INSERT INTO enum_reason VALUES(  20 , 'Validation expiration date is required.' , 'datum vypršení platnosti je požadováno' );

-- Update NSSET nelze odstranit ci pradat DNS jost ci vyradit tech kontakt min 1 tech
INSERT INTO enum_reason VALUES(  21 , 'Can not remove nameserver.'  , 'nelze odstranit jmený server DNS' );
INSERT INTO enum_reason VALUES(  22 , 'Can not add nameserver'  , 'nelze přidat jmený server DNS' );

INSERT INTO enum_reason VALUES(  23 ,  'Can not remove  technical contact'  , 'nelze vymazat  technický kontakt'  );

INSERT INTO enum_reason VALUES(  24 , 'Technical contact is already set to this nsset.'  , 'technický kontakt je již přiřazen k  sadě jmených servrů' );
INSERT INTO enum_reason VALUES(  25 , 'Technical contact is not set to this nsset.' ,  'technický kontak není přiřazen k sadě jmených servrů'   );

INSERT INTO enum_reason VALUES(  26 , 'Administrative contact is already set to this domain.'  , 'administrátorký kontakt je již přiřazen k doméně' );
INSERT INTO enum_reason VALUES(  27 , 'Administravite contact is not set to this domain.' ,  'administrátorký kontak není přiřazen k doméně'   );
 
-- pro domenu kdyz neexistuje vlastnik ci nsset
INSERT INTO enum_reason VALUES( 28 ,  'handle of nsset does not exist.' , 'sada jmených servrů není vytvořena' );
INSERT INTO enum_reason VALUES( 29 ,  'contact handle of registrant does not exist.' , 'ukazatel kontaktu vlastníka není vytvořen' );

-- pokud nelze pridat nebo odebrat dns host
INSERT INTO enum_reason VALUES( 30 , 'Nameserver is already set to this nsset.' , 'jmený server DNS je již přiřazen v sadě jmených servrů' );
INSERT INTO enum_reason VALUES( 31 , 'Nameserver is not set to this nsset.'  , 'jmený server DNS není přiřazen v sadě jmených servrů' );

-- pro domain renew kdyz nesouhlasi zadany datum expirace
INSERT INTO enum_reason VALUES( 32 ,  'Expiration date does not match registry data.' , 'nesouhlasí datum expirace' );
 
-- chyba z mod_eppd, pokud chybi u prikazu transfer atribut 'op'
INSERT INTO enum_reason VALUES( 33 ,  'Attribute op in element transfer is missing', 'Chybi atribut op u elementu transfer' );
-- chyba z mod_eppd, pokud chybi u elementu ident jeho typ
INSERT INTO enum_reason VALUES( 34 ,  'Attribute type in element ident is missing', 'Chybi atribut type u elementu ident' );
-- chyba z mod_eppd, pokud chybi u elementu poll atribut msgID
INSERT INTO enum_reason VALUES( 35 ,  'Attribute msgID in element poll is missing', 'Chybi atribut msgID u elementu poll' );

-- blacklist domain
INSERT INTO enum_reason VALUES( 36 ,  'registratration is prohibited'  , 'registrace je  zakázána' );
-- nepodarilose zvalidovat XML
INSERT INTO enum_reason VALUES( 37 ,  'Schemas validity error' , 'Chyba validace XML schemat' );
