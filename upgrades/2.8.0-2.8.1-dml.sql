---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.8.1' WHERE id = 1;


UPDATE mail_templates SET template = '
This is a bilingual message. Please see below for the English version

Vážená paní, vážený pane,

dovolujeme si Vás zdvořile požádat o kontrolu správnosti údajů,
které nyní evidujeme u Vašeho kontaktu v centrálním registru
doménových jmen.

ID kontaktu v registru: <?cs var:handle ?>
Organizace: <?cs var:organization ?>
Jméno: <?cs var:name ?>
Adresa: <?cs var:address ?><?cs if:ident_type != "" ?>
<?cs if:ident_type == "RC"?>Datum narození: <?cs 
elif:ident_type == "OP"?>Číslo OP: <?cs 
elif:ident_type == "PASS"?>Číslo pasu: <?cs 
elif:ident_type == "ICO"?>IČO: <?cs 
elif:ident_type == "MPSV"?>Identifikátor MPSV: <?cs 
elif:ident_type == "BIRTHDAY"?>Datum narození: <?cs 
/if ?> <?cs var:ident_value ?><?cs 
/if ?>
DIČ: <?cs var:dic ?>
Telefon: <?cs var:telephone ?>
Fax: <?cs var:fax ?>
E-mail: <?cs var:email ?>
Notifikační e-mail: <?cs var:notify_email ?>
Určený registrátor: <?cs var:registrar_name ?> (<?cs var:registrar_url ?>)
<?cs if:registrar_memo_cz ?>Další informace poskytnuté registrátorem:
<?cs var:registrar_memo_cz ?><?cs /if ?>

Se žádostí o opravu údajů se neváhejte obrátit na svého vybraného registrátora.
V případě, že zde uvedené údaje odpovídají skutečnosti, není nutné na tuto zprávu reagovat.

Aktuální, úplné a správné informace v registru znamenají Vaši jistotu,
že Vás důležité informace o Vaší doméně zastihnou vždy a včas na správné adrese.
Nedočkáte se tak nepříjemného překvapení v podobě nefunkční či zrušené domény.

Dovolujeme si Vás rovněž upozornit, že nesprávné, nepravdivé, neúplné
či zavádějící údaje mohou být v souladu s Pravidly registrace doménových jmen
v ccTLD .cz důvodem ke zrušení registrace doménového jména!

Chcete mít snadnější přístup ke správě Vašich údajů? Založte si mojeID na www.mojeid.cz.
Kromě nástroje, kterým můžete snadno a bezpečně spravovat údaje v centrálním
registru, získáte také prostředek pro jednoduché přihlašování k Vašim oblíbeným
webovým službám jediným jménem a heslem.

Pro více informací nás neváhejte kontaktovat!

Úplný výpis z registru obsahující všechny domény a další objekty přiřazené
k shora uvedenému kontaktu naleznete v příloze.

Váš tým CZ.NIC.

Příloha:

<?cs if:domains.0 ?>Seznam domén kde je kontakt v roli držitele nebo administrativního
nebo dočasného kontaktu:<?cs each:item = domains ?>
<?cs var:item ?><?cs /each ?><?cs else ?>Kontakt není uveden u žádného doménového jména.<?cs /if ?><?cs if:nssets.0 ?>

Seznam sad jmenných serverů, kde je kontakt v roli technického kontaktu:<?cs each:item = nssets ?>
<?cs var:item ?><?cs /each ?><?cs /if ?><?cs if:keysets.0 ?>

Seznam sad klíčů, kde je kontakt v roli technického kontaktu:<?cs each:item = keysets ?>
<?cs var:item ?><?cs /each ?><?cs /if ?>



Dear Sir or Madam,

Please check the correctness of the information we currently have on file
for your contact in the central registry of domain names.

Contact ID in the registry: <?cs var:handle ?>
Organization: <?cs var:organization ?>
Name: <?cs var:name ?>
Address: <?cs var:address ?><?cs if:ident_type != "" ?>
<?cs if:ident_type == "RC"?>Birth date: <?cs 
elif:ident_type == "OP"?>Personal ID: <?cs 
elif:ident_type == "PASS"?>Passport number: <?cs 
elif:ident_type == "ICO"?>ID number: <?cs 
elif:ident_type == "MPSV"?>MSPV ID: <?cs 
elif:ident_type == "BIRTHDAY"?>Birth day: <?cs 
/if ?> <?cs var:ident_value ?><?cs 
/if ?>
VAT No.: <?cs var:dic ?>
Phone: <?cs var:telephone ?>
Fax: <?cs var:fax ?>
E-mail: <?cs var:email ?>
Notification e-mail: <?cs var:notify_email ?>
Designated registrator: <?cs var:registrar_name ?> (<?cs var:registrar_url ?>)
<?cs if:registrar_memo_en ?>Other information provided by registrar:
<?cs var:registrar_memo_en ?><?cs /if ?>

