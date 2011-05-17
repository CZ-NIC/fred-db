
-- classifier of priced operation ( only 2 for domains so far )
-- DROP TABLE enum_operation CASCADE;
CREATE TABLE enum_operation (
        id SERIAL PRIMARY KEY,         
        operation varchar(64) UNIQUE NOT NULL
        );

INSERT INTO enum_operation  VALUES( 1 , 'CreateDomain'); -- registration fee
INSERT INTO enum_operation  VALUES( 2 , 'RenewDomain'); -- maintainance fee

select setval('enum_operation_id_seq', 2);

comment on table enum_operation is 'list of priced operation';
comment on column enum_operation.id is 'unique automatically generated identifier';
comment on column enum_operation.operation is 'operation';

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
INSERT INTO price_vat  VALUES ( 2 , '2009-12-31 23:00:00' , 0.1597 , 19 );
INSERT INTO price_vat  VALUES ( 3 , NULL , 0.1667 , 20 );

select setval('price_vat_id_seq', 2);

comment on table price_vat is 'Table of VAT validity (in case that VAT is changing in the future. Stores coefficient for VAT recount)';
comment on column price_vat.id is 'unique automatically generated identifier';
comment on column price_vat.valid_to is 'date of VAT change realization';
comment on column price_vat.koef is 'coefficient high for VAT recount';
comment on column price_vat.VAT is 'VAT high';
     
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

comment on table price_list is 'list of operation prices';
comment on column price_list.id is 'unique automatically generated identifier';
comment on column price_list.zone is 'link to zone, for which is price list valid if it is domain (if it is not domain then it is NULL)';
comment on column price_list.operation is 'for which action is price connected';
comment on column price_list.valid_from is 'from when is record valid';
comment on column price_list.valid_to is 'till when is record valid, if it is NULL then valid is unlimited';
comment on column price_list.price is 'cost of operation (for one year-12 months)';
comment on column price_list.period is 'period (in months) of payment, null if it is not periodic';
