---
--- dont forget to update database schema version
---
UPDATE enum_parameters SET val = '<insert version here>' WHERE id = 1;

---
--- Ticket #3107 - object state description typo
---
UPDATE
    enum_object_states_desc
SET
    description = 'Domain is administratively kept out of zone'
WHERE
    state_id = 5 AND lang = 'EN';


UPDATE
    enum_object_states_desc
SET
    description = 'Domain is administratively kept in zone'
WHERE
    state_id = 6 AND lang = 'EN';

