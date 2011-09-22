--- 
---  Ticket #5808
---
ALTER TABLE request_fee_parameter ALTER COLUMN zone SET NOT NULL;


--- create trigger
CREATE TRIGGER "trigger_registrar_credit_transaction"
  AFTER INSERT OR UPDATE OR DELETE ON registrar_credit_transaction
  FOR EACH ROW EXECUTE PROCEDURE registrar_credit_change_lock();

