---
--- Ticket #5796
---
--- THIS SCRIPT MUST BE RUN WITH SUPERUSER PRIVILEGES
--- SO THAT `COPY' CAN WORK
---

--drop table registrar_credit_transaction cascade;
--drop table registrar_credit cascade;

--drop table bank_payment_registrar_credit_transaction_map cascade;
--drop table invoice_registrar_credit_transaction_map;


--#!sql


----- backup old version of invoice_object_registry

COPY invoice_object_registry TO '/tmp/temp_upgrade_invoice_object_registry.csv';
COPY invoice_object_registry_price_map TO '/tmp/temp_upgrade_invoice_object_registry_price_map.csv';

-- we'll have to add NOT NULL COLUMN
TRUNCATE TABLE invoice_object_registry_price_map, invoice_object_registry;

--- last usage of bank_payment.invoice_id , bank_bayment will have removed invoice_id
COPY 
    (SELECT bp.id, bp.invoice_id  
    FROM bank_payment bp)
TO '/tmp/temp_upgrade_bank_payment.csv';





------------------------------------------------ schema changes 

ALTER TABLE bank_payment DROP COLUMN invoice_id;

ALTER TABLE invoice RENAME COLUMN zone TO zone_id; 
ALTER TABLE invoice RENAME COLUMN registrarid TO registrar_id;
ALTER TABLE invoice RENAME COLUMN prefix_type TO invoice_prefix_id;
ALTER TABLE invoice RENAME COLUMN credit TO balance;
ALTER TABLE invoice RENAME COLUMN price TO operations_price;
ALTER TABLE invoice ALTER COLUMN operations_price DROP NOT NULL;
ALTER TABLE invoice ALTER COLUMN vat TYPE numeric;

ALTER TABLE invoice_prefix RENAME COLUMN zone TO zone_id;

ALTER TABLE price_list RENAME COLUMN zone TO zone_id;
ALTER TABLE price_list RENAME COLUMN operation TO operation_id;
ALTER TABLE price_list RENAME COLUMN period TO quantity;
ALTER TABLE price_list ADD COLUMN enable_postpaid_operation boolean DEFAULT 'false';
 
ALTER TABLE invoice_object_registry RENAME TO invoice_operation;
ALTER TABLE invoice_operation RENAME COLUMN invoiceid TO ac_invoice_id;
ALTER TABLE invoice_operation RENAME COLUMN zone TO zone_id;
ALTER TABLE invoice_operation RENAME COLUMN registrarid TO registrar_id;
ALTER TABLE invoice_operation RENAME COLUMN objectid TO object_id;
ALTER TABLE invoice_operation RENAME COLUMN exdate TO date_to;
ALTER TABLE invoice_operation RENAME COLUMN period TO quantity;
ALTER TABLE invoice_operation RENAME COLUMN operation TO operation_id;
ALTER TABLE invoice_operation ADD COLUMN date_from date;


ALTER TABLE invoice_object_registry_price_map RENAME TO invoice_operation_charge_map;
ALTER TABLE invoice_operation_charge_map RENAME COLUMN id TO invoice_operation_id;
ALTER TABLE invoice_operation_charge_map RENAME COLUMN invoiceid TO invoice_id;

ALTER TABLE invoice_credit_payment_map RENAME COLUMN invoiceid TO ac_invoice_id;
ALTER TABLE invoice_credit_payment_map RENAME COLUMN ainvoiceid TO ad_invoice_id;

ALTER TABLE invoice_generation RENAME COLUMN zone TO zone_id; 
ALTER TABLE invoice_generation RENAME COLUMN registrarid TO registrar_id;
ALTER TABLE invoice_generation RENAME COLUMN invoiceid TO invoice_id;

ALTER TABLE registrarinvoice DROP COLUMN lastdate;

CREATE TABLE registrar_credit
(
    id BIGSERIAL PRIMARY KEY
    , credit numeric(10,2) NOT NULL DEFAULT 0
    , registrar_id bigint NOT NULL REFERENCES registrar(id)
    , zone_id bigint NOT NULL REFERENCES zone(id)
);

ALTER TABLE registrar_credit OWNER TO FRED;

COMMENT ON TABLE registrar_credit 
	IS 'current credit by registrar and zone';

CREATE TABLE registrar_credit_transaction
(
    id bigserial PRIMARY KEY
    , balance_change numeric(10,2) NOT NULL
    , registrar_credit_id bigint NOT NULL REFERENCES registrar_credit(id)
);


ALTER TABLE registrar_credit_transaction OWNER TO FRED;

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

ALTER FUNCTION registrar_credit_change_lock() OWNER TO FRED;

COMMENT ON FUNCTION registrar_credit_change_lock()
	IS 'check and lock insert into registrar_credit_transaction disable update and delete'; 

CREATE TRIGGER "trigger_registrar_credit_transaction"
  AFTER INSERT OR UPDATE OR DELETE ON registrar_credit_transaction
  FOR EACH ROW EXECUTE PROCEDURE registrar_credit_change_lock();

CREATE TABLE bank_payment_registrar_credit_transaction_map
(
    id BIGSERIAL PRIMARY KEY
    , bank_payment_id bigint NOT NULL REFERENCES bank_payment(id)
    , registrar_credit_transaction_id bigint UNIQUE NOT NULL REFERENCES registrar_credit_transaction(id)
);

ALTER TABLE bank_payment_registrar_credit_transaction_map OWNER TO FRED;

COMMENT ON TABLE bank_payment_registrar_credit_transaction_map
	IS 'payment assigned to credit items';

CREATE TABLE invoice_registrar_credit_transaction_map
(
    id BIGSERIAL PRIMARY KEY
    , invoice_id bigint NOT NULL REFERENCES invoice(id)
    , registrar_credit_transaction_id bigint UNIQUE NOT NULL REFERENCES registrar_credit_transaction(id)
);

ALTER TABLE invoice_registrar_credit_transaction_map OWNER TO FRED;

COMMENT ON TABLE invoice_registrar_credit_transaction_map
	IS 'positive credit item from payment assigned to deposit or account invoice';

--- we can use NOT NULL, table is truncated
ALTER TABLE invoice_operation ADD COLUMN registrar_credit_transaction_id bigint UNIQUE NOT NULL REFERENCES registrar_credit_transaction(id);







---------------------------------------migration

INSERT INTO price_list (zone_id, operation_id, valid_from, valid_to, price, quantity, enable_postpaid_operation)
VALUES (
(SELECT id FROM zone WHERE fqdn = 'cz')
, (SELECT id FROM enum_operation WHERE operation = 'GeneralEppOperation')
, now(), null, 0.10, 1, 'true');

UPDATE price_list SET quantity = 1 WHERE quantity = 0;

--UPDATE price_list pl SET enable_postpaid_operation = 'true' FROM enum_operation eo  
--WHERE pl.operation_id = eo.id AND eo.operation = 'GeneralEppOperation';

-- safer way to initialize everything needed
INSERT INTO registrar_credit SELECT nextval('registrar_credit_id_seq'), 0,r.id,  z.id FROM registrar r, zone z;

-- not possible yet due to data from some tests
-- INSERT INTO registrar_credit SELECT nextval('registrar_credit_id_seq'), 0, registrarid,  zone FROM registrarinvoice;



------restore files
--- temporary table to init the new tables
CREATE TEMP TABLE temp_bank_payment (
    id integer,
    invoice_id integer
);

COPY temp_bank_payment 
FROM '/tmp/temp_upgrade_bank_payment.csv';



-- restore saved invoice_object_registry (old name) 
-- this does not have date_from and registrar_credit_transaction_id yet - to match date from file
CREATE TEMP TABLE temp_invoice_operation (
    id integer NOT NULL PRIMARY KEY, -- unique primary key
    ac_invoice_id INTEGER, -- REFERENCES invoice (id) , -- id of invoice for which is item counted 
    CrDate timestamp NOT NULL DEFAULT now(),  -- billing date and time 
    object_id integer, --  REFERENCES object_registry (id),
    zone_id INTEGER, -- REFERENCES zone (id),
    registrar_id INTEGER NOT NULL, -- REFERENCES registrar, -- link to registrar 
    operation_id INTEGER NOT NULL, -- REFERENCES enum_operation, -- operation type of registration or renew
    date_to date default NULL,  -- final ExDate only for RENEW 
    quantity integer default 0 -- number of unit for renew in months
);

COPY temp_invoice_operation 
FROM '/tmp/temp_upgrade_invoice_object_registry.csv';


CREATE TEMP TABLE temp_invoice_operation_charge_map (
    invoice_operation_id INTEGER, -- REFERENCES invoice_operation(ID),
    invoice_id INTEGER, -- REFERENCES invoice (id), -- id of advanced invoice
    price numeric(10,2) NOT NULL default 0 , -- cost for operation
    PRIMARY KEY ( invoice_operation_id ,  invoice_id ) -- unique key
);

COPY temp_invoice_operation_charge_map
FROM '/tmp/temp_upgrade_invoice_object_registry_price_map.csv';

--- data for (indirectly) filling registrar_credit_transaction , bank_payment_registrar_credit_transaction_map, invoice_registrar_credit_transaction_map 
CREATE TEMP TABLE temp_rct_plus
(
    id bigserial PRIMARY KEY,
    balance_change numeric(10,2) NOT NULL,
    registrar_credit_id bigint NOT NULL, --REFERENCES registrar_credit(id),
    invoice_id bigint, -- REFERENCES invoice(id),
    bank_payment_id bigint -- REFERENCES bank_payment(id)
);

INSERT INTO temp_rct_plus 
    (SELECT nextval('registrar_credit_transaction_id_seq'), i.balance,rc.id , i.id, tbp.id
    FROM temp_bank_payment tbp JOIN invoice i ON tbp.invoice_id = i.id
    JOIN registrar_credit rc ON i.registrar_id = rc.registrar_id and  i.zone_id = rc.zone_id);


-------------init new tables
--insert credit changes from deposits
INSERT INTO registrar_credit_transaction 
SELECT id, balance_change, registrar_credit_id 
    FROM temp_rct_plus;


--insert bank_payment_registrar_credit_transaction_map
INSERT INTO bank_payment_registrar_credit_transaction_map 
SELECT nextval('bank_payment_registrar_credit_transaction_map_id_seq'), rct.bank_payment_id, rct.id
FROM temp_rct_plus rct
WHERE rct.bank_payment_id IS NOT NULL;


--insert invoice_registrar_credit_transaction_map
INSERT INTO invoice_registrar_credit_transaction_map 
SELECT nextval('invoice_registrar_credit_transaction_map_id_seq'), rct.invoice_id, rct.id
FROM temp_rct_plus rct
WHERE rct.invoice_id IS NOT NULL;



---------------------minus credit chanes 
CREATE TEMP TABLE temp_rct_minus
(
    id bigserial PRIMARY KEY
    , balance_change numeric(10,2) NOT NULL
    , registrar_credit_id bigint NOT NULL -- REFERENCES registrar_credit(id)
    , invoice_operation_id bigint -- REFERENCES invoice_operation(id)
);

INSERT INTO temp_rct_minus
    (SELECT nextval('registrar_credit_transaction_id_seq'), 
    sum(iocm.price) * -1, rc.id, io.id
    FROM temp_invoice_operation io 
    JOIN temp_invoice_operation_charge_map iocm ON io.id = iocm.invoice_operation_id
    JOIN registrar_credit rc ON rc.zone_id = io.zone_id AND rc.registrar_id = io.registrar_id
    GROUP BY iocm.invoice_operation_id, rc.id, io.id);


--insert credit changes from operations (minus)
INSERT INTO registrar_credit_transaction
SELECT rct.id, rct.balance_change, rct.registrar_credit_id
FROM temp_rct_minus rct;

-- fill new version of invoice_operation (NOT NULL column was added) with data from the old one 
-- exclude new column date_from
-- plus data for FK(registrar_credit_transaction_id)
INSERT INTO invoice_operation (id, ac_invoice_id, crdate, object_id, zone_id, registrar_id, operation_id, date_to, quantity,     registrar_credit_transaction_id)
 SELECT tio.id, tio.ac_invoice_id, tio.crdate, tio.object_id, tio.zone_id, tio.registrar_id, tio.operation_id, tio.date_to, tio.quantity,      rct.id
FROM temp_invoice_operation tio
JOIN temp_rct_minus rct ON tio.id = rct.invoice_operation_id;

INSERT INTO invoice_operation_charge_map 
SELECT * FROM temp_invoice_operation_charge_map;


