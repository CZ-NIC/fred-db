---
--- Ticket #5897
---
-- draft using tmp tables

--rename old tables
ALTER TABLE invoice RENAME TO invoice_5897;
ALTER TABLE invoice_prefix DROP CONSTRAINT invoice_prefix_zone_key;
ALTER TABLE invoice_prefix RENAME TO invoice_prefix_5897;
ALTER TABLE price_list RENAME TO price_list_5897;
ALTER TABLE invoice_object_registry RENAME TO invoice_object_registry_5897;
ALTER TABLE invoice_object_registry_price_map RENAME TO invoice_object_registry_price_map_5897;
ALTER TABLE invoice_credit_payment_map DROP CONSTRAINT invoice_credit_payment_map_pkey;
ALTER TABLE invoice_credit_payment_map RENAME TO invoice_credit_payment_map_5897;
ALTER TABLE invoice_generation RENAME TO invoice_generation_5897;
ALTER TABLE bank_payment RENAME TO bank_payment_5897;
ALTER TABLE registrarinvoice RENAME TO registrarinvoice_5897;

--create copy temp tables
CREATE TEMPORARY TABLE tmp_invoice AS SELECT * FROM invoice_5897;
CREATE TEMPORARY TABLE tmp_invoice_prefix AS SELECT * FROM invoice_prefix_5897;
CREATE TEMPORARY TABLE tmp_price_list AS SELECT * FROM price_list_5897;
CREATE TEMPORARY TABLE tmp_invoice_object_registry AS SELECT * FROM invoice_object_registry_5897;
CREATE TEMPORARY TABLE tmp_invoice_object_registry_price_map AS SELECT * FROM invoice_object_registry_price_map_5897;
CREATE TEMPORARY TABLE tmp_invoice_credit_payment_map AS SELECT * FROM invoice_credit_payment_map_5897;
CREATE TEMPORARY TABLE tmp_invoice_generation AS SELECT * FROM invoice_generation_5897;
CREATE TEMPORARY TABLE tmp_bank_payment AS SELECT * FROM bank_payment_5897;
CREATE TEMPORARY TABLE tmp_registrarinvoice AS SELECT * FROM registrarinvoice_5897;

-- new tmp tables
CREATE TEMPORARY TABLE tmp_registrar_credit
(
    id BIGSERIAL PRIMARY KEY
    , credit numeric(30,2) NOT NULL DEFAULT 0
    , registrar_id bigint NOT NULL --REFERENCES registrar(id)
    , zone_id bigint NOT NULL --REFERENCES zone(id)
);

CREATE TEMPORARY TABLE tmp_registrar_credit_transaction
(
    id bigserial PRIMARY KEY
    , balance_change numeric(10,2) NOT NULL
    , registrar_credit_id bigint NOT NULL --REFERENCES registrar_credit(id)
);

CREATE TEMPORARY TABLE tmp_bank_payment_registrar_credit_transaction_map
(
    id BIGSERIAL PRIMARY KEY
    , bank_payment_id bigint NOT NULL --REFERENCES bank_payment(id)
    , registrar_credit_transaction_id bigint UNIQUE NOT NULL --REFERENCES registrar_credit_transaction(id)
);

CREATE TEMPORARY TABLE tmp_invoice_registrar_credit_transaction_map
(
    id BIGSERIAL PRIMARY KEY
    , invoice_id bigint NOT NULL --REFERENCES invoice(id)
    , registrar_credit_transaction_id bigint UNIQUE NOT NULL --REFERENCES registrar_credit_transaction(id)
);

--tmp schema transformation
ALTER TABLE tmp_invoice RENAME COLUMN zone TO zone_id; 
ALTER TABLE tmp_invoice RENAME COLUMN registrarid TO registrar_id;
ALTER TABLE tmp_invoice RENAME COLUMN prefix_type TO invoice_prefix_id;
ALTER TABLE tmp_invoice RENAME COLUMN credit TO balance;
ALTER TABLE tmp_invoice RENAME COLUMN price TO operations_price;
ALTER TABLE tmp_invoice ALTER COLUMN operations_price DROP NOT NULL;
ALTER TABLE tmp_invoice ALTER COLUMN vat TYPE numeric;

ALTER TABLE tmp_invoice_prefix RENAME COLUMN zone TO zone_id;

