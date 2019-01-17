---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.35.1' WHERE id = 1;

ALTER TABLE bank_payment_registrar_credit_transaction_map
    DROP CONSTRAINT IF EXISTS bank_payment_registrar_credit_transaction_bank_payment_uuid_key;
