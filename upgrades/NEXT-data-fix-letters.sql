-- ====== start transaction ======
--BEGIN;

WITH warning_letters AS (
    SELECT id AS file_id,
           crdate,
           SUBSTRING(name FROM 19 FOR 8)::BIGINT AS object_state_id
    FROM files
    WHERE '2010-09-14'::DATE<=crdate::DATE AND crdate::DATE<'2013-01-30'::DATE AND
          name~'^letter\-[0-9]{4}\-[0-9]{2}\-[0-9]{2}\-[0-9]{8}\.pdf$')
SELECT la.id AS letter_archive_id,
       TRIM(CASE WHEN cah.id IS NULL THEN COALESCE(ch.country,'') ELSE COALESCE(cah.country,'') END) AS country,
       TRIM(CASE WHEN cah.id IS NULL THEN COALESCE(ch.organization,'') ELSE COALESCE(cah.company_name,'') END) AS organization,
       TRIM(COALESCE(ch.name,'')) AS name,
       TRIM(CASE WHEN cah.id IS NULL THEN COALESCE(ch.postalcode,'') ELSE COALESCE(cah.postalcode,'') END) AS postalcode,
       TRIM(CASE WHEN cah.id IS NULL THEN COALESCE(ch.street1,'') ELSE COALESCE(cah.street1,'') END) AS street1,
       TRIM(CASE WHEN cah.id IS NULL THEN COALESCE(ch.street2,'') ELSE COALESCE(cah.street2,'') END) AS street2,
       TRIM(CASE WHEN cah.id IS NULL THEN COALESCE(ch.street3,'') ELSE COALESCE(cah.street3,'') END) AS street3,
       TRIM(CASE WHEN cah.id IS NULL THEN COALESCE(ch.city,'') ELSE COALESCE(cah.city,'') END) AS city,
       TRIM(CASE WHEN cah.id IS NULL THEN COALESCE(ch.stateorprovince,'') ELSE COALESCE(cah.stateorprovince,'') END) AS stateorprovince,
       TRIM(CASE WHEN cah.id IS NULL THEN COALESCE(ch.country,'') ELSE COALESCE(cah.country,'') END || ' ' ||
            CASE WHEN cah.id IS NULL THEN COALESCE(ch.organization,'') ELSE COALESCE(cah.company_name,'') END || ' ' ||
            COALESCE(ch.name,'') || ' ' ||
            CASE WHEN cah.id IS NULL THEN COALESCE(ch.postalcode,'') ELSE COALESCE(cah.postalcode,'') END || ' ' ||
            CASE WHEN cah.id IS NULL THEN COALESCE(ch.street1,'') ELSE COALESCE(cah.street1,'') END || ' ' ||
            CASE WHEN cah.id IS NULL THEN COALESCE(ch.street2,'') ELSE COALESCE(cah.street2,'') END || ' ' ||
            CASE WHEN cah.id IS NULL THEN COALESCE(ch.street3,'') ELSE COALESCE(cah.street3,'') END)
       =
       TRIM(COALESCE(ec.id,'') || ' ' ||
            COALESCE(la.postal_address_organization,'') || ' ' ||
            COALESCE(la.postal_address_name,'') || ' ' ||
            COALESCE(la.postal_address_postalcode,'') || ' ' ||
            COALESCE(la.postal_address_street1,'') || ' ' ||
            COALESCE(la.postal_address_street2,'') || ' ' ||
            COALESCE(la.postal_address_street3,'')) AS is_correct
INTO TEMPORARY TABLE repair_letter_address
FROM warning_letters wl
JOIN letter_archive la ON la.file_id=wl.file_id
JOIN object_state os ON os.id=wl.object_state_id
JOIN domain_history dh ON dh.historyid=os.ohid_from
JOIN history h ON h.valid_from<=wl.crdate AND (wl.crdate<h.valid_to OR
                                               h.valid_to IS NULL)
JOIN contact_history ch ON ch.id=dh.registrant AND ch.historyid=h.id
LEFT JOIN enum_country ec ON UPPER(ec.country)=UPPER(la.postal_address_country)
LEFT JOIN contact_address_history cah ON cah.contactid=ch.id AND
                                         cah.type='MAILING'::contact_address_type AND
                                         EXISTS(SELECT * FROM history
                                                WHERE id=cah.historyid AND
                                                      valid_from<=wl.crdate AND (wl.crdate<valid_to OR
                                                                                 valid_to IS NULL))
WHERE os.state_id=(SELECT id FROM enum_object_states WHERE name='deleteWarning');

-- ====== repair letter_archive table ======
UPDATE letter_archive
SET postal_address_name=rla.name,
    postal_address_organization=rla.organization,
    postal_address_street1=rla.street1,
    postal_address_street2=rla.street2,
    postal_address_street3=rla.street3,
    postal_address_city=rla.city,
    postal_address_stateorprovince=rla.stateorprovince,
    postal_address_postalcode=rla.postalcode,
    postal_address_country=ec.country