ALTER TABLE tmp_price_list RENAME COLUMN zone TO zone_id;
ALTER TABLE tmp_price_list RENAME COLUMN operation TO operation_id;
ALTER TABLE tmp_price_list RENAME COLUMN period TO quantity;
ALTER TABLE tmp_price_list ADD COLUMN enable_postpaid_operation boolean DEFAULT 'false';
 
ALTER TABLE tmp_invoice_object_registry RENAME TO tmp_invoice_operation;
ALTER TABLE tmp_invoice_operation RENAME COLUMN invoiceid TO ac_invoice_id;
ALTER TABLE tmp_invoice_operation RENAME COLUMN zone TO zone_id;
ALTER TABLE tmp_invoice_operation RENAME COLUMN registrarid TO registrar_id;
ALTER TABLE tmp_invoice_operation RENAME COLUMN objectid TO object_id;
ALTER TABLE tmp_invoice_operation RENAME COLUMN exdate TO date_to;
ALTER TABLE tmp_invoice_operation RENAME COLUMN period TO quantity;
ALTER TABLE tmp_invoice_operation RENAME COLUMN operation TO operation_id;
ALTER TABLE tmp_invoice_operation ADD COLUMN date_from date;

ALTER TABLE tmp_invoice_object_registry_price_map RENAME TO tmp_invoice_operation_charge_map;
ALTER TABLE tmp_invoice_operation_charge_map RENAME COLUMN id TO invoice_operation_id;
ALTER TABLE tmp_invoice_operation_charge_map RENAME COLUMN invoiceid TO invoice_id;

ALTER TABLE tmp_invoice_credit_payment_map RENAME COLUMN invoiceid TO ac_invoice_id;
ALTER TABLE tmp_invoice_credit_payment_map RENAME COLUMN ainvoiceid TO ad_invoice_id;

ALTER TABLE tmp_invoice_generation RENAME COLUMN zone TO zone_id; 
ALTER TABLE tmp_invoice_generation RENAME COLUMN registrarid TO registrar_id;
ALTER TABLE tmp_invoice_generation RENAME COLUMN invoiceid TO invoice_id;

ALTER TABLE tmp_registrarinvoice DROP COLUMN lastdate;
ALTER TABLE tmp_invoice_operation ADD COLUMN registrar_credit_transaction_id bigint UNIQUE;-- REFERENCES registrar_credit_transaction(id);

--data migration into tmp

INSERT INTO tmp_price_list (zone_id, operation_id, valid_from, valid_to, price, quantity, enable_postpaid_operation)
VALUES (
(SELECT id FROM zone WHERE fqdn = 'cz')
, (SELECT id FROM enum_operation WHERE operation = 'GeneralEppOperation')
, now(), null, 0.10, 1, 'true');

UPDATE tmp_price_list SET quantity = 1 WHERE quantity = 0;

UPDATE tmp_price_list SET quantity = 1  
FROM enum_operation  
WHERE operation_id = enum_operation.id  
    AND quantity = 12  
    AND enum_operation.operation = 'RenewDomain'; 
	     
INSERT INTO tmp_registrar_credit SELECT nextval('tmp_registrar_credit_id_seq'), 0,r.id,  z.id FROM registrar r, zone z;

--tmp invoice_id, and bank_payment_id
ALTER TABLE tmp_registrar_credit_transaction ADD COLUMN invoice_id bigint;-- REFERENCES invoice(id);
ALTER TABLE tmp_registrar_credit_transaction ADD COLUMN bank_payment_id bigint;-- REFERENCES bank_payment(id);

--insert credit changes from deposits
INSERT INTO tmp_registrar_credit_transaction 
SELECT nextval('tmp_registrar_credit_transaction_id_seq'), i.balance,rc.id , i.id, bp.id
FROM tmp_bank_payment bp JOIN tmp_invoice i ON bp.invoice_id = i.id
JOIN tmp_registrar_credit rc ON i.registrar_id = rc.registrar_id and  i.zone_id = rc.zone_id;

--insert bank_payment_registrar_credit_transaction_map
INSERT INTO tmp_bank_payment_registrar_credit_transaction_map 
SELECT nextval('tmp_bank_payment_registrar_credit_transaction_map_id_seq'), rct.bank_payment_id, rct.id
FROM tmp_registrar_credit_transaction rct
WHERE rct.bank_payment_id IS NOT NULL;

