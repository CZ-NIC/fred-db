UPDATE enum_parameters SET val='1.8.2' WHERE id=1;

CREATE INDEX epp_info_buffer_content_registrar_id_idx ON epp_info_buffer_content (registrar_id);
CREATE INDEX mail_archive_status_idx ON mail_archive (status);
CREATE INDEX mail_attachments_mailid_idx ON mail_attachments (mailid);
