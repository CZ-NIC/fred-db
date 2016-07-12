-- Ticket #16107 - new-notification-module-import-additional-emails

-- additional domain notification emails
CREATE TABLE notify_outzone_unguarded_domain_additional_email (
  id SERIAL CONSTRAINT notify_outzone_unguarded_domain_additional_email_pkey PRIMARY KEY,
  crdate TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now(),
  state_id BIGINT REFERENCES object_state (id),
  domain_id INTEGER NOT NULL REFERENCES object_registry (id),
  email varchar(1024) NOT NULL,
  CONSTRAINT notify_outzone_unguarded_domain_additional_email_unique_key UNIQUE (state_id, domain_id, email)
);

comment on table notify_outzone_unguarded_domain_additional_email is
'Additional contact emails used for notification of outzoneUnguardedWarning state';

comment on column notify_outzone_unguarded_domain_additional_email.crdate is 'date and time of insertion in table';
comment on column notify_outzone_unguarded_domain_additional_email.state_id is 'id of the state notified by email, not available in time of record insertion';
comment on column notify_outzone_unguarded_domain_additional_email.domain_id is 'id of the domain';
comment on column notify_outzone_unguarded_domain_additional_email.email is 'email address';

-- view for actual domain states
-- ================= DOMAIN ========================
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
       THEN ARRAY[20] ELSE '{}' END || -- outzoneUnguarded
  CASE WHEN date_time_test(d.exdate::date,ep_ozu_warn.val,'0',ep_tz.val)
            AND NOT (2 = ANY(COALESCE(osr.states,'{}'))) -- !renewProhibited
            AND NOT (6 = ANY(COALESCE(osr.states,'{}'))) -- !inzoneManual
       THEN ARRAY[28] ELSE '{}' END    -- outzoneUnguardedWarning
  AS states
FROM
  object_registry o,
  domain d
  LEFT JOIN enumval e ON (d.id=e.domainid)
  LEFT JOIN object_state_request_now osr ON (d.id=osr.object_id)
  JOIN enum_parameters ep_ex_not ON (ep_ex_not.id=3) -- expiration_notify_period
  JOIN enum_parameters ep_ex_dns ON (ep_ex_dns.id=4) -- expiration_dns_protection_period
  JOIN enum_parameters ep_ex_let ON (ep_ex_let.id=5) -- expiration_letter_warning_period
  JOIN enum_parameters ep_ex_reg ON (ep_ex_reg.id=6) -- expiration_registration_protection_period
  JOIN enum_parameters ep_val_not1 ON (ep_val_not1.id=7) -- validation_notify1_period
  JOIN enum_parameters ep_val_not2 ON (ep_val_not2.id=8) -- validation_notify2_period
  JOIN enum_parameters ep_tm ON (ep_tm.id=9)  -- regular_day_procedure_period
  JOIN enum_parameters ep_tz ON (ep_tz.id=10) -- regular_day_procedure_zone
  JOIN enum_parameters ep_tm2 ON (ep_tm2.id=14) -- regular_day_outzone_procedure_period
  JOIN enum_parameters ep_ozu_warn ON (ep_ozu_warn.id=18) -- outzone_unguarded_email_warning_period
WHERE d.id=o.id;