FROM repair_letter_address rla
JOIN enum_country ec ON ec.id=rla.country
WHERE letter_archive.id=rla.letter_archive_id AND
      NOT rla.is_correct;

-- ====== delete incorrect records from notify_letters (ticket #11622) ======
WITH to_delete AS (
    SELECT nl.state_id FROM notify_letters nl
    JOIN letter_archive la ON la.id=nl.letter_id
    JOIN files f ON f.id=la.file_id
    JOIN object_state os ON os.id=nl.state_id
    JOIN domain_history dh ON dh.historyid=os.ohid_from
    JOIN history h ON h.valid_from<=f.crdate AND (f.crdate<h.valid_to OR h.valid_to IS NULL)
    JOIN contact_history ch ON ch.id=dh.registrant AND ch.historyid=h.id
    LEFT JOIN enum_country ec ON UPPER(ec.country)=UPPER(la.postal_address_country)
    LEFT JOIN contact_address_history cah ON cah.contactid=ch.id AND
                                             cah.type='MAILING'::contact_address_type AND
                                             EXISTS(SELECT * FROM history
                                                    WHERE id=cah.historyid AND
                                                          valid_from<=f.crdate AND (f.crdate<valid_to OR
                                                                                    valid_to IS NULL))
    WHERE '2010-09-14'::DATE<=f.crdate::DATE AND
          os.state_id=(SELECT id FROM enum_object_states WHERE name='deleteWarning') AND
          TRIM(CASE WHEN cah.id IS NULL THEN COALESCE(ch.country,'') ELSE COALESCE(cah.country,'') END || ' ' ||
               CASE WHEN cah.id IS NULL THEN COALESCE(ch.organization,'') ELSE COALESCE(cah.company_name,'') END || ' ' ||
               COALESCE(ch.name,'') || ' ' ||
               CASE WHEN cah.id IS NULL THEN COALESCE(ch.postalcode,'') ELSE COALESCE(cah.postalcode,'') END || ' ' ||
               CASE WHEN cah.id IS NULL THEN COALESCE(ch.street1,'') ELSE COALESCE(cah.street1,'') END || ' ' ||
               CASE WHEN cah.id IS NULL THEN COALESCE(ch.street2,'') ELSE COALESCE(cah.street2,'') END || ' ' ||
               CASE WHEN cah.id IS NULL THEN COALESCE(ch.street3,'') ELSE COALESCE(cah.street3,'') END)
          !=
          TRIM(COALESCE(ec.id,'') || ' ' ||
               COALESCE(la.postal_address_organization,'') || ' ' ||
               COALESCE(la.postal_address_name,'') || ' ' ||
               COALESCE(la.postal_address_postalcode,'') || ' ' ||
               COALESCE(la.postal_address_street1,'') || ' ' ||
               COALESCE(la.postal_address_street2,'') || ' ' ||
               COALESCE(la.postal_address_street3,''))
    )
DELETE FROM notify_letters
USING to_delete
WHERE notify_letters.state_id=to_delete.state_id;

-- ====== repair message_contact_history_map ======
WITH file_contact AS (
    SELECT f.id AS file_id,
           f.crdate AS file_crdate,
           ch.id AS contact_id,
           ch.historyid AS contact_hid,
           TRIM(CASE WHEN cah.id IS NULL THEN COALESCE(ch.country,'') ELSE COALESCE(cah.country,'') END || ' ' ||
                CASE WHEN cah.id IS NULL THEN COALESCE(ch.organization,'') ELSE COALESCE(cah.company_name,'') END || ' ' ||
                COALESCE(ch.name,'') || ' ' ||
                CASE WHEN cah.id IS NULL THEN COALESCE(ch.postalcode,'') ELSE COALESCE(cah.postalcode,'') END || ' ' ||
                CASE WHEN cah.id IS NULL THEN COALESCE(ch.street1,'') ELSE COALESCE(cah.street1,'') END || ' ' ||
                CASE WHEN cah.id IS NULL THEN COALESCE(ch.street2,'') ELSE COALESCE(cah.street2,'') END || ' ' ||
                CASE WHEN cah.id IS NULL THEN COALESCE(ch.street3,'') ELSE COALESCE(cah.street3,'') END) AS distinction
    FROM files f
    JOIN object_state os ON os.id=SUBSTRING(f.name FROM 19 FOR 8)::BIGINT
    JOIN domain_history dh ON dh.historyid=os.ohid_from
    JOIN history h ON h.valid_from<=f.crdate AND (f.crdate<h.valid_to OR
                                                  h.valid_to IS NULL)
    JOIN contact_history ch ON ch.id=dh.registrant AND ch.historyid=h.id
    LEFT JOIN contact_address_history cah ON cah.contactid=ch.id AND
                                             cah.type='MAILING'::contact_address_type AND
                                             EXISTS(SELECT * FROM history
                                                    WHERE id=cah.historyid AND
                                                          valid_from<=f.crdate AND (f.crdate<valid_to OR
                                                                                    valid_to IS NULL))
    WHERE '2010-09-14'::DATE<=f.crdate::DATE AND
          f.name~'^letter\-[0-9]{4}\-[0-9]{2}\-[0-9]{2}\-[0-9]{8}\.pdf$' AND
          os.state_id=(SELECT id FROM enum_object_states WHERE name='deleteWarning')),
     correct_mchm AS (
    SELECT mchm.id,fc.contact_id,fc.contact_hid
    FROM message_contact_history_map mchm
    JOIN message_archive ma ON ma.id=mchm.message_archive_id
    JOIN letter_archive la ON la.id=ma.id
    JOIN file_contact fc ON fc.file_id=la.file_id
    JOIN contact_history ch ON ch.historyid=mchm.contact_history_historyid
    LEFT JOIN contact_address_history cah ON cah.contactid=ch.id AND
                                             cah.type='MAILING'::contact_address_type AND
                                             EXISTS(SELECT * FROM history
                                                    WHERE id=cah.historyid AND
                                                          valid_from<=fc.file_crdate AND (fc.file_crdate<valid_to OR
                                                                                          valid_to IS NULL))
    WHERE ma.message_type_id=(SELECT id FROM message_type WHERE type='domain_expiration') AND
          TRIM(CASE WHEN cah.id IS NULL THEN COALESCE(ch.country,'') ELSE COALESCE(cah.country,'') END || ' ' ||
               CASE WHEN cah.id IS NULL THEN COALESCE(ch.organization,'') ELSE COALESCE(cah.company_name,'') END || ' ' ||
               COALESCE(ch.name,'') || ' ' ||
               CASE WHEN cah.id IS NULL THEN COALESCE(ch.postalcode,'') ELSE COALESCE(cah.postalcode,'') END || ' ' ||
               CASE WHEN cah.id IS NULL THEN COALESCE(ch.street1,'') ELSE COALESCE(cah.street1,'') END || ' ' ||
               CASE WHEN cah.id IS NULL THEN COALESCE(ch.street2,'') ELSE COALESCE(cah.street2,'') END || ' ' ||
               CASE WHEN cah.id IS NULL THEN COALESCE(ch.street3,'') ELSE COALESCE(cah.street3,'') END)!=
          fc.distinction)
UPDATE message_contact_history_map
SET contact_object_registry_id=correct_mchm.contact_id,
    contact_history_historyid=correct_mchm.contact_hid
FROM correct_mchm
WHERE message_contact_history_map.id=correct_mchm.id;

-- ====== select letters after 2010-09-14 with multiple recipients addresses (should be zero) ======
WITH letter_distinction AS
    (SELECT nl.letter_id,
            TRIM(CASE WHEN cah.id IS NULL THEN COALESCE(ch.country,'') ELSE COALESCE(cah.country,'') END || ' ' ||
                 CASE WHEN cah.id IS NULL THEN COALESCE(ch.organization,'') ELSE COALESCE(cah.company_name,'') END || ' ' ||
                 COALESCE(ch.name,'') || ' ' ||
                 CASE WHEN cah.id IS NULL THEN COALESCE(ch.postalcode,'') ELSE COALESCE(cah.postalcode,'') END || ' ' ||
                 CASE WHEN cah.id IS NULL THEN COALESCE(ch.street1,'') ELSE COALESCE(cah.street1,'') END || ' ' ||
                 CASE WHEN cah.id IS NULL THEN COALESCE(ch.street2,'') ELSE COALESCE(cah.street2,'') END || ' ' ||
                 CASE WHEN cah.id IS NULL THEN COALESCE(ch.street3,'') ELSE COALESCE(cah.street3,'') END) AS distinction,
            COUNT(*) AS cnt
     FROM notify_letters nl
     JOIN letter_archive la ON la.id=nl.letter_id
     JOIN files f ON f.id=la.file_id
     JOIN object_state os ON os.id=nl.state_id
     JOIN domain_history dh ON dh.historyid=os.ohid_from
     JOIN history h ON h.valid_from<=f.crdate AND (f.crdate<h.valid_to OR h.valid_to IS NULL)
     JOIN contact_history ch ON ch.id=dh.registrant AND ch.historyid=h.id
     LEFT JOIN enum_country ec ON UPPER(ec.country)=UPPER(la.postal_address_country)
     LEFT JOIN contact_address_history cah ON cah.contactid=ch.id AND
                                              cah.type='MAILING'::contact_address_type AND
                                              EXISTS(SELECT * FROM history
                                                     WHERE id=cah.historyid AND
                                                           valid_from<=f.crdate AND (f.crdate<valid_to OR
                                                                                     valid_to IS NULL))
     WHERE '2010-09-14'::DATE<=f.crdate::DATE
     GROUP BY 1,2
     ORDER BY 1)
SELECT ld.letter_id,SUM(ld.cnt) AS sum_cnt,COUNT(*) AS cnt
FROM letter_distinction ld
GROUP BY 1
HAVING 1<COUNT(*)
ORDER BY cnt DESC,1;

-- ====== transaction done ======
--ROLLBACK; --failure
--COMMIT;   --success