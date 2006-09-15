-- kodovani
\encoding       LATIN2

-- ciselnik chybovych hlaseni reason
DROP TABLE enum_reason  CASCADE;
CREATE TABLE enum_reason (
        id SERIAL PRIMARY KEY,
        reason varchar(128) UNIQUE NOT NULL,
        reason_cs varchar(128)  UNIQUE  NOT NULL -- �esk� p�eklad
        );


INSERT INTO enum_reason VALUES(  1 ,  'bad format contact handle'   , 'neplatn� form�t ukazatele kontaktu' );
INSERT INTO enum_reason VALUES(  2 ,  'bad format nsset handle' ,  'neplatn� form�t ukazatele nssettu' );
INSERT INTO enum_reason VALUES(  3 ,  'bad format of fqdn domain'  , 'neplatn� form�t n�zvu dom�ny' );


INSERT INTO enum_reason VALUES( 100 , 'bad periody interval'  , 'neplatn� interval prodlou�en�'  );
INSERT INTO enum_reason VALUES( 101 , 'bad format of valExpDate' , 'neplatn� form�t expirace validace'  );
INSERT INTO enum_reason VALUES( 102 , 'ip addres is not valid' , 'neplatn� ip adresa'  );
INSERT INTO enum_reason VALUES( 103 , 'can not add status flag' , 'nelze p�idat stavov� p��znak'  );
INSERT INTO enum_reason VALUES( 104 , 'can not remove status flag' , 'nelze odstranit stavov� p��znak' );
INSERT INTO enum_reason VALUES( 105 ,  'current ExpDate is not expiry date' , 'zadan� datum expirace nesouhlas�' );

INSERT INTO enum_reason VALUES(  400 ,  'bad format of DNS host name'  ,  'neplatn� form�t  n�zvu  DNS servru' );
INSERT INTO enum_reason VALUES(  401 ,  'duplicity DNS host address' , 'duplicitn� adresa jmen�ho servru DNS'  );
INSERT INTO enum_reason VALUES(  402 ,  'DNS host is not in table'  , 'DNS host nen� v tabulce' );
INSERT INTO enum_reason VALUES(  403 ,  'DNS host name exist' , 'jmen� server DNS u� existuje' );
INSERT INTO enum_reason VALUES(  404 ,  'minimal two dns host set one'  , 'minim�ln� dva DNS servry' );
INSERT INTO enum_reason VALUES(  405 ,  'not any DNS host sets'  , 'nejsou nastaven ��dn� DNS servry' );
INSERT INTO enum_reason VALUES(  406 ,  'not any tech contact sets'  , 'nen�  zad�n ��dn� technick� kontakt' );
INSERT INTO enum_reason VALUES(  407 ,  'not glue ipaddr allowed'  , 'nepovolen�  ip adresa' );
INSERT INTO enum_reason VALUES(  408 ,  'can not remove tech contact to zero'  , 'nelze vymazat v�echny technick� kontakty'  );
INSERT INTO enum_reason VALUES(  409 ,  'can not remove DNS host to zero'  ,  'nelze vymazat v�echny DNS hosty' );

INSERT INTO enum_reason VALUES(  410 ,  'can not remove DNS host'  , 'nelze odstranit jmen� server DNS' );
INSERT INTO enum_reason VALUES(  411 , 'can not add DNS host'  , 'nelze p�idat jmen� server DNS' );


INSERT INTO enum_reason VALUES(  901 , 'nsset handle exist not Avail'  , 'ukazatel nssetu existuje nen� dostupn�' );
INSERT INTO enum_reason VALUES(  902 , 'nsset handle not exist '  , 'ukazatel nssetu  neexistuje');
INSERT INTO enum_reason VALUES(  903 , 'nsset handle in history'  , 'ukazatel nssetu je v ochran� lh�t�'  );

INSERT INTO enum_reason VALUES(  911 , 'contact handle exist not Avail' , 'ukazatel  kontaktu existuje nen� dostupn�'   );
INSERT INTO enum_reason VALUES(  912 , 'contact handle not exist '  , 'ukazatel  kontaktu neexistuje'  );
INSERT INTO enum_reason VALUES(  913 , 'contact handle in history' ,  'ukazatel  kontaktu  je v ochran� lh�t�'  );

INSERT INTO enum_reason VALUES(  921 , 'fqdn of domain exist not Avail' , 'n�zev dom�ny  existuje nen� dostupn�'   );
INSERT INTO enum_reason VALUES(  922 , 'fqdn of domain not exist ' ,  'n�zev dom�ny neexistuje' );
INSERT INTO enum_reason VALUES(  923 , 'fqdn of domain in history'  , 'n�zev dom�ny je v ochran� lh�t�'  );


INSERT INTO enum_reason VALUES(  1001 , 'admin contact exist in contact map'  , 'administr�tork� kontakt je u� zad�n' );
INSERT INTO enum_reason VALUES(  1003 , 'admin contact not exist in contact map' ,  'administr�tork� kontak nen� zad�n'   );

INSERT INTO enum_reason VALUES(  1011 , 'tech contact exist in contact map'  , 'technick� kontakt je u� zad�n');
INSERT INTO enum_reason VALUES(  1013 , 'tech contact not exist in contact map' , 'technick� kontakt nen� zad�n'  );

INSERT INTO enum_reason VALUES(  1100 , 'registrant not exist'  , 'vlastn�k neexistuje; );

INSERT INTO enum_reason VALUES(  1101 , 'unknown registrant handle' ,  'nezn�m� ukazatel vlastn�ka' );
INSERT INTO enum_reason VALUES(  1102 , 'unknown nsset handle'  , 'nezn�m� ukazatel nssettu');
INSERT INTO enum_reason VALUES(  1103 , 'unknown admin contact' , 'nezn�m� administr�tork� kontakt'  );
INSERT INTO enum_reason VALUES(  1104 , 'unknown tech contact' , 'nezn�m� technick� kontakt');
INSERT INTO enum_reason VALUES(  1105 , 'unknown country code'  , 'nezn�m� k�d zem�' );
INSERT INTO enum_reason VALUES(  1106 , 'unknown msgID' ,  'nezn�m�  msgID' );
