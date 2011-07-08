---
--- inserting new poll message type
---
INSERT INTO messagetype (id, name) VALUES (16, 'request_fee_info');

---
--- general registry operation used in price_list entry for request charging
--- 
INSERT INTO enum_operation (id, operation) VALUES (3, 'GeneralEppOperation');

