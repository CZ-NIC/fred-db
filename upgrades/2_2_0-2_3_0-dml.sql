---
--- UPGRADE SCRIPT 2.2.0 -> 2.3.0 (data modification part)
---

---
--- dont forget to update database schema version
---
UPDATE enum_parameters SET val = '2.3.0' WHERE id = 1;

---
--- Ticket #1670 Banking refactoring
---

INSERT INTO enum_bank_code (name_full,name_short,code) VALUES ('Fio, družstevní záložna', 'FIOZ', '2010');
UPDATE bank_account SET balance = 0.0 WHERE balance IS NULL;

---
--- data migration
--- bank_statement_head -> bank_statement
---
INSERT INTO bank_statement
                           (id, account_id, num, create_date, balance_old_date,
                            balance_old, balance_new, balance_credit, balance_debet,
                            file_id)

    SELECT id, account_id, num, create_date, balance_old_date, balance_old, balance_new,
           balance_credit, balance_debet, NULL
       FROM bank_statement_head
      ORDER BY id;

---
--- bank_statement_item && bank_ebanka_list -> bank_payement
--- (should be ordered by account_date or not?, crtime set to NOW()?)
---

INSERT INTO bank_payment
                         (statement_id, account_id, account_number, bank_code,
                          code, type, status, konstsym, varsymb, specsymb,
                          price, account_evid, account_date, account_memo,
                          invoice_id, account_name, crtime)

        SELECT NULL, ebanka.account_id, trim(both ' ' from ebanka.account_number),
                trim(both ' ' from ebanka.bank_code), 1, NULL::integer, 1,
                trim(both ' ' from ebanka.konstsym), trim(both from ebanka.varsymb),
                NULL, ebanka.price, trim(both ' ' from ebanka.ident) as account_evid,
                ebanka.crdate AS account_date, trim(both ' ' from ebanka.memo),
                ebanka.invoice_id, trim(both ' ' from ebanka.name), NOW()
           FROM bank_ebanka_list ebanka
        UNION ALL
        SELECT csob.statement_id,
               (SELECT ba.id
                   FROM bank_account ba
                  WHERE ba.account_number = csob.account_number AND ba.bank_code = csob.bank_code
                 LIMIT 1
               ),
               trim(both ' ' from csob.account_number), trim(both ' ' from csob.bank_code),
               1, NULL::integer, 1, trim(both ' ' from csob.konstsym), trim(both ' ' from csob.varsymb),
               trim(both ' ' from csob.specsymb), csob.price, trim(both ' ' from csob.account_evid) as account_evid,
               csob.account_date AS account_date, trim(both ' ' from csob.account_memo), csob.invoice_id, NULL,
               NOW()
           FROM bank_statement_item csob
          ORDER BY account_date, account_evid;


---
--- Typo fixes
---

---
--- Ticket #3107 - object state description typo
---
UPDATE
    enum_object_states_desc
SET
    description = 'Domain is administratively kept out of zone'
WHERE
    state_id = 5 AND lang = 'EN';


UPDATE
    enum_object_states_desc
SET
    description = 'Domain is administratively kept in zone'
WHERE
    state_id = 6 AND lang = 'EN';

---
--- Upgrade to fixes from SVN r8467 and r9590 - Fix typos
---

UPDATE
    enum_object_states_desc
SET
    description = 'Není povoleno prodloužení registrace objektu'
WHERE
    state_id = 2 AND lang = 'CS';

UPDATE
    enum_object_states_desc
SET
    description = 'Registration renewal prohibited'
WHERE
    state_id = 2 AND lang = 'EN';



UPDATE
    enum_reason
SET
    reason = 'bad format of contact handle'
WHERE
    id = 1;

UPDATE
    enum_reason
SET
    (reason, reason_cs) = ('bad format of nsset handle', 'neplatný formát ukazatele nssetu')
WHERE
    id = 2;

UPDATE
    enum_reason
SET
    reason_cs = 'neplatný formát názvu domény'
WHERE
    id = 3;

UPDATE
    enum_reason
SET
    (reason, reason_cs) = ('within protection period.', 'je v ochranné lhůtě')
WHERE
    id = 7;

UPDATE
    enum_reason
SET
    reason_cs = 'neplatná IP adresa'
WHERE
    id = 8;

UPDATE
    enum_reason
SET
    reason_cs = 'neplatný formát názvu jmenného serveru DNS'
WHERE
    id = 9;

UPDATE
    enum_reason
SET
    reason_cs = 'duplicitní adresa jmenného serveru DNS'
WHERE
    id = 10;

UPDATE
    enum_reason
SET
    reason_cs = 'nepovolená  IP adresa glue záznamu'
WHERE
    id = 11;

UPDATE
    enum_reason
SET
    reason_cs = 'jsou zapotřebí alespoň dva DNS servery'
WHERE
    id = 12;

UPDATE
    enum_reason
SET
    reason_cs = 'perioda je nad maximální dovolenou hodnotou'
WHERE
    id = 14;

UPDATE
    enum_reason
