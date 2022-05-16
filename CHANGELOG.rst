CHANGELOG
=========

2.47.1 (2022-04-07)
-------------------

* Add constraint for allowed characters on ``service.name``

  * rename necessary services

2.47.0 (2022-01-31)
-------------------

* Add possibility to mark registrar as internal

  * not in registrar list in public interfaces but still traceable when linked to another object
  * not charged

2.46.0 (2021-11-08)
-------------------

* Add ``contact_identity`` table (to manage history of linkage between registry
  contact and external identity service)

* Add new contact states to inform that some of the contact attributes are locked and cannot be changed

2.45.5 (2021-09-09)
-------------------

* Fix rpm build

2.45.4 (2021-08-24)
-------------------

* Do not require createlang utility

2.45.3 (2021-07-02)
-------------------

* Update template of mojeid PIN1 e-mail

2.45.2 (2021-06-14)
-------------------

* Update template for epp send authinfo e-mail template (new ``registrar_url`` parameter)

2.45.1 (2021-03-16)
-------------------

* Fix partition naming (quoting)

2.45.0 (2021-02-10)
-------------------

* Rework unique constraints on service, request types, result codes and object types

  * Fix case sensitivity

* Change datatype of ``request_object_ref.object_id`` to bigint

2.44.0 (2020-07-02)
-------------------

* Add possibility to change domain lifecycle parameters over time

  * Move from enum_parameters to dedicated table domain_lifecycle_parameters
  * Adjust corresponding procedures and triggers

2.43.0 (2020-06-03)
-------------------

* Add new request type for MojeID (MojeidNiaUpdateAccount)

2.42.0 (2020-06-01)
-------------------

* Add new request types for Ferda service (contact representatives)

2.41.0 (2020-04-30)
-------------------

* Add textual object identifier request_object_ref.object_ident to logger

* Add Ferda service, request types and result codes to logger

2.40.1 (2020-03-17)
-------------------

* Remove unused GiST indexes

2.40.0 (2020-02-19)
-------------------

* Add GIN trigram indexes for similar string search in domain, nsset and keyset history

2.39.0 (2020-01-09)
-------------------

* Add GIN trigram indexes for similar string search in contact history

2.38.2 (2019-11-20)
-------------------

* Add new message type (mojeid_sms_two_factor_reset)

  * Fix changes in older upgrade script after tagging

2.38.1 (2019-11-12)
-------------------

* new logger request type (BulkTransfer)

2.38.0 (2019-09-11)
-------------------

* New charged operation type (MonthlyFee)

* New logger request types (MojeidDeactivateNiaAuthenticators, NiaPairingRequest)

2.37.2 (2019-07-26)
-------------------

* Add new message type (mojeid_sms_password_reset)

2.37.1 (2019-06-10)
-------------------

* Set search_path for unaccent_streets function (fix autoanalyze run for tables with new function indexes)

* New logger request type (MojeidDeactivateFido2)

2.37.0 (2019-04-01)
-------------------

* Add unique constraint for registrar var. symbol

* Fix spec file

2.36.0 (2019-03-08)
-------------------

* Add UUID identifier for every basic registry object (domain, contact, nsset, keyset)
  and every history record

* Add indexes for similar string search (trigrams)

2.35.1 (2019-01-17)
-------------------

* Fix for clean db setup (removed unique constraint)

* Fix e-mail archive migration (2.33.0) and remove cz.nic specific
  templates migration

2.35.0 (2018-08-16)
-------------------

* Bank payments moved to separate project (django-pain, fred-pain)

  * preparations for moving invoices as well

  * FRED will manage only registrar credit transactions through accouting interface (fred-accifd)

* Public request

  * status enum renaming

  * fix personal info template

  * new verification type for requests (government)

2.34.1 (2018-08-08)
-------------------

* Set schema_path for check constraint function (fixing backup restore)

2.34.0 (2018-04-20)
-------------------

* Little rework of mail template version trigger (just check expected version)

* New type of public request (personal info)

* New version of conditional_contact_identification mail template

* New type of poll message (update contact)

2.33.1 (2018-03-27)
-------------------

