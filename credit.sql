-- tabulka pro pricitani creditu za operace DomainCreate a DomainReNew
-- DROP TABLE Credit CASCADE;

-- tabulka pro cerpani kreditu ze zalohych faktur
CREATE TABLE Credit_invoice_credit_map
(
Zone INTEGER REFERENCES Zone (ID), 
registrarID integer NOT NULL REFERENCES Registrar, -- id registratora
Invoice_ID INTEGER REFERENCES Invoice (ID), -- zalohova faktura
Credit numeric(10,2) NOT NULL default 0 , -- celkova vyse kreditu (bez DPH) prevedena ze zalohove faktury
Total numeric(10,2) NOT NULL default 0 -- cerpano  ( pokud Credit == Total ) zalohova faktura je vycerpana
);

-- tabulka pro cerpany credit po uzavereni ucetni faktury
CREATE TABLE Credit_invoice_total_map
(
Invoice_ID INTEGER REFERENCES Invoice (ID),  -- normalni ucetovaci faktura
aInvoice_ID INTEGER REFERENCES Invoice (ID),  -- zalohova faktura ze ktere bylo cerpano
Total numeric(10,2) NOT NULL default 0 -- kolik creditu vycerpano
);


     
-- tabulka cen
CREATE TABLE price
(
  id serial NOT NULL, -- primarni klic
  zone integer, -- odkaz na zonu pro kterou cenik plati pokud se jedna o domenu, pokud ne je to NULL
  action integer NOT NULL, -- na jakou akci se cena vaze 
  valid_from timestamp NOT NULL, -- od kdy zaznam plati
  valid_to timestamp default NULL, -- do kdy zaznam plati, pokud je NULL, neni omezen
  price numeric(10,2) NOT NULL, -- cena operace
  period integer NOT NULL, -- za jednotku 
  CONSTRAINT price_pkey PRIMARY KEY (id),
  CONSTRAINT price_action_fkey FOREIGN KEY ("action")
      REFERENCES "enum_action" (id) MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT price_zone_fkey FOREIGN KEY ("zone")
      REFERENCES "zone" (id) MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT
);

-- testovaci zaznamy
-- data za rok 2005
INSERT INTO price ( zone , action ,   valid_from ,  valid_to ,  price ,  period ) values ( 3 , 504 , '01-01-2005' , '12-31-2005 23:59:59' , 600 , 12 );
INSERT INTO price ( zone , action ,   valid_from ,  valid_to ,  price ,  period ) values ( 3 , 506 , '01-01-2005' , '12-31-2005 23:59:59' , 600 , 12 );
-- pro rok 2006
INSERT INTO price ( zone , action ,   valid_from , valid_to , price ,  period ) values ( 3 , 504 , '01-01-2006' , '08-31-2006  23:59:59' ,  500 , 12 );
INSERT INTO price ( zone , action ,   valid_from ,  price ,  period ) values ( 3 , 504 , '09-01-2006' ,  400 , 12 );
INSERT INTO price ( zone , action ,   valid_from ,  price ,  period ) values ( 3 , 506 , '01-01-2006' ,  500 , 12 );
-- ceny za enum domeny pouze DomainRenew 
INSERT INTO price ( zone , action ,   valid_from ,  price ,  period ) values ( 1 , 506 , '01-01-2006' ,  200 , 12 );
INSERT INTO price ( zone , action ,   valid_from ,  price ,  period ) values ( 2 , 506 , '01-01-2006' ,  200 , 12 );

