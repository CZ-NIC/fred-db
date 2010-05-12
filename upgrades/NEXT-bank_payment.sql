-- set type of account_name and account_memo to character varying(63) #3946
ALTER TABLE bank_payment ALTER COLUMN account_name TYPE character varying (63);
ALTER TABLE bank_payment ALTER COLUMN account_memo TYPE character varying (63);

