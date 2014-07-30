---
---  #11106 merge contact fn index
---

CREATE INDEX contact_name_coalesce_trim_idx ON contact (trim(both ' ' from COALESCE(name,'')));

