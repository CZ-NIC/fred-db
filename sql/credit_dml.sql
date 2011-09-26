INSERT INTO price_list (zone_id, operation_id, valid_from, valid_to, price, quantity, enable_postpaid_operation)
    VALUES ((SELECT id FROM zone WHERE fqdn = 'cz'),
    (SELECT id FROM enum_operation WHERE operation = 'GeneralEppOperation'),
    '2011-05-31 22:00:00', null, 0.10, 1, 'true');
