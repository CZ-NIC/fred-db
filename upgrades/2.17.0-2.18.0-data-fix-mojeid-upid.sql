---
--- Ticket #10732 - fix object.upid of mojeid contacts
---
WITH upo AS (
    SELECT o.id
    FROM object o
    JOIN object_registry oreg ON oreg.id=o.id
    WHERE o.clid=(SELECT id FROM registrar WHERE handle='REG-MOJEID') AND
          (o.upid NOT IN (SELECT id FROM registrar WHERE handle IN ('REG-CZNIC','REG-MOJEID')) OR
           o.upid IS NULL) AND
          (SELECT true
           FROM object_state os
           JOIN enum_object_states eos ON eos.id=os.state_id
           WHERE (os.object_id=o.id AND eos.name='mojeidContact') AND
                 (os.valid_from<=o.update AND (o.update<os.valid_to OR os.valid_to IS NULL)) LIMIT 1))
UPDATE object
SET upid=(SELECT id FROM registrar WHERE handle='REG-MOJEID')
FROM upo
WHERE object.id IN (upo.id);

WITH upoh AS (
    SELECT oh.historyid
    FROM object_history oh
    JOIN object_registry oreg ON oreg.id=oh.id
    WHERE oh.clid=(SELECT rm.id FROM registrar rm WHERE rm.handle='REG-MOJEID') AND
          (oh.upid NOT IN (SELECT id FROM registrar WHERE handle IN ('REG-CZNIC','REG-MOJEID')) OR
           oh.upid IS NULL) AND
          (SELECT true
           FROM object_state os
           JOIN enum_object_states eos ON eos.id=os.state_id
           WHERE os.object_id=oh.id AND
                 eos.name='mojeidContact' AND
                 (os.valid_from<=oh.update AND (oh.update<os.valid_to OR os.valid_to IS NULL)) LIMIT 1))
UPDATE object_history
SET upid=(SELECT id FROM registrar WHERE handle='REG-MOJEID')
FROM upoh
WHERE object_history.historyid IN (upoh.historyid);

