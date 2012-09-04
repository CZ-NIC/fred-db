ALTER TABLE public_request ADD CONSTRAINT public_request_status_fkey FOREIGN KEY(status) REFERENCES enum_public_request_status(id);
ALTER TABLE public_request ADD CONSTRAINT public_request_type_fkey FOREIGN KEY(request_type) REFERENCES enum_public_request_type(id);

---
--- schema changes omited from previous upgrades
---
ALTER TABLE bank_payment DROP COLUMN invoice_id;
ALTER TABLE notify_letters DROP COLUMN file_id;
ALTER TABLE public_request DROP COLUMN epp_action_id;

DROP TABLE action_elements CASCADE;
DROP TABLE action_xml CASCADE;
DROP TABLE action CASCADE;
DROP TABLE enum_action CASCADE;
DROP TABLE login CASCADE;


