---
--- Ticket #15031 - price_list changes
---

ALTER TABLE price_list ALTER COLUMN enable_postpaid_operation SET NOT NULL;

CREATE OR REPLACE FUNCTION check_price_list()
    RETURNS trigger AS
$BODY$
BEGIN
    IF NEW.valid_from > COALESCE(NEW.valid_to, 'infinity'::timestamp) THEN
        RAISE EXCEPTION 'invalid price_list item: valid_from > valid_to';
    END IF;
    IF EXISTS (
        SELECT 1 FROM price_list
          WHERE id <> NEW.id
          AND zone_id = NEW.zone_id
          AND operation_id=NEW.operation_id
          AND (valid_from , COALESCE(valid_to, 'infinity'::timestamp))
            OVERLAPS (NEW.valid_from , COALESCE(NEW.valid_to, 'infinity'::timestamp))
    ) THEN
        RAISE EXCEPTION 'price_list item overlaps';
    END IF;
    RETURN NEW;
END;
$BODY$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_price_list
  AFTER INSERT OR UPDATE ON price_list
  FOR EACH ROW EXECUTE PROCEDURE check_price_list();



