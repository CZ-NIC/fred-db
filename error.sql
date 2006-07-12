-- kodovani
\encoding       LATIN2

-- ciselnik chybovych hlaseni
-- DROP TABLE enum_error  CASCADE;
CREATE TABLE enum_error (
        id SERIAL PRIMARY KEY,
        status varchar(128) UNIQUE NOT NULL,
        status_cs varchar(128) UNIQUE NOT NULL -- cesky preklad
        );
                        
                        

-- chybove zpravy EN a CS


INSERT INTO enum_error VALUES(  1000 , 'Command completed successfully',    'P��kaz �sp�n� proveden');
INSERT INTO enum_error VALUES(  1001 , 'Command completed successfully; action pending',  'P��kaz �sp�n� proveden; vykon�n� akce odlo�eno');

INSERT INTO enum_error VALUES(  1300 , 'Command completed successfully; no messages',    'P��kaz �sp�n� proveden; ��dn� nov� zpr�vy');
INSERT INTO enum_error VALUES(  1301 , 'Command completed successfully; ack to dequeue',    'P��kaz �sp�n� proveden; potvr� za ��elem vy�azen� z fronty');
INSERT INTO enum_error VALUES(  1500 , 'Command completed successfully; ending session',    'P��kaz �sp�n� proveden; konec relace');


INSERT INTO enum_error VALUES(  2000 ,    'Unknown command',    'Nezn�m� p��kaz');
INSERT INTO enum_error VALUES(  2001 ,    'Command syntax error',    'Chybn� syntaxe p��kazu');
INSERT INTO enum_error VALUES(  2002 ,    'Command use error',     'Chybn� pou�it� p��kazu');
INSERT INTO enum_error VALUES(  2003 ,    'Required parameter missing',    'Po�adovan� parametr neuveden');
INSERT INTO enum_error VALUES(  2004 ,    'Parameter value range error',    'Chybn� rozsah parametru');
INSERT INTO enum_error VALUES(  2005 ,    'Parameter value syntax error',    'Chybn� syntaxe hodnoty parametru');


INSERT INTO enum_error VALUES( 2100 ,   'Unimplemented protocol version',    'Neimplementovan� verze protokolu');
INSERT INTO enum_error VALUES( 2101 ,   'Unimplemented command',     'Neimplementovan� p��kaz');
INSERT INTO enum_error VALUES( 2102 ,   'Unimplemented option',    'Neimplementovan� volba');
INSERT INTO enum_error VALUES( 2103 ,   'Unimplemented extension',    'Neimplementovan� roz���en�');
INSERT INTO enum_error VALUES( 2104 ,   'Billing failure',     '��etn� selh�n�');
INSERT INTO enum_error VALUES( 2105 ,   'Object is not eligible for renewal',     'Objekt je nezp�sobil� pro obnoven�');
INSERT INTO enum_error VALUES( 2106 ,   'Object is not eligible for transfer',    'Objekt je nezp�sobil� pro transfer');


INSERT INTO enum_error VALUES( 2200 ,    'Authentication error',    'Chyba ov��en� identity');
INSERT INTO enum_error VALUES( 2201 ,    'Authorization error',     'Chyba opr�vn�n�');
INSERT INTO enum_error VALUES( 2202 ,    'Invalid authorization information',    'Chybn� autoriza�n� informace');

INSERT INTO enum_error VALUES( 2300 ,    'Object pending transfer',    'Objekt �ek� na transfer');
INSERT INTO enum_error VALUES( 2301 ,    'Object not pending transfer',    'Objekt ne�ek� na transfer');
INSERT INTO enum_error VALUES( 2302 ,    'Object exists',    'Objekt existuje');
INSERT INTO enum_error VALUES( 2303 ,    'Object does not exist',    'Objekt neexistuje');
INSERT INTO enum_error VALUES( 2304 ,    'Object status prohibits operation',    'Status objektu nedovoluje operaci');
INSERT INTO enum_error VALUES( 2305 ,    'Object association prohibits operation',    'Asociace objektu nedovoluje operaci');
INSERT INTO enum_error VALUES( 2306 ,    'Parameter value policy error',    'Chyba z�sady pro hodnotu parametru');
INSERT INTO enum_error VALUES( 2307 ,    'Unimplemented object service',    'Neimplementovan� slu�ba objektu');
INSERT INTO enum_error VALUES( 2308 ,    'Data management policy violation',    'Poru�en� z�sady pro spr�vu dat');

INSERT INTO enum_error VALUES( 2400 ,    'Command failed',    'P��kaz selhal');
INSERT INTO enum_error VALUES( 2500 ,    'Command failed; server closing connection',    'P��kaz selhal; server uzav�r� spojen�');
INSERT INTO enum_error VALUES( 2501 ,    'Authentication error; server closing connection',    'Chyba ov��en� identity; server uzav�r� spojen�');
INSERT INTO enum_error VALUES( 2502 ,    'Session limit exceeded; server closing connection',    'Limit na po�et relac� p�ekro�en; server uzav�r� spojen�');



                                                                                                
