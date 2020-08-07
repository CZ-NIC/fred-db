CREATE TABLE domain_lifecycle_parameters (
    id SERIAL PRIMARY KEY,
    valid_for_exdate_after TIMESTAMP NOT NULL UNIQUE DEFAULT CURRENT_TIMESTAMP,
    expiration_notify_period INTERVAL NOT NULL,
    outzone_unguarded_email_warning_period INTERVAL NOT NULL,
    expiration_dns_protection_period INTERVAL NOT NULL,
    expiration_letter_warning_period INTERVAL NOT NULL,
    expiration_registration_protection_period INTERVAL NOT NULL,
    validation_notify1_period INTERVAL NOT NULL,
    validation_notify2_period INTERVAL NOT NULL
);

INSERT INTO domain_lifecycle_parameters (
    valid_for_exdate_after,
    expiration_notify_period,
    outzone_unguarded_email_warning_period,
    expiration_dns_protection_period,
    expiration_letter_warning_period,
    expiration_registration_protection_period,
    validation_notify1_period,
    validation_notify2_period)
VALUES (NOW()::DATE-'20YEARS'::INTERVAL,'-30DAYS','25DAYS','30DAYS','34DAYS','61DAYS','-30DAYS','-15DAYS');
