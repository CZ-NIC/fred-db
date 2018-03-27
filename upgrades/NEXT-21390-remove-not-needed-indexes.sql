DROP INDEX IF EXISTS mail_archive_mail_type_id_idx;
DROP INDEX IF EXISTS history_action_idx;
DROP INDEX IF EXISTS history_request_id_idx;

DROP INDEX IF EXISTS domain_history_historyid_idx;
DROP INDEX IF EXISTS nsset_history_historyid_idx;
DROP INDEX IF EXISTS registrar_group_short_name_idx;
ALTER TABLE enumval DROP CONSTRAINT enumval_domainid_key;
