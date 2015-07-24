-- remove trigger AFTER INSERT, preserve trigger AFTER UPDATE
DROP TRIGGER "trigger_lock_public_request"
  ON public_request;

CREATE TRIGGER "trigger_lock_public_request"
  AFTER UPDATE ON public_request
  FOR EACH ROW EXECUTE PROCEDURE lock_public_request();
