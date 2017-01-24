---
--- Ticket #17972 - nameserver name db constraint
---

CREATE OR REPLACE FUNCTION domain_name_syntax_check(fqdn text) RETURNS bool AS $$
SELECT bool_and(label_length > 0 AND label_length <= 63
    AND domain_name_length > 0 AND domain_name_length <= 255 -- RFC1035#section-2.3.4 size limits
    AND label !~* '[^a-z0-9-]' AND left(label,1) != '-' AND right(label,1) != '-') -- LDH and RFC1123#section-2.1 syntax
  FROM (SELECT label, length(label) AS label_length, length(domain_name) + 1 AS domain_name_length -- +1 for optional trailing dot
    FROM (SELECT unnest(string_to_array(domain_name, '.'))::text AS label, domain_name
      FROM (SELECT CASE WHEN right($1::text,1) = '.' THEN left($1::text,-1) ELSE $1::text END) AS tmp1(domain_name) -- removed optional trailing dot
    ) AS tmp2) AS tmp3;
$$ LANGUAGE SQL RETURNS NULL ON NULL INPUT;

ALTER TABLE host ADD CONSTRAINT domain_name_check CHECK (domain_name_syntax_check(fqdn));

