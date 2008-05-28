--
--  block requests answer emails
--

INSERT INTO mail_type (id, name, subject) VALUES (20, 'request_block', 'Informace o vyřízení žádosti / Information about processing of request ');
INSERT INTO mail_templates (id, contenttype, footer, template) VALUES
(20, 'plain', 1,
'English version of the e-mail is entered below the Czech version

Informace o vyřízení žádosti

Vážený zákazníku,

   na základě Vaší žádosti podané prostřednictvím webového formuláře
na stránkách sdružení dne <?cs var:reqdate ?>, které bylo přiděleno identifikační 
číslo <?cs var:reqid ?>, Vám oznamujeme, že požadovaná žádost o <?cs if:otype == #1 ?>zablokování<?cs elif:otype == #2 ?>odblokování<?cs /if ?>
<?cs if:rtype == #1 ?>změny dat<?cs elif:rtype == #2 ?>transferu k jinému registrátorovi<?cs /if ?> pro <?cs if:type == #3 ?>doménu<?cs elif:type == #1 ?>kontakt s identifikátorem<?cs elif:type == #2 ?>sadu nameserverů s identifikátorem<?cs /if ?> <?cs var:handle ?> 
byla úspěšně realizována.  
<?cs if:otype == #1 ?>
U <?cs if:type == #3 ?>domény<?cs elif:type == #1 ?>kontaktu s identifikátorem<?cs elif:type == #2 ?>sady nameserverů s identifikátorem<?cs /if ?> <?cs var:handle ?> nebude možné provést 
<?cs if:rtype == #1 ?>změnu dat<?cs elif:rtype == #2 ?>transfer k jinému registrátorovi <?cs /if ?> až do okamžiku, kdy tuto blokaci 
zrušíte pomocí příslušného formuláře na stránkách sdružení.
<?cs /if?>
                                             S pozdravem
                                             podpora <?cs var:defaults.company ?>

Information about processing of request

Dear customer,

   Based on your request submitted via the web form on the association
pages on <?cs var:reqdate ?>, which received the identification number 
<?cs var:reqid ?>, we are announcing that your request for <?cs if:otype == #1 ?>blocking<?cs elif:otype == #2 ?>unblocking<?cs /if ?>
<?cs if:rtype == #1 ?>data changes<?cs elif:rtype == #2 ?>transfer to other registrar<?cs /if ?> for <?cs if:type == #3 ?>domain name<?cs elif:type == #1 ?>contact with identifier<?cs elif:type == #2 ?>NS set with identifier<?cs /if ?> <?cs var:handle ?> 
has been realized.
<?cs if:otype == #1 ?>
No <?cs if:rtype == #1 ?>data changes<?cs elif:rtype == #2 ?>transfer to other registrar<?cs /if ?> of <?cs if:type == #3 ?>domain name<?cs elif:type == #1 ?>contact with identifier<?cs elif:type == #2 ?>NS set with identifier<?cs /if ?> <?cs var:handle ?> 
will be possible until You cancel the blocking option using the 
applicable form on association pages. 
<?cs /if?>
                                             Yours sincerely
                                             support <?cs var:defaults.company ?>
');
INSERT INTO mail_type_template_map (typeid, templateid) VALUES (20, 20);


--
-- changing domain.exdate type from timestamp to date
--

-- need convert exdate to CET zone
UPDATE domain SET exdate = exdate at time zone 'CET';
-- drop domain_states view to allow alter table command
DROP VIEW domain_states;
-- alter table 
ALTER TABLE domain ALTER COLUMN exdate TYPE date;
-- recreate domain_states view
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
  CASE WHEN date_time_test(d.exdate::date,ep_ex_dns.val,ep_tm.val,ep_tz.val)
            AND NOT (2 = ANY(COALESCE(osr.states,'{}'))) -- !renewProhibited
       THEN ARRAY[10] ELSE '{}' END || -- unguarded
  CASE WHEN date_test(e.exdate::date,ep_val_not1.val)
       THEN ARRAY[11] ELSE '{}' END || -- validationWarning1
  CASE WHEN date_test(e.exdate::date,ep_val_not2.val)
       THEN ARRAY[12] ELSE '{}' END || -- validationWarning2
  CASE WHEN date_time_test(e.exdate::date,'0',ep_tm.val,ep_tz.val)
       THEN ARRAY[13] ELSE '{}' END || -- notValidated
  CASE WHEN d.nsset ISNULL 
       THEN ARRAY[14] ELSE '{}' END || -- nssetMissing
  CASE WHEN
    d.nsset ISNULL OR
    5 = ANY(COALESCE(osr.states,'{}')) OR                -- outzoneManual
    (((date_time_test(d.exdate::date,ep_ex_dns.val,ep_tm.val,ep_tz.val)
       AND NOT (2 = ANY(COALESCE(osr.states,'{}')))      -- !renewProhibited
      ) OR date_time_test(e.exdate::date,'0',ep_tm.val,ep_tz.val)) AND 
     NOT (6 = ANY(COALESCE(osr.states,'{}'))))           -- !inzoneManual
       THEN ARRAY[15] ELSE '{}' END || -- outzone
  CASE WHEN date_time_test(d.exdate::date,ep_ex_reg.val,ep_tm.val,ep_tz.val)
            AND NOT (2 = ANY(COALESCE(osr.states,'{}'))) -- !renewProhibited
            AND NOT (1 = ANY(COALESCE(osr.states,'{}'))) -- !deleteProhibited
       THEN ARRAY[17] ELSE '{}' END || -- deleteCandidate
  CASE WHEN date_test(d.exdate::date,ep_ex_let.val)
            AND NOT (2 = ANY(COALESCE(osr.states,'{}'))) -- !renewProhibited
       THEN ARRAY[19] ELSE '{}' END || -- deleteWarning
  CASE WHEN date_time_test(d.exdate::date,ep_ex_dns.val,ep_tm.val,ep_tz.val)
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
WHERE d.id=o.id;
