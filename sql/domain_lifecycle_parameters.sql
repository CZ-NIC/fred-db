CREATE TABLE domain_lifecycle_parameters (
    id SERIAL PRIMARY KEY,
    valid_from TIMESTAMP NOT NULL UNIQUE DEFAULT CURRENT_TIMESTAMP,
    expiration_notify_period INTERVAL NOT NULL,
    outzone_unguarded_email_warning_period INTERVAL NOT NULL,
    expiration_dns_protection_period INTERVAL NOT NULL,
    expiration_letter_warning_period INTERVAL NOT NULL,
    expiration_registration_protection_period INTERVAL NOT NULL
);

INSERT INTO domain_lifecycle_parameters (
    expiration_notify_period,
    outzone_unguarded_email_warning_period,
    expiration_dns_protection_period,
    expiration_letter_warning_period,
    expiration_registration_protection_period)
VALUES ('-30DAYS','25DAYS','30DAYS','34DAYS','61DAYS');
