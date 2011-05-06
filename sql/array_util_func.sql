---
--- remove duplicate elements from array
---
CREATE OR REPLACE FUNCTION array_uniq(anyarray)
RETURNS anyarray as $$
SELECT array(SELECT DISTINCT $1[i] FROM
    generate_series(array_lower($1,1), array_upper($1,1)) g(i));
$$ LANGUAGE SQL STRICT IMMUTABLE;


---
--- remove null elements from array
---
CREATE OR REPLACE FUNCTION array_filter_null(anyarray)
RETURNS anyarray as $$
SELECT array(SELECT $1[i] FROM
    generate_series(array_lower($1,1), array_upper($1,1)) g(i) WHERE $1[i] IS NOT NULL) ;
$$ LANGUAGE SQL STRICT IMMUTABLE;


