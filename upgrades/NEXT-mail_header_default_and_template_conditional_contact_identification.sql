DROP TRIGGER set_next_mail_template_version_trigger ON mail_template CASCADE;

DROP FUNCTION get_next_mail_template_version();

CREATE FUNCTION get_next_mail_template_version(_mail_type_id INTEGER) RETURNS INTEGER AS
$$
    SELECT COALESCE(get_current_mail_template_version(_mail_type_id), 0) + 1;
$$
LANGUAGE SQL;

CREATE FUNCTION check_next_mail_template_version() RETURNS TRIGGER AS
$$
DECLARE
    expected_new_version INTEGER;
BEGIN
    expected_new_version := get_next_mail_template_version(NEW.mail_type_id);
    IF NEW.version <> expected_new_version THEN
        RAISE EXCEPTION 'version must be %', expected_new_version;
    END IF;
    RETURN NEW;
END;
$$
LANGUAGE PLPGSQL;

CREATE TRIGGER check_next_mail_template_version_trigger
       BEFORE INSERT ON mail_template
       FOR EACH ROW EXECUTE PROCEDURE check_next_mail_template_version();
