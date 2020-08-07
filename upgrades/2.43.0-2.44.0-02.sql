DELETE FROM enum_parameters
WHERE name IN (
    'expiration_notify_period',
    'outzone_unguarded_email_warning_period',
    'expiration_dns_protection_period',
    'expiration_letter_warning_period',
    'expiration_registration_protection_period',
    'validation_notify1_period',
    'validation_notify2_period') AND
    (SELECT val = '2.44.0' FROM enum_parameters WHERE id = 1);
