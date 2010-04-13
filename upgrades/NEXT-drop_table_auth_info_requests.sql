---
--- don't forget to update database schema version
---

UPDATE enum_parameters SET val = '<insert version here>' WHERE id = 1;


---
--- this table is not used anymore, public_request contains the data
---

drop table auth_info_requests
