INSERT INTO service (id, partition_postfix, name) VALUES
(7, 'd_browser_', 'Domainbrowser');

INSERT INTO request_type (service_id, id, name) VALUES
(7, 1700, 'Login'),
(7, 1701, 'Logout'),
(7, 1702, 'BlockingChange'),
(7, 1703, 'DiscloseChange'),
(7, 1704, 'Browse'),
(7, 1705, 'Detail'),
(7, 1706, 'AuthInfoChange')
;

INSERT INTO result_code (service_id, result_code, name) VALUES
(7, 1 , 'Success'),
(7, 2 , 'Fail'),
(7, 3 , 'Error'),
(7, 4 , 'NotValidated'),
(7, 5 , 'Warning')
;

-- Ticket #8289 - new column 'importance'
ALTER TABLE enum_object_states ADD COLUMN importance INTEGER;

UPDATE enum_object_states SET importance = 10 WHERE name = 'expired';
UPDATE enum_object_states SET importance = 10 WHERE name = 'mojeidContact';
UPDATE enum_object_states SET importance = 20 WHERE name = 'outzone';
UPDATE enum_object_states SET importance = 20 WHERE name = 'identifiedContact';
UPDATE enum_object_states SET importance = 20 WHERE name = 'conditionallyIdentifiedContact';
UPDATE enum_object_states SET importance = 20 WHERE name = 'validatedContact';
UPDATE enum_object_states SET importance = 30 WHERE name = 'serverOutzoneManual';
UPDATE enum_object_states SET importance = 30 WHERE name = 'serverInzoneManual';
UPDATE enum_object_states SET importance = 30 WHERE name = 'notValidated';
UPDATE enum_object_states SET importance = 30 WHERE name = 'linked';
UPDATE enum_object_states SET importance = 40 WHERE name = 'serverUpdateProhibited';
UPDATE enum_object_states SET importance = 50 WHERE name = 'serverTransferProhibited';
UPDATE enum_object_states SET importance = 60 WHERE name = 'serverRegistrantChangeProhibited';
UPDATE enum_object_states SET importance = 70 WHERE name = 'serverRenewProhibited';
UPDATE enum_object_states SET importance = 80 WHERE name = 'serverDeleteProhibited';
UPDATE enum_object_states SET importance = 90 WHERE name = 'serverBlocked';

-- Ticket #8289 - correct error typing
UPDATE enum_object_states_desc SET description = 'Kontakt je částečně identifikován' WHERE lang = 'CS' AND state_id = 21; -- conditionallyIdentifiedContact
UPDATE enum_object_states_desc SET description = 'Je navázán na další záznam v registru' WHERE lang = 'CS' AND state_id = 16; -- linked
UPDATE enum_object_states_desc SET description = 'Není povolena změna údajů' WHERE lang = 'CS' AND state_id = 4; -- serverUpdateProhibited

-- Fix error typing:
UPDATE enum_object_states_desc SET description = 'Není povolena změna určeného registrátora' WHERE lang = 'CS' AND state_id = 3;


CREATE OR REPLACE FUNCTION external_state_description(object_id BIGINT, lang_code varchar)
RETURNS TEXT
AS $$
    --Usage:
    --  SELECT
    --    og.id,
    --    og.name,
    --    external_state_description(og.id, 'CS') AS states
    --  FROM object_registry og
    --  WHERE og.name = 'test.cz'

SELECT array_to_string(ARRAY((
    SELECT osd.description
    FROM object_state os
    LEFT JOIN enum_object_states eos ON eos.id = os.state_id
    LEFT JOIN enum_object_states_desc osd ON osd.state_id = eos.id AND lang = $2
    WHERE os.object_id = $1
        AND eos.external = 't'
        AND os.valid_from <= CURRENT_TIMESTAMP
        AND (os.valid_to IS NULL OR os.valid_to > CURRENT_TIMESTAMP)
    ORDER BY osd.description
)), '|')
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION get_object_states(object_id BIGINT)
RETURNS TEXT
AS $$
SELECT array_to_string(ARRAY((
    SELECT name
    FROM object_state os
    LEFT JOIN enum_object_states eos ON eos.id = os.state_id
    WHERE os.object_id = $1
        AND os.valid_from <= CURRENT_TIMESTAMP
        AND (os.valid_to IS NULL OR os.valid_to > CURRENT_TIMESTAMP)
)), '|')
$$ LANGUAGE SQL;