* Remove no longer needed (not used) indexes

2.33.0 (2018-03-08)
-------------------

* reworked e-mail archive tables

  * drop support for multiple templates (parts) for one e-mail type

  * support template versioning

  * save only template parameters and generate e-mail when sending or rendering

2.32.0 (2017-12-19)
-------------------

* registrar passwords in registraracl table can be in hashed form

2.31.1 (2017-12-11)
-------------------

* fix ``serverBlocked`` status description

* fix 2.21.5-2.21.6.sql upgrade script (remove .cz zone dependency)

2.31.0 (2017-11-15)
-------------------

* add functions to automate logger partitioning dropping

* new logger request types

2.30.0 (2017-09-11)
-------------------

* fix epp poll message table indexes

* fix epp reason messages

2.29.0 (2017-09-11)
-------------------

* contact, nsset, keyset handle format rules (regex) moved to database

2.28.0 (2017-06-21)
-------------------

* automatic keyset management (e-mail templates)

2.27.0 (2017-03-13)
-------------------

* fix domain outzone warning e-mail template

* db constraint for ldh domain name (domains, nameservers)

2.26.2 (2016-03-30)
-------------------

* replace usage of user-defined aggregate function array_accum with built-in array_agg

2.26.1 (2016-03-09)
-------------------

* fix invoice domain renew operation bill item date_from values

2.26.0 (2016-12-19)
-------------------

* configuration for keyset dnskeys algorithm blacklist

* enum domain validation continuation window configuration

* add price list constraints

* add new epp error reasons

2.25.1 (2016-12-19)
-------------------

* new style whois links in e-mail templates

* add MojeidResetPassword request type

2.25.0 (2016-10-09)
-------------------

* configuration for prohibited nsset ip networks

* add ImportOutzoneWarningNotificationEmails request type

2.24.1 (2016-10-14)
-------------------

* mail templates fixes

  * configurable whois registrar list page link

  * fax removed

2.24.0 (2016-09-13)
-------------------

* new status outzoneUnguardedWarning - custom e-mail notification

2.23.0 (2016-06-13)
-------------------

* fix - remove defaults from history tables

* fix - correct defaults for contact disclose[name|organization|address]

* contact create notification e-mail template (with full contact data)

2.22.1 (2016-05-30)
-------------------

* fix length of bank_payment.bank_code column

2.22.0 (2016-04-10)
-------------------

* object event notification made async (notification queue table)

* add additional contact addresses to contact update notification e-mail

* public requests for mojeid transfer with data change

2.21.6 (2016-02-08)
-------------------

* add RDAP service 400 (BadRequest) result code

* registry e-mail templates content fixes

2.21.5 (2015-02-08)
-------------------

* add MojeidDeactivateAutor request type

2.21.4 (2015-11-02)
-------------------

* add OpenIDConnectRefreshRequest request type

2.21.3 (2015-10-13)
-------------------

* add MojeidValidateISIC request type

2.21.2 (2015-08-26)
-------------------

* fix technical test e-mail template

2.21.1 (2015-07-23)
-------------------

* add OpenID Connect request type

2.21.0 (2015-05-19)
-------------------

* add warning letter flag to contact (and contact_history) tables

* add next portion of missing constraints and indexes

* mail template fixes

* new logger request types

* new file types

2.20.0 (2015-01-27)
-------------------

* public request and object state request locking simplified

* logging constraint for discloseaddress flag rules

* contact address type extended with additional 2 shipping addresses

2.19.1 (2014-12-31)
-------------------

* company address change

2.19.0 (2014-10-17)
-------------------

* add table to store additional addreses for contact (with history)

* add public request type for mojeid re-identification

* fix - add index public_request_objects_map.object_id

  * add index object_state.valid_to

  * fix domain.zone constraint

  * add index object_state_request.object_id

2.18.1 (2014-10-24)
------------------------------

* admin. contact verification - new automatic test

2.18.0 (2014-08-01)
-------------------

* mapping table between message type and forwarding service which should be used

* add index contact.name to speed-up contact duplicates search

* logger

  * add domain browser merge contacts request type

  * rdap service, request types and result codes

