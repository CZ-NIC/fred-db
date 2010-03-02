---
--- UPGRADE SCRIPT 2.2.0 -> 2.3.0 Logger stuff only (data definition part)
---

---
--- Ticket #3141 Logger (only included!)
---

\i ../sql/logger_ddl.sql
\i ../sql/logger_partitioning.sql

