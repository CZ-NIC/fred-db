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

UPDATE enum_object_states SET importance =  1*2 WHERE name = 'expired';
UPDATE enum_object_states SET importance =  2*2 WHERE name = 'mojeidContact';
UPDATE enum_object_states SET importance =  3*2 WHERE name = 'outzone';
UPDATE enum_object_states SET importance =  4*2 WHERE name = 'identifiedContact';
UPDATE enum_object_states SET importance =  5*2 WHERE name = 'conditionallyIdentifiedContact';
UPDATE enum_object_states SET importance =  6*2 WHERE name = 'validatedContact';
UPDATE enum_object_states SET importance =  7*2 WHERE name = 'serverOutzoneManual';
UPDATE enum_object_states SET importance =  8*2 WHERE name = 'serverInzoneManual';
UPDATE enum_object_states SET importance =  9*2 WHERE name = 'notValidated';
UPDATE enum_object_states SET importance = 10*2 WHERE name = 'linked';
UPDATE enum_object_states SET importance = 11*2 WHERE name = 'serverUpdateProhibited';
UPDATE enum_object_states SET importance = 12*2 WHERE name = 'serverTransferProhibited';
UPDATE enum_object_states SET importance = 13*2 WHERE name = 'serverRegistrantChangeProhibited';
UPDATE enum_object_states SET importance = 14*2 WHERE name = 'serverRenewProhibited';
UPDATE enum_object_states SET importance = 15*2 WHERE name = 'serverDeleteProhibited';
UPDATE enum_object_states SET importance = 16*2 WHERE name = 'serverBlocked';

-- Ticket #8289 - correct error typing
UPDATE enum_object_states_desc SET description = 'Kontakt je částečně identifikován' WHERE lang = 'CS' AND state_id = 21; -- conditionallyIdentifiedContact
UPDATE enum_object_states_desc SET description = 'Je navázán na další záznam v registru' WHERE lang = 'CS' AND state_id = 16; -- linked
UPDATE enum_object_states_desc SET description = 'Není povolena změna údajů' WHERE lang = 'CS' AND state_id = 4; -- serverUpdateProhibited

-- Fix error typing:

UPDATE enum_object_states_desc SET description = 'Deletion unauthorised' WHERE lang = 'EN' AND state_id = 01;
UPDATE enum_object_states_desc SET description = 'Registration renewal unauthorised' WHERE lang = 'EN' AND state_id = 02;
UPDATE enum_object_states_desc SET description = 'Sponsoring registrar change unauthorised' WHERE lang = 'EN' AND state_id = 03;
UPDATE enum_object_states_desc SET description = 'Update unauthorised' WHERE lang = 'EN' AND state_id = 04;
UPDATE enum_object_states_desc SET description = 'The domain is administratively kept out of zone' WHERE lang = 'EN' AND state_id = 05;
UPDATE enum_object_states_desc SET description = 'The domain is administratively kept in zone' WHERE lang = 'EN' AND state_id = 06;
UPDATE enum_object_states_desc SET description = 'The domain expires in 30 days' WHERE lang = 'EN' AND state_id = 08;
UPDATE enum_object_states_desc SET description = 'The domain is 30 days after expiration' WHERE lang = 'EN' AND state_id = 10;
UPDATE enum_object_states_desc SET description = 'The domain validation expires in 30 daysThe domain validatio' WHERE lang = 'EN' AND state_id = 11;
UPDATE enum_object_states_desc SET description = 'The domain validation expires in 15 days' WHERE lang = 'EN' AND state_id = 12;
UPDATE enum_object_states_desc SET description = 'The domain doesn''t have associated nsset' WHERE lang = 'EN' AND state_id = 14;
UPDATE enum_object_states_desc SET description = 'The domain isn''t generated in the zone' WHERE lang = 'EN' AND state_id = 15;
UPDATE enum_object_states_desc SET description = 'Has relation to other records in the registry' WHERE lang = 'EN' AND state_id = 16;
UPDATE enum_object_states_desc SET description = 'Registrant change unauthorised' WHERE lang = 'EN' AND state_id = 18;
UPDATE enum_object_states_desc SET description = 'The domain will be deleted in 11 days' WHERE lang = 'EN' AND state_id = 19;
UPDATE enum_object_states_desc SET description = 'The domain is out of zone after 30 days in expiration state' WHERE lang = 'EN' AND state_id = 20;

-- pyfred + domainbrowser
CREATE OR REPLACE VIEW domains_by_nsset_view AS
    SELECT nsset, COUNT(nsset) AS number FROM domain WHERE nsset IS NOT NULL GROUP BY nsset
;
CREATE OR REPLACE VIEW domains_by_keyset_view AS
    SELECT keyset, COUNT(keyset) AS number FROM domain WHERE keyset IS NOT NULL GROUP BY keyset
;

--
-- Collect states into one string
-- Usage: SELECT get_state_descriptions(53, 'CS');
-- retval: string ca be splited by row delimiter '\n' and column delimiter '\t':
--      [[external, importance, name, description], ...]
-- example: 't\t20\toutzone\tDomain is not generated into zone\nf\t\texpirationWarning\tExpires '
--          'within 30 days\nf\t\tunguarded\tDomain is 30 days after expiration\nf\t\tnssetMissi'
--          'ng\tDomain has not associated nsset'
--
CREATE OR REPLACE FUNCTION get_state_descriptions(object_id BIGINT, lang_code varchar)
RETURNS TEXT
AS $$
SELECT array_to_string(ARRAY((
    SELECT
        array_to_string(ARRAY[eos.external::char,
        COALESCE(eos.importance::varchar, ''),
        eos.name,
        COALESCE(osd.description, '')], E'#')
    FROM object_state os
    LEFT JOIN enum_object_states eos ON eos.id = os.state_id
    LEFT JOIN enum_object_states_desc osd ON osd.state_id = eos.id AND lang = $2
    WHERE os.object_id = $1
        AND os.valid_from <= CURRENT_TIMESTAMP
        AND (os.valid_to IS NULL OR os.valid_to > CURRENT_TIMESTAMP)
    ORDER BY eos.importance
)), E'&')
$$ LANGUAGE SQL;
