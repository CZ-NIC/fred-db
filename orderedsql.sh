#!/bin/bash
# printing-out sql command in right order to create of new database
#base system

set -e

DIR=$(dirname $0)/sql

write_script() 
{
    cat $DIR/array_util_func.sql
	cat $DIR/error.sql
	cat $DIR/enum_reason.sql
	cat $DIR/enum_ssntype.sql
	cat $DIR/enum_country.sql
	cat $DIR/enum_cs_country.sql
	cat $DIR/zone.sql
	#registar and registraracl  tables
	cat $DIR/registrar.sql
	# object table
	cat $DIR/history_base.sql
	cat $DIR/ccreg.sql
	cat $DIR/history.sql
    # regex handle validation
	cat $DIR/regex_handle_validation_ddl.sql
	cat $DIR/regex_handle_validation_dml.sql
	#zone generator
	cat $DIR/genzone.sql
	#adif
	cat $DIR/admin.sql  
	#filemanager
	cat $DIR/filemanager.sql
	#filemanager's file for certification evaluation pdf
	cat $DIR/certification_file_dml.sql
	# mailer
	cat $DIR/mail_archive/mail_archive_schema.sql
    cat $DIR/mail_archive/mail_type_admin_contact_verification.sql
    cat $DIR/mail_archive/mail_type_akm.sql
    cat $DIR/mail_archive/mail_type_authinfo.sql
    cat $DIR/mail_archive/mail_type_personalinfo.sql
    cat $DIR/mail_archive/mail_type_contact_merge.sql
    cat $DIR/mail_archive/mail_type_contact_reminder.sql
    cat $DIR/mail_archive/mail_type_contact_verification.sql
    cat $DIR/mail_archive/mail_type_expiration.sql
    cat $DIR/mail_archive/mail_type_invoice.sql
    cat $DIR/mail_archive/mail_type_mojeid.sql
    cat $DIR/mail_archive/mail_type_notification.sql
    cat $DIR/mail_archive/mail_type_public_request.sql
    cat $DIR/mail_archive/mail_type_record_statement.sql
    cat $DIR/mail_archive/mail_type_techcheck.sql
    # mailer setting (TEMP - cz.nic specific)
    cat $DIR/_defaults/mail_archive/mail_template_default.sql
    cat $DIR/_defaults/mail_archive/mail_header_default.sql
    cat $DIR/_defaults/mail_archive/mail_template_footer.sql
    cat $DIR/_defaults/mail_archive/mail_vcard.sql
    cat $DIR/_defaults/mail_archive/mail_type_priority.sql
    cat $DIR/_defaults/mail_archive/mail_template_akm_candidate_state_ko.sql
    cat $DIR/_defaults/mail_archive/mail_template_akm_candidate_state_ok.sql
    cat $DIR/_defaults/mail_archive/mail_template_akm_keyset_update.sql
    cat $DIR/_defaults/mail_archive/mail_template_annual_contact_reminder.sql
    cat $DIR/_defaults/mail_archive/mail_template_conditional_contact_identification.sql
    cat $DIR/_defaults/mail_archive/mail_template_contact_identification.sql
    cat $DIR/_defaults/mail_archive/mail_template_expiration_dns_owner.sql
    cat $DIR/_defaults/mail_archive/mail_template_expiration_dns_tech.sql
    cat $DIR/_defaults/mail_archive/mail_template_expiration_dns_warning_owner.sql
    cat $DIR/_defaults/mail_archive/mail_template_expiration_notify.sql
    cat $DIR/_defaults/mail_archive/mail_template_expiration_register_owner.sql
    cat $DIR/_defaults/mail_archive/mail_template_expiration_register_tech.sql
    cat $DIR/_defaults/mail_archive/mail_template_expiration_validation_before.sql
    cat $DIR/_defaults/mail_archive/mail_template_expiration_validation.sql
    cat $DIR/_defaults/mail_archive/mail_template_invoice_audit.sql
    cat $DIR/_defaults/mail_archive/mail_template_invoice_deposit.sql
    cat $DIR/_defaults/mail_archive/mail_template_invoice_noaudit.sql
    cat $DIR/_defaults/mail_archive/mail_template_merge_contacts_auto.sql
    cat $DIR/_defaults/mail_archive/mail_template_mojeid_email_change.sql
    cat $DIR/_defaults/mail_archive/mail_template_mojeid_identification.sql
    cat $DIR/_defaults/mail_archive/mail_template_mojeid_validation.sql
    cat $DIR/_defaults/mail_archive/mail_template_mojeid_verified_contact_transfer.sql
    cat $DIR/_defaults/mail_archive/mail_template_notification_create.sql
    cat $DIR/_defaults/mail_archive/mail_template_notification_delete.sql
    cat $DIR/_defaults/mail_archive/mail_template_notification_renew.sql
    cat $DIR/_defaults/mail_archive/mail_template_notification_transfer.sql
    cat $DIR/_defaults/mail_archive/mail_template_notification_unused.sql
    cat $DIR/_defaults/mail_archive/mail_template_notification_update.sql
    cat $DIR/_defaults/mail_archive/mail_template_record_statement.sql
    cat $DIR/_defaults/mail_archive/mail_template_request_block.sql
    cat $DIR/_defaults/mail_archive/mail_template_sendauthinfo_epp.sql
    cat $DIR/_defaults/mail_archive/mail_template_sendauthinfo_pif.sql
    cat $DIR/_defaults/mail_archive/mail_template_sendpersonalinfo_pif.sql
    cat $DIR/_defaults/mail_archive/mail_template_techcheck.sql
	# banking
	cat $DIR/enum_bank_code.sql
	cat $DIR/credit_ddl.sql
	cat $DIR/invoice.sql
	cat $DIR/bank.sql
	cat $DIR/bank_ddl_new.sql
	#tech-check
	cat $DIR/techcheck.sql
	cat $DIR/info_buffer.sql
	# common functions
	cat $DIR/func.sql
	# table with parameters
	cat $DIR/enum_params.sql
	# keyset
	cat $DIR/keyset.sql
	# state and poll
	cat $DIR/state.sql
	cat $DIR/poll.sql
    cat $DIR/request_fee_ddl.sql
    cat $DIR/request_fee_dml.sql
	# notify mailer
	cat $DIR/notify_new.sql
	# list of tld domains
	cat $DIR/enum_tlds.sql
	# new table with filters
	cat $DIR/filters.sql
	# new indexes for history tables
	cat $DIR/index.sql
	# new table for requests from public
	cat $DIR/public_request.sql
    cat $DIR/public_request_dml.sql
    cat $DIR/public_request_dml_authinfo.sql
    cat $DIR/public_request_dml_block.sql
    cat $DIR/public_request_dml_verification.sql
    cat $DIR/public_request_dml_personalinfo.sql
	# registrar's certifications and groups
	cat $DIR/registrar_certification_ddl.sql
    cat $DIR/registrar_disconnect.sql
    # mojeid
    cat $DIR/registry_dml_mojeid.sql
    # contact reminder
    cat $DIR/reminder_ddl.sql
    # monitoring
    cat $DIR/monitoring_dml.sql
    # epp login IDs
    cat $DIR/epp_login.sql
    # contact verification
    cat $DIR/contact_verification_dml.sql
    # admin contact verification
    cat $DIR/admin_contact_verification_ddl.sql
    cat $DIR/admin_contact_verification_dml.sql
    # manual verification states
    cat $DIR/registry_dml_contact_manual_verification.sql
    # message forwarding service for message type
    cat $DIR/message_type_forwarding_service_map_dml.sql
    # changes notifications
    cat $DIR/changes_notifications.sql
    # similar search indexes
    cat $DIR/similar_search_trigram_indexes.sql
}

usage()
{
	echo "$0 : Create database installation .sql script. It accepts one of these options: "
	echo "		--without-log exclude logging tables (used by fred-logd daemon) "
	echo "		--help 	   display this message "
}

case "$1" in
	--without-log)
		write_script
		;;
	--help) 
		usage
		;;
	*)
		write_script
        cat $DIR/logger_ddl.sql		
        cat $DIR/logger_dml_whois.sql
        cat $DIR/logger_dml_webwhois.sql
        cat $DIR/logger_dml_pubrequest.sql
        cat $DIR/logger_dml_epp.sql
        cat $DIR/logger_dml_webadmin.sql
        cat $DIR/logger_dml_intranet.sql
        cat $DIR/logger_dml_mojeid.sql
        cat $DIR/logger_dml_domainbrowser.sql
        cat $DIR/logger_dml.sql
        cat $DIR/logger_dml_pubrequest_result.sql
        cat $DIR/logger_dml_admin.sql
        cat $DIR/logger_dml_rdap.sql
        cat $DIR/logger_partitioning.sql
		;;
esac
