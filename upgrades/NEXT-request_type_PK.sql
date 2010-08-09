
---
--- don't forget to update database schema version
---

UPDATE enum_parameters SET val = '<insert version here>' WHERE id = 1;


---
--- #4274
---
---

ALTER TABLE request_type DROP CONSTRAINT request_type_pkey;

ALTER TABLE request_type ADD PRIMARY KEY (id);

ALTER TABLE request_type ADD UNIQUE(name, service_id);