SET
    reason_cs = 'perioda neodpovídá dovolenému intervalu'
WHERE
    id = 15;

UPDATE
    enum_reason
SET
    reason_cs = 'neznámé msgID'
WHERE
    id = 17;

UPDATE
    enum_reason
SET
    reason_cs = 'datum vypršení platnosti se nepoužívá'
WHERE
    id = 18;

UPDATE
    enum_reason
SET
    reason_cs = 'nelze odstranit jmenný server DNS'
WHERE
    id = 21;

UPDATE
    enum_reason
SET
    reason_cs = 'nelze přidat jmenný server DNS'
WHERE
    id = 22;

UPDATE
    enum_reason
SET
    (reason, reason_cs) = ('Can not remove technical contact', 'nelze vymazat technický kontakt')
WHERE
    id = 23;

UPDATE
    enum_reason
SET
    reason = 'Technical contact does not exist'
WHERE
    id = 25;

UPDATE
    enum_reason
SET
    reason_cs = 'Administrátorský kontakt je již přiřazen k tomuto objektu'
WHERE
    id = 26;

UPDATE
    enum_reason
SET
    (reason, reason_cs) = ('Administrative contact does not exist', 'Administrátorský kontakt neexistuje')
WHERE
    id = 27;

UPDATE
    enum_reason
SET
    (reason, reason_cs) = ('nsset handle does not exist.', 'sada jmenných serverů není vytvořena')
WHERE
    id = 28;

UPDATE
    enum_reason
SET
    reason_cs = 'jmenný server DNS je již přiřazen sadě jmenných serverů'
WHERE
    id = 30;

UPDATE
    enum_reason
SET
    reason_cs = 'jmenný server DNS není přiřazen sadě jmenných serverů'
WHERE
    id = 31;

UPDATE
    enum_reason
SET
    (reason, reason_cs) = ('Registration is prohibited', 'Registrace je zakázána')
WHERE
    id = 36;

UPDATE
    enum_reason
SET
    reason = 'Bad format of keyset handle'
WHERE
    id = 39;

UPDATE
    enum_reason
SET
    reason = 'Keyset handle does not exist'
WHERE
    id = 40;

UPDATE
    enum_reason
SET
    reason = 'DSRecord is not set for this keyset'
WHERE
    id = 45;

UPDATE
    enum_reason
SET
    reason = 'Digest must be 40 characters long'
WHERE
    id = 47;

UPDATE
    enum_reason
SET
    reason = 'Object does not belong to the registrar'
WHERE
    id = 48;

UPDATE
    enum_reason
SET
    reason = 'Too many nameservers in this nsset'
WHERE
    id = 52;

UPDATE
    enum_reason
SET
    reason_cs = 'Pole ``flags'''' musí být 0, 256 nebo 257'
WHERE
    id = 54;

UPDATE
    enum_reason
SET
    reason = 'Field ``key'''' contains invalid character'
WHERE
    id = 58;

UPDATE
    enum_reason
SET
    reason = 'DNSKey does not exist for this keyset'
WHERE
    id = 60;




UPDATE
    mail_templates
SET
    template = 
'English version of the e-mail is entered below the Czech version

Zaslání autorizační informace

Vážený zákazníku,

   na základě Vaší žádosti podané prostřednictvím webového formuláře
na stránkách sdružení dne <?cs var:reqdate ?>, které
bylo přiděleno identifikační číslo <?cs var:reqid ?>, Vám zasíláme požadované
heslo, příslušející <?cs if:type == #3 ?>k doméně<?cs elif:type == #1 ?>ke kontaktu s identifikátorem<?cs elif:type == #2 ?>k sadě nameserverů s identifikátorem<?cs elif:type == #4 ?>k sadě klíčů s identifikátorem<?cs /if ?> <?cs var:handle ?>.

   Heslo je: <?cs var:authinfo ?>

   V případě, že jste tuto žádost nepodali, oznamte prosím tuto
skutečnost na adresu <?cs var:defaults.emailsupport ?>.

                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>



Sending authorization information

Dear customer,

   Based on your request submitted via the web form on the association
pages on <?cs var:reqdate ?>, which received
the identification number <?cs var:reqid ?>, we are sending you the requested
password that belongs to the <?cs if:type == #3 ?>domain name<?cs elif:type == #1 ?>contact with identifier<?cs elif:type == #2 ?>NS set with identifier<?cs elif:type == #4 ?>Keyset with identifier<?cs /if ?> <?cs var:handle ?>.

   The password is: <?cs var:authinfo ?>

   If you did not submit the aforementioned request, please notify us about
this fact at the following address <?cs var:defaults.emailsupport ?>.


                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
'
WHERE
    id = 1;


UPDATE
    mail_templates
SET
    template = 
' English version of the e-mail is entered below the Czech version

Zaslání autorizační informace

Vážený zákazníku,

   na základě Vaší žádosti, podané prostřednictvím registrátora
