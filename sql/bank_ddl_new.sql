CREATE TABLE bank_payment_registrar_credit_transaction_map
(
    id BIGSERIAL CONSTRAINT bank_payment_registrar_credit_transaction_map_pkey PRIMARY KEY
    , bank_payment_uuid UUID UNIQUE NOT NULL
    , registrar_credit_transaction_id bigint
    CONSTRAINT bank_payment_registrar_credit_registrar_credit_transaction__key UNIQUE
    NOT NULL
    CONSTRAINT bank_payment_registrar_credit_registrar_credit_transaction_fkey REFERENCES registrar_credit_transaction(id)
);

COMMENT ON TABLE bank_payment_registrar_credit_transaction_map IS 'payment assigned to credit items';
