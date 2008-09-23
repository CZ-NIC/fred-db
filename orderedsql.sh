#!/bin/bash
# printing-out sql command in right order to create of new database
#base system


DIR=$(dirname $0)/sql

write_script() 
{
	cat $DIR/error.sql
	cat $DIR/enum_reason.sql
	cat $DIR/enum_ssntype.sql
	cat $DIR/enum_country.sql
	cat $DIR/enum_cs_country.sql
	cat $DIR/zone.sql
	#registar and registraracl  tables
	cat $DIR/registrar.sql
	#login and action table plus history table
	cat $DIR/login.sql
	cat $DIR/action.sql
	# object table
	cat $DIR/ccreg.sql
	cat $DIR/history.sql
	#zone generator
	cat $DIR/genzone.sql
	#adif
	cat $DIR/admin.sql  
	#filemanager
	cat $DIR/filemanager.sql
	#mailer
	cat $DIR/mail_notify.sql
	cat $DIR/mail_templates.sql
	#authinfo
	cat $DIR/authinfo.sql
	# banking
	cat $DIR/enum_bank_code.sql
	cat $DIR/credit.sql
	cat $DIR/invoice.sql
	cat $DIR/bank.sql
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
	# notify mailer
	cat $DIR/notify.sql
	cat $DIR/notify_new.sql
	# list of tld domains
	cat $DIR/enum_tlds.sql
	# new table with filters
	cat $DIR/filters.sql
	# new indexes for history tables
	cat $DIR/index.sql
	# new table for requests from public
	cat $DIR/public_request.sql
}

usage()
{
	echo "$0 : Create database installation .sql script. It accepts one of these options: "
	echo "		--with-log include logging tables (used by fred-logd daemon) "
	echo "		--help 	   display this message "
}

case "$1" in
	--with-log)
		write_script
		cat $DIR/structure_log.sql
		;;
	--help) 
		usage
		;;
	*)
		write_script
		;;
esac