Do not hesitate to contact your designated registrar with a correction request.

Having up-to-date, complete and correct information in the registry is crucial
to reach you with all the important information about your domain name in a timely manner
and at the correct contact address. Check you contact details now and avoid unpleasant
surprises such as a non-functional or expired domain.

We would also like to inform you that in accordance with the Rules of Domain Name
Registration for the .cz ccTLD, incorrect, false, incomplete or misleading
information can be grounds for the cancellation of a domain name registration.

Please do not hesitate to contact us for additional information.

You can find a complete summary of your domain names, and other objects
associated with your contact attached below.


Your CZ.NIC team.

Attachment:

<?cs if:domains.0 ?>Domains where the contact is a holder or an administrative or a temporary contact:<?cs each:item = domains ?>
<?cs var:item ?><?cs /each ?><?cs else ?>Contact is not linked to any domain name.<?cs /if ?><?cs if:nssets.0 ?>

Sets of name servers where the contact is a technical contact:<?cs each:item = nssets ?>
<?cs var:item ?><?cs /each ?><?cs /if ?><?cs if:keysets.0 ?>

Keysets where the contact is a technical contact:<?cs each:item = keysets ?>
<?cs var:item ?><?cs /each ?><?cs /if ?>
' WHERE id = 23;


UPDATE
    enum_object_states
    SET external = true
  WHERE name = 'deleteCandidate';

UPDATE
    enum_object_states_desc
    SET description = 'Určeno ke zrušení'
  WHERE lang = 'CS'
        AND state_id = (SELECT id FROM enum_object_states WHERE name = 'deleteCandidate');

UPDATE
    enum_object_states_desc
    SET description = 'To be deleted'
  WHERE lang = 'EN'
        AND state_id = (SELECT id FROM enum_object_states WHERE name = 'deleteCandidate');


---
--- Ticket #5917
---
INSERT INTO enum_parameters (id, name, val)
    VALUES (14, 'regular_day_outzone_procedure_period', '14');

UPDATE enum_parameters
    SET val = '0' WHERE name = 'regular_day_procedure_period';

DROP VIEW domain_states;
CREATE VIEW domain_states AS
SELECT
  d.id AS object_id,
  o.historyid AS object_hid,
  COALESCE(osr.states,'{}') ||
  CASE WHEN date_test(d.exdate::date,ep_ex_not.val) 
            AND NOT (2 = ANY(COALESCE(osr.states,'{}'))) -- !renewProhibited
       THEN ARRAY[8] ELSE '{}' END ||  -- expirationWarning
  CASE WHEN date_test(d.exdate::date,'0')                
            AND NOT (2 = ANY(COALESCE(osr.states,'{}'))) -- !renewProhibited
       THEN ARRAY[9] ELSE '{}' END ||  -- expired
  CASE WHEN date_time_test(d.exdate::date,ep_ex_dns.val,ep_tm2.val,ep_tz.val)
            AND NOT (2 = ANY(COALESCE(osr.states,'{}'))) -- !renewProhibited
       THEN ARRAY[10] ELSE '{}' END || -- unguarded
  CASE WHEN date_test(e.exdate::date,ep_val_not1.val)
       THEN ARRAY[11] ELSE '{}' END || -- validationWarning1
  CASE WHEN date_test(e.exdate::date,ep_val_not2.val)
       THEN ARRAY[12] ELSE '{}' END || -- validationWarning2
  CASE WHEN date_time_test(e.exdate::date,'0',ep_tm2.val,ep_tz.val)
       THEN ARRAY[13] ELSE '{}' END || -- notValidated
  CASE WHEN d.nsset ISNULL 
       THEN ARRAY[14] ELSE '{}' END || -- nssetMissing
  CASE WHEN
    d.nsset ISNULL OR
    5 = ANY(COALESCE(osr.states,'{}')) OR                -- outzoneManual
    (((date_time_test(d.exdate::date,ep_ex_dns.val,ep_tm2.val,ep_tz.val)
       AND NOT (2 = ANY(COALESCE(osr.states,'{}')))      -- !renewProhibited
      ) OR date_time_test(e.exdate::date,'0',ep_tm2.val,ep_tz.val)) AND 
     NOT (6 = ANY(COALESCE(osr.states,'{}'))))           -- !inzoneManual
       THEN ARRAY[15] ELSE '{}' END || -- outzone
  CASE WHEN date_time_test(d.exdate::date,ep_ex_reg.val,ep_tm.val,ep_tz.val)
            AND NOT (2 = ANY(COALESCE(osr.states,'{}'))) -- !renewProhibited
            AND NOT (1 = ANY(COALESCE(osr.states,'{}'))) -- !deleteProhibited
       THEN ARRAY[17] ELSE '{}' END || -- deleteCandidate
  CASE WHEN date_test(d.exdate::date,ep_ex_let.val)
            AND NOT (2 = ANY(COALESCE(osr.states,'{}'))) -- !renewProhibited
       THEN ARRAY[19] ELSE '{}' END || -- deleteWarning
  CASE WHEN date_time_test(d.exdate::date,ep_ex_dns.val,ep_tm2.val,ep_tz.val)
            AND NOT (2 = ANY(COALESCE(osr.states,'{}'))) -- !renewProhibited
            AND NOT (6 = ANY(COALESCE(osr.states,'{}'))) -- !inzoneManual
       THEN ARRAY[20] ELSE '{}' END    -- outzoneUnguarded
  AS states
