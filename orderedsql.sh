#!/bin/bash
# printing-out sql command in right order to create of new database
#base system
cat error.sql
cat enum_reason.sql
cat enum_status.sql
cat enum_ssntype.sql
cat enum_country.sql
cat enum_cs_country.sql
cat zone.sql
#registar and registraracl  tables
cat registrar.sql
#login and action table plus history table
cat login.sql
cat action.sql
# object table
cat ccreg.sql
cat history.sql
#zone generator
cat genzone.sql
#adif
cat admin.sql  
#filemanager
cat filemanager.sql
#mailer
cat mail_notify.sql
cat mail_templates.sql
#authinfo
cat authinfo.sql
# banking
cat enum_bank_code.sql
cat credit.sql
cat invoice.sql
cat bank.sql
#tech-check
cat techcheck.sql
cat info_buffer.sql
# common functions
cat func.sql
# state and poll
cat state.sql
cat poll.sql
#notify  mailer
cat notify.sql
