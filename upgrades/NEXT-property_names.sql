
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
