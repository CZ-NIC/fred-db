-- This SQL check value blance in table invoice_credit_payment map 
-- which contains list of advance invoices associated to given
-- account invoice. Current invoice generation process expect that
-- total credit on invoice on creation is in price value and according
-- to that fact, it counts balance of credit by subtacting all used
-- credit from this number. This suspection is not true for imported
-- invoiced during migration that had lower credit than total credit
-- This SQL list all invoices that have corrupted balance value, that
-- means current balance + all credit subtractions differs from 
-- total credit

SELECT
 pm.invoiceid,
 pm.ainvoiceid,
 pm.balance as old_bal,
 adv.cred_max - COALESCE(SUM(pm2.credit),0) AS new_bal,
 'UPDATE invoice_credit_payment_map SET balance=' ||
 adv.cred_max - COALESCE(SUM(pm2.credit),0) ||
 ' WHERE invoiceid=' || pm.invoiceid || 
 ' AND ainvoiceid=' || pm.ainvoiceid || ';' AS repsql
FROM
  -- take one record 
  invoice_credit_payment_map pm  
  -- count total credit provided by advance invoice from this record
  JOIN (
   SELECT zi.id, COALESCE(z.credit,zi.total) AS cred_max
   -- version 1 (take i.total and optionaly tmp table)
   FROM
    invoice zi
    JOIN invoice_prefix ip ON (zi.prefix_type=ip.id AND ip.typ=0)
    LEFT JOIN tmp_zalohy z ON (zi.prefix=z.prefix)
   -- version 2 (commented out in favor to version 1)
   -- for each advance invoice this table contains sum of all subtractions
   -- added to current credit. this is total credit available on
   -- invoice on creation. This number should be same as i.total except
   -- of migrated invoices which wasn't imported with full credit
   -- SELECT
   --  i.id, i.credit + SUM(ipm.price) as cred_max
   -- FROM 
   --  invoice i
   --  JOIN invoice_object_registry_price_map ipm ON (ipm.invoiceid=i.id)
   -- GROUP BY i.id, i.credit
  ) adv ON (pm.ainvoiceid=adv.id)
  -- join all credit subtractions 
  LEFT JOIN invoice_credit_payment_map pm2 ON (
   pm.ainvoiceid=pm2.ainvoiceid AND pm.invoiceid>=pm2.invoiceid
  )
GROUP BY pm.invoiceid, pm.ainvoiceid, adv.cred_max, pm.balance
HAVING 
 (adv.cred_max - COALESCE(SUM(pm2.credit),0)) != pm.balance
ORDER BY pm.invoiceid;
