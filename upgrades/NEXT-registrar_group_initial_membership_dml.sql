---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '<insert version here>' WHERE id = 1;

---
--- Ticket #4113
---

INSERT INTO registrar_group_map (registrar_id, registrar_group_id, member_from)
SELECT DISTINCT registrarid AS registrar_id
    , (SELECT id 
         FROM registrar_group 
        WHERE short_name = 'uncertified'
      ) AS registrar_group_id
    , CURRENT_DATE AS member_from
  FROM (SELECT r.id AS registrarid
        , z.id AS zoneid
        , z.fqdn AS zone_fqdn
        , (SELECT count(*) 
             FROM registrarinvoice ri 
            WHERE fromdate <= CURRENT_DATE
                AND (todate >= CURRENT_DATE OR todate IS null)
                AND ri.registrarid = r.id 
                AND ri.zone = z.id
          ) AS isinzone
          FROM registrar AS r , zone AS z
       ) AS rii
 WHERE isinzone > 0 
   AND (zone_fqdn = 'cz' OR zone_fqdn = '0.2.4.e164.arpa');

