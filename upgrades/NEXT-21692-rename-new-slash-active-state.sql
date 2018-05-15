-- Ticket #21692

UPDATE enum_public_request_status
SET name = 'opened', description = 'Opened'
WHERE id = (select id from enum_public_request_status where name = 'new');

UPDATE enum_public_request_status
SET name = 'resolved', description = 'Resolved'
WHERE id = (select id from enum_public_request_status where name = 'answered');