<?cs var:registrar ?>, Vám zasíláme požadované heslo
příslušející <?cs if:type == #3 ?>k doméně<?cs elif:type == #1 ?>ke kontaktu s identifikátorem<?cs elif:type == #2 ?>k sadě nameserverů s identifikátorem<?cs elif:type == #4 ?>k sadě klíčů s identifikátorem<?cs /if ?> <?cs var:handle ?>.

   Heslo je: <?cs var:authinfo ?>

   Tato zpráva je zaslána pouze na e-mailovou adresu uvedenou u příslušné
osoby v Centrálním registru doménových jmen.

   V případě, že jste tuto žádost nepodali, oznamte prosím tuto
skutečnost na adresu <?cs var:defaults.emailsupport ?>.


                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>



Sending authorization information

Dear customer,

   Based on your request submitted via the registrar <?cs var:registrar ?>,
we are sending the requested password that belongs to
the <?cs if:type == #3 ?>domain name<?cs elif:type == #1 ?>contact with identifier<?cs elif:type == #2 ?>NS set with identifier<?cs elif:type == #4 ?>Keyset with identifier<?cs /if ?> <?cs var:handle ?>.

   The password is: <?cs var:authinfo ?>

   This message is being sent only to the e-mail address that we have on file
for a particular person in the Central Registry of Domain Names.

   If you did not submit the aforementioned request, please notify us about
this fact at the following address <?cs var:defaults.emailsupport ?>.


                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
'
WHERE
    id = 2;


---
--- Ticket #3477
---

UPDATE mail_templates SET template =
'
Výsledek technické kontroly sady nameserverů <?cs var:handle ?>
Result of technical check on NS set <?cs var:handle ?>

Datum kontroly / Date of the check: <?cs var:checkdate ?>
Typ kontroly / Control type : periodická / periodic 
Číslo kontroly / Ticket: <?cs var:ticket ?>

<?cs def:printtest(par_test) ?><?cs if:par_test.name == "existence" ?>Následující nameservery v sadě nameserverů nejsou dosažitelné:
Following nameservers in NS set are not reachable:
<?cs each:ns = par_test.ns ?>    <?cs var:ns ?>
<?cs /each ?><?cs /if ?><?cs if:par_test.name == "autonomous" ?>Sada nameserverů neobsahuje minimálně dva nameservery v různých
autonomních systémech.
In NS set are no two nameservers in different autonomous systems.

<?cs /if ?><?cs if:par_test.name == "presence" ?><?cs each:ns = par_test.ns ?>Nameserver <?cs var:ns ?> neobsahuje záznam pro domény:
Nameserver <?cs var:ns ?> does not contain record for domains:
<?cs each:fqdn = ns.fqdn ?>    <?cs var:fqdn ?>
<?cs /each ?><?cs if:ns.overfull ?>    ...
<?cs /if ?><?cs /each ?><?cs /if ?><?cs if:par_test.name == "authoritative" ?><?cs each:ns = par_test.ns ?>Nameserver <?cs var:ns ?> není autoritativní pro domény:
Nameserver <?cs var:ns ?> is not authoritative for domains:
<?cs each:fqdn = ns.fqdn ?>    <?cs var:fqdn ?>
<?cs /each ?><?cs if:ns.overfull ?>    ...
<?cs /if ?><?cs /each ?><?cs /if ?><?cs if:par_test.name == "heterogenous" ?>Všechny nameservery v sadě nameserverů používají stejnou implementaci
DNS serveru.
All nameservers in NS set use the same implementation of DNS server.

<?cs /if ?><?cs if:par_test.name == "notrecursive" ?>Následující nameservery v sadě nameserverů jsou rekurzivní:
Following nameservers in NS set are recursive:
<?cs each:ns = par_test.ns ?>    <?cs var:ns ?>
<?cs /each ?><?cs /if ?><?cs if:par_test.name == "notrecursive4all" ?>Následující nameservery v sadě nameserverů zodpověděly rekurzivně dotaz:
Following nameservers in NS set answered recursively a query:
<?cs each:ns = par_test.ns ?>    <?cs var:ns ?>
<?cs /each ?><?cs /if ?><?cs if:par_test.name == "dnsseckeychase" ?>Pro následující domény přislušející sadě nameserverů nebylo možno 
sestavit řetěz důvěry:
For following domains belonging to NS set was unable to create 
key chain of trust:
<?cs each:domain = par_test.ns ?>    <?cs var:domain ?>
<?cs /each ?><?cs /if ?><?cs /def ?>
=== Chyby / Errors ==================================================

<?cs each:item = tests ?><?cs if:item.type == "error" ?><?cs call:printtest(item) ?><?cs /if ?><?cs /each ?>
=== Varování / Warnings =============================================

<?cs each:item = tests ?><?cs if:item.type == "warning" ?><?cs call:printtest(item) ?><?cs /if ?><?cs /each ?>
=== Upozornění / Notice =============================================

<?cs each:item = tests ?><?cs if:item.type == "notice" ?><?cs call:printtest(item) ?><?cs /if ?><?cs /each ?>
=====================================================================


                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>
' WHERE id = 16;


