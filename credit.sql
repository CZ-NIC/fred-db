
-- ciselnik zpoplatnenych operaci ( zatim dve pro domeny )
-- DROP TABLE enum_operation CASCADE;
CREATE TABLE enum_operation (
        id SERIAL PRIMARY KEY,         
        operation varchar(64) UNIQUE NOT NULL
        );

INSERT INTO enum_operation  VALUES( 1 , 'CreateDomain'); -- registracni poplatek
INSERT INTO enum_operation  VALUES( 2 , 'RenewDomain'); -- udrzovaci poplatek

-- tabulka platnosti DPH ( pro pripad ze se DPH bude v budoucnu menit ) a take aby bylo kde ulozeno
CREATE TABLE price_vat
(
  id serial PRIMARY KEY, -- primarni klic
  valid_to timestamp default NULL, -- datum kdy probehne zmena DPH    
  VAT numeric default 19 -- vyse DPH 
);

INSERT INTO price_vat ( id , valid_to ,  VAT )  VALUES ( 1 , '2004-04-30 22:00:00' , 22 ); -- uvedeno v UTC CEST +2:00
INSERT INTO price_vat ( id , valid_to , VAT )  VALUES ( 2 , NULL , 19 );

     
-- cenik operaci
CREATE TABLE price_list
(
  id serial PRIMARY KEY, -- primarni klic
  zone integer not null  REFERENCES  zone , -- odkaz na zonu pro kterou cenik plati pokud se jedna o domenu, pokud ne je to NULL
  operation integer NOT NULL REFERENCES  enum_operation, -- na jakou akci se cena vaze 
  valid_from timestamp NOT NULL, -- od kdy zaznam plati
  valid_to timestamp default NULL, -- do kdy zaznam plati, pokud je NULL, neni omezen
  price numeric(10,2) NOT NULL default 0, -- cena operace ( za rok 12 mesicu )
  period integer default 12 -- pokud neni periodicka operace NULL
);

-- testovaci zaznamy
-- ceny za enum domeny pouze DomainRenew 

INSERT INTO price_list ( id , zone , operation ,   valid_from ,  price ,  period ) values (1, 1 , 1 , '01-01-2007' ,  1 , 12 ); -- registrace
INSERT INTO price_list ( id , zone , operation ,   valid_from ,  price ,  period ) values (2, 1 , 2 , '01-01-2007' ,  50 , 12 ); -- prodlouzeni

INSERT INTO price_list ( id , zone , operation ,   valid_from ,  price ,  period ) values (3 , 3 , 1 , '01-01-2007' ,  -50 , 12 ); -- registrace ( 1 rok pouze 50 Kc )
INSERT INTO price_list ( id , zone , operation ,   valid_from ,  price ,  period ) values (4 , 3 , 2 , '01-01-2007' ,  100 , 12 ); -- prodlouzeni

