CREATE INDEX CONCURRENTLY reminder_contact_message_map_message_id_idx
    ON reminder_contact_message_map USING btree (message_id);

CREATE INDEX CONCURRENTLY public_request_answer_email_id_idx
    ON public_request USING btree (answer_email_id);

CREATE INDEX CONCURRENTLY public_request_messages_map_mail_archive_id_idx
    ON public_request_messages_map USING btree (mail_archive_id);

CREATE INDEX CONCURRENTLY notify_statechange_mail_id_idx
    ON notify_statechange USING btree (mail_id);

CREATE INDEX CONCURRENTLY invoice_mails_mailid_idx
    ON invoice_mails USING btree (mailid);
