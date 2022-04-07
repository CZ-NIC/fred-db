UPDATE service SET name = 'UnixWhois' WHERE LOWER(name) = LOWER('Unix whois');
UPDATE service SET name = 'WebWhois' WHERE LOWER(name) = LOWER('Web whois');
UPDATE service SET name = 'PublicRequest' WHERE LOWER(name) = LOWER('Public Request');

ALTER TABLE service ADD CHECK (name ~ '^[a-zA-Z0-9_\-]+$');
