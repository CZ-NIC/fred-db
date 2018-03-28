DROP INDEX IF EXISTS mail_archive_mail_type_id_idx;
DROP INDEX IF EXISTS history_action_idx;
DROP INDEX IF EXISTS history_request_id_idx;

DROP INDEX IF EXISTS domain_history_historyid_idx;
DROP INDEX IF EXISTS nsset_history_historyid_idx;
DROP INDEX IF EXISTS registrar_group_short_name_idx;
ALTER TABLE enumval DROP CONSTRAINT enumval_domainid_key;

DROP INDEX IF EXISTS dnskey_keysetid_idx;
DROP INDEX IF EXISTS idx_contact_test_result_contact_check_id;
DROP INDEX IF EXISTS host_nsset_idx;
DROP INDEX IF EXISTS nsset_contact_map_nssetid_idx;
DROP INDEX IF EXISTS invoice_credit_payment_map_ac_invoice_id_idx;
DROP INDEX IF EXISTS keyset_contact_map_contact_idx;
