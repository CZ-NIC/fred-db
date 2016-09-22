-- ====== start transaction ======
--BEGIN;

-- ====== repair letter_archive table ======
WITH warning_letter_contact AS (
    SELECT la.id AS letter_archive_id,
           ch.historyid AS contact_historyid,
           ecc.country AS contact_en_country_name,
           ecl.id AS letter_country_id
    FROM files f
	JOIN letter_archive la ON la.file_id=f.id
	JOIN object_state os ON os.id=SUBSTRING(f.name FROM 19 FOR 8)::BIGINT AND
	                        os.state_id=(SELECT id FROM enum_object_states WHERE name='deleteWarning')
	JOIN domain_history dh ON dh.historyid=os.ohid_from
	JOIN history h ON h.valid_from<=f.crdate AND (f.crdate<h.valid_to OR
	                                              h.valid_to IS NULL)
	JOIN contact_history ch ON ch.id=dh.registrant AND ch.historyid=h.id
	LEFT JOIN enum_country ecc ON ecc.id=ch.country
	LEFT JOIN enum_country ecl ON UPPER(ecl.country)=UPPER(la.postal_address_country)
    WHERE '2010-09-14'::DATE<=f.crdate::DATE AND f.crdate::DATE<'2013-01-30'::DATE AND
          f.name~'^letter\-[0-9]{4}\-[0-9]{2}\-[0-9]{2}\-[0-9]{8}\.pdf$')
UPDATE letter_archive
SET postal_address_name=TRIM(COALESCE(ch.name,'')),
    postal_address_organization=TRIM(COALESCE(ch.organization,'')),
    postal_address_street1=TRIM(COALESCE(ch.street1,'')),
    postal_address_street2=TRIM(COALESCE(ch.street2,'')),
    postal_address_street3=TRIM(COALESCE(ch.street3,'')),
    postal_address_city=TRIM(COALESCE(ch.city,'')),
    postal_address_stateorprovince=TRIM(COALESCE(ch.stateorprovince,'')),
    postal_address_postalcode=TRIM(COALESCE(ch.postalcode,'')),
    postal_address_country=wlc.contact_en_country_name
FROM warning_letter_contact wlc
JOIN contact_history ch ON ch.historyid=wlc.contact_historyid
WHERE letter_archive.id=wlc.letter_archive_id AND
      TRIM(COALESCE(ch.country,'')||' '||COALESCE(ch.organization,'')||' '||
           COALESCE(ch.name,'')||' '||COALESCE(ch.postalcode,'')||' '||
           COALESCE(ch.street1,'')||' '||COALESCE(ch.street2,'')||' '||
           COALESCE(ch.street3,''))
      !=
      TRIM(COALESCE(wlc.letter_country_id,'')||' '||
           COALESCE(postal_address_organization,'')||' '||
           COALESCE(postal_address_name,'')||' '||
           COALESCE(postal_address_postalcode,'')||' '||
           COALESCE(postal_address_street1,'')||' '||
           COALESCE(postal_address_street2,'')||' '||
           COALESCE(postal_address_street3,''));

