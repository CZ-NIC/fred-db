-- kodovani
\encoding       LATIN2

-- ciselnik chybovych hlaseni reason
DROP TABLE enum_reason  CASCADE;
CREATE TABLE enum_reason (
        id SERIAL PRIMARY KEY,
        reason varchar(128) UNIQUE NOT NULL,
        reason_cs varchar(128)  UNIQUE  NOT NULL -- èeský pøeklad
        );


INSERT INTO enum_reason VALUES(  1 ,  'bad format contact handle'   , 'neplatný formát ukazatele kontaktu' );
INSERT INTO enum_reason VALUES(  2 ,  'bad format nsset handle' ,  'neplatný formát ukazatele nssettu' );
INSERT INTO enum_reason VALUES(  3 ,  'bad format of fqdn domain'  , 'neplatný formát názvu domény' );


INSERT INTO enum_reason VALUES( 100 , 'bad periody interval'  , 'neplatný interval prodlou¾ení'  );
INSERT INTO enum_reason VALUES( 101 , 'bad format of valExpDate' , 'neplatný formát expirace validace'  );
INSERT INTO enum_reason VALUES( 102 , 'ip addres is not valid' , 'neplatná ip adresa'  );
INSERT INTO enum_reason VALUES( 103 , 'can not add status flag' , 'nelze pøidat stavový pøíznak'  );
INSERT INTO enum_reason VALUES( 104 , 'can not remove status flag' , 'nelze odstranit stavový pøíznak' );
INSERT INTO enum_reason VALUES( 105 ,  'current ExpDate is not expiry date' , 'zadané datum expirace nesouhlasí' );

INSERT INTO enum_reason VALUES(  400 ,  'bad format of DNS host name'  ,  'neplatný formát  názvu  DNS servru' );
INSERT INTO enum_reason VALUES(  401 ,  'duplicity DNS host address' , 'duplicitní adresa jmeného servru DNS'  );
INSERT INTO enum_reason VALUES(  402 ,  'DNS host is not in table'  , 'DNS host není v tabulce' );
INSERT INTO enum_reason VALUES(  403 ,  'DNS host name exist' , 'jmený server DNS u¾ existuje' );
INSERT INTO enum_reason VALUES(  404 ,  'minimal two dns host set one'  , 'minimálnì dva DNS servry' );
INSERT INTO enum_reason VALUES(  405 ,  'not any DNS host sets'  , 'nejsou nastaven ¾ádné DNS servry' );
INSERT INTO enum_reason VALUES(  406 ,  'not any tech contact sets'  , 'není  zadán ¾ádný technický kontakt' );
INSERT INTO enum_reason VALUES(  407 ,  'not glue ipaddr allowed'  , 'nepovolená  ip adresa' );
INSERT INTO enum_reason VALUES(  408 ,  'can not remove tech contact to zero'  , 'nelze vymazat v¹echny technické kontakty'  );
INSERT INTO enum_reason VALUES(  409 ,  'can not remove DNS host to zero'  ,  'nelze vymazat v¹echny DNS hosty' );

INSERT INTO enum_reason VALUES(  410 ,  'can not remove DNS host'  , 'nelze odstranit jmený server DNS' );
INSERT INTO enum_reason VALUES(  411 , 'can not add DNS host'  , 'nelze pøidat jmený server DNS' );


INSERT INTO enum_reason VALUES(  901 , 'nsset handle exist not Avail'  , 'ukazatel nssetu existuje není dostupný' );
INSERT INTO enum_reason VALUES(  902 , 'nsset handle not exist '  , 'ukazatel nssetu  neexistuje');
INSERT INTO enum_reason VALUES(  903 , 'nsset handle in history'  , 'ukazatel nssetu je v ochrané lhùtì'  );

INSERT INTO enum_reason VALUES(  911 , 'contact handle exist not Avail' , 'ukazatel  kontaktu existuje není dostupný'   );
INSERT INTO enum_reason VALUES(  912 , 'contact handle not exist '  , 'ukazatel  kontaktu neexistuje'  );
INSERT INTO enum_reason VALUES(  913 , 'contact handle in history' ,  'ukazatel  kontaktu  je v ochrané lhùtì'  );

INSERT INTO enum_reason VALUES(  921 , 'fqdn of domain exist not Avail' , 'název domény  existuje není dostupná'   );
INSERT INTO enum_reason VALUES(  922 , 'fqdn of domain not exist ' ,  'název domény neexistuje' );
INSERT INTO enum_reason VALUES(  923 , 'fqdn of domain in history'  , 'název domény je v ochrané lhùtì'  );


INSERT INTO enum_reason VALUES(  1001 , 'admin contact exist in contact map'  , 'administrátorký kontakt je u¾ zadán' );
INSERT INTO enum_reason VALUES(  1003 , 'admin contact not exist in contact map' ,  'administrátorký kontak není zadán'   );

INSERT INTO enum_reason VALUES(  1011 , 'tech contact exist in contact map'  , 'technický kontakt je u¾ zadán');
INSERT INTO enum_reason VALUES(  1013 , 'tech contact not exist in contact map' , 'technický kontakt není zadán'  );

INSERT INTO enum_reason VALUES(  1100 , 'registrant not exist'  , 'vlastník neexistuje; );

INSERT INTO enum_reason VALUES(  1101 , 'unknown registrant handle' ,  'neznámý ukazatel vlastníka' );
INSERT INTO enum_reason VALUES(  1102 , 'unknown nsset handle'  , 'neznámý ukazatel nssettu');
INSERT INTO enum_reason VALUES(  1103 , 'unknown admin contact' , 'neznámý administrátorký kontakt'  );
INSERT INTO enum_reason VALUES(  1104 , 'unknown tech contact' , 'neznámý technický kontakt');
INSERT INTO enum_reason VALUES(  1105 , 'unknown country code'  , 'neznámý kód zemì' );
INSERT INTO enum_reason VALUES(  1106 , 'unknown msgID' ,  'neznámé  msgID' );
