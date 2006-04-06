-- ciselnik chybovych hlaseni
DROP TABLE enum_error  CASCADE;
CREATE TABLE enum_error (
        id SERIAL PRIMARY KEY,
        status varchar(128) UNIQUE NOT NULL
        );
                        
                        

-- chybove zpravy
INSERT INTO enum_error (id , status) VALUES(   1000 ,   'Command completed successfully' );
INSERT INTO enum_error (id , status) VALUES(   1001 ,   'Command completed successfully; action pending' );

INSERT INTO enum_error (id , status) VALUES(   1300 ,   'Command completed successfully; no messages');
INSERT INTO enum_error (id , status) VALUES(   1301 ,   'Command completed successfully; ack to dequeue');
INSERT INTO enum_error (id , status) VALUES(   1500 ,   'Command completed successfully; ending session');

INSERT INTO enum_error (id , status) VALUES(   2000 ,   'Unknown command');
INSERT INTO enum_error (id , status) VALUES(   2001 ,   'Command syntax error');
INSERT INTO enum_error (id , status) VALUES(   2002 ,   'Command use error');
INSERT INTO enum_error (id , status) VALUES(   2003 ,   'Required parameter missing');
INSERT INTO enum_error (id , status) VALUES(   2004 ,   'Parameter value range error');
INSERT INTO enum_error (id , status) VALUES(   2005 ,   'Parameter value syntax error');
INSERT INTO enum_error (id , status) VALUES(   2100 ,   'Unimplemented protocol version');
INSERT INTO enum_error (id , status) VALUES(   2101 ,   'Unimplemented command');
INSERT INTO enum_error (id , status) VALUES(   2102 ,   'Unimplemented option');
INSERT INTO enum_error (id , status) VALUES(   2103 ,   'Unimplemented extension');
INSERT INTO enum_error (id , status) VALUES(   2104 ,   'Billing failure');
INSERT INTO enum_error (id , status) VALUES(   2105 ,   'Object is not eligible for renewal');
INSERT INTO enum_error (id , status) VALUES(   2106 ,   'Object is not eligible for transfer');
INSERT INTO enum_error (id , status) VALUES(   2200 ,   'Authentication error');
INSERT INTO enum_error (id , status) VALUES(   2201 ,   'Authorization error');
INSERT INTO enum_error (id , status) VALUES(   2202 ,   'Invalid authorization information');
INSERT INTO enum_error (id , status) VALUES(   2300 ,   'Object pending transfer');
INSERT INTO enum_error (id , status) VALUES(   2301 ,   'Object not pending transfer');
INSERT INTO enum_error (id , status) VALUES(   2302 ,   'Object exists');
INSERT INTO enum_error (id , status) VALUES(   2303 ,   'Object does not exist');
INSERT INTO enum_error (id , status) VALUES(   2304 ,   'Object status prohibits operation');
INSERT INTO enum_error (id , status) VALUES(   2305 ,   'Object association prohibits operation');
INSERT INTO enum_error (id , status) VALUES(   2306 ,   'Parameter value policy error');
INSERT INTO enum_error (id , status) VALUES(   2307 ,   'Unimplemented object service');
INSERT INTO enum_error (id , status) VALUES(   2308 ,   'Data management policy violation');
INSERT INTO enum_error (id , status) VALUES(   2400 ,   'Command failed');
INSERT INTO enum_error (id , status) VALUES(   2500 ,   'Command failed; server closing connection');
INSERT INTO enum_error (id , status) VALUES(   2501 ,  'Authentication error; server closing connection');


                                                                                                
