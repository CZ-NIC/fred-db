---
--- Tickets #4722
---
ALTER TABLE session ALTER COLUMN login_date DROP DEFAULT;


---
--- Ticket #5103 - match indexes in main table with indexes in paritions
--- 
CREATE INDEX request_user_name_idx ON request(user_name);
CREATE INDEX request_user_id_idx ON request(user_id);

DROP INDEX request_data_content_idx;

---
--- Ticket #5113 - long property names from Daphne
--- 

ALTER TABLE request_property_name ALTER COLUMN name TYPE VARCHAR(256);



