CREATE OR REPLACE FUNCTION migrate_mail_archive_type_1(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE WHEN mail_type_id = 1 THEN
           json_build_object(
               'header', json_build_object(
                   'To',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
               ),
               'body', json_build_object(
                   'reqdate',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'via the web form on our pages on(.*?), which was assigned'), '\s', '', 'g'),
                   'reqid',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'the identification number(.*?), we are sending you the'), '\s', '', 'g'),
                   'authinfo',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'The password is:(.*?)If you did not submit the aforementioned'), '\s', '', 'g'),
                   'type',
                       CASE WHEN SUBSTRING(message FROM 'belonging to the domain name') IS NOT NULL THEN 3
                            WHEN SUBSTRING(message FROM 'belonging to the contact identified with') IS NOT NULL THEN 1
                            WHEN SUBSTRING(message FROM 'belonging to the NS set identified') IS NOT NULL THEN 2
                            WHEN SUBSTRING(message FROM 'belonging to the keyset identified with') IS NOT NULL THEN 4
                       END,
                   'handle',
                       CASE WHEN SUBSTRING(message FROM 'belonging to the domain name') IS NOT NULL
                                 THEN REGEXP_REPLACE(SUBSTRING(message FROM 'belonging to the domain name(.*?).\n'), '\s', '', 'g')
                            WHEN SUBSTRING(message FROM 'belonging to the contact identified with') IS NOT NULL
                                 THEN REGEXP_REPLACE(SUBSTRING(message FROM 'belonging to the contact identified with(.*?).\n'), '\s', '', 'g')
                            WHEN SUBSTRING(message FROM 'belonging to the NS set identified') IS NOT NULL
                                 then regexp_replace(substring(message FROM 'belonging to the NS set identified(.*?).\n'), '\s', '', 'g')
                            WHEN SUBSTRING(message from 'belonging to the keyset identified with') IS NOT NULL
                                 THEN REGEXP_REPLACE(SUBSTRING(message FROM 'belonging to the keyset identified with(.*?).\n'), '\s', '', 'g')
                       END
               )
           )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- sendauthinfo_pif


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_2(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE WHEN mail_type_id = 2 THEN
           json_build_object(
               'header', json_build_object(
                   'To',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
               ),
               'body', json_build_object(
                   'registrar',
                       SUBSTRING(message FROM 'submitted via the registrar (.*?),\nwe are sending you'),
                   'password',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'The password is:(.*?)\nThis'), '\s', '', 'g'),
                   'type',
                       CASE WHEN SUBSTRING(message FROM 'příslušející k doméně') IS NOT NULL THEN 3
                            WHEN SUBSTRING(message FROM 'příslušející ke kontaktu s identifikátorem') IS NOT NULL THEN 1
                            WHEN SUBSTRING(message FROM 'příslušející k sadě nameserverů s identifikátorem') IS NOT NULL THEN 2
                            WHEN SUBSTRING(message FROM 'příslušející k sadě klíčů s identifikátorem') IS NOT NULL THEN 4
                       END,
                   'handle',
                       CASE WHEN SUBSTRING(message FROM 'příslušející k doméně') IS NOT NULL
                                 THEN REGEXP_REPLACE(SUBSTRING(message from 'příslušející k doméně(.*?).\n'), '\s', '', 'g')
                            WHEN SUBSTRING(message FROM 'příslušející ke kontaktu s identifikátorem') IS NOT NULL
                                 THEN REGEXP_REPLACE(SUBSTRING(message FROM 'příslušející ke kontaktu s identifikátorem(.*?).\n'), '\s', '', 'g')
                            WHEN SUBSTRING(message FROM 'příslušející k sadě nameserverů s identifikátorem') IS NOT NULL
                                 THEN REGEXP_REPLACE(SUBSTRING(message FROM 'příslušející k sadě nameserverů s identifikátorem(.*?).\n'), '\s', '', 'g')
                            WHEN SUBSTRING(message FROM 'příslušející k sadě klíčů s identifikátorem') IS NOT NULL
                                 THEN REGEXP_REPLACE(SUBSTRING(message FROM 'příslušející k sadě klíčů s identifikátorem(.*?).\n'), '\s', '', 'g')
                       END
                )
           )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- sendauthinfo_epp


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_3(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE WHEN mail_type_id = 3 THEN
           json_build_object(
               'header', json_build_object(
                   'To',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
               ),
               'body', json_build_object(
                   'header_to',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g'),
                   'checkdate',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'We would like to inform you that as of(.*?), your registrar'), '\s', '', 'g'),
                   'domain',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'registration of the domain name(.*?). Concerning'), '\s', '', 'g'),
                   'exdate',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'for a period ending on(.*?), your domain name'), '\s', '', 'g'),
                   'dnsdate',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'Registration Rules:\n\n(.*?)- The domain name will become inaccessible \(exclusion from DNS\)'), '\s', '', 'g'),
                   'exregdate',
                       REGEXP_REPLACE(SUBSTRING(message FROM '\(exclusion from DNS\)\.\n(.*?)- The final cancellation of the domain name registration'), '\s', '', 'g'),
                   'owner',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'Holder:(.*?)\n'), '\s', '', 'g'),
                   'registrar',
                       SUBSTRING(message FROM 'Registrar: (.*?)\n'),
                   'administrators', (
                       SELECT ARRAY_AGG(foo.a) AS administrators
                         FROM (SELECT ARRAY_TO_STRING(REGEXP_MATCHES(message, 'Admin contact: (.*?)\n', 'g'), '') AS a) AS foo
                   )
               )
           )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- expiration_notify


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_4(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE WHEN mail_type_id = 4 THEN
           json_build_object(
               'header', json_build_object(
                   'To',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
               ),
               'body', json_build_object(
                   'domain',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'of the domain name(.*?). With regard to that'), '\s', '', 'g'),
                   'zone',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'excluding it from the\n(.*?)zone\.'), '\s', '', 'g'),
                   'day_before_exregdate',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'designated registrar by(.*?),'), '\s', '', 'g'),
                   'exregdate',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'the domain is extended:\n\n(.*?)- The final cancellation of the'), '\s', '', 'g'),
                   'owner',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'Owner:(.*?)\n'), '\s', '', 'g'),
                   'registrar',
                       SUBSTRING(message FROM 'Designated registrar: (.*?)\n'),
                   'administrators', (
                       SELECT ARRAY_AGG(foo.a) AS administrators
                         FROM (SELECT ARRAY_TO_STRING(REGEXP_MATCHES(message, 'Admin.*? contact: (.*?)\n', 'g'), '') AS a) AS foo
                   )
               )
           )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- expiration_dns_owner


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_5(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE WHEN mail_type_id = 5 THEN
           json_build_object(
               'header', json_build_object(
                   'To',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
               ),
               'body', json_build_object(
                   'domain', REGEXP_REPLACE(SUBSTRING(message FROM 'of the domain name(.*?)\. Due'), '\s', '', 'g')
               )
           )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- expiration_register_owner


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_6(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE WHEN mail_type_id = 6 THEN
           json_build_object(
               'header', json_build_object(
                   'To',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
               ),
               'body', json_build_object(
                   'nsset',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'technical contact for the set\n(.*?)of nameservers'), '\s', '', 'g'),
                   'domain',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'of nameservers assigned to the(.*?)\n'), '\s', '', 'g'),
                   'statechangedate',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'was excluded from DNS as of(.*?)\.'), '\s', '', 'g')
               )
           )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- expiration_dns_tech


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_7(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE WHEN mail_type_id = 7 THEN
           json_build_object(
               'header', json_build_object(
                   'To',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
               ),
               'body', json_build_object(
                   'nsset',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'technical contact for the set\n(.*?)of nameservers'), '\s', '', 'g'),
                   'domain',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'of nameservers assigned to the(.*?)\n'), '\s', '', 'g'),
                   'exregdate',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'was cancelled as of(.*?)\.'), '\s', '', 'g')
               )
           )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- expiration_register_tech


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_8(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE WHEN mail_type_id = 8 THEN
           json_build_object(
               'header', json_build_object(
                   'To',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
               ),
               'body', json_build_object(
                   'checkdate',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'We would like to notify you that as of(.*?),\n'), '\s', '', 'g'),
                   'domain',
                       REGEXP_REPLACE(SUBSTRING(message FROM '\nthe(.*?)domain name validation has'), '\s', '', 'g'),
                   'owner',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'Owner:(.*?)\n'), '\s', '', 'g'),
                   'registrar',
                       SUBSTRING(message FROM 'Registrar: (.*?)\n'),
                   'administrators', (
                       SELECT ARRAY_AGG(foo.a) AS administrators
                         FROM (SELECT ARRAY_TO_STRING(REGEXP_MATCHES(message, 'Admin contact: (.*?)\n', 'g'), '') AS a) AS foo
                   )
               )
           )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- expiration_validation_before


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_9(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE WHEN mail_type_id = 9 THEN
           json_build_object(
               'header', json_build_object(
                   'To',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
               ),
               'body', json_build_object(
                   'checkdate',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'We would like to notify you that as of(.*?),\n'), '\s', '', 'g'),
                   'domain',
                       REGEXP_REPLACE(SUBSTRING(message FROM '\nthe(.*?)domain name validation has not been extended'), '\s', '', 'g'),
                   'owner',
                       REGEXP_REPLACE(SUBSTRING(message FROM 'Owner:(.*?)\n'), '\s', '', 'g'),
                   'registrar',
                       SUBSTRING(message FROM 'Registrar: (.*?)\n'),
                   'administrators', (
                       SELECT ARRAY_AGG(foo.a) AS administrators
                         FROM (SELECT ARRAY_TO_STRING(REGEXP_MATCHES(message, 'Admin contact: (.*?)\n', 'g'), '') AS a) AS foo
                   )
               )
           )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- expiration_validation


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_10(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE
           WHEN mail_type_id = 10 THEN
               CASE
               WHEN message LIKE '%Domain creation%' THEN
                   json_build_object(
                       'header', json_build_object(
                           'To',
                               REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                       ),
                       'body', json_build_object(
                           'handle',
                               REGEXP_REPLACE(SUBSTRING(message FROM '/ Domain handle :(.*?)\n'), '\s', '', 'g'),
                           'ticket',
                               REGEXP_REPLACE(SUBSTRING(message FROM '/ Ticket :(.*?)\n'), '\s', '', 'g'),
                           'registrar',
                               SUBSTRING(message FROM '/ Registrar : (.*?)\n'),
                           'type', 3
                       )
                   )::JSONB
               WHEN message LIKE '%NS set creation%' THEN
                   json_build_object(
                       'header', json_build_object(
                           'To',
                               REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                       ),
                       'body', json_build_object(
                           'handle',
                               REGEXP_REPLACE(SUBSTRING(message FROM '/ NS set handle :(.*?)\n'), '\s', '', 'g'),
                           'ticket',
                               REGEXP_REPLACE(SUBSTRING(message FROM '/ Ticket :(.*?)\n'), '\s', '', 'g'),
                           'registrar',
                               SUBSTRING(message FROM '/ Registrar : (.*?)\n'),
                           'type', 2
                       )
                   )::JSONB
               WHEN message LIKE '%Keyset creation%' THEN
                   json_build_object(
                       'header', json_build_object(
                           'To',
                               REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                       ),
                       'body', json_build_object(
                           'handle',
                               REGEXP_REPLACE(SUBSTRING(message FROM '/ Keyset handle :(.*?)\n'), '\s', '', 'g'),
                           'ticket',
                               REGEXP_REPLACE(SUBSTRING(message FROM '/ Ticket :(.*?)\n'), '\s', '', 'g'),
                           'registrar',
                               SUBSTRING(message FROM '/ Registrar : (.*?)\n'),
                           'type', 4
                       )
                   )::JSONB
               WHEN message LIKE '%Contact creation%' THEN
                   json_build_object(
                       'header', json_build_object(
                           'To',
                               REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                       ),
                       'body', json_build_object(
                           'handle',
                               REGEXP_REPLACE(SUBSTRING(message FROM '/ Contact handle :(.*?)\n'), '\s', '', 'g'),
                           'ticket',
                               REGEXP_REPLACE(SUBSTRING(message FROM '/ Ticket :(.*?)\n'), '\s', '', 'g'),
                           'registrar',
                               SUBSTRING(message FROM '/ Registrar : (.*?)\n'),
                           'type', 1,
                           'fresh.contact.name',
                               BTRIM(SUBSTRING(message FROM 'Details of the contact are:.*?Jméno / Name: (.*?)\n.*?Viditelnost údajů')),
                           'fresh.contact.org',
                               BTRIM(SUBSTRING(message FROM 'Details of the contact are:.*?Organizace / Organization: (.*?)\n.*?Viditelnost údajů')),
                           'fresh.contact.address.permanent',
                               BTRIM(SUBSTRING(message FROM 'Details of the contact are:.*?Trvalá Adresa / Permanent Address: (.*?)\n.*?Viditelnost údajů')),
                           'fresh.contact.address.mailing',
                               BTRIM(SUBSTRING(message FROM 'Details of the contact are:.*?Korespondenční adresa / Mailing address: (.*?)\n.*?Viditelnost údajů')),
                           'fresh.contact.address.billing',
                               BTRIM(SUBSTRING(message FROM 'Details of the contact are:.*?Fakturační adresa / Billing address: (.*?)\n.*?Viditelnost údajů')),
                           'fresh.contact.address.shipping',
                               BTRIM(SUBSTRING(message FROM 'Details of the contact are:.*?Dodací adresa / Shipping address: (.*?)\n.*?Viditelnost údajů')),
                           'fresh.contact.telephone',
                               BTRIM(SUBSTRING(message FROM 'Details of the contact are:.*?Telefon / Telephone: (.*?)\n.*?Viditelnost údajů')),
                           'fresh.contact.fax',
                               BTRIM(SUBSTRING(message FROM 'Details of the contact are:.*?Fax / Fax: (.*?)\n.*?Viditelnost údajů')),
                           'fresh.contact.email',
                               BTRIM(SUBSTRING(message FROM 'Details of the contact are:.*?E-mail / Email: (.*?)\n.*?Viditelnost údajů')),
                           'fresh.contact.notify_email',
                               BTRIM(SUBSTRING(message FROM 'Details of the contact are:.*?Notifikační e-mail / Notification email: (.*?)\n.*?Viditelnost údajů')),
                           'fresh.contact.ident_type',
                               BTRIM(SUBSTRING(message FROM 'Details of the contact are:.*?Typ identifikace / Identification type: (.*?)\n.*?Viditelnost údajů')),
                           'fresh.contact.ident',
                               BTRIM(SUBSTRING(message FROM 'Details of the contact are:.*?Identifikační údaj / Identification data: (.*?)\n.*?Viditelnost údajů')),
                           'fresh.contact.vat',
                               BTRIM(SUBSTRING(message FROM 'Details of the contact are:.*?DIČ / VAT number: (.*?)\n.*?Viditelnost údajů')),
                           'fresh.contact.disclose.name',
                               CASE
                               WHEN BTRIM(SUBSTRING(message FROM 'Viditelnost údajů / Data visibility:\n.*?Jméno / Name: (.*?)\n')) ~ 'public'
                                   THEN 1 ELSE 0
                               END,
                           'fresh.contact.disclose.org',
                               CASE
                               WHEN BTRIM(SUBSTRING(message FROM 'Viditelnost údajů / Data visibility:\n.*?Organizace / Organization: (.*?)\n')) ~ 'public'
                                   THEN 1 ELSE 0
                               END,
                           'fresh.contact.disclose.email',
                               CASE
                               WHEN BTRIM(SUBSTRING(message FROM 'Viditelnost údajů / Data visibility:\n.*?E-mail / Email: (.*?)\n')) ~ 'public'
                                   THEN 1 ELSE 0
                               END,
                           'fresh.contact.disclose.address',
                               CASE
                               WHEN BTRIM(SUBSTRING(message FROM 'Viditelnost údajů / Data visibility:\n.*?Adresa / Address: (.*?)\n')) ~ 'public'
                                   THEN 1 ELSE 0
                               END,
                           'fresh.contact.disclose.notify_email',
                               CASE
                               WHEN BTRIM(SUBSTRING(message FROM 'Viditelnost údajů / Data visibility:\n.*?Notifikační e-mail / Notification email: (.*?)\n')) ~ 'public'
                                   THEN 1 ELSE 0
                               END,
                           'fresh.contact.disclose.ident',
                               CASE
                               WHEN BTRIM(SUBSTRING(message FROM 'Viditelnost údajů / Data visibility:\n.*?Identifikační údaj / Identification data: (.*?)\n')) ~ 'public'
                                   THEN 1 ELSE 0
                               END,
                           'fresh.contact.disclose.vat',
                               CASE
                               WHEN BTRIM(SUBSTRING(message FROM 'Viditelnost údajů / Data visibility:\n.*?DIČ / VAT number: (.*?)\n')) ~ 'public'
                                   THEN 1 ELSE 0
                               END,
                           'fresh.contact.disclose.telephone',
                               CASE
                               WHEN BTRIM(SUBSTRING(message FROM 'Viditelnost údajů / Data visibility:\n.*?Telefon / Telephone: (.*?)\n')) ~ 'public'
                                   THEN 1 ELSE 0
                               END,
                           'fresh.contact.disclose.fax',
                               CASE
                               WHEN BTRIM(SUBSTRING(message FROM 'Viditelnost údajů / Data visibility:\n.*?Fax / Fax: (.*?)\n')) ~ 'public'
                                   THEN 1 ELSE 0
                               END
                       )
                   )::JSONB
               ELSE NULL
               END
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- notification_create


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_11(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE
           WHEN mail_type_id = 11 THEN
               CASE
               WHEN message like '%Contact data change%' THEN
                   json_build_object(
                       'header', json_build_object(
                           'To',
                               REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                       ),
                       'body', json_build_object(
                           'type', 1,
                           'changes.object.authinfo.old',
                               BTRIM(SUBSTRING(message FROM '\nHeslo / Authinfo: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.contact.name.old',
                               BTRIM(SUBSTRING(message FROM '\nPůvodní hodnoty / Original values:.*?Jméno / Name: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.contact.org.old',
                               BTRIM(SUBSTRING(message FROM '\nOrganizace / Organization: (.*?)\n')),
                           'changes.contact.address.permanent.old',
                               BTRIM(SUBSTRING(message FROM '\nTrvalá Adresa / Permanent Address: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.contact.address.mailing.old',
                               BTRIM(SUBSTRING(message FROM '\nKorespondenční adresa / Mailing address: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.contact.address.billing.old',
                               BTRIM(SUBSTRING(message FROM '\nFakturační adresa / Billing address: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.contact.address.shipping.old',
                               BTRIM(SUBSTRING(message FROM '\nDodací adresa / Shipping address: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.contact.address.shipping_2.old',
                               BTRIM(SUBSTRING(message FROM '\nDodací adresa / Shipping address:.*?\nDodací adresa / Shipping address: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.contact.address.shipping_3.old',
                               BTRIM(SUBSTRING(message FROM '\nDodací adresa / Shipping address:.*?\nDodací adresa / Shipping address:.*?\nDodací adresa / Shipping address: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.contact.telephone.old',
                               BTRIM(SUBSTRING(message FROM '\nTelefon / Telephone: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.contact.fax.old',
                               BTRIM(SUBSTRING(message FROM '\nFax / Fax: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.contact.email.old',
                               BTRIM(SUBSTRING(message FROM '\nE-mail / Email: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.contact.notify_email.old',
                               BTRIM(SUBSTRING(message FROM '\nNotifikační e-mail / Notification email: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.contact.ident_type.old',
                               BTRIM(SUBSTRING(message FROM '\nTyp identifikace / Identification type: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.contact.ident.old',
                               BTRIM(SUBSTRING(message FROM '\nIdentifikační údaj / Identification data: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.contact.vat.old',
                               BTRIM(SUBSTRING(message FROM '\nDIČ / VAT number: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.contact.disclose.name.old',
                               CASE
                               WHEN BTRIM(SUBSTRING(message FROM 'Viditelnost údajů / Data visibility:.*\n  Jméno / Name: (.*?)\n.*?Nové hodnoty / New values:')) ~ 'public'
                                   THEN 1 ELSE 0
                               END,
                           'changes.contact.disclose.org.old',
                               CASE
                               WHEN BTRIM(SUBSTRING(message FROM 'Viditelnost údajů / Data visibility:.*\n  Organizace / Organization: (.*?)\n.*?Nové hodnoty / New values:')) ~ 'public'
                                   THEN 1 ELSE 0
                               END,
                           'changes.contact.disclose.email.old',
                               CASE
                               WHEN BTRIM(SUBSTRING(message FROM 'Viditelnost údajů / Data visibility:.*\n  E-mail / Email: (.*?)\n.*?Nové hodnoty / New values:')) ~ 'public'
                                   THEN 1 ELSE 0
                               END,
                           'changes.contact.disclose.address.old',
                               CASE
                               WHEN BTRIM(SUBSTRING(message FROM 'Viditelnost údajů / Data visibility:.*\n  Adresa / Address: (.*?)\n.*?Nové hodnoty / New values:')) ~ 'public'
                                   THEN 1 ELSE 0
                               END,
                           'changes.contact.disclose.notify_email.old',
                               CASE
                               WHEN BTRIM(SUBSTRING(message FROM 'Viditelnost údajů / Data visibility:.*\n  Notifikační e-mail / Notification email: (.*?)\n.*?Nové hodnoty / New values:')) ~ 'public'
                                   THEN 1 ELSE 0
                               END,
                           'changes.contact.disclose.ident.old',
                               CASE
                               WHEN BTRIM(SUBSTRING(message FROM 'Viditelnost údajů / Data visibility:.*\n  Identifikační údaj / Identification data: (.*?)\n.*?Nové hodnoty / New values:')) ~ 'public'
                                   THEN 1 ELSE 0
                               END,
                           'changes.contact.disclose.vat.old',
                               CASE
                               WHEN BTRIM(SUBSTRING(message FROM 'Viditelnost údajů / Data visibility:.*\n  DIČ / VAT number: (.*?)\n.*?Nové hodnoty / New values:')) ~ 'public'
                                   THEN 1 ELSE 0
                               END,
                           'changes.contact.disclose.telephone.old',
                               CASE
                               WHEN BTRIM(SUBSTRING(message FROM 'Viditelnost údajů / Data visibility:.*\n  Telefon / Telephone: (.*?)\n.*?Nové hodnoty / New values:')) ~ 'public'
                                   THEN 1 ELSE 0
                               END,
                           'changes.contact.disclose.fax.old',
                               CASE WHEN BTRIM(SUBSTRING(message FROM 'Viditelnost údajů / Data visibility:.*\n  Fax / Fax: (.*?)\n.*?Nové hodnoty / New values:')) ~ 'public'
                                   THEN 1 ELSE 0
                               END,
                           'changes.object.authinfo.new',
                               BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*\nHeslo / Authinfo: (.*?)\n')),
                           'changes.contact.name.new',
                               BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*\nJméno / Name: (.*?)\n')),
                           'changes.contact.org.new',
                               BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*\nOrganizace / Organization: (.*?)\n')),
                           'changes.contact.address.permanent.new',
                               BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*\nTrvalá Adresa / Permanent Address: (.*?)\n')),
                           'changes.contact.address.mailing.new',
                               BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*\nKorespondenční adresa / Mailing address: (.*?)\n')),
                           'changes.contact.address.billing.new',
                               BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*\nFakturační adresa / Billing address: (.*?)\n')),
                           'changes.contact.address.shipping.new',
                               BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*?\nDodací adresa / Shipping address: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.contact.address.shipping_2.new',
                               BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*?\nDodací adresa / Shipping address:.*?\nDodací adresa / Shipping address: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.contact.address.shipping_3.new',
                               BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*?\nDodací adresa / Shipping address:.*?\nDodací adresa / Shipping address:.*?\nDodací adresa / Shipping address: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.contact.telephone.new',
                               BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*\nTelefon / Telephone: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.contact.fax.new',
                               BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*\nFax / Fax: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.contact.email.new',
                               BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*\nE-mail / Email: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.contact.notify_email.new',
                               BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*\nNotifikační e-mail / Notification email: (.*?)\n')),
                           'changes.contact.ident_type.new',
                               BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*\nTyp identifikace / Identification type: (.*?)\n')),
                           'changes.contact.ident.new',
                               BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*\nIdentifikační údaj / Identification data: (.*?)\n')),
                           'changes.contact.vat.new',
                               BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*\nDIČ / VAT number: (.*?)\n')),
                           'changes.contact.disclose.name.new',
                               CASE
                               WHEN BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*?Viditelnost údajů / Data visibility:.*\n  Jméno / Name: (.*?)\n.*?')) ~ 'public'
                                   THEN 1 ELSE 0
                               END,
                           'changes.contact.disclose.org.new',
                               CASE
                               WHEN BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*?Viditelnost údajů / Data visibility:.*\n  Organizace / Organization: (.*?)\n.*?Nové hodnoty / New values:')) ~ 'public'
                                   THEN 1 ELSE 0
                               END,
                           'changes.contact.disclose.email.new',
                               CASE
                               WHEN BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*?Viditelnost údajů / Data visibility:.*\n  E-mail / Email: (.*?)\n.*?Nové hodnoty / New values:')) ~ 'public'
                                   THEN 1 ELSE 0
                               END,
                           'changes.contact.disclose.address.new',
                               CASE
                               WHEN BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*?Viditelnost údajů / Data visibility:.*\n  Adresa / Address: (.*?)\n.*?Nové hodnoty / New values:')) ~ 'public'
                                   THEN 1 ELSE 0
                               END,
                           'changes.contact.disclose.notify_email.new',
                               CASE
                               WHEN BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*?Viditelnost údajů / Data visibility:.*\n  Notifikační e-mail / Notification email: (.*?)\n.*?Nové hodnoty / New values:')) ~ 'public'
                                   THEN 1 ELSE 0
                               END,
                           'changes.contact.disclose.ident.new',
                               CASE
                               WHEN BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*?Viditelnost údajů / Data visibility:.*\n  Identifikační údaj / Identification data: (.*?)\n.*?Nové hodnoty / New values:')) ~ 'public'
                                   THEN 1 ELSE 0
                               END,
                           'changes.contact.disclose.vat.new',
                               CASE
                               WHEN BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*?Viditelnost údajů / Data visibility:.*\n  DIČ / VAT number: (.*?)\n.*?Nové hodnoty / New values:')) ~ 'public'
                                   THEN 1 ELSE 0
                               END
                       )::JSONB
                            || json_build_object(
                           'changes.contact.disclose.telephone.new',
                               CASE WHEN BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*?Viditelnost údajů / Data visibility:.*\n  Telefon / Telephone: (.*?)\n.*?Nové hodnoty / New values:')) ~ 'public'
                                   THEN 1 ELSE 0
                               END,
                           'changes.contact.disclose.fax.new',
                               CASE WHEN BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*?Viditelnost údajů / Data visibility:.*\n  Fax / Fax: (.*?)\n.*?Nové hodnoty / New values:')) ~ 'public'
                                   THEN 1 ELSE 0
                               END
                       )::JSONB
                   )::JSONB
               WHEN message LIKE '%NS set data change%' THEN
                   json_build_object(
                       'header', json_build_object(
                           'To',
                               REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                       ),
                       'body', json_build_object(
                           'type', 2,
                           'changes.object.authinfo.old',
                               BTRIM(SUBSTRING(message FROM '\nHeslo / Authinfo: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.nsset.check_level.old',
                               BTRIM(SUBSTRING(message FROM '\nÚroveň tech. kontrol / Check level: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.nsset.tech_c.old',
                               BTRIM(SUBSTRING(message FROM '\nTechnické kontakty / Technical contacts: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.nsset.dns.old', (
                               SELECT ARRAY_AGG(foo.a) AS dns
                                 FROM (SELECT ARRAY_TO_STRING(REGEXP_MATCHES(SUBSTRING(message
                                         FROM '(.*)\nNové hodnoty / New values:'), '\nJmenný server / Name server: (.*?)\n', 'g'), '') AS a) AS foo
                           ),
                           'changes.object.authinfo.new',
                               BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*\nHeslo / Authinfo: (.*?)\n')),
                           'changes.nsset.check_level.new',
                               BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*\nÚroveň tech. kontrol / Check level: (.*?)\n')),
                           'changes.nsset.tech_c.new',
                               BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*\nTechnické kontakty / Technical contacts: (.*?)\n')),
                           'changes.nsset.dns.new', (
                               SELECT ARRAY_AGG(foo.a) AS dns
                                 FROM (SELECT ARRAY_TO_STRING(REGEXP_MATCHES(SUBSTRING(message
                                         FROM 'Nové hodnoty / New values:\n(.*)'), 'Nové hodnoty / New values:.*\nJmenný server / Name server: (.*?)\n', 'g'), '') AS a) AS foo
                           )
                       )
                   )::JSONB
               WHEN message LIKE '%Domain data change%' THEN
                   json_build_object(
                       'header', json_build_object(
                           'To',
                               REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                       ),
                       'body', json_build_object(
                           'type', 3,
                           'changes.object.authinfo.old',
                               BTRIM(SUBSTRING(message FROM '\nHeslo / Authinfo: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.domain.registrant.old',
                               BTRIM(SUBSTRING(message FROM '\nDržitel / Holder: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.domain.nsset.old',
                               BTRIM(SUBSTRING(message FROM '\nSada jmenných serverů / Name server set: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.domain.keyset.old',
                               BTRIM(SUBSTRING(message FROM '\nSada klíčů / Key set: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.domain.admin_c.old',
                               BTRIM(SUBSTRING(message FROM '\nAdministrativní kontakty / Administrative contacts: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.domain.temp_c.old',
                               BTRIM(SUBSTRING(message FROM '\nDočasné kontakty / Temporary contacts: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.domain.val_ex_date.old',
                               BTRIM(SUBSTRING(message FROM '\nValidováno do / Validation expiration date: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.domain.publish.old',
                               CASE
                               WHEN BTRIM(SUBSTRING(message FROM 'Přidat do ENUM tel.sezn. / Include in ENUM dict: (.*?)\n.*?Nové hodnoty / New values:')) ~ 'yes'
                                   THEN 1 ELSE 0
                               END,
                           'changes.object.authinfo.new',
                               BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*\nHeslo / Authinfo: (.*?)\n')),
                           'changes.domain.registrant.new',
                               BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*\nDržitel / Holder: (.*?)\n')),
                           'changes.domain.nsset.new',
                               BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*\nSada jmenných serverů / Name server set: (.*?)\n')),
                           'changes.domain.admin_c.new',
                               BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*\nAdministrativní kontakty / Administrative contacts: (.*?)\n')),
                           'changes.domain.temp_c.new',
                               BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*\nDočasné kontakty / Temporary contacts: (.*?)\n')),
                           'changes.domain.val_ex_date.new',
                               BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*\nValidováno do / Validation expiration date: (.*?)\n')),
                           'changes.domain.publish.new',
                               CASE
                               WHEN BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*\nPřidat do ENUM tel.sezn. / Include in ENUM dict: (.*?)\n')) ~ 'yes'
                                   THEN 1 ELSE 0
                               END
                       )
                   )::JSONB
               WHEN message LIKE '%Keyset data change%' THEN
                   json_build_object(
                       'header', json_build_object(
                           'To',
                               REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                       ),
                       'body', json_build_object(
                           'type', 4,
                           'changes.object.authinfo.old',
                               BTRIM(SUBSTRING(message FROM '\nHeslo / Authinfo: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.keyset.tech_c.old',
                               BTRIM(SUBSTRING(message FROM '\nTechnické kontakty / Technical contacts: (.*?)\n.*?Nové hodnoty / New values:')),
                           'changes.nsset.dnskey.old', (
                               SELECT ARRAY_AGG(foo.a) AS dnskey
                                 FROM (SELECT ARRAY_TO_STRING(REGEXP_MATCHES(SUBSTRING(message
                                         FROM '(.*)\nNové hodnoty / New values:'), '\nklíče DNS / DNS keys: (.*?)\n', 'g'), '') AS a) AS foo
                           ),
                           'changes.object.authinfo.new',
                               BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*\nHeslo / Authinfo: (.*?)\n')),
                           'changes.keyset.tech_c.new',
                               BTRIM(SUBSTRING(message FROM 'Nové hodnoty / New values:.*\nTechnické kontakty / Technical contacts: (.*?)\n')),
                           'changes.nsset.dnskey.new', (
                               SELECT ARRAY_AGG(foo.a) AS dnskey
                                 FROM (SELECT ARRAY_TO_STRING(REGEXP_MATCHES(SUBSTRING(message
                                         FROM 'Nové hodnoty / New values:\n(.*)'), 'Nové hodnoty / New values:.*\nklíče DNS / DNS keys: (.*?)\n', 'g'), '') AS a) AS foo
                           )
                       )
                   )::JSONB
               ELSE NULL
               END
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- notification_update


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_12(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE
           WHEN mail_type_id = 12 THEN
               json_build_object(
                   'header', json_build_object(
                       'To',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                   ),
                   'body', json_build_object(
                       'type',
                           CASE
                           WHEN SUBSTRING(message FROM '(Transfer .*? transfer)\n') = 'Transfer kontaktu / Contact transfer'
                               THEN 1
                           WHEN SUBSTRING(message FROM '(Transfer .*? transfer)\n') = 'Transfer sady nameserverů / NS set transfer'
                               THEN 2
                           WHEN SUBSTRING(message FROM '(Transfer .*? transfer)\n') = 'Transfer domény / Domain transfer'
                               THEN 3
                           WHEN SUBSTRING(message FROM '(Transfer .*? transfer)\n') = 'Transfer sady klíčů / Keyset transfer'
                               THEN 4
                           END,
                       'handle',
                           REGEXP_REPLACE(SUBSTRING(message FROM '/ .*? handle : (.*?)\n'), '\s', '', 'g'),
                       'ticket',
                           REGEXP_REPLACE(SUBSTRING(message FROM '/ Ticket : (.*?)\n'), '\s', '', 'g'),
                       'registrar',
                           SUBSTRING(message FROM '/ Registrar : (.*?)\n')
                   )
               )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- notification_transfer


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_13(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE
           WHEN mail_type_id = 13 THEN
               json_build_object(
                   'header', json_build_object(
                       'To',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                   ),
                   'body', json_build_object(
                       'handle',
                           REGEXP_REPLACE(SUBSTRING(message FROM '/ Domain :(.*?)\n'), '\s', '', 'g'),
                       'ticket',
                           REGEXP_REPLACE(SUBSTRING(message FROM '/ Ticket :(.*?)\n'), '\s', '', 'g'),
                       'registrar',
                           SUBSTRING(message FROM '/ Registrar : (.*?)\n'),
                       'type', 4
                   )
               )::JSONB
          ELSE NULL
          END;
$$
LANGUAGE SQL;
-- notification_renew


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_14(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE
           WHEN mail_type_id = 14 THEN
               CASE
               WHEN message LIKE '%contact identified%' THEN
                   json_build_object(
                       'header', json_build_object(
                           'To',
                               REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                       ),
                       'body', json_build_object(
                           'handle',
                               REGEXP_REPLACE(SUBSTRING(message FROM 'contact identified with (.*?)\n'), '\s', '', 'g'),
                           'deldate',
                               REGEXP_REPLACE(SUBSTRING(message FROM 'cancelling the aforementioned contact as of (.*?)\.\n'), '\s', '', 'g'),
                           'type', 1

                       )
                   )::JSONB
               WHEN message LIKE '%NS set identified with%' THEN
                   json_build_object(
                       'header', json_build_object(
                           'To',
                               REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                       ),
                       'body', json_build_object(
                           'handle',
                               REGEXP_REPLACE(SUBSTRING(message FROM 'the NS set identified with (.*?)\n'), '\s', '', 'g'),
                           'deldate',
                               REGEXP_REPLACE(SUBSTRING(message FROM 'cancelling the aforementioned set of nameservers as of (.*?)\.\n'), '\s', '', 'g'),
                           'type', 2
                       )
                   )::JSONB
               WHEN message LIKE '%keyset identified with%' THEN
                   json_build_object(
                       'header', json_build_object(
                           'To',
                               REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                       ),
                       'body', json_build_object(
                           'handle',
                               REGEXP_REPLACE(SUBSTRING(message FROM 'the keyset identified with (.*?)\n'), '\s', '', 'g'),
                           'deldate',
                               REGEXP_REPLACE(SUBSTRING(message FROM 'cancelling the aforementioned set of keysets as of (.*?)\.\n'), '\s', '', 'g'),
                           'type', 4
                       )
                   )::JSONB
               ELSE NULL
               END
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- notification_unused


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_15(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE
           WHEN mail_type_id = 15 THEN
               json_build_object(
                   'header', json_build_object(
                       'To',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                   ),
                   'body', json_build_object(
                       'handle',
                           REGEXP_REPLACE(SUBSTRING(message FROM '/ Domain handle :(.*?)\n'), '\s', '', 'g'),
                       'ticket',
                           REGEXP_REPLACE(SUBSTRING(message FROM '/ Ticket : \xa0(.*?)\n'), '\s', '', 'g'),
                       'registrar',
                           SUBSTRING(message FROM '/ Registrar : (.*?)\n'),
                       'type', 3
                   )
               )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- notification_delete


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_16(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE
           WHEN mail_type_id = 16 THEN
               json_build_object(
                   'header', json_build_object(
                       'To',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                   ),
                   'body', json_build_object(
                       'handle', substring(message from 'Sada nameserverů / NS set: (.*?)\n'),
                       'ticket', regexp_replace(substring(message from '/ Ticket: (.*?)\n'), '\s', '', 'g'),
                       'checkdate', substring(message from 'Datum kontroly / Date of the check: (.*?)\n'),
                       'ns', '',
                       'fqdn', '',
                       'domain', ''
                   )
               )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- techcheck


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_17(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE
           WHEN mail_type_id = 17 THEN
               json_build_object(
                   'header', json_build_object(
                       'To',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                   ),
                   'body', json_build_object(
                       'header_to',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g'),
                       'zone',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'payment received for the (.*?) zone'), '\s', '', 'g')
                   )
               )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- invoice_deposit


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_18(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE
           WHEN mail_type_id = 18 THEN
               json_build_object(
                   'header', json_build_object(
                       'To',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                   ),
                   'body', json_build_object(
                       'fromdate',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'from (.*?) to'), '\s', '', 'g'),
                       'todate',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'to (.*?) for the'), '\s', '', 'g'),
                       'zone',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'for the (.*?) zone'), '\s', '', 'g')
                   )
               )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- invoice_audit


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_19(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE
           WHEN mail_type_id = 19 THEN
               json_build_object(
                   'header', json_build_object(
                       'To',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                   ),
                   'body', json_build_object(
                       'fromdate',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'period from (.*?) to'), '\s', '', 'g'),
                       'todate',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'to (.*?) for the'), '\s', '', 'g'),
                       'zone',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'for the (.*?) zone,'), '\s', '', 'g')
                   )
               )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- invoice_noaudit


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_20(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE
           WHEN mail_type_id = 20 THEN
               json_build_object(
                   'header', json_build_object(
                       'To',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                   ),
                   'body', json_build_object(
                       'reqdate',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'pages on (.*?), which'), '\s', '', 'g'),
                       'reqid',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'identification number\n(.*?), we are'), '\s', '', 'g'),
                       'otype',
                           CASE
                           WHEN SUBSTRING(message FROM 'we are announcing that your request for (.*?)\n') = 'blocking'
                               THEN 1
                           WHEN SUBSTRING(message FROM 'we are announcing that your request for (.*?)\n') = 'unblocking'
                               THEN 2
                           END,
                       'rtype',
                           CASE
                           WHEN SUBSTRING(message FROM 'your request for.*?\n(.*?) for') = 'data changes'
                               THEN 1
                           WHEN SUBSTRING(message FROM 'your request for.*?\n(.*?) for') = 'transfer to other registrar'
                               THEN 2
                           END,
                       'type',
                           CASE
                           WHEN SUBSTRING(message FROM 'your request.*?\n.* for (.*?) [^ ]*?\nhas been dealt with') = 'domain name'
                               THEN 3
                           WHEN SUBSTRING(message FROM 'your request.*?\n.* for (.*?) [^ ]*?\nhas been dealt with') = 'contact identified with'
                               THEN 1
                           WHEN SUBSTRING(message FROM 'your request.*?\n.* for (.*?) [^ ]*?\nhas been dealt with') = 'NS set identified with'
                               THEN 2
                           WHEN SUBSTRING(message FROM 'your request.*?\n.* for (.*?) [^ ]*?\nhas been dealt with') = 'keyset identified with'
                               THEN 4
                           END,
                       'handle',
                           SUBSTRING(message FROM ' ([^ ]*?)\nhas been dealt with')
                   )
               )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- request_block


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_21(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE
           WHEN mail_type_id = 21 THEN
               json_build_object(
                   'header', json_build_object(
                       'To',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                   ),
                   'body', json_build_object(
                       'passwd',
                           SUBSTRING(message FROM 'PIN1: (.*?)\n'),
                       'hostname',
                           SUBSTRING(message FROM 'https://(.*?)/identify/'),
                       'identification',
                           SUBSTRING(message FROM 'https://.*?/identify/email-sms/(.*?)/\?password1='),
                       'handle',
                           SUBSTRING(message FROM 'účet mojeID: (.*?)\n'),
                       'firstname',
                           SUBSTRING(message FROM 'jméno:       (.*?)\n'),
                       'lastname',
                           SUBSTRING(message FROM 'příjmení:    (.*?)\n'),
                       'email',
                           SUBSTRING(message FROM 'e-mail:      (.*?)\n')
                   )
               )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- mojeid_identification


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_22(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE
           WHEN mail_type_id = 22 THEN
               json_build_object(
                   'header', json_build_object(
                       'To',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                   ),
                   'body', json_build_object(
                       'status',
                           CASE
                           WHEN SUBSTRING(message FROM 'Validace účtu mojeID (.*?)\n') = 'provedena'
                               THEN 1
                           WHEN SUBSTRING(message FROM 'Validace účtu mojeID (.*?)\n') = 'neprovedena'
                               THEN 0 -- XXX
                           END,
                       'reqdate',
                           SUBSTRING(message FROM 'žádosti číslo .*? ze dne (.*?)( byla provedena validace účtu mojeID|, nebyl validován)\.'),
                       'name',
                           SUBSTRING(message FROM 'Jméno: (.*?)\n'),
                       'org',
                           SUBSTRING(message FROM 'Organizace: (.*?)\n'),
                       'ic',
                           SUBSTRING(message FROM 'IČ: (.*?)\n'),
                       'birthdate',
                           SUBSTRING(message FROM 'Datum narození: (.*?)\n'),
                       'address',
                           SUBSTRING(message FROM 'Adresa: (.*?)\n')
                   )
               )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- mojeid_validation


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_23(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE
           WHEN mail_type_id = 23 THEN
               json_build_object(
                   'header', json_build_object(
                       'To',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                   ),
                   'body', json_build_object(
                       'handle',
                           SUBSTRING(message FROM 'ID kontaktu v registru: (.*?)\n'),
                       'organization',
                           SUBSTRING(message FROM 'Organizace: (.*?)\n'),
                       'name',
                           SUBSTRING(message FROM 'Jméno: (.*?)\n'),
                       'address',
                           SUBSTRING(message FROM 'Adresa: (.*?)\n'),
                       'ident_type',
                           CASE
                           WHEN SUBSTRING(message FROM 'Birth date: ') IS NOT NULL
                               THEN 'RC'
                           WHEN SUBSTRING(message FROM 'Číslo OP: ') IS NOT NULL
                               THEN 'OP'
                           WHEN SUBSTRING(message FROM 'Číslo pasu: ') IS NOT NULL
                               THEN 'PASS'
                           WHEN SUBSTRING(message FROM 'IČO: ') IS NOT NULL
                               THEN 'ICO'
                           WHEN SUBSTRING(message FROM 'Identifikátor MPSV: ') IS NOT NULL
                               THEN 'MPSV'
                           WHEN SUBSTRING(message FROM 'Birth day: ') IS NOT NULL
                               THEN 'BIRTHDAY'
                           END,
                       'ident_value',
                           CASE
                           WHEN SUBSTRING(message FROM 'Birth date: ') IS NOT NULL
                               THEN SUBSTRING(message FROM 'Birth date: (.*?)\n')
                           WHEN SUBSTRING(message FROM 'Číslo OP: ') IS NOT NULL
                               THEN SUBSTRING(message FROM 'Číslo OP: (.*?)\n')
                           WHEN SUBSTRING(message FROM 'Číslo pasu: ') IS NOT NULL
                               THEN SUBSTRING(message FROM 'Číslo pasu: (.*?)\n')
                           WHEN SUBSTRING(message FROM 'IČO: ') IS NOT NULL
                               THEN SUBSTRING(message FROM 'IČO: (.*?)\n')
                           WHEN SUBSTRING(message FROM 'Identifikátor MPSV: ') IS NOT NULL
                               THEN SUBSTRING(message FROM 'Identifikátor MPSV: (.*?)\n')
                           WHEN SUBSTRING(message FROM 'Birth day: ') IS NOT NULL
                               THEN SUBSTRING(message FROM 'Birth day: (.*?)\n')
                           END,
                       'dic',
                           SUBSTRING(message FROM 'DIČ: (.*?)\n'),
                       'telephne',
                           SUBSTRING(message FROM 'Telefon: (.*?)\n'),
                       'fax',
                           SUBSTRING(message FROM 'Fax: (.*?)\n'),
                       'email',
                           SUBSTRING(message FROM 'E-mail: (.*?)\n'),
                       'notify_email',
                           SUBSTRING(message FROM 'Notifikační e-mail: (.*?)\n'),
                       'registrar_name',
                           SUBSTRING(message FROM 'Určený registrátor: (.*?) \(.*?\)\n'),
                       'registrar_url',
                           SUBSTRING(message FROM 'Určený registrátor: .*? \((.*?)\)\n'),
                       'registrar_memo_cz',
                           SUBSTRING(message FROM 'Další informace poskytnuté registrátorem:\n(.*?)\nV případě, že jsou údaje správné, nereagujte prosím na tento e-mail\.'),
                       'registrar_memo_en',
                           SUBSTRING(message FROM 'Other information provided by your registrar:\n(.*?)\nPlease, do not take any measures if your data are correct\.'),
                       'domains', (
                           SELECT STRING_TO_ARRAY(ARRAY_TO_STRING(REGEXP_MATCHES(message, 'Seznam domén, kde je kontakt v roli držitele nebo administrativního\nkontaktu:\n(.*)\n(Kontakt není uveden u žádného doménového jména\.|Seznam sad jmenných serverů, kde je kontakt v roli technického kontaktu:|Seznam sad klíčů, kde je kontakt v roli technického kontaktu:|Dear customer,)'), ''), E'\n')
                       ),
                       'nssets', (
                           SELECT STRING_TO_ARRAY(ARRAY_TO_STRING(REGEXP_MATCHES(message, 'Seznam sad jmenných serverů, kde je kontakt v roli technického kontaktu:\n(.*)\n(Seznam sad klíčů, kde je kontakt v roli technického kontaktu:|Dear customer,)'), ''), E'\n')
                        ),
                       'keysets', (
                           SELECT STRING_TO_ARRAY(ARRAY_TO_STRING(REGEXP_MATCHES(message, 'Seznam sad klíčů, kde je kontakt v roli technického kontaktu:\n(.*?)\nDear customer,'), ''), E'\n')
                       )
                   )
               )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- annual_contact_reminder


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_24(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE
           WHEN mail_type_id = 24 THEN
               json_build_object(
                   'header', json_build_object(
                       'To',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                   ),
                   'body', json_build_object(
                       'pin',
                           SUBSTRING(message FROM '\nk dokončení procedury změny e-mailu zadejte prosím kód PIN1: (.*?)\n')
                   )
               )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- mojeid_email_change


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_25(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE
           WHEN mail_type_id = 25 THEN
               json_build_object(
                   'header', json_build_object(
                       'To',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                   ),
                   'body', json_build_object(
                       'handle',
                           SUBSTRING(message FROM 'ID kontaktu: (.*?)\n'),
                       'firstname',
                           SUBSTRING(message FROM 'jméno:       (.*?)\n'),
                       'lastname',
                           SUBSTRING(message FROM 'příjmení:    (.*?)\n'),
                       'email',
                           SUBSTRING(message FROM 'e-mail:      (.*?)\n'),
                       'passwd',
                           SUBSTRING(message FROM 'PIN1: (.*?)\n'),
                       'hostname',
                           SUBSTRING(message FROM 'https://(.*?)/verification/'),
                       'identification',
                           SUBSTRING(message FROM 'https://.*?/verification/identify/email-sms/(.*?)/\?password1=')
                   )
               )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- conditional_contact_identification


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_26(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE
           WHEN mail_type_id = 26 THEN
               json_build_object(
                   'header', json_build_object(
                       'To',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                   ),
                   'body', json_build_object(
                       'handle',
                           SUBSTRING(message FROM 'identifikátor: (.*?)\n'),
                       'firstname',
                           SUBSTRING(message FROM 'jméno:         (.*?)\n'),
                       'lastname',
                           SUBSTRING(message FROM 'příjmení:      (.*?)\n'),
                       'email',
                           SUBSTRING(message FROM 'e-mail:        (.*?)\n'),
                       'hostname',
                           SUBSTRING(message FROM 'https://(.*?)/verification/'),
                       'identification',
                           SUBSTRING(message FROM 'https://.*?/verification/identify/letter/\?handle=')
                   )
               )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- contact_identification


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_27(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE
           WHEN mail_type_id = 27 THEN
               json_build_object(
                   'header', json_build_object(
                       'To',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                   ),
                   'body', json_build_object(
                       'handle',
                           SUBSTRING(message FROM 'účet mojeID: (.*?)\n'),
                       'firstname',
                           SUBSTRING(message FROM 'jméno:       (.*?)\n'),
                       'lastname',
                           SUBSTRING(message FROM 'příjmení:    (.*?)\n'),
                       'email',
                           SUBSTRING(message FROM 'e-mail:      (.*?)\n'),
                       'passwd',
                           SUBSTRING(message FROM 'PIN1: (.*?)\n'),
                       'hostname',
                           SUBSTRING(message FROM 'https://(.*?)/identify/'),
                       'identification',
                           SUBSTRING(message FROM 'https://.*?/identify/email/(.*?)/\?password1=')
                   )
               )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- mojeid_verified_contact_transfer


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_28(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE
           WHEN mail_type_id = 28 THEN
               json_build_object(
                   'header', json_build_object(
                       'To',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                   ),
                   'body', json_build_object(
                       'dst_contact_handle',
                           SUBSTRING(message, 'merged into a single entry carrying the identifier (.*?)\.\n'),
                       'domain_registrant_list',
                           STRING_TO_ARRAY(REGEXP_REPLACE(SUBSTRING(message, 'Holders were changed for the following domains:\n(.*?)\n\n'), ' ', '', 'g'), E'\n'),
                       'domain_admin_list',
                           STRING_TO_ARRAY(REGEXP_REPLACE(SUBSTRING(message, 'Administrative contacts were changed for the following domains:\n(.*?)\n\n'), ' ', '', 'g'), E'\n'),
                       'nsset_tech_list',
                           STRING_TO_ARRAY(REGEXP_REPLACE(SUBSTRING(message, 'Technical contacts were changed for the following nameserver sets:\n(.*?)\n\n'), ' ', '', 'g'), E'\n'),
                       'keyset_tech_list',
                           STRING_TO_ARRAY(REGEXP_REPLACE(SUBSTRING(message, 'Technical contacts were changed for the following key sets:\n(.*?)\n\n'), ' ', '', 'g'), E'\n'),
                       'removed_list',
                           STRING_TO_ARRAY(REGEXP_REPLACE(SUBSTRING(message, 'The following duplicate contact entries were removed:\n(.*?)\n\n'), ' ', '', 'g'), E'\n')
                   )
               )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- merge_contacts_auto


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_29(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE
           WHEN mail_type_id = 29 THEN
               json_build_object(
                   'header', json_build_object(
                       'To',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                   ),
                   'body', json_build_object(
                       'contact_handle',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'of data assigned to the contact identified with (.*?) \(The original letter'), '\s', '', 'g')
                   )
               )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- contact_check_notice


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_30(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE
           WHEN mail_type_id = 30 THEN
               json_build_object(
                   'header', json_build_object(
                       'To',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                   ),
                   'body', json_build_object(
                       'contact_handle',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'the data assigned to the contact identified with (.*?) has not been corrected up to this'), '\s', '', 'g'),
                       'contact_update_till',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'their accuracy is provided\) till (.*?), we can, in'), '\s', '', 'g')
                   )
               )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- contact_check_warning


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_31(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE
           WHEN mail_type_id = 31 THEN
               json_build_object(
                   'header', json_build_object(
                       'To',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                   ),
                   'body', json_build_object(
                       'domain',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'of the domain name (.*?). With regard to that'), '\s', '', 'g'),
                       'zone',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'and excluding it from the\n(.*?) zone on'), '\s', '', 'g'),
                       'dnsdate',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'zone on (.*?).\n'), '\s', '', 'g'),
                       'day_before_exregdate',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'through your\ndesignated registrar by (.*?),'), '\s', '', 'g'),
                       'exregdate',
                           REGEXP_REPLACE(SUBSTRING(message FROM '\(exclusion from DNS\)\.\n(.*?) \- The final cancellation of the domain name registration'), '\s', '', 'g'),
                       'owner',
                           REGEXP_REPLACE(SUBSTRING(message FROM '\nOwner: (.*?)\n'), '\s', '', 'g'),
                       'registrar',
                           SUBSTRING(message FROM 'Designated registrar: (.*?)\n'),
                       'administrators', (
                           SELECT ARRAY_AGG(foo.a) AS administrators
                             FROM (SELECT ARRAY_TO_STRING(REGEXP_MATCHES(message, 'Administrative contact: (.*?)\n', 'g'), '') AS a) AS foo
                       )
                   )
               )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- expiration_dns_warning_owner


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_32(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE
           WHEN mail_type_id = 32 THEN
               json_build_object(
                   'header', json_build_object(
                       'To',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                   ),
                   'body', json_build_object(
                       'domain',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'all DNS servers of your domain (.*?)\. The CDNSKEY'), '\s', '', 'g'),
                       'keys',
                           '[' || SUBSTRING(message, 'contained the following key\(s\):\n.*?\[(.*?)\]\n') || ']',
                       'datetime',
                           SUBSTRING(message FROM '\nDiscovered at: (.*?)\n')
                   )
               )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- akm_candidate_state_ok


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_33(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE
           WHEN mail_type_id = 33 THEN
               json_build_object(
                   'header', json_build_object(
                       'To',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                   ),
                   'body', json_build_object(
                       'domain',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'Unless you change the configuration, your (.*?) domain will not be included'), '\s', '', 'g'),
                       'datetime',
                           SUBSTRING(message FROM '\nDetected at: (.*?)\n')
                   )
               )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- akm_candidate_state_ko


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_34(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE
           WHEN mail_type_id = 34 THEN
               json_build_object(
                   'header', json_build_object(
                       'To',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                   ),
                   'body', json_build_object(
                       'domain',
                           SUBSTRING(message, 'following key\(s\) on DNS servers of your domain (.*?):\n'),
                       'keys',
                           STRING_TO_ARRAY(SUBSTRING(message, 'on DNS servers of your domain .*?:\n\n(.*?)\n\n'), E'\n'),
                       'datetime',
                           SUBSTRING(message, 'Discovered at: (.*?)\n'),
                       'zone',
                           SUBSTRING(message, 'keys in the (.*?) zone. Given that this key')
                   )
               )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- akm_keyset_update


CREATE OR REPLACE FUNCTION migrate_mail_archive_type_35(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
    SELECT CASE
           WHEN mail_type_id = 35 THEN
               json_build_object(
                   'header', json_build_object(
                       'To',
                           REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)Message-ID: '), '\s', '', 'g')
                   ),
                   'body', json_build_object(
                       'request_day',
                           SUBSTRING(message FROM '\nna základě Vaší žádosti podané prostřednictvím webového formuláře na našich stránkách dne (.*?)\..*?\..*?, Vám v příloze zasíláme požadovaný výpis z registru doménových jmen\.\n'),
                       'request_month',
                           SUBSTRING(message FROM '\nna základě Vaší žádosti podané prostřednictvím webového formuláře na našich stránkách dne .*?\.(.*?)\..*?, Vám v příloze zasíláme požadovaný výpis z registru doménových jmen\.\n'),
                       'request_year',
                           SUBSTRING(message FROM '\nna základě Vaší žádosti podané prostřednictvím webového formuláře na našich stránkách dne .*?\..*?\.(.*?), Vám v příloze zasíláme požadovaný výpis z registru doménových jmen\.\n')
                   )
               )::JSONB
           ELSE NULL
           END;
$$
LANGUAGE SQL;
-- record_statement


CREATE OR REPLACE FUNCTION migrate_mail_archive_to_json(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
DECLARE
    message_params JSONB;
BEGIN
    IF COALESCE(message, '') != '' AND SUBSTRING(message FROM '^Content-Type') IS NULL THEN
        RETURN json_build_object('header', json_build_object('To', message))::JSONB;
    END IF;
    EXECUTE 'SELECT migrate_mail_archive_type_' || mail_type_id || '($1, $2)' INTO message_params USING message, mail_type_id;
    RETURN message_params;
END;
$$
LANGUAGE PLPGSQL;
