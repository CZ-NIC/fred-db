---
--- Ticket #6304
---
INSERT INTO enum_object_states VALUES (24,'mojeidContact','{1}','t','f');
INSERT INTO enum_object_states_desc VALUES (24, 'CS', 'MojeID kontakt');
INSERT INTO enum_object_states_desc VALUES (24, 'EN', 'MojeID contact');

INSERT INTO object_state_request (object_id,state_id, valid_from, valid_to)
SELECT object_id, (SELECT id FROM enum_object_states WHERE name='mojeidContact') AS state_id, valid_from 
, (CASE WHEN one_of_valid_to_is_null THEN null ELSE max_valid_to END) as valid_to
FROM (SELECT object_id, MIN(valid_from) AS valid_from
, MAX(valid_to) AS max_valid_to, bool_or(valid_to is null) AS one_of_valid_to_is_null
FROM (SELECT os.object_id, os.valid_from, os.valid_to
FROM contact c JOIN object o ON o.id=c.id 
JOIN object_registry obr ON obr.id = o.id
JOIN registrar r ON r.id=o.clid
JOIN object_state os ON os.object_id = obr.id
JOIN enum_object_states eos ON eos.id=os.state_id
WHERE r.handle='REG-MOJEID'
AND (eos.name='conditionallyIdentifiedContact'
OR eos.name='identifiedContact'
OR eos.name='validatedContact')  
) AS tmp1
GROUP BY object_id
) AS tmp2
