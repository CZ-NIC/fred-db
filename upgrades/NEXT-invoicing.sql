---
--- Ticket #5796
---

--drop table registrar_credit_transaction cascade;
--drop table registrar_credit cascade;

--drop table bank_payment_registrar_credit_transaction_map cascade;
--drop table invoice_registrar_credit_transaction_map;


--#!sql

ALTER TABLE invoice RENAME COLUMN zone TO zone_id; 
ALTER TABLE invoice RENAME COLUMN registrarid TO registrar_id;
ALTER TABLE invoice RENAME COLUMN prefix_type TO invoice_prefix_id;
ALTER TABLE invoice RENAME COLUMN credit TO balance;
ALTER TABLE invoice RENAME COLUMN price TO operations_price;

ALTER TABLE invoice_prefix RENAME COLUMN zone TO zone_id;

ALTER TABLE price_list RENAME COLUMN zone TO zone_id;
ALTER TABLE price_list RENAME COLUMN operation TO operation_id;

ALTER TABLE invoice_object_registry RENAME TO invoice_operation;
ALTER TABLE invoice_operation RENAME COLUMN invoiceid TO ac_invoice_id;
ALTER TABLE invoice_operation RENAME COLUMN zone TO zone_id;
ALTER TABLE invoice_operation RENAME COLUMN registrarid TO registrar_id;
ALTER TABLE invoice_operation RENAME COLUMN objectid TO object_id;

ALTER TABLE invoice_object_registry_price_map RENAME TO invoice_operation_charge_map;
ALTER TABLE invoice_operation_charge_map RENAME COLUMN id TO invoice_operation_id;
ALTER TABLE invoice_operation_charge_map RENAME COLUMN invoiceid TO invoice_id;

ALTER TABLE invoice_credit_payment_map RENAME COLUMN invoiceid TO ac_invoice_id;
ALTER TABLE invoice_credit_payment_map RENAME COLUMN ainvoiceid TO ad_invoice_id;

ALTER TABLE invoice_generation RENAME COLUMN zone TO zone_id; 
ALTER TABLE invoice_generation RENAME COLUMN registrarid TO registrar_id;
ALTER TABLE invoice_generation RENAME COLUMN invoiceid TO invoice_id;

CREATE TABLE registrar_credit
(
    id BIGSERIAL PRIMARY KEY
    , credit numeric(10,2) NOT NULL DEFAULT 0
    , registrar_id bigint NOT NULL REFERENCES registrar(id)
    , zone_id bigint NOT NULL REFERENCES zone(id)
);

COMMENT ON TABLE registrar_credit 
	IS 'current credit by registrar and zone';

CREATE TABLE registrar_credit_transaction
(
    id bigserial PRIMARY KEY
    , balance_change numeric(10,2) NOT NULL
    , registrar_credit_id bigint NOT NULL REFERENCES registrar_credit(id)
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

CREATE TABLE bank_payment_registrar_credit_transaction_map
(
    id BIGSERIAL PRIMARY KEY
    , bank_payment_id bigint NOT NULL REFERENCES bank_payment(id)
    , registrar_credit_transaction_id bigint UNIQUE NOT NULL REFERENCES registrar_credit_transaction(id)
);

COMMENT ON TABLE bank_payment_registrar_credit_transaction_map
	IS 'payment assigned to credit items';

CREATE TABLE invoice_registrar_credit_transaction_map
(
    id BIGSERIAL PRIMARY KEY
    , invoice_id bigint NOT NULL REFERENCES invoice(id)
    , registrar_credit_transaction_id bigint UNIQUE NOT NULL REFERENCES registrar_credit_transaction(id)
);

COMMENT ON TABLE invoice_registrar_credit_transaction_map
	IS 'positive credit item from payment assigned to deposit or account invoice';

ALTER TABLE price_list ADD COLUMN enable_postpaid_operation boolean DEFAULT 'false';

ALTER TABLE invoice_operation ADD COLUMN registrar_credit_transaction_id bigint UNIQUE REFERENCES registrar_credit_transaction(id);

--migration

INSERT INTO price_list (zone_id, operation_id, valid_from, valid_to, price, period, enable_postpaid_operation)
VALUES (
(SELECT id FROM zone WHERE fqdn = 'cz')
, (SELECT id FROM enum_operation WHERE operation = 'GeneralEppOperation')
, now(), null, 0.10, 0, 'true');

--UPDATE price_list pl SET enable_postpaid_operation = 'true' FROM enum_operation eo  
--WHERE pl.operation_id = eo.id AND eo.operation = 'GeneralEppOperation';

INSERT INTO registrar_credit SELECT nextval('registrar_credit_id_seq'), 0,r.id,  z.id FROM registrar r, zone z;

--tmp invoice_id, and bank_payment_id
ALTER TABLE registrar_credit_transaction ADD COLUMN invoice_id bigint REFERENCES invoice(id);
ALTER TABLE registrar_credit_transaction ADD COLUMN bank_payment_id bigint REFERENCES bank_payment(id);

--insert credit changes from deposits
INSERT INTO registrar_credit_transaction 
SELECT nextval('registrar_credit_transaction_id_seq'), i.balance,rc.id , i.id, bp.id
FROM bank_payment bp JOIN invoice i ON bp.invoice_id = i.id
JOIN registrar_credit rc ON i.registrar_id = rc.registrar_id and  i.zone_id = rc.zone_id;

--insert bank_payment_registrar_credit_transaction_map
INSERT INTO bank_payment_registrar_credit_transaction_map 
SELECT nextval('bank_payment_registrar_credit_transaction_map_id_seq'), rct.bank_payment_id, rct.id
FROM registrar_credit_transaction rct
WHERE rct.bank_payment_id IS NOT NULL;

--insert invoice_registrar_credit_transaction_map
INSERT INTO invoice_registrar_credit_transaction_map 
SELECT nextval('invoice_registrar_credit_transaction_map_id_seq'), rct.invoice_id, rct.id
FROM registrar_credit_transaction rct
WHERE rct.invoice_id IS NOT NULL;

--drop tmp cols
ALTER TABLE registrar_credit_transaction DROP COLUMN bank_payment_id;
ALTER TABLE registrar_credit_transaction DROP COLUMN invoice_id;

--tmp invoice_operation_id
ALTER TABLE registrar_credit_transaction ADD COLUMN invoice_operation_id bigint REFERENCES invoice_operation(id);

--insert credit changes from operations
INSERT INTO registrar_credit_transaction
SELECT nextval('registrar_credit_transaction_id_seq'), 
sum(iocm.price) * -1, rc.id, io.id
FROM invoice_operation io 
JOIN invoice_operation_charge_map iocm ON io.id = iocm.invoice_operation_id
JOIN registrar_credit rc ON rc.zone_id = io.zone_id AND rc.registrar_id = io.registrar_id
GROUP BY iocm.invoice_operation_id, rc.id, io.id;

--update operations credit changes
UPDATE invoice_operation io 
SET registrar_credit_transaction_id = rct.invoice_operation_id 
FROM registrar_credit_transaction rct  
WHERE io.id = rct.invoice_operation_id;

ALTER TABLE invoice_operation ALTER COLUMN registrar_credit_transaction_id SET NOT NULL;

--drop tmp cols
ALTER TABLE registrar_credit_transaction DROP COLUMN invoice_operation_id;


ALTER TABLE bank_payment DROP COLUMN invoice_id;
ALTER TABLE registrarinvoice DROP COLUMN lastdate;
