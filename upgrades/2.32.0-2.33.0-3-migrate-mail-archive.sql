CREATE OR REPLACE FUNCTION migrate_mail_header(message TEXT) RETURNS JSONB AS
$$
    SELECT json_strip_nulls(json_build_object(
                'To',
                    REGEXP_REPLACE(SUBSTRING(message FROM 'To:(.*?)(\n[^\n]*?:|\n\n)'), '\s', '', 'g'),
                'Cc',
                    REGEXP_REPLACE(SUBSTRING(message FROM 'Cc:(.*?)(\n[^\n]*?:|\n\n)'), '\s', '', 'g'),
                'Bcc',
                    REGEXP_REPLACE(SUBSTRING(message FROM 'Bcc:(.*?)(\n[^\n]*?:|\n\n)'), '\s', '', 'g'),
                'Message-ID',
                    SUBSTRING(message FROM 'Message-ID: (.*?)\n')
           ))::JSONB;
$$
LANGUAGE SQL
IMMUTABLE
RETURNS NULL ON NULL INPUT
PARALLEL SAFE;


CREATE OR REPLACE FUNCTION migrate_mail_archive_message_to_json(message TEXT, mail_type_id INTEGER) RETURNS JSONB AS
$$
DECLARE
    message_params JSONB;
BEGIN
    IF COALESCE(message, '') != '' AND SUBSTRING(message FROM '^Content-Type') IS NULL THEN
        RETURN json_build_object('header', json_build_object('To', message))::JSONB;
    END IF;
    EXECUTE $e$SELECT json_build_object(
                        'header',
                            migrate_mail_header($1),
                        'body',
                            json_build_object()
                    )$e$ INTO message_params USING message, mail_type_id;
    RETURN message_params;
END;
$$
LANGUAGE PLPGSQL
IMMUTABLE
RETURNS NULL ON NULL INPUT
PARALLEL SAFE;


CREATE OR REPLACE FUNCTION migrate_mail_archive_response_to_json_impl(response_encoded TEXT, mail_id INTEGER, encoding TEXT) RETURNS JSONB AS
$$
    SELECT CASE
           WHEN COALESCE(BTRIM(response_encoded), '') != '' THEN
               json_build_object(
                   'To',
                       REGEXP_REPLACE(SUBSTRING(decoded.response FROM '\nTo: (.*?)\n'), E'[\\n\\r]+', '', 'g'),
                   'Date',
                       REGEXP_REPLACE(SUBSTRING(decoded.response FROM '\nDate: (.*?)\n'), E'[\\n\\r]+', '', 'g'),
                   'Action',
                       REGEXP_REPLACE(SUBSTRING(decoded.response FROM '\nAction: (.*?)\n'), E'[\\n\\r]+', '', 'g'),
                   'Status',
                       REGEXP_REPLACE(SUBSTRING(decoded.response FROM '\nStatus: (.*?)\n'), E'[\\n\\r]+', '', 'g'),
                   'Subject',
                       REGEXP_REPLACE(SUBSTRING(decoded.response FROM '\nSubject: (.*?)\n'), E'[\\n\\r]+', '', 'g'),
                   'Remote-MTA',
                       REGEXP_REPLACE(SUBSTRING(decoded.response FROM '\nRemote-MTA: (.*?)\n'), E'[\\n\\r]+', '', 'g'),
                   'Reporting-MTA',
                       REGEXP_REPLACE(SUBSTRING(decoded.response FROM '\nReporting-MTA: (.*?)\n'), E'[\\n\\r]+', '', 'g'),
                   'Diagnostic-Code',
                       REGEXP_REPLACE(SUBSTRING(decoded.response FROM '\nDiagnostic-Code: (.*?)\n'), E'[\\n\\r]+', '', 'g'),
                   'Final-Recipient',
                       REGEXP_REPLACE(SUBSTRING(decoded.response FROM '\nFinal-Recipient: (.*?)\n'), E'[\\n\\r]+', '', 'g')
               )::JSONB
           ELSE NULL
           END
      FROM (
          SELECT CONVERT_FROM(DECODE(response_encoded, 'BASE64'), encoding) AS response
      ) AS decoded;
$$
LANGUAGE SQL
IMMUTABLE
PARALLEL SAFE;


CREATE OR REPLACE FUNCTION migrate_mail_archive_response_to_json(response_encoded TEXT, mail_id INTEGER) RETURNS JSONB AS
$$
DECLARE
    response_header JSONB;
BEGIN
    SELECT migrate_mail_archive_response_to_json_impl(response_encoded, mail_id, 'UTF-8') INTO response_header;
    RETURN response_header;
EXCEPTION
    WHEN data_exception THEN
        BEGIN
            RAISE NOTICE 'Could not decode or convert response with UTF-8 trying WINDOWS-1250 (id=%)', mail_id;
            SELECT migrate_mail_archive_response_to_json_impl(response_encoded, mail_id, 'WINDOWS-1250') INTO response_header;
            RETURN response_header;
        EXCEPTION
            WHEN data_exception THEN
                RAISE NOTICE 'Could not decode or convert response (id=%)', mail_id;
                RETURN NULL;
        END;
END;
$$
LANGUAGE PLPGSQL
IMMUTABLE
PARALLEL SAFE;


CREATE OR REPLACE FUNCTION migrate_mail_archive(from_date DATE, to_date DATE) RETURNS VOID AS
$$
    UPDATE mail_archive
       SET message_params = migrate_mail_archive_message_to_json(message, mailtype),
           response_header = migrate_mail_archive_response_to_json(response, id),
           mail_type_id = mailtype,
           mail_template_version = 1
     WHERE crdate >= COALESCE(from_date, (SELECT MIN(crdate) FROM mail_archive))
           AND crdate < COALESCE(to_date, (SELECT MAX(crdate) FROM mail_archive))
$$
LANGUAGE SQL;


SELECT migrate_mail_archive(NULL, NULL);
