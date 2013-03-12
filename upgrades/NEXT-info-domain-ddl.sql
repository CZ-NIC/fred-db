---
--- Ticket #7873
---

-- enumval domainid unique constraint
ALTER TABLE enumval ADD CONSTRAINT enumval_domainid_key UNIQUE (domainid);
