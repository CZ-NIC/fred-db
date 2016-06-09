---
--- Ticket #15982 - change contacts default disclose flags
---
ALTER TABLE contact
    ALTER disclosename SET DEFAULT true,
    ALTER discloseorganization SET DEFAULT true,
    ALTER discloseaddress SET DEFAULT true;

ALTER TABLE contact_history
    ALTER disclosename SET DEFAULT true,
    ALTER discloseorganization SET DEFAULT true,
    ALTER discloseaddress SET DEFAULT true;