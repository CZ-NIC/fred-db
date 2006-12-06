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
#zone generator
cat genzone.sql
#registar & registraracl (pass) tables
cat registrar.sql
#login and action table plus history table
cat login.sql
cat action.sql
# object table
cat ccreg.sql
cat history.sql
#adif
cat admin.sql  
#mailer
cat mail_notify.sql
# banking
cat enum_bank_code.sql
cat bank.sql
cat invoice.sql
cat credit.sql

