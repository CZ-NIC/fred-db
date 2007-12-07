-- This SQL list all invoices which have an inconsistance in count of items
-- and operations registred in relevant period. There are two tables 'a' 
-- and 'io'. First table count actions DomainCreate and DomainRenew from
-- action table for relevant period. Second table count items on invoice.
-- Finally, results of this two selects are joined together with invoice
-- table and counts are compared. There is a hack in action count (see
-- GREATEST()) because actions started to be billed in the middle of the
-- day 2007-01-22

SELECT 
 i.prefix, 
 r.handle,
 i.taxdate::date AS taxdate, 
 a.inew AS anew, 
 io.inew AS inew,
 a.irenew AS arenew,
 io.irenew AS irenew
FROM 
 invoice i
 JOIN registrar r ON (i.registrarid=r.id)
 JOIN (
  SELECT
   i.id,
   SUM(CASE WHEN a.action=504 THEN 1 ELSE 0 END) AS inew, 
   SUM(CASE WHEN a.action=506 THEN 1 ELSE 0 END) AS irenew
  FROM 
   invoice i
   JOIN invoice_generation ig ON (ig.invoiceid=i.id)
   JOIN action a ON (
    a.action IN (504,506) 
    AND (a.startdate::timestamptz AT TIME ZONE 'CET')::date 
     BETWEEN GREATEST(ig.fromdate,'2007-01-22 13:00:00') AND ig.todate
   )
   JOIN history h ON (h.action=a.id)
   JOIN domain_history dh ON (dh.historyid=h.id AND i.zone=dh.zone)
   JOIN login l ON (l.id=a.clientid AND i.registrarid=l.registrarid)
  GROUP BY i.id
 ) a ON (i.id=a.id)
 JOIN (
  SELECT
   i.id,
   SUM(CASE WHEN ior.operation=1 THEN 1 ELSE 0 END) AS inew,
   SUM(CASE WHEN ior.operation=2 THEN 1 ELSE -1 END) AS irenew 
  FROM 
   invoice i JOIN invoice_object_registry ior ON (i.id=ior.invoiceid)
  GROUP BY i.id
 ) io ON (i.id=io.id)
WHERE a.inew!=io.inew OR a.irenew!=io.irenew;

