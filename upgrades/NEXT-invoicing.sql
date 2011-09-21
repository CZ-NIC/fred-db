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

COPY invoice TO '/tmp/temp_upgrade_invoice.csv';
COPY invoice_prefix TO '/tmp/temp_upgrade_invoice_prefix.csv';
COPY price_list TO '/tmp/temp_upgrade_price_list.csv';
COPY invoice_credit_payment_map TO '/tmp/temp_upgrade_invoice_credit_payment_map.csv';
COPY invoice_generation TO '/tmp/temp_upgrade_invoice_generation.csv';

COPY invoice_object_registry TO '/tmp/temp_upgrade_invoice_object_registry.csv';
COPY invoice_object_registry_price_map TO '/tmp/temp_upgrade_invoice_object_registry_price_map.csv';

--- last usage of bank_payment.invoice_id , bank_bayment will have removed invoice_id
COPY 
    (SELECT bp.id, bp.invoice_id  
    FROM bank_payment bp)
TO '/tmp/temp_upgrade_bank_payment.csv';




--- backup of old tables - these won't be part of replication
ALTER TABLE invoice RENAME TO old_invoice;


ALTER TABLE invoice_prefix DROP CONSTRAINT invoice_prefix_zone_key;
ALTER TABLE invoice_prefix RENAME TO old_invoice_prefix;
ALTER TABLE price_list RENAME TO old_price_list;
ALTER TABLE invoice_credit_payment_map RENAME TO old_invoice_credit_payment_map;
ALTER TABLE invoice_generation RENAME TO old_invoice_generation;
ALTER TABLE invoice_object_registry RENAME TO old_invoice_object_registry;
ALTER TABLE invoice_object_registry_price_map RENAME TO old_invoice_object_registry_price_map;





------------------------------------------------ schema changes 

-- ALTER TABLE bank_payment DROP COLUMN invoice_id;
-- keep it to be sure...
ALTER TABLE bank_payment DROP CONSTRAINT bank_payment_invoice_id_fkey;

-- operation price list 
CREATE TABLE price_list
(
  id serial PRIMARY KEY, -- primary key
  zone_id integer not null  REFERENCES  zone , -- link to zone, for which is price list valid if it is domain (if it isn't domain then it is NULL)
  operation_id integer NOT NULL REFERENCES  enum_operation, -- for which action is a price connected  
  valid_from timestamp NOT NULL, -- from when is record valid 
  valid_to timestamp default NULL, -- till when is record valid, if it is NULL, it isn't limited
  price numeric(10,2) NOT NULL default 0, -- cost of operation ( for year 12 months )
  quantity integer default 12, -- if it isn't periodic operation NULL 
  enable_postpaid_operation boolean DEFAULT 'false'
);

ALTER TABLE price_list OWNER TO fred;

comment on table price_list is 'list of operation prices';
comment on column price_list.id is 'unique automatically generated identifier';
comment on column price_list.zone_id is 'link to zone, for which is price list valid if it is domain (if it is not domain then it is NULL)';
comment on column price_list.operation_id is 'for which action is price connected';
comment on column price_list.valid_from is 'from when is record valid';
comment on column price_list.valid_to is 'till when is record valid, if it is NULL then valid is unlimited';
comment on column price_list.price is 'cost of operation (for one year-12 months)';
COMMENT ON COLUMN price_list.quantity IS 'quantity of operation or period (in years) of operation';
comment on column price_list.enable_postpaid_operation is 'true if operation of this specific type can be executed when credit is not sufficient and create debt';


CREATE TABLE invoice_prefix
(
id serial NOT NULL PRIMARY KEY, 
zone_id INTEGER REFERENCES zone (id),
typ integer default 0,  -- invoice type 0 advanced 1 normal
year numeric NOT NULL, --for which year  
prefix bigint -- counter with prefix of number line invoice 
, CONSTRAINT invoice_prefix_zone_key UNIQUE (zone_id, typ, year)
);

ALTER TABLE invoice_prefix OWNER TO fred;

comment on column invoice_prefix.zone_id is 'reference to zone';
comment on column invoice_prefix.typ is 'invoice type (0-advanced, 1-normal)';
comment on column invoice_prefix.year is 'for which year';
comment on column invoice_prefix.prefix is 'counter with prefix of number of invoice';



-- advance invoices 
CREATE TABLE invoice
(
id serial NOT NULL PRIMARY KEY, -- unique primary key
zone_id INTEGER REFERENCES zone (id),
CrDate timestamp NOT NULL DEFAULT now(),  -- date and time of invoice creation 
TaxDate date NOT NULL, -- date of taxable fulfilment ( when payment cames by advance FA)
prefix bigint UNIQUE NOT NULL , -- 9 placed number of invoice from invoice_prefix.prefix counted via TaxDate 
registrar_id INTEGER NOT NULL REFERENCES registrar, -- link to registrar
-- TODO registrarhistoryID for links to right ICO and DIC addresses
balance numeric(10,2) DEFAULT 0.0, -- credit from which is taken till zero if it is NULL it is normal invoice 
operations_price numeric(10,2) DEFAULT 0.0, -- account invoice sum price of operations  
VAT numeric NOT NULL, -- VAT percent used for this invoice)
total numeric(10,2) NOT NULL  DEFAULT 0.0 ,  -- amount without tax ( for accounting is same as price = total amount without tax);
totalVAT numeric(10,2)  NOT NULL DEFAULT 0.0 , -- tax paid (0 for accounted tax it is paid at advance invoice)
invoice_prefix_id INTEGER NOT NULL REFERENCES invoice_prefix(ID), --  invoice type  from which year is anf which type is according to prefix 
file INTEGER REFERENCES files ,-- link to generated PDF (it can be null till is generated)
fileXML INTEGER REFERENCES files -- link to generated XML (it can be null till is generated) 
);

