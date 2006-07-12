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


INSERT INTO enum_error VALUES(  1000 , 'Command completed successfully',    'Pøíkaz úspì¹nì proveden');
INSERT INTO enum_error VALUES(  1001 , 'Command completed successfully; action pending',  'Pøíkaz úspì¹nì proveden; vykonání akce odlo¾eno');

INSERT INTO enum_error VALUES(  1300 , 'Command completed successfully; no messages',    'Pøíkaz úspì¹nì proveden; ¾ádné nové zprávy');
INSERT INTO enum_error VALUES(  1301 , 'Command completed successfully; ack to dequeue',    'Pøíkaz úspì¹nì proveden; potvrï za úèelem vyøazení z fronty');
INSERT INTO enum_error VALUES(  1500 , 'Command completed successfully; ending session',    'Pøíkaz úspì¹nì proveden; konec relace');


INSERT INTO enum_error VALUES(  2000 ,    'Unknown command',    'Neznámý pøíkaz');
INSERT INTO enum_error VALUES(  2001 ,    'Command syntax error',    'Chybná syntaxe pøíkazu');
INSERT INTO enum_error VALUES(  2002 ,    'Command use error',     'Chybné pou¾ití pøíkazu');
INSERT INTO enum_error VALUES(  2003 ,    'Required parameter missing',    'Po¾adovaný parametr neuveden');
INSERT INTO enum_error VALUES(  2004 ,    'Parameter value range error',    'Chybný rozsah parametru');
INSERT INTO enum_error VALUES(  2005 ,    'Parameter value syntax error',    'Chybná syntaxe hodnoty parametru');


INSERT INTO enum_error VALUES( 2100 ,   'Unimplemented protocol version',    'Neimplementovaná verze protokolu');
INSERT INTO enum_error VALUES( 2101 ,   'Unimplemented command',     'Neimplementovaný pøíkaz');
INSERT INTO enum_error VALUES( 2102 ,   'Unimplemented option',    'Neimplementovaná volba');
INSERT INTO enum_error VALUES( 2103 ,   'Unimplemented extension',    'Neimplementované roz¹íøení');
INSERT INTO enum_error VALUES( 2104 ,   'Billing failure',     'Úèetní selhání');
INSERT INTO enum_error VALUES( 2105 ,   'Object is not eligible for renewal',     'Objekt je nezpùsobilý pro obnovení');
INSERT INTO enum_error VALUES( 2106 ,   'Object is not eligible for transfer',    'Objekt je nezpùsobilý pro transfer');


INSERT INTO enum_error VALUES( 2200 ,    'Authentication error',    'Chyba ovìøení identity');
INSERT INTO enum_error VALUES( 2201 ,    'Authorization error',     'Chyba oprávnìní');
INSERT INTO enum_error VALUES( 2202 ,    'Invalid authorization information',    'Chybná autorizaèní informace');

INSERT INTO enum_error VALUES( 2300 ,    'Object pending transfer',    'Objekt èeká na transfer');
INSERT INTO enum_error VALUES( 2301 ,    'Object not pending transfer',    'Objekt neèeká na transfer');
INSERT INTO enum_error VALUES( 2302 ,    'Object exists',    'Objekt existuje');
INSERT INTO enum_error VALUES( 2303 ,    'Object does not exist',    'Objekt neexistuje');
INSERT INTO enum_error VALUES( 2304 ,    'Object status prohibits operation',    'Status objektu nedovoluje operaci');
INSERT INTO enum_error VALUES( 2305 ,    'Object association prohibits operation',    'Asociace objektu nedovoluje operaci');
INSERT INTO enum_error VALUES( 2306 ,    'Parameter value policy error',    'Chyba zásady pro hodnotu parametru');
INSERT INTO enum_error VALUES( 2307 ,    'Unimplemented object service',    'Neimplementovaná slu¾ba objektu');
INSERT INTO enum_error VALUES( 2308 ,    'Data management policy violation',    'Poru¹ení zásady pro správu dat');

INSERT INTO enum_error VALUES( 2400 ,    'Command failed',    'Pøíkaz selhal');
INSERT INTO enum_error VALUES( 2500 ,    'Command failed; server closing connection',    'Pøíkaz selhal; server uzavírá spojení');
INSERT INTO enum_error VALUES( 2501 ,    'Authentication error; server closing connection',    'Chyba ovìøení identity; server uzavírá spojení');
INSERT INTO enum_error VALUES( 2502 ,    'Session limit exceeded; server closing connection',    'Limit na poèet relací pøekroèen; server uzavírá spojení');



                                                                                                
