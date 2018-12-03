--- Ticket #22449 (superuser)

COPY bank_account TO '/var/lib/postgresql/bank_account.csv' DELIMITER ',' CSV HEADER;

-- DUMP to /var/lib/postgresql
COPY(
    SELECT ROW_TO_JSON(payment)
      FROM (
            SELECT trim(both ' ' from bank_account.account_name) as account_name,
                   trim(both ' ' from bank_account.account_number) as account_number,
                   bank_account.bank_code,
                   bank_payment.account_evid as account_payment_ident,
                   bank_payment.account_number AS counter_account_number,
                   bank_payment.bank_code AS counter_account_bank_code,
                   bank_payment.code,
                   bank_payment.type,
                   bank_payment.status,
                   bank_payment.konstsym AS constant_symbol,
                   bank_payment.varsymb AS variable_symbol,
                   bank_payment.specsymb AS specific_symbol,
                   bank_payment.price,
                   bank_payment.account_date as date,
                   bank_payment.account_memo as memo,
                   bank_payment.account_name as counter_account_name,
                   bank_payment.crtime AS creation_time,
                   bank_payment.uuid,
                   (SELECT json_object_agg(i.id, i.prefix)
                      FROM invoice_registrar_credit_transaction_map icm
                      JOIN bank_payment_registrar_credit_transaction_map bpcm
                        ON icm.registrar_credit_transaction_id = bpcm.registrar_credit_transaction_id
                      JOIN registrar_credit_transaction rct
                        ON rct.id = bpcm.registrar_credit_transaction_id
                      JOIN invoice i
                        ON i.id = icm.invoice_id
                      JOIN invoice_prefix ip
                        ON ip.id = i.invoice_prefix_id
                     WHERE bpcm.bank_payment_id = bank_payment.id
                       AND ip.typ = 0) as advance_invoice,
                   (SELECT json_object_agg(i.id, i.prefix)
                      FROM invoice_registrar_credit_transaction_map icm
                      JOIN bank_payment_registrar_credit_transaction_map bpcm
                        ON icm.registrar_credit_transaction_id = bpcm.registrar_credit_transaction_id
                      JOIN registrar_credit_transaction rct
                        ON rct.id = bpcm.registrar_credit_transaction_id
                      JOIN invoice i
                        ON i.id = icm.invoice_id
                      JOIN invoice_prefix ip
                        ON ip.id = i.invoice_prefix_id
                     WHERE bpcm.bank_payment_id = bank_payment.id
                       AND ip.typ = 1) as account_invoices,
                    (SELECT registrar.id
                      FROM bank_payment_registrar_credit_transaction_map bpcm
                      JOIN registrar_credit_transaction rct
                        ON rct.id = bpcm.registrar_credit_transaction_id
                      JOIN registrar_credit rc
                        ON rct.registrar_credit_id = rc.id
                      JOIN registrar
                        ON registrar.id = rc.registrar_id
                     WHERE bpcm.bank_payment_id = bank_payment.id
                     LIMIT 1
                     ) AS registrar_id,
                    (SELECT registrar.handle
                      FROM bank_payment_registrar_credit_transaction_map bpcm
                      JOIN registrar_credit_transaction rct
                        ON rct.id = bpcm.registrar_credit_transaction_id
                      JOIN registrar_credit rc
                        ON rct.registrar_credit_id = rc.id
                      JOIN registrar
                        ON registrar.id = rc.registrar_id
                     WHERE bpcm.bank_payment_id = bank_payment.id
                     LIMIT 1
                     ) AS registrar_handle
              FROM bank_payment
              LEFT JOIN bank_account
                ON bank_payment.account_id = bank_account.id
           ) payment
)
TO '/var/lib/postgresql/payments-export-for-pain.json';
