-- Ticket #21692

UPDATE enum_public_request_status
SET name = 'opened', description = 'Opened'
WHERE name = 'new';

UPDATE enum_public_request_status
SET name = 'resolved', description = 'Resolved'
WHERE name = 'answered';

