--- 
---  Ticket #5808
---

ALTER TABLE request_fee_parameter ADD COLUMN zone INTEGER REFERENCES zone(id);

-- this must be zone 'cz'
UPDATE request_fee_parameter SET zone = z.id FROM zone z WHERE z.fqdn = 'cz';

ALTER TABLE request_fee_parameter ALTER COLUMN zone SET NOT NULL;