FROM
  object_registry o,
  domain d
  LEFT JOIN enumval e ON (d.id=e.domainid)
  LEFT JOIN object_state_request_now osr ON (d.id=osr.object_id)
  JOIN enum_parameters ep_ex_not ON (ep_ex_not.id=3)
  JOIN enum_parameters ep_ex_dns ON (ep_ex_dns.id=4)
  JOIN enum_parameters ep_ex_let ON (ep_ex_let.id=5)
  JOIN enum_parameters ep_ex_reg ON (ep_ex_reg.id=6)
  JOIN enum_parameters ep_val_not1 ON (ep_val_not1.id=7)
  JOIN enum_parameters ep_val_not2 ON (ep_val_not2.id=8)
  JOIN enum_parameters ep_tm ON (ep_tm.id=9)
  JOIN enum_parameters ep_tz ON (ep_tz.id=10)
  JOIN enum_parameters ep_tm2 ON (ep_tm2.id=14)
WHERE d.id=o.id;

CREATE OR REPLACE FUNCTION status_update_domain() RETURNS TRIGGER AS $$
  DECLARE
    _num INTEGER;
    _nsset_old INTEGER;
    _registrant_old INTEGER;
    _keyset_old INTEGER;
    _nsset_new INTEGER;
    _registrant_new INTEGER;
    _keyset_new INTEGER;
    _ex_not VARCHAR;
    _ex_dns VARCHAR;
    _ex_let VARCHAR;
--    _ex_reg VARCHAR;
    _proc_tm VARCHAR;
    _proc_tz VARCHAR;
    _proc_tm2 VARCHAR;
  BEGIN
    _nsset_old := NULL;
    _registrant_old := NULL;
    _keyset_old := NULL;
    _nsset_new := NULL;
    _registrant_new := NULL;
    _keyset_new := NULL;
    SELECT val INTO _ex_not FROM enum_parameters WHERE id=3;
    SELECT val INTO _ex_dns FROM enum_parameters WHERE id=4;
    SELECT val INTO _ex_let FROM enum_parameters WHERE id=5;
