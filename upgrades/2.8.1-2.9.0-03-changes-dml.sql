
---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.9.0' WHERE id = 1;


---
--- Ticket #5796
---
--- THIS SCRIPT MUST BE RUN WITH SUPERUSER PRIVILEGES
--- SO THAT `COPY' CAN WORK
---

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
FROM '/var/tmp/temp_upgrade_bank_payment.csv';



-- restore saved invoice_object_registry (old name) 
-- this does not have date_from and registrar_credit_transaction_id yet - to match date from file
CREATE TEMP TABLE temp_invoice_operation (
    id integer NOT NULL PRIMARY KEY, -- unique primary key
    ac_invoice_id INTEGER, -- REFERENCES invoice (id) , -- id of invoice for which is item counted 
    CrDate timestamp NOT NULL,  -- billing date and time 
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
COPY price_list(id, zone_id, operation_id, valid_from, valid_to, price, quantity) FROM '/var/tmp/temp_upgrade_price_list.csv';
select setval( 'price_list_id_seq1'::regclass,  (select max(id) from price_list));
COPY invoice_prefix FROM '/var/tmp/temp_upgrade_invoice_prefix.csv';
select setval( 'invoice_prefix_id_seq1'::regclass,  (select max(id) from invoice_prefix));
COPY invoice FROM '/var/tmp/temp_upgrade_invoice.csv';
select setval( 'invoice_id_seq1'::regclass,  (select max(id) from invoice));
COPY invoice_credit_payment_map FROM '/var/tmp/temp_upgrade_invoice_credit_payment_map.csv';
COPY invoice_generation FROM '/var/tmp/temp_upgrade_invoice_generation.csv';
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
FROM '/var/tmp/temp_upgrade_invoice_object_registry.csv';

/*
-- in case we need to restore it directly
COPY invoice_operation (id, ac_invoice_id, crdate, object_id, zone_id, registrar_id, operation_id, date_to, quantity)
FROM '/var/tmp/temp_upgrade_invoice_object_registry.csv';
*/

COPY temp_invoice_operation_charge_map
FROM '/var/tmp/temp_upgrade_invoice_object_registry_price_map.csv';

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


---
---  Ticket #5808
---
UPDATE request_fee_parameter SET zone = z.id FROM zone z WHERE z.fqdn = 'cz';

