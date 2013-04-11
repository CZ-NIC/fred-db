---
--- Ticket #7875
---

CREATE INDEX dnskey_keysetid_idx ON dnskey (keysetid);

ALTER TABLE dnskey ADD CONSTRAINT dnskey_unique_key UNIQUE (keysetid, flags, protocol, alg, key);