--    SELECT val INTO _ex_reg FROM enum_parameters WHERE id=6;
    SELECT val INTO _proc_tm FROM enum_parameters WHERE id=9;
    SELECT val INTO _proc_tz FROM enum_parameters WHERE id=10;
    SELECT val INTO _proc_tm2 FROM enum_parameters WHERE id=14;
    -- is it INSERT operation
    IF TG_OP = 'INSERT' THEN
      _registrant_new := NEW.registrant;
      _nsset_new := NEW.nsset;
      _keyset_new := NEW.keyset;
      -- we ignore exdate, for new domain it shouldn't influence its state
      -- state: nsset missing
      EXECUTE status_update_state(
        NEW.nsset ISNULL, 14, NEW.id
      );
    -- is it UPDATE operation
    ELSIF TG_OP = 'UPDATE' THEN
      IF NEW.registrant <> OLD.registrant THEN
        _registrant_old := OLD.registrant;
        _registrant_new := NEW.registrant;
      END IF;
      IF COALESCE(NEW.nsset,0) <> COALESCE(OLD.nsset,0) THEN
        _nsset_old := OLD.nsset;
        _nsset_new := NEW.nsset;
      END IF;
      IF COALESCE(NEW.keyset,0) <> COALESCE(OLD.keyset,0) THEN
        _keyset_old := OLD.keyset;
        _keyset_new := NEW.keyset;
      END IF;
      -- take care of all domain statuses
      IF NEW.exdate <> OLD.exdate THEN
        -- at the first sight it seems that there should be checking
        -- for renewProhibited state before setting all of these states
        -- as it's done in global (1. type) views
        -- but the point is that when renewProhibited is set
        -- there is no way to change exdate so this situation can never happen 
        -- state: expiration warning
        EXECUTE status_update_state(
          date_test(NEW.exdate::date,_ex_not),
          8, NEW.id
        );
        -- state: expired
        EXECUTE status_update_state(
          date_test(NEW.exdate::date,'0'),
          9, NEW.id
        );
        -- state: unguarded
        EXECUTE status_update_state(
          date_time_test(NEW.exdate::date,_ex_dns,_proc_tm2,_proc_tz), 
          10, NEW.id
        );
        -- state: deleteWarning
        EXECUTE status_update_state(
          date_test(NEW.exdate::date,_ex_let),
          19, NEW.id
        );
        -- state: delete candidate (seems useless - cannot switch after del)
        -- for now delete state will be set only globaly
--        EXECUTE status_update_state(
--          date_time_test(NEW.exdate::date,_ex_reg,_proc_tm,_proc_tz), 
--          17, NEW.id
--        );
      END IF; -- change in exdate
      IF COALESCE(NEW.nsset,0) <> COALESCE(OLD.nsset,0) THEN
        -- state: nsset missing
        EXECUTE status_update_state(
          NEW.nsset ISNULL, 14, NEW.id
        );
      END IF; -- change in nsset
    -- is it DELETE operation
    ELSIF TG_OP = 'DELETE' THEN
      _registrant_old := OLD.registrant;
      _nsset_old := OLD.nsset; -- may be NULL!
      _keyset_old := OLD.keyset; -- may be NULL!
      -- exdate is meaningless when deleting (probably)
    END IF;

    -- add registrant's linked status if there is none
    EXECUTE status_set_state(
      _registrant_new IS NOT NULL, 16, _registrant_new
    );
    -- add nsset's linked status if there is none
    EXECUTE status_set_state(
      _nsset_new IS NOT NULL, 16, _nsset_new
    );
    -- add keyset's linked status if there is none
    EXECUTE status_set_state(
      _keyset_new IS NOT NULL, 16, _keyset_new
    );
    -- remove registrant's linked status if not bound
    -- locking must be done (see comment above)
    IF _registrant_old IS NOT NULL AND 
       status_clear_lock(_registrant_old, 16) IS NOT NULL 
    THEN
      SELECT count(*) INTO _num FROM domain
          WHERE registrant = OLD.registrant;
      IF _num = 0 THEN
        SELECT count(*) INTO _num FROM domain_contact_map
            WHERE contactid = OLD.registrant;
        IF _num = 0 THEN
          SELECT count(*) INTO _num FROM nsset_contact_map
              WHERE contactid = OLD.registrant;
          IF _num = 0 THEN
            SELECT count(*) INTO _num FROM keyset_contact_map
                WHERE contactid = OLD.registrant;
            EXECUTE status_clear_state(_num <> 0, 16, OLD.registrant);
          END IF;
        END IF;
      END IF;
    END IF;
    -- remove nsset's linked status if not bound
    -- locking must be done (see comment above)
    IF _nsset_old IS NOT NULL AND
       status_clear_lock(_nsset_old, 16) IS NOT NULL  
    THEN
      SELECT count(*) INTO _num FROM domain WHERE nsset = OLD.nsset;
      EXECUTE status_clear_state(_num <> 0, 16, OLD.nsset);
    END IF;
    -- remove keyset's linked status if not bound
    -- locking must be done (see comment above)
    IF _keyset_old IS NOT NULL AND
       status_clear_lock(_keyset_old, 16) IS NOT NULL  
    THEN
      SELECT count(*) INTO _num FROM domain WHERE keyset = OLD.keyset;
      EXECUTE status_clear_state(_num <> 0, 16, OLD.keyset);
    END IF;
    RETURN NULL;
  END;
$$ LANGUAGE plpgsql;

