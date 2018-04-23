---
--- don't forget to update database schema version
---
UPDATE enum_parameters SET val = '2.34.0' WHERE id = 1;


---
--- Public request types for sending personalinfo
---
INSERT INTO enum_public_request_type (id, name, description)
    VALUES (22, 'personalinfo_auto_pif', 'PersonalInfo (Web/Auto)');
INSERT INTO enum_public_request_type (id, name, description)
    VALUES (23, 'personalinfo_email_pif', 'PersonalInfo (Web/Email)');
INSERT INTO enum_public_request_type (id, name, description)
    VALUES (24, 'personalinfo_post_pif', 'PersonalInfo (Web/Post)');


---
--- Ticket #21503
---   - little bit rework of mail template version trigger
---   - new version of conditional_contact_identification template
---
DROP TRIGGER set_next_mail_template_version_trigger ON mail_template;

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

INSERT INTO mail_template (
    mail_type_id, version, subject, body_template, body_template_content_type,
    mail_template_footer_id, mail_template_default_id, mail_header_default_id, created_at
)
VALUES
    (25, get_next_mail_template_version(25),
'Podmíněná identifikace kontaktu / Conditional contact identification',
'Vážený uživateli,

tento e-mail potvrzuje úspěšné zahájení procesu ověření kontaktu v Centrálním registru:

ID kontaktu: <?cs var:handle ?>
jméno:       <?cs var:firstname ?>
příjmení:    <?cs var:lastname ?>
e-mail:      <?cs var:email ?>
telefon:     <?cs var:telephone ?>

Pro dokončení prvního ze dvou kroků ověření je nutné zadat kódy PIN1 a PIN2.

PIN1: <?cs var:passwd ?>
PIN2: Vám byl zaslán pomocí SMS na číslo <?cs var:telephone ?>.

Zadání PIN1 a PIN2 bude možné po kliknutí na následující odkaz:
https://<?cs var:hostname ?>/verification/identify/email-sms/<?cs var:identification ?>/?password1=<?cs var:passwd ?>

S pozdravem
podpora <?cs var:defaults.company_cs ?>



Dear user,

This email confirms that the process of verifying your contact data in the Central Registry has been successfully initiated:

contact ID: <?cs var:handle ?>
first name: <?cs var:firstname ?>
last name:  <?cs var:lastname ?>
email:      <?cs var:email ?>
phone:      <?cs var:telephone ?>

To complete the first of the two verification steps, authorisation with your PIN1 and PIN2 codes is required.

PIN1: <?cs var:passwd ?>
PIN2: was sent to you in a text message (SMS) to phone number <?cs var:telephone ?>.

You will be able to enter your PIN1 and PIN2 by following this link:
https://<?cs var:hostname ?>/verification/identify/email-sms/<?cs var:identification ?>/?password1=<?cs var:passwd ?>

Yours sincerely
Support of <?cs var:defaults.company_en ?>
', 'plain', 1, 1, 1, DEFAULT);
