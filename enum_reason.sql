-- kodovani
\encoding       LATIN2

-- ciselnik chybovych hlaseni reason
DROP TABLE enum_reason  CASCADE;
CREATE TABLE enum_reason (
        id SERIAL PRIMARY KEY,
        reason varchar(128) UNIQUE NOT NULL
-- TODO        reason_cs varchar(128)  UNIQUE  NOT NULL -- cesky preklad
        );


INSERT INTO enum_reason VALUES(  1 ,  'bad format nsset handle'  );
INSERT INTO enum_reason VALUES(  2 ,  'bad format contact handle'   );
INSERT INTO enum_reason VALUES(  3 ,  'bad format of fqdn domain'   );

INSERT INTO enum_reason VALUES(  4 , 'bad DNS host address'  );
INSERT INTO enum_reason VALUES(  5 , 'bad DNS host name'   );

INSERT INTO enum_reason VALUES( 100 , 'bad periody interval'   );
INSERT INTO enum_reason VALUES( 101 , 'bad format of valExpDate'  );
INSERT INTO enum_reason VALUES( 201 , 'can not add status flag'   );
INSERT INTO enum_reason VALUES( 202 , 'can not remove status flag'  );


INSERT INTO enum_reason VALUES( 203 , 'can not add DNS host'   );
INSERT INTO enum_reason VALUES( 204 ,  'can not remove DNS host'   );
INSERT INTO enum_reason VALUES( 205 , 'can not be set valExpDate'   );
INSERT INTO enum_reason VALUES( 300 ,  'curExpDate is not ExDate' );

INSERT INTO enum_reason VALUES(  401 ,  'duplicity DNS host address'  );
INSERT INTO enum_reason VALUES(  402 ,  'host is not in table'  );
INSERT INTO enum_reason VALUES(  403 ,  'host name exist'  );
INSERT INTO enum_reason VALUES(  404 ,  'minimal two dns host set one'  );
INSERT INTO enum_reason VALUES(  405 ,  'not any DNS host sets'  );
INSERT INTO enum_reason VALUES(  406 ,  'not any tech contact sets'  );
INSERT INTO enum_reason VALUES(  407 ,  'not glue ipaddr allowed'  );
INSERT INTO enum_reason VALUES(  408 ,  'can not remove tech contact to zero'  );
INSERT INTO enum_reason VALUES(  409 , 'can not remove DNS host to zero'  );

INSERT INTO enum_reason VALUES(  901 , 'nsset handle exist not Avail'   );
INSERT INTO enum_reason VALUES(  902 , 'nsset handle not exist '  );
INSERT INTO enum_reason VALUES(  903 , 'nsset handle in history'   );

INSERT INTO enum_reason VALUES(  911 , 'contact handle exist not Avail'   );
INSERT INTO enum_reason VALUES(  912 , 'contact handle not exist '  );
INSERT INTO enum_reason VALUES(  913 , 'contact handle in history'   );

INSERT INTO enum_reason VALUES(  921 , 'fqdn of domain exist not Avail'   );
INSERT INTO enum_reason VALUES(  922 , 'fqdn of domain not exist '  );
INSERT INTO enum_reason VALUES(  923 , 'fqdn of domain in history'   );

INSERT INTO enum_reason VALUES(  990 , 'nsset not exist'   );
INSERT INTO enum_reason VALUES(  991 , 'registrant not exist'   );

INSERT INTO enum_reason VALUES(  1001 , 'admin contact exist in contact map'  );
INSERT INTO enum_reason VALUES(  1002 , 'bad format of admin contact'   );
INSERT INTO enum_reason VALUES(  1003 , 'admin contact not exist in contact map'   );

INSERT INTO enum_reason VALUES(  1011 , 'tech contact exist in contact map'  );
INSERT INTO enum_reason VALUES(  1012 , 'bad format of tech  contact'   );
INSERT INTO enum_reason VALUES(  1013 , 'tech contact not exist in contact map'   );

INSERT INTO enum_reason VALUES(  1101 , 'unknown registrant handle' );
INSERT INTO enum_reason VALUES(  1102 , 'unknown nsset handle'  );
INSERT INTO enum_reason VALUES(  1103 , 'unknown admin contact'  );
INSERT INTO enum_reason VALUES(  1104 , 'unknown tech contact' );
INSERT INTO enum_reason VALUES(  1105 , 'unknown country code'  );
INSERT INTO enum_reason VALUES(  1106 , 'unknown msgID'  );
