---
--- Ticket #15099 - ENUM validation magic number
---
--opportunity window in days before current ENUM domain validation expiration
-- for new ENUM domain validation to be appended after current ENUM domain validation
INSERT INTO enum_parameters (id, name, val)
VALUES (19, 'enum_validation_continuation_window', '14');