--insert invoice_registrar_credit_transaction_map
INSERT INTO tmp_invoice_registrar_credit_transaction_map 
SELECT nextval('tmp_invoice_registrar_credit_transaction_map_id_seq'), rct.invoice_id, rct.id
FROM tmp_registrar_credit_transaction rct
WHERE rct.invoice_id IS NOT NULL;

--drop tmp cols
ALTER TABLE tmp_registrar_credit_transaction DROP COLUMN bank_payment_id;
ALTER TABLE tmp_registrar_credit_transaction DROP COLUMN invoice_id;

--tmp invoice_operation_id
ALTER TABLE tmp_registrar_credit_transaction ADD COLUMN invoice_operation_id bigint;-- REFERENCES invoice_operation(id);

--insert credit changes from operations
INSERT INTO tmp_registrar_credit_transaction
SELECT nextval('tmp_registrar_credit_transaction_id_seq'), 
sum(iocm.price) * -1, rc.id, io.id
FROM tmp_invoice_operation io 
JOIN tmp_invoice_operation_charge_map iocm ON io.id = iocm.invoice_operation_id
JOIN tmp_registrar_credit rc ON rc.zone_id = io.zone_id AND rc.registrar_id = io.registrar_id
GROUP BY iocm.invoice_operation_id, rc.id, io.id;

--update operations credit changes
UPDATE tmp_invoice_operation io 
SET registrar_credit_transaction_id = rct.id 
FROM tmp_registrar_credit_transaction rct  
WHERE io.id = rct.invoice_operation_id;

ALTER TABLE tmp_invoice_operation ALTER COLUMN registrar_credit_transaction_id SET NOT NULL;

--drop tmp cols
ALTER TABLE tmp_registrar_credit_transaction DROP COLUMN invoice_operation_id;
ALTER TABLE tmp_bank_payment DROP COLUMN invoice_id;


--new tables

CREATE TABLE invoice_prefix
(
  id bigserial PRIMARY KEY,
  zone_id bigint REFERENCES zone (id) , -- reference to zone
  typ integer DEFAULT 0, -- invoice type (0-advanced, 1-normal)
  "year" numeric NOT NULL, -- for which year
  prefix bigint, -- counter with prefix of number of invoice
  CONSTRAINT invoice_prefix_zone_key UNIQUE (zone_id, typ, year)
);

CREATE TABLE invoice
(
  id bigserial PRIMARY KEY NOT NULL, -- unique automatically generated identifier
  zone_id bigint REFERENCES zone(id) , -- reference to zone
  crdate timestamp without time zone NOT NULL DEFAULT now(), -- date and time of invoice creation
  taxdate date NOT NULL, -- date of taxable fulfilment (when payment cames by advance FA)
  prefix bigint NOT NULL UNIQUE, -- 9 placed number of invoice from invoice_prefix.prefix counted via TaxDate
  registrar_id bigint NOT NULL REFERENCES registrar (id), -- link to registrar
  balance numeric(10,2) DEFAULT 0.0, -- *advance invoice: balance from which operations are charged *account invoice: amount to be paid (0 in case there is no debt)
  operations_price numeric(10,2) DEFAULT 0.0, -- sum of operations without tax
  vat numeric NOT NULL, -- VAT hight from account
  total numeric(10,2) NOT NULL DEFAULT 0.0, -- amount without tax
  totalvat numeric(10,2) NOT NULL DEFAULT 0.0, -- tax paid
  invoice_prefix_id bigint NOT NULL REFERENCES invoice_prefix (id), -- invoice type - which year and type (accounting/advance)
  file bigint REFERENCES files (id), -- link to generated PDF file, it can be NULL till file is generated
  filexml bigint REFERENCES files (id) -- link to generated XML file, it can be NULL till file is generated
);

CREATE TABLE price_list
(
  id bigserial PRIMARY KEY, -- unique automatically generated identifier
  zone_id bigint NOT NULL REFERENCES "zone" (id), -- link to zone, for which is price list valid if it is domain (if it is not domain then it is NULL)
  operation_id bigint NOT NULL REFERENCES enum_operation (id), -- for which action is price connected
  valid_from timestamp without time zone NOT NULL, -- from when is record valid
  valid_to timestamp without time zone, -- till when is record valid, if it is NULL then valid is unlimited
  price numeric(10,2) NOT NULL DEFAULT 0, -- cost of operation (for one year-12 months)
  quantity integer DEFAULT 12, -- quantity or period (in years) of operation
  enable_postpaid_operation boolean DEFAULT false -- true if operation of this specific type can be executed when credit is not sufficient and create debt
);

