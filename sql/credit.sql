
-- classifier of priced operation ( only 2 for domains so far )
-- DROP TABLE enum_operation CASCADE;
CREATE TABLE enum_operation (
        id SERIAL PRIMARY KEY,         
        operation varchar(64) UNIQUE NOT NULL
        );

INSERT INTO enum_operation  VALUES( 1 , 'CreateDomain'); -- registration fee
INSERT INTO enum_operation  VALUES( 2 , 'RenewDomain'); -- maintainance fee

-- tabel of VAT validity (in case that VAT is changing in the future) 
-- saving of coefficient for VAT recount

CREATE TABLE price_vat
(
  id serial PRIMARY KEY, -- primary key
  valid_to timestamp default NULL, -- date when VAT change is realized
  koef real, -- coefficient high for VAT recount
  VAT numeric default 19 -- VAT high
);

INSERT INTO price_vat   VALUES ( 1 , '2004-04-30 22:00:00' , 0.1803 ,  22 ); -- to be in UTC CEST +2:00
INSERT INTO price_vat  VALUES ( 2 , NULL , 0.1597 , 19 );


     
-- operation price list 
CREATE TABLE price_list
(
  id serial PRIMARY KEY, -- primary key
  zone integer not null  REFERENCES  zone , -- link to zone, for which is price list valid if it is domain (if it isn't domain then it is NULL)
  operation integer NOT NULL REFERENCES  enum_operation, -- for which action is a price connected  
  valid_from timestamp NOT NULL, -- from when is record valid 
  valid_to timestamp default NULL, -- till when is record valid, if it is NULL, it isn't limited
  price numeric(10,2) NOT NULL default 0, -- cost of operation ( for year 12 months )
  period integer default 12 -- if it isn't periodic operation NULL 
);

-- testing records 
-- prices for enum domains only DomainRenew 
-- ENUM trial working only renew operations are priced 
-- from 22 January 14:00  CEST, till when is free
INSERT into price_list  values ( 1 , 1 , 2 , '2007-01-22 13:00:00' , NULL , 1.00 , 12 );
--  price for domain create operations are zero
INSERT into price_list  values ( 2 , 1 , 1 , '2007-01-22 13:00:00' , NULL , 0.00 , 12 );

--INSERT INTO price_list ( id , zone , operation ,   valid_from ,  price ,  period ) values (1, 1 , 1 , '01-01-2007' ,  1 , 12 ); -- registration
--INSERT INTO price_list ( id , zone , operation ,   valid_from ,  price ,  period ) values (2, 1 , 2 , '01-01-2007' ,  50 , 12 ); -- renew

--INSERT INTO price_list ( id , zone , operation ,   valid_from ,  price ,  period ) values (3 , 3 , 1 , '01-01-2007' ,  -50 , 12 ); -- registration ( one year only for fifty CZK )
--INSERT INTO price_list ( id , zone , operation ,   valid_from ,  price ,  period ) values (4 , 3 , 2 , '01-01-2007' ,  100 , 12 ); -- renew 

