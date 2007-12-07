SELECT *
FROM 
 invoice i
 JOIN invoice_prefix ip ON (i.prefix_type=ip.id AND ip.typ=0)
 LEFT JOIN tmp_zalohy z ON (z.prefix=i.prefix)
 JOIN (   
   SELECT
     i.id, i.credit + SUM(ipm.price) as cred_max
   FROM 
    invoice i
    JOIN invoice_object_registry_price_map ipm ON (ipm.invoiceid=i.id)
   GROUP BY i.id, i.credit
  ) adv ON (i.id=adv.id)
WHERE
 COALESCE(z.credit,i.total) != adv.cred_max;
