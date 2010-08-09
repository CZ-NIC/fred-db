----------------------------------
--- THIS  script is meant for fred 2.4, please use it BEFORE renaming upgrade script, because this has to use the old names
----------------------------------

--- don't forget to update database schema version
---
---

UPDATE enum_parameters SET val = '<insert version here>' WHERE id = 1;


---
--- #4344, #4328
---
---

UPDATE request_property_value rv SET name_id = 
        (SELECT id FROM request_property WHERE name='handle') 
  FROM request r 
  WHERE r.id=rv.entry_id AND  name_id = 
        (SELECT id FROM request_property WHERE name='checkId') 
    AND r.action_type IN 
        (SELECT id FROM request_type WHERE status IN ('NSsetCheck', 'KeysetCheck', 'DomainCheck', 'ContactCheck'));


UPDATE request_property_value rv SET name_id = 
        (SELECT id FROM request_property WHERE name='handle') 
  FROM request r 
  WHERE r.id=rv.entry_id AND  name_id = 
        (SELECT id FROM request_property WHERE name='id') 
    AND r.action_type IN 
        (SELECT id FROM request_type WHERE status IN ('ContactInfo', 'KeysetInfo', 'NSsetInfo', 'NSsetCreate', 'KeysetCreate', 'ContactCreate', 
'NSsetUpdate', 'KeysetUpdate', 'ContactUpdate', 'ContactDelete', 'KeysetDelete', 'NSsetDelete', 'DomainDelete', 'ContactTransfer', 'KeysetTransfer', 'NSsetTransfer', 'DomainTransfer'));



UPDATE request_property_value rv SET name_id = 
        (SELECT id FROM request_property WHERE name='handle') 
  FROM request r 
  WHERE r.id=rv.entry_id AND  name_id = 
        (SELECT id FROM request_property WHERE name='name') 
    AND r.action_type IN 
        (SELECT id FROM request_type WHERE status IN ('DomainCreate', 'DomainTransfer', 'DomainRenew', 'DomainUpdate', 'DomainInfo'));


        /*
UPDATE request_property_value rv SET property_name_id = 
        (SELECT id FROM request_property_name WHERE name='handle') 
  FROM request r 
  WHERE r.id=rv.request_id AND  property_name_id = 
        (SELECT id FROM request_property_name WHERE name='checkId') 
    AND r.request_type_id IN 
        (SELECT id FROM request_type WHERE name IN ('NSsetCheck', 'KeysetCheck', 'DomainCheck', 'ContactCheck'));


UPDATE request_property_value rv SET property_name_id = 
        (SELECT id FROM request_property_name WHERE name='handle') 
  FROM request r 
  WHERE r.id=rv.request_id AND  property_name_id = 
        (SELECT id FROM request_property_name WHERE name='id') 
    AND r.request_type_id IN 
        (SELECT id FROM request_type WHERE name IN ('ContactInfo', 'KeysetInfo', 'NSsetInfo', 'NSsetCreate', 'KeysetCreate', 'ContactCreate', 
'NSsetUpdate', 'KeysetUpdate', 'ContactUpdate', 'ContactDelete', 'KeysetDelete', 'NSsetDelete', 'DomainDelete', 'ContactTransfer', 'KeysetTransfer', 'NSsetTransfer', 'DomainTransfer'));



UPDATE request_property_value rv SET property_name_id = 
        (SELECT id FROM request_property_name WHERE name='handle') 
  FROM request r 
  WHERE r.id=rv.request_id AND  property_name_id = 
        (SELECT id FROM request_property_name WHERE name='name') 
    AND r.request_type_id IN 
        (SELECT id FROM request_type WHERE name IN ('DomainCreate', 'DomainTransfer', 'DomainRenew', 'DomainUpdate', 'DomainInfo'));


*/
