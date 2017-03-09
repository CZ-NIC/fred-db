---
--- Ticket #18474 domain renew bill item,  invoice_operation.date_from fix
---

UPDATE invoice_operation
  SET date_from = (date_to::date - (quantity * '1 year'::interval))::date
 WHERE crdate::date >= '2017-03-01'::date
  AND operation_id = (SELECT id FROM enum_operation WHERE operation = 'RenewDomain')
  AND (date_to::date - (quantity * '1 year'::interval))::date <> date_from;
