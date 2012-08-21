---
--- CIC and IC states change to external
---
UPDATE enum_object_states SET external = True
  WHERE name in ('conditionallyIdentifiedContact', 'identifiedContact');

