---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '<insert version here>' WHERE id = 1;

---
--- Ticket #4113
---

INSERT INTO registrar_group_map (registrar_id, registrar_group_id, member_from)
SELECT DISTINCT registrarid,
       (SELECT id FROM registrar_group WHERE short_name = 'uncertified'),
       CURRENT_DATE 
  FROM (SELECT r.id AS registrarid 
          FROM registrar r 
               JOIN registrarinvoice ri ON ri.registrarid = r.id 
               JOIN zone z ON z.id = ri.zone 
         WHERE ri.fromdate <= CURRENT_DATE 
               AND (todate >= CURRENT_DATE OR todate IS NULL) 
               AND z.fqdn = 'cz' OR z.fqdn = '0.2.4.e164.arpa') AS riz;
