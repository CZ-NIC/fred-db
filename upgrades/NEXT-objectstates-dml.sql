---
--- Ticket #6304
---
INSERT INTO enum_object_states VALUES (24,'mojeidContact','{1}','t','f');
INSERT INTO enum_object_states_desc VALUES (24, 'CS', 'MojeID kontakt');
INSERT INTO enum_object_states_desc VALUES (24, 'EN', 'MojeID contact');

INSERT INTO object_state_request (object_id,state_id,crdate, valid_from)
SELECT DISTINCT os.object_id, (SELECT id FROM enum_object_states WHERE name='mojeidContact') AS state_id, now() AS crdate, now() AS valid_from 
FROM contact c JOIN object o ON o.id=c.id 
JOIN object_registry obr ON obr.id = o.id
JOIN registrar r ON r.id=o.clid
JOIN object_state os ON os.object_id = obr.id
JOIN enum_object_states eos ON eos.id=os.state_id
WHERE r.handle='REG-MOJEID'
AND (eos.name='conditionallyIdentifiedContact'
OR eos.name='identifiedContact'
OR eos.name='validatedContact');
