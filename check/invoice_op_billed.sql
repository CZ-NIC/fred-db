-- This SQL list all epp operations that don't have associated invoice
-- item 

SELECT
 obr.name,a.startdate,ea.status,ior.crdate,ig.todate,i.prefix
FROM
 action a
 JOIN enum_action ea ON (ea.id=a.action)
 JOIN login l ON (l.id=a.clientid)
 JOIN history h ON (h.action=a.id)
 JOIN domain_history dh ON (dh.historyid=h.id)
 JOIN object_registry obr ON (obr.id=dh.id)
 LEFT JOIN invoice_object_registry ior ON (
  ior.objectid=dh.id 
  AND (ior.exdate=(dh.exdate::timestamptz AT TIME ZONE 'CET')::date 
       OR (a.action=504 AND dh.exdate IS NULL))
 )
 LEFT JOIN invoice_generation ig ON (
   ig.invoiceid=ior.invoiceid AND
   (a.startdate::timestamptz AT TIME ZONE 'CET')::date
   BETWEEN ig.fromdate AND ig.todate
 )
 LEFT JOIN invoice i ON (ig.invoiceid=i.id)
WHERE
 a.action IN (504,506) 
 AND a.startdate > '2007-01-22 13:00:00' AND l.registrarid!=1
 AND (a.startdate::timestamptz AT TIME ZONE 'CET')::date < 
  DATE_TRUNC('month',NOW())
 AND (ior.objectid ISNULL OR ig.invoiceid ISNULL OR i.id ISNULL)
 -- added to make check faster
 AND a.startdate > CURRENT_DATE - INTERVAL '2 month';
