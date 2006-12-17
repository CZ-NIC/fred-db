#!/bin/bash
# vypsani sql prikazu ve spravnem poradi pro zalozeni nove databaze
#base system
cat error.sql
cat enum_reason.sql
cat enum_status.sql
cat enum_ssntype.sql
cat enum_country.sql
cat enum_cs_country.sql
cat zone.sql
#registar & registraracl (pass) tables
cat registrar.sql
cat registraracl.sql
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
cat invoice.sql
cat bank.sql
cat credit.sql