* public_request_state_request_map removed

2.17.0 (2014-06-13)
-------------------

* data model for admin. contact verification

* e-mail templates minor fixes

2.16.0 (2014-02-13)
-------------------

* add mail default headers by mail type mapping table

* logger - new request type

2.15.0 (2013-11-06)
-------------------

* add table for attach reason for object state request (object_state_request_reason)

* add tables to specify domain name checkers for given zone

* new logger request types for administrative blocking/unblocking of domains

* explicit constraints names (not generated by postgres because it can change between versions)

* removed obsolete functions

2.14.4 (2013-12-20)
-------------------

* add new status for contact manual verification

2.14.3 (2013-10-07)
-------------------

* unused tables removed

2.14.2 (2013-08-15)
-------------------

* object states descriptions - translations changes

2.14.1 (2013-07-30)
-------------------

* new request types for mojeid user management

2.14.0 (2013-06-27)
-------------------

* mail type priority table

* domain browser schema changes

  * new column to enum_object_states table

  * new views for number of domains for keyset/nsset

  * function to get list of object states as parsable string

2.13.0 (2013-04-02)
-------------------

* contact merge auto procedure

  * email templates

  * logger request types

* object update poll messages types

* schema fixes

  * add enumval constraint

    * add enum_object_type table

2.12.2 (2012-11-23)
-------------------

* add new letter type (mojeid_pin3_reminder)

2.12.1 (2012-11-15)
-------------------

* fix setting of mojeidContact in upgrade script

* mojeid pin1 email template changes

2.12.0 (2012-09-06)
-------------------

* mojeid mail templates update (removed demo mode)

* contact verification

  * mail templates

  * sms, letter types

  * public request types

* epp mail notifications - direct whois link added

* public request - enum tables for type and status

* contact identification and validation states are now external

* fix low credit poll message table - credit and creditlimit are now numeric types

* fix differences between new schema and consecutive upgrades

* added object_state.valid_from index for mojeid/cv contact checks speedup

2.11.3 (2012-07-23)
-------------------

* update country codes enumeration

2.11.2 (2012-06-18)
-------------------

* fix update notification mail template (disclose address changes)

2.11.1 (2012-06-11)
-------------------

* fix whois reminder template (removed temporary contact)

2.11.0 (2012-05-11)
-------------------

* bank_payment account.number type to text - was too short for IBAN format

* refactoring of invoice type and invoice prefix tables

* drop epp_info_buffer_content foreign key to object_registry for better performance of epp list commands

2.10.0 (2012-04-27)
-------------------

* epp action removed from fred

2.9.2 (2011-10-26)
------------------

* fix upgrade script

  * price_list.enable_postpaid_operation init

  * unique constraint for (registrar_id, zone_id) in registrar_credit table

* better support for creating logger partitions

2.9.1 (2011-10-24)
------------------

* fix migration of invoice_operation.date_from

* transactions added to upgrade scripts

2.9.0 (2011-10-11)
------------------

* invoicing module rework

* added credit related tables - separation from invoicing

2.8.5 (2011-10-17)
------------------

* whois reminder template fixes

* deleteCandidate status changed to external, description update

* object regular procedure enum_parameters update

  * regular_day_outzone_procedure_period (14)

  * regular_day_procedure_period (0)

  * domain_states view

  * status_update_domain

2.8.4 (2011-08-11)
------------------

* whois reminder template fixes

2.8.3 (2011-07-12)
------------------

* request_fee_parameter table initialization date conv. fix

2.8.2 (2011-07-04)
------------------

* poll_request_fee primary key

2.8.1 (2011-07-04)
------------------

* poll request fee - parameters adjusted

2.8.0 (2011-07-04)
------------------

* poll request fee tables

* enum object states typo fix

2.7.2 (2011-06-14)
------------------

* notify_request primary key fixed

* mail templates format fixes

2.7.1 (2011-05-25)
------------------

* price_vat.koef column type changed to numeric

2.7.0 (2011-05-13)
------------------

* whois contact reminder tables

* public request types added to logger

2.6.3 (2011-03-17)
------------------