-- ====== delete incorrect records from notify_letters (ticket #11622) ======
WITH to_delete AS (
	SELECT nl.state_id
	FROM notify_letters nl
	JOIN letter_archive la ON la.id=nl.letter_id
	JOIN files f ON f.id=la.file_id
	JOIN object_state os ON os.id=nl.state_id AND
                            os.state_id=(SELECT id FROM enum_object_states WHERE name='deleteWarning')
	JOIN domain_history dh ON dh.historyid=os.ohid_from
	JOIN history h ON h.valid_from<=f.crdate AND (f.crdate<h.valid_to OR h.valid_to IS NULL)
	JOIN contact_history ch ON ch.id=dh.registrant AND ch.historyid=h.id
	LEFT JOIN enum_country ec ON ec.id=ch.country
	WHERE '2010-09-14'::DATE<=f.crdate::DATE AND f.crdate::DATE<'2014-12-10'::DATE AND
	      (COALESCE(TRIM(UPPER(ec.country),'')!=COALESCE(TRIM(UPPER(la.postal_address_country)),'') OR
           COALESCE(TRIM(ch.organization),'')!=COALESCE(TRIM(la.postal_address_organization),'') OR 
           COALESCE(TRIM(ch.name),'')!=COALESCE(TRIM(la.postal_address_name),'') OR
           COALESCE(TRIM(ch.postalcode),'')!=COALESCE(TRIM(la.postal_address_postalcode),'') OR
           COALESCE(TRIM(ch.street1),'')!=COALESCE(TRIM(la.postal_address_street1),'') OR
           COALESCE(TRIM(ch.street2),'')!=COALESCE(TRIM(la.postal_address_street2),'') OR
           COALESCE(TRIM(ch.street3),'')!=COALESCE(TRIM(la.postal_address_street3),''))))
DELETE FROM notify_letters
USING to_delete
WHERE notify_letters.state_id=to_delete.state_id;

-- ====== repair message_contact_history_map ======
WITH file_contact AS (
    SELECT f.id AS file_id,
           f.crdate AS file_crdate,
           ch.id AS contact_id,
           ch.historyid AS contact_hid,
           TRIM(COALESCE(ch.country,'')||' '||COALESCE(ch.organization,'')||' '||
                COALESCE(ch.name,'')||' '||COALESCE(ch.postalcode,'')||' '||
                COALESCE(ch.street1,'')||' '||COALESCE(ch.street2,'')||' '||
                COALESCE(ch.street3,'')) AS address_imprint
    FROM files f
    JOIN object_state os ON os.id=SUBSTRING(f.name FROM 19 FOR 8)::BIGINT
    JOIN domain_history dh ON dh.historyid=os.ohid_from
    JOIN history h ON h.valid_from<=f.crdate AND (f.crdate<h.valid_to OR
                                                  h.valid_to IS NULL)
    JOIN contact_history ch ON ch.id=dh.registrant AND ch.historyid=h.id
    WHERE '2010-09-14'::DATE<=f.crdate::DATE AND f.crdate::DATE<'2014-12-10'::DATE AND
          f.name~'^letter\-[0-9]{4}\-[0-9]{2}\-[0-9]{2}\-[0-9]{8}\.pdf$' AND
          os.state_id=(SELECT id FROM enum_object_states WHERE name='deleteWarning')),
     correct_mchm AS (
    SELECT mchm.id,fc.contact_id,fc.contact_hid
    FROM message_contact_history_map mchm
    JOIN message_archive ma ON ma.id=mchm.message_archive_id
    JOIN letter_archive la ON la.id=ma.id
    JOIN file_contact fc ON fc.file_id=la.file_id
    JOIN contact_history ch ON ch.historyid=mchm.contact_history_historyid
    WHERE ma.message_type_id=(SELECT id FROM message_type WHERE type='domain_expiration') AND
          TRIM(COALESCE(ch.country,'')||' '||COALESCE(ch.organization,'')||' '||
               COALESCE(ch.name,'')||' '||COALESCE(ch.postalcode,'')||' '||
               COALESCE(ch.street1,'')||' '||COALESCE(ch.street2,'')||' '||
               COALESCE(ch.street3,''))!=
          fc.address_imprint)
UPDATE message_contact_history_map
SET contact_object_registry_id=correct_mchm.contact_id,
    contact_history_historyid=correct_mchm.contact_hid
FROM correct_mchm
WHERE message_contact_history_map.id=correct_mchm.id;

-- ====== select letters after 2010-09-14 with multiple recipients addresses (should be zero) ======
CREATE OR REPLACE FUNCTION check_warning_letters() 
RETURNS VOID AS $$
DECLARE
    my_result RECORD;
BEGIN
	WITH letter_distinction AS
	    (SELECT nl.letter_id,
	            TRIM(COALESCE(ch.country,'')||' '||
	                 COALESCE(ch.organization,'')||' '||
	                 COALESCE(ch.name,'')||' '||
	                 COALESCE(ch.postalcode,'')||' '||
	                 COALESCE(ch.street1,'')||' '||
	                 COALESCE(ch.street2,'')||' '||
	                 COALESCE(ch.street3,'')) AS distinction,
	            COUNT(*) AS cnt
	     FROM notify_letters nl
	     JOIN letter_archive la ON la.id=nl.letter_id
	     JOIN files f ON f.id=la.file_id
	     JOIN object_state os ON os.id=nl.state_id
	     JOIN domain_history dh ON dh.historyid=os.ohid_from
	     JOIN history h ON h.valid_from<=f.crdate AND (f.crdate<h.valid_to OR h.valid_to IS NULL)
	     JOIN contact_history ch ON ch.id=dh.registrant AND ch.historyid=h.id
	     LEFT JOIN enum_country ec ON UPPER(ec.country)=UPPER(la.postal_address_country)
	     WHERE '2010-09-14'::DATE<=f.crdate::DATE AND f.crdate::DATE<'2014-12-10'::DATE
	     GROUP BY 1,2
	     ORDER BY 1)
	SELECT ld.letter_id,SUM(ld.cnt) AS sum_cnt,COUNT(*) AS cnt INTO my_result
	FROM letter_distinction ld
	GROUP BY 1
	HAVING 1<COUNT(*);
	IF FOUND THEN
	    RAISE EXCEPTION 'No duplicity expected!';
	END IF;
END;
$$ LANGUAGE plpgsql;

SELECT check_warning_letters();
DROP FUNCTION check_warning_letters(); 

-- ====== transaction done ======
--ROLLBACK; --failure
--COMMIT;   --success