---
--- Ticket #13042 - domainbrowser waring_letter flag
---

ALTER TABLE contact ADD COLUMN warning_letter boolean DEFAULT NULL;
COMMENT ON COLUMN contact.warning_letter IS 'whether to send domain expiration letters (NULL - no user preference, use zone.warning_letter flag; TRUE - send domain expiration letters; FALSE - don''t send domain expiration letters';


