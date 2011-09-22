---
--- Ticket #5796
---
--- THIS SCRIPT MUST BE RUN WITH SUPERUSER PRIVILEGES
--- SO THAT `COPY' CAN WORK
---

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


---
--- Ticket #5666
---

CREATE TABLE registrar_disconnect (
    id SERIAL PRIMARY KEY,
    registrarid INTEGER NOT NULL REFERENCES registrar(id),
    blocked_from TIMESTAMP NOT NULL DEFAULT now(),
    blocked_to TIMESTAMP,
    unblock_request_id BIGINT
)

CREATE TABLE request_fee_registrar_parameter (
registrar_id INTEGER PRIMARY KEY REFERENCES registrar(id),
request_price_limit numeric(10, 2) NOT NULL,
email varchar(200) NOT NULL,
telephone varchar(64) NOT NULL
-- [ contact_id REFERENCES contact(id) ]
);

ALTER TABLE request_fee_parameter ADD COLUMN zone INTEGER REFERENCES zone(id);