CREATE TABLE invoice_credit_payment_map
(
  ac_invoice_id bigint NOT NULL REFERENCES invoice (id), -- id of normal invoice
  ad_invoice_id bigint NOT NULL REFERENCES invoice (id), -- id of advance invoice
  credit numeric(10,2) NOT NULL DEFAULT 0.0, -- seized credit
  balance numeric(10,2) NOT NULL DEFAULT 0.0, -- actual tax balance advance invoice
  CONSTRAINT invoice_credit_payment_map_pkey PRIMARY KEY (ac_invoice_id, ad_invoice_id)
);

CREATE TABLE invoice_generation
(
  id bigserial NOT NULL PRIMARY KEY, -- unique automatically generated identifier
  fromdate date NOT NULL,
  todate date NOT NULL,
  registrar_id bigint NOT NULL REFERENCES registrar (id),
  zone_id bigint REFERENCES zone (id),
  invoice_id bigint REFERENCES invoice (id) -- id of normal invoice
);


CREATE TABLE registrarinvoice
(
  id bigserial NOT NULL PRIMARY KEY,
  registrarid bigint NOT NULL REFERENCES registrar (id),
  "zone" bigint NOT NULL REFERENCES "zone" (id), -- zone for which has registrar an access
  fromdate date NOT NULL, -- date when began registrar work in a zone
  todate date -- after this date, registrar is not allowed to register
);

CREATE TABLE registrar_credit
(
    id BIGSERIAL PRIMARY KEY
    , credit numeric(30,2) NOT NULL DEFAULT 0
    , registrar_id bigint NOT NULL REFERENCES registrar(id)
    , zone_id bigint NOT NULL REFERENCES zone(id)
);

CREATE TABLE registrar_credit_transaction
(
    id bigserial PRIMARY KEY
    , balance_change numeric(10,2) NOT NULL
    , registrar_credit_id bigint NOT NULL REFERENCES registrar_credit(id)
);

CREATE TABLE invoice_operation
(
  id bigserial PRIMARY KEY, -- unique automatically generated identifier
  ac_invoice_id bigint REFERENCES invoice (id), -- id of invoice for which is item counted
  crdate timestamp without time zone NOT NULL DEFAULT now(), -- billing date and time
  object_id bigint REFERENCES object_registry (id),
  zone_id bigint REFERENCES "zone" (id), -- link to zone
  registrar_id bigint NOT NULL REFERENCES registrar (id), -- link to registrar
  operation_id bigint NOT NULL REFERENCES enum_operation (id), -- operation type of registration or renew
  date_from date,
  date_to date, -- expiration date only for RENEW
  quantity bigint DEFAULT 0, -- number of operations or number of months for renew
  registrar_credit_transaction_id bigint NOT NULL UNIQUE REFERENCES registrar_credit_transaction (id)
);

CREATE TABLE invoice_operation_charge_map
(
  invoice_operation_id bigint NOT NULL REFERENCES invoice_operation (id),
  invoice_id bigint NOT NULL REFERENCES invoice (id), -- id of advanced invoice
  price numeric(10,2) NOT NULL DEFAULT 0, -- operation cost
  CONSTRAINT invoice_operation_charge_map_pkey PRIMARY KEY (invoice_operation_id, invoice_id)
);



CREATE TABLE bank_payment_registrar_credit_transaction_map
(
    id BIGSERIAL PRIMARY KEY
    , bank_payment_id bigint NOT NULL REFERENCES bank_payment(id)
    , registrar_credit_transaction_id bigint UNIQUE NOT NULL REFERENCES registrar_credit_transaction(id)
);

CREATE TABLE invoice_registrar_credit_transaction_map
(
    id BIGSERIAL PRIMARY KEY
    , invoice_id bigint NOT NULL REFERENCES invoice(id)
    , registrar_credit_transaction_id bigint UNIQUE NOT NULL REFERENCES registrar_credit_transaction(id)
);






