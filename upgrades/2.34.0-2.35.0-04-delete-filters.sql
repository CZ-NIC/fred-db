---
--- Fix for Webadmin (aka Daphne) filters
---
--- Because of changes in the internal identification of classes used in boost serialization library
--- we need to create them from scratch
---
DELETE FROM filters;