* history.request_id index cond. on not null values

2.6.2 (2011-03-16)
------------------

* primary key, unique message_id on notify_request table

* template typo fix

* create_tmp_table with bigint id columnt added to upgrade scripts

2.6.1 (2011-03-02)
------------------

* index for history.request_id

2.6.0 (2011-02-28)
------------------

* Logger reference ids changed in public_request (added resolve_request_id column,
  renamed logd_request_id to create_request_id)

* Datatype of logger id-sequence changed to bigint

* notify_request table

* message_status table dropped, all moved to enum_send_status

* Logger partition indexes

* Logger request_property_name.name attribute expanded to varchar(256) and fixed bad values

2.4.1 (2010-08-10)
------------------

* Logger property renaming - upgrade script

2.4.0 (2010-07-22)
------------------

* New tables for registrar group and certification management

* Notification of expiration letters refactoring

* New enumeration tables for message send status

* Logger procedures fixes

* Schema cleaning (unused tables deleted)

2.3.2 (2010-03-29)
------------------

* banking data migration fixes

2.3.1 (2010-03-22)
------------------

* Banking changes:

  * payment type default value

  * migration fixes

2.3.0 (2010-02-16)
------------------

* Audit (Logger) tables added

* New tables for banking refactoring (constraint changes)

* Registrars

  * 'regex' column added for payment pairing by memo message

    * access to zone limited by 'todate' column in registrarinvoice

* Typo in messages and mail templates fixes

* Separation of upgrade script (schema modification, data modification)

* Dropped constrains to action table (except action_xml table)

2.2.0 (2010-01-08)
------------------

* public request <-> action tables dependency refactoring started

* Enum directory implementation - publish flag

2.1.4 (2009-06-30)
------------------

* fixing minor manager, configure scripts issues

* fixing tables initialization (bank_account, price_list)

* fixing authinfo mail template

* technical test mail template update due to dnssec test

* added new enum parameters:

  * handle_registration_protection_period

  * roid_suffix

2.1.3 (2009-05-05)
------------------

* mail templates update

  * added zone paramater to invoice emails

  * added object handle to subject of notification and expiratjon emails

  * added object changes to notifiaction about epp update command

  * line wrap fixes

* all initial values (except constants) removed

2.1.2 (2009-03-26)
------------------

* Added columns into table history (valid_from, valid_to and next) and corrseponding triggers and update scripts.

2.0.0 (2008-08-14)
------------------

* DNSSEC implementation, new keyset object attached to domain

1.9.0 (2008-05-30)
------------------

* new tables for public request

  * public_request

  * public_request_objects_map

  * public_request_state_request_map

* update default values in object_state_request table

* exdate changed to date from datetime

* new mail template for blocking request

1.8.2 (2008-04-30)
------------------

* fixing fred-dbmanager uninstallation process

* fixing mail_template with notification about delete of contact and nsset

* new indexes (poll)

1.8.1
-----

* better user detection in fred-dbmanager

* new indexes (mail,epp_info)

* new indexes into history tables

* new table for stored filters

2008-03-25
----------

* upgrade deleteCandidate state update procedure for contacts/nssets

2008-03-12
----------

* few indexes added

2008-03-12
----------

* configuration process enhancement

* adding sql comments

1.8.0 (2008-02-09)
------------------

* adding action_elements table

* setting of sequences for tables registrar,registraracl,zone,registrarinvoice

2008-02-01
----------

* new directory with distinct upgrade sql files for every change

* new table with top level domains

* refactoring and fixing state.sql

  * states setting parameters moved to parameters table

  * exdate states dependant on serverRenewProhibited

  * proper handling of shared linked state updates (locking)

* new parameter table with system configuration

2008-01-19
----------

* autotooling package with a lot of structural changes

2007-05-24
----------

* ccreg.sql (domain_contact_map) - Adding role of contact - 1=admin, 2=temp and

* history.sql (domain_contact_map_history) - Adding role of contact - 1=admin, 2=temp and

* reason.sql - Fixing typo

* ChangeLog - Adding this changelog

* UPGRADE - Updating alter script
