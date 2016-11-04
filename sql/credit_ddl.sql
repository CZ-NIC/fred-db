
-- classifier of priced operation ( only 2 for domains so far )
-- DROP TABLE enum_operation CASCADE;
CREATE TABLE enum_operation (
        id SERIAL CONSTRAINT enum_operation_pkey PRIMARY KEY,
        operation varchar(64) CONSTRAINT enum_operation_operation_key UNIQUE NOT NULL
        );

INSERT INTO enum_operation  VALUES( 1 , 'CreateDomain'); -- registration fee
INSERT INTO enum_operation  VALUES( 2 , 'RenewDomain'); -- maintainance fee
--number 3 is request fee in request_fee_dml.sql
INSERT INTO enum_operation (id, operation) VALUES (4, 'Fine'); -- annual registry contractual fine
INSERT INTO enum_operation (id, operation) VALUES (5, 'Fee'); -- annual registry contractual fee

select setval('enum_operation_id_seq', 2);

comment on table enum_operation is 'list of priced operation';
comment on column enum_operation.id is 'unique automatically generated identifier';
comment on column enum_operation.operation is 'operation';

-- tabel of VAT validity (in case that VAT is changing in the future) 
-- saving of coefficient for VAT recount

CREATE TABLE price_vat
(
  id serial CONSTRAINT price_vat_pkey PRIMARY KEY, -- primary key
  valid_to timestamp default NULL, -- date when VAT change is realized
  koef numeric, -- coefficient high for VAT recount
  VAT numeric default 19 -- VAT high
);

INSERT INTO price_vat   VALUES ( 1 , '2004-04-30 22:00:00' , 0.1803 ,  22 ); -- to be in UTC CEST +2:00
INSERT INTO price_vat  VALUES ( 2 , '2009-12-31 23:00:00' , 0.1597 , 19 );
INSERT INTO price_vat  VALUES ( 3 , NULL , 0.1667 , 20 );

select setval('price_vat_id_seq', 3);

comment on table price_vat is 'Table of VAT validity (in case that VAT is changing in the future. Stores coefficient for VAT recount)';
comment on column price_vat.id is 'unique automatically generated identifier';
comment on column price_vat.valid_to is 'date of VAT change realization';
comment on column price_vat.koef is 'coefficient high for VAT recount';
comment on column price_vat.VAT is 'VAT high';
     
-- operation price list 
CREATE TABLE price_list
(
  id serial CONSTRAINT price_list_pkey PRIMARY KEY, -- primary key
  zone_id integer not null CONSTRAINT price_list_zone_id_fkey REFERENCES  zone , -- link to zone, for which is price list valid if it is domain (if it isn't domain then it is NULL)
  operation_id integer NOT NULL CONSTRAINT price_list_operation_id_fkey REFERENCES  enum_operation, -- for which action is a price connected  
  valid_from timestamp NOT NULL, -- from when is record valid 
  valid_to timestamp default NULL, -- till when is record valid, if it is NULL, it isn't limited
  price numeric(10,2) NOT NULL default 0, -- cost of operation ( for year 12 months )
  quantity integer default 12 NOT NULL,
  enable_postpaid_operation boolean DEFAULT 'false' NOT NULL
);

comment on table price_list is 'list of operation prices';
comment on column price_list.id is 'unique automatically generated identifier';
comment on column price_list.zone_id is 'link to zone, for which is price list valid if it is domain (if it is not domain then it is NULL)';
comment on column price_list.operation_id is 'for which action is price connected';
comment on column price_list.valid_from is 'from when is record valid';
comment on column price_list.valid_to is 'till when is record valid, if it is NULL then valid is unlimited';
comment on column price_list.price is 'cost of operation (for one year-12 months)';
comment on column price_list.quantity is 'quantity of operation or period (in months) of payment';
comment on column price_list.enable_postpaid_operation is 'true if operation of this specific type can be executed when credit is not sufficient and create debt';

CREATE OR REPLACE FUNCTION check_price_list()
    RETURNS trigger AS
$BODY$
BEGIN
    IF NEW.valid_from > COALESCE(NEW.valid_to, 'infinity'::timestamp) THEN
        RAISE EXCEPTION 'invalid price_list item: valid_from > valid_to';
    END IF;
    IF EXISTS (
        SELECT 1 FROM price_list
          WHERE id <> NEW.id
          AND zone_id = NEW.zone_id
          AND operation_id=NEW.operation_id
          AND (valid_from , COALESCE(valid_to, 'infinity'::timestamp))
            OVERLAPS (NEW.valid_from , COALESCE(NEW.valid_to, 'infinity'::timestamp))
    ) THEN
        RAISE EXCEPTION 'price_list item overlaps';
    END IF;
    RETURN NEW;
END;
$BODY$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_price_list
  AFTER INSERT OR UPDATE ON price_list
  FOR EACH ROW EXECUTE PROCEDURE check_price_list();



CREATE TABLE registrar_credit
(
    id BIGSERIAL CONSTRAINT registrar_credit_pkey PRIMARY KEY
    , credit numeric(30,2) NOT NULL DEFAULT 0
    , registrar_id bigint NOT NULL CONSTRAINT registrar_credit_registrar_id_fkey REFERENCES registrar(id)
    , zone_id bigint NOT NULL CONSTRAINT registrar_credit_zone_id_fkey REFERENCES zone(id),
    CONSTRAINT registrar_credit_unique_key UNIQUE (registrar_id, zone_id)
);

COMMENT ON TABLE registrar_credit 
	IS 'current credit by registrar and zone';

CREATE TABLE registrar_credit_transaction
(
    id bigserial CONSTRAINT registrar_credit_transaction_pkey PRIMARY KEY
    , balance_change numeric(10,2) NOT NULL
    , registrar_credit_id bigint NOT NULL CONSTRAINT registrar_credit_transaction_registrar_credit_id_fkey REFERENCES registrar_credit(id)
);

COMMENT ON TABLE registrar_credit_transaction 
	IS 'balance changes';

-- locked registrar and zone credit account insert, disabled update and delete
CREATE OR REPLACE FUNCTION registrar_credit_change_lock()
RETURNS "trigger" AS $$
DECLARE
    registrar_credit_result RECORD;
BEGIN
    IF TG_OP = 'INSERT' THEN
        SELECT id, credit FROM registrar_credit INTO registrar_credit_result
            WHERE id = NEW.registrar_credit_id FOR UPDATE;
        IF FOUND THEN
            UPDATE registrar_credit 
                SET credit = credit + NEW.balance_change
                WHERE id = registrar_credit_result.id;
        ELSE
            RAISE EXCEPTION 'Invalid registrar_credit_id';
        END IF;
    ELSE
        RAISE EXCEPTION 'Unallowed operation to registrar_credit_transaction';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION registrar_credit_change_lock()
	IS 'check and lock insert into registrar_credit_transaction disable update and delete'; 

CREATE TRIGGER "trigger_registrar_credit_transaction"
  AFTER INSERT OR UPDATE OR DELETE ON registrar_credit_transaction
  FOR EACH ROW EXECUTE PROCEDURE registrar_credit_change_lock();


