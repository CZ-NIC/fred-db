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
 LEFT JOIN (
   SELECT
     i.id, ipm.credit as cred_penalty
   FROM 
    invoice i
    JOIN invoice_credit_payment_map ipm ON (i.id=ipm.ainvoiceid)
    LEFT JOIN invoice_object_registry ior ON (ipm.invoiceid=ior.invoiceid)
   WHERE ior.invoiceid IS NULL
 ) adv_pen ON (i.id=adv_pen.id)
WHERE
 COALESCE(z.credit,i.total) != adv.cred_max + COALESCE(adv_pen.cred_penalty,0);
