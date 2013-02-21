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