ALTER TABLE invoice OWNER TO fred;

comment on table invoice is
'table of invoices';
comment on column invoice.id is 'unique automatically generated identifier';
comment on column invoice.zone_id is 'reference to zone';
comment on column invoice.CrDate is 'date and time of invoice creation';
comment on column invoice.TaxDate is 'date of taxable fulfilment (when payment cames by advance FA)';
comment on column invoice.prefix is '9 placed number of invoice from invoice_prefix.prefix counted via TaxDate';
comment on column invoice.registrar_id is 'link to registrar';
comment on column invoice.balance is '*advance invoice: balance from which operations are charged *account invoice: amount to be paid (0 in case there is no debt)';
comment on column invoice.operations_price is 'sum of operations without tax';
comment on column invoice.VAT is 'VAT hight from account';
comment on column invoice.total is 'amount without tax';
comment on column invoice.totalVAT is 'tax paid';
comment on column invoice.invoice_prefix_id is 'invoice type - which year and type (accounting/advance) ';
comment on column invoice.file is 'link to generated PDF file, it can be NULL till file is generated';
comment on column invoice.fileXML is 'link to generated XML file, it can be NULL till file is generated';


CREATE TABLE registrar_credit
(
    id BIGSERIAL PRIMARY KEY
    , credit numeric(30,2) NOT NULL DEFAULT 0
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


CREATE TABLE invoice_operation
(
id serial NOT NULL PRIMARY KEY, -- unique primary key
ac_invoice_id INTEGER REFERENCES invoice (id) , -- id of invoice for which is item counted 
CrDate timestamp NOT NULL DEFAULT now(),  -- billing date and time 
object_id integer  REFERENCES object_registry (id),
zone_id INTEGER REFERENCES zone (id),
registrar_id INTEGER NOT NULL REFERENCES registrar, -- link to registrar 
operation_id INTEGER NOT NULL REFERENCES enum_operation, -- operation type of registration or renew
date_from date,
date_to date default NULL,  -- final ExDate only for RENEW 
quantity integer default 0, -- number of unit for renew in months
registrar_credit_transaction_id bigint UNIQUE NOT NULL REFERENCES registrar_credit_transaction(id)
);

ALTER TABLE invoice_operation OWNER TO fred;

comment on column invoice_operation.id is 'unique automatically generated identifier';
comment on column invoice_operation.ac_invoice_id is 'id of invoice for which is item counted';
comment on column invoice_operation.CrDate is 'billing date and time';
comment on column invoice_operation.zone_id is 'link to zone';
comment on column invoice_operation.registrar_id is 'link to registrar';
comment on column invoice_operation.operation_id is 'operation type of registration or renew';
comment on column invoice_operation.date_to is 'expiration date only for RENEW';
comment on column invoice_operation.quantity is 'number of operations or number of months for renew';

CREATE INDEX invoice_operation_object_id_idx
       ON invoice_operation (object_id);

CREATE TABLE invoice_operation_charge_map
(
invoice_operation_id INTEGER REFERENCES invoice_operation(ID),
invoice_id INTEGER REFERENCES invoice (id), -- id of advanced invoice
price numeric(10,2) NOT NULL default 0 , -- cost for operation
PRIMARY KEY ( invoice_operation_id ,  invoice_id ) -- unique key
);

ALTER TABLE invoice_operation_charge_map OWNER TO fred;

comment on column invoice_operation_charge_map.invoice_id is 'id of advanced invoice';
comment on column invoice_operation_charge_map.price is 'operation cost';

CREATE INDEX invoice_operation_charge_map_invoice_id_idx
       ON invoice_operation_charge_map (invoice_id);




--  account tabel of advance invoices
CREATE TABLE invoice_credit_payment_map
(
ac_invoice_id INTEGER REFERENCES invoice (id) , -- id of normal invoice
ad_invoice_id INTEGER REFERENCES invoice (id) , -- id of advance invoice
credit numeric(10,2)  NOT NULL DEFAULT 0.0, -- seized credit
balance numeric(10,2)  NOT NULL DEFAULT 0.0, -- actual tax balance advance invoice 
PRIMARY KEY (ac_invoice_id, ad_invoice_id)
);

ALTER TABLE invoice_credit_payment_map OWNER TO fred;

comment on column invoice_credit_payment_map.ac_invoice_id is 'id of normal invoice';
comment on column invoice_credit_payment_map.ad_invoice_id is 'id of advance invoice';
comment on column invoice_credit_payment_map.credit is 'seized credit';
comment on column invoice_credit_payment_map.balance is 'actual tax balance advance invoice';

CREATE INDEX invoice_credit_payment_map_ac_invoice_id_idx
       ON invoice_credit_payment_map (ac_invoice_id);
CREATE INDEX invoice_credit_payment_map_ad_invoice_id_idx
       ON invoice_credit_payment_map (ad_invoice_id);



-- invoices generation
CREATE TABLE invoice_generation
(
id serial NOT NULL PRIMARY KEY, -- unique primary key
FromDate date NOT  NULL , -- local date account period from is taken 00:00:00 
ToDate date NOT NULL  , -- 23:59:59 is taken into date
registrar_id INTEGER NOT NULL REFERENCES registrar, -- link to registrar
zone_id INTEGER REFERENCES Zone (id),
invoice_id INTEGER REFERENCES invoice (id) -- id of normal invoice
);

ALTER TABLE invoice_generation OWNER TO fred;

comment on column invoice_generation.id is 'unique automatically generated identifier';
comment on column invoice_generation.invoice_id is 'id of normal invoice';






ALTER TABLE registrarinvoice DROP COLUMN lastdate;


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








---------------------------------------migration

--legacy invoices from old system
CREATE TEMPORARY TABLE tmp_zalohy (
    prefix bigint NOT NULL,
    credit numeric(10,2) 
);
INSERT INTO tmp_zalohy VALUES (2407000660,168060.00);
INSERT INTO tmp_zalohy VALUES (2407000653,7768.70);
INSERT INTO tmp_zalohy VALUES (2406000831,142604.50);
INSERT INTO tmp_zalohy VALUES (2407000624,336120.00);
INSERT INTO tmp_zalohy VALUES (2407000514,107490.30);
INSERT INTO tmp_zalohy VALUES (2407000649,42015.00);
INSERT INTO tmp_zalohy VALUES (2407000645,33066.00);
INSERT INTO tmp_zalohy VALUES (2407000664,928.60);
INSERT INTO tmp_zalohy VALUES (2407000663,556777.57);
INSERT INTO tmp_zalohy VALUES (2407000392,13008.10);
INSERT INTO tmp_zalohy VALUES (2407000602,104304.20);
INSERT INTO tmp_zalohy VALUES (2407000669,16806.00);
INSERT INTO tmp_zalohy VALUES (2407000656,23654.80);
INSERT INTO tmp_zalohy VALUES (2407000661,0.00);
INSERT INTO tmp_zalohy VALUES (2407000667,27702.70);
INSERT INTO tmp_zalohy VALUES (2407000662,0.00);
INSERT INTO tmp_zalohy VALUES (2407000658,0.00);
INSERT INTO tmp_zalohy VALUES (2407000655,0.00);
INSERT INTO tmp_zalohy VALUES (2407000651,0.00);
INSERT INTO tmp_zalohy VALUES (2407000668,196273.90);
INSERT INTO tmp_zalohy VALUES (2407000648,0.00);
INSERT INTO tmp_zalohy VALUES (2407000670,47498.00);
INSERT INTO tmp_zalohy VALUES (2407000671,100836.00);
INSERT INTO tmp_zalohy VALUES (2407000672,25209.00);
INSERT INTO tmp_zalohy VALUES (2407000673,92433.00);
INSERT INTO tmp_zalohy VALUES (2407000675,16806.00);
INSERT INTO tmp_zalohy VALUES (2407000676,100836.00);
INSERT INTO tmp_zalohy VALUES (2407000677,25209.00);
INSERT INTO tmp_zalohy VALUES (2407000678,65543.40);
INSERT INTO tmp_zalohy VALUES (2407000679,100836.00);
INSERT INTO tmp_zalohy VALUES (2407000674,244587.74);
INSERT INTO tmp_zalohy VALUES (2407000665,503640.40);
INSERT INTO tmp_zalohy VALUES (2407000642,14914.80);
INSERT INTO tmp_zalohy VALUES (2407000666,330994.20);


UPDATE price_list SET quantity = 1 WHERE quantity = 0;

UPDATE price_list SET quantity = 1 
FROM enum_operation 
WHERE operation_id = enum_operation.id 
    AND quantity = 12 
    AND enum_operation.operation = 'RenewDomain';
    
COMMENT ON COLUMN price_list.quantity IS 'quantity of operation or period (in years) of operation';    

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

CREATE TEMP TABLE temp_invoice_operation_charge_map (
    invoice_operation_id INTEGER, -- REFERENCES invoice_operation(ID),
    invoice_id INTEGER, -- REFERENCES invoice (id), -- id of advanced invoice
    price numeric(10,2) NOT NULL default 0 , -- cost for operation
    PRIMARY KEY ( invoice_operation_id ,  invoice_id ) -- unique key
);


----------------------------- restore from files
COPY price_list(id, zone_id, operation_id, valid_from, valid_to, price, quantity) FROM '/tmp/temp_upgrade_price_list.csv';
select setval( 'price_list_id_seq1'::regclass,  (select max(id) from price_list));
COPY invoice_prefix FROM '/tmp/temp_upgrade_invoice_prefix.csv';
select setval( 'invoice_prefix_id_seq1'::regclass,  (select max(id) from invoice_prefix));
COPY invoice FROM '/tmp/temp_upgrade_invoice.csv';
select setval( 'invoice_id_seq1'::regclass,  (select max(id) from invoice));
COPY invoice_credit_payment_map FROM '/tmp/temp_upgrade_invoice_credit_payment_map.csv';
COPY invoice_generation FROM '/tmp/temp_upgrade_invoice_generation.csv';
select setval( 'invoice_generation_id_seq1'::regclass,  (select max(id) from invoice_generation));

INSERT INTO price_list (zone_id, operation_id, valid_from, valid_to, price, quantity, enable_postpaid_operation)
VALUES (
(SELECT id FROM zone WHERE fqdn = 'cz')
, (SELECT id FROM enum_operation WHERE operation = 'GeneralEppOperation')
, now(), null, 0.10, 1, 'true');

UPDATE price_list SET quantity = 1 
FROM enum_operation 
WHERE operation_id = enum_operation.id 
    AND quantity = 12 
    AND enum_operation.operation = 'RenewDomain';

COPY temp_invoice_operation 
FROM '/tmp/temp_upgrade_invoice_object_registry.csv';

/*
-- in case we need to restore it directly
COPY invoice_operation (id, ac_invoice_id, crdate, object_id, zone_id, registrar_id, operation_id, date_to, quantity)
FROM '/tmp/temp_upgrade_invoice_object_registry.csv';
*/

COPY temp_invoice_operation_charge_map
FROM '/tmp/temp_upgrade_invoice_object_registry_price_map.csv';

--- data for (indirectly) filling registrar_credit_transaction , bank_payment_registrar_credit_transaction_map, invoice_registrar_credit_transaction_map 
CREATE TEMP TABLE temp_rct_plus
(
    id bigserial PRIMARY KEY,
    balance_change numeric(10,2) NOT NULL,
    registrar_credit_id bigint NOT NULL, --REFERENCES registrar_credit(id),
    invoice_id bigint NOT NULL, -- REFERENCES invoice(id),
    bank_payment_id bigint -- REFERENCES bank_payment(id)
);

INSERT INTO temp_rct_plus 
    (SELECT nextval('registrar_credit_transaction_id_seq'), COALESCE(ti.credit, i.total),  rc.id , i.id, tbp.id
    FROM invoice i
    LEFT JOIN temp_bank_payment tbp ON tbp.invoice_id = i.id
    JOIN registrar_credit rc ON i.registrar_id = rc.registrar_id and  i.zone_id = rc.zone_id 
    LEFT JOIN tmp_zalohy ti ON ti.prefix=i.prefix 
    WHERE i.balance IS NOT NULL);


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
FROM temp_rct_plus rct;



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

----- fill registrar_credit

UPDATE registrar_credit SET credit = reg_credit.balance_change_sum 
FROM (SELECT registrar_credit_id, sum(balance_change) AS balance_change_sum
    FROM registrar_credit_transaction
    GROUP BY registrar_credit_id) AS reg_credit
WHERE id = reg_credit.registrar_credit_id ;



-- fill new version of invoice_operation (NOT NULL column was added) with data from the old one 
-- exclude new column date_from
-- plus data for FK(registrar_credit_transaction_id)
INSERT INTO invoice_operation (id, ac_invoice_id, crdate, object_id, zone_id, registrar_id, operation_id, date_to, quantity,     registrar_credit_transaction_id)
 SELECT tio.id, tio.ac_invoice_id, tio.crdate, tio.object_id, tio.zone_id, tio.registrar_id, tio.operation_id, tio.date_to, tio.quantity,      rct.id
FROM temp_invoice_operation tio
JOIN temp_rct_minus rct ON tio.id = rct.invoice_operation_id;

INSERT INTO invoice_operation_charge_map 
SELECT * FROM temp_invoice_operation_charge_map;




--- create trigger
CREATE TRIGGER "trigger_registrar_credit_transaction"
  AFTER INSERT OR UPDATE OR DELETE ON registrar_credit_transaction
  FOR EACH ROW EXECUTE PROCEDURE registrar_credit_change_lock();

