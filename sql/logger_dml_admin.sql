INSERT INTO service (id, partition_postfix, name)
    VALUES
        (8, 'admin_', 'Admin');

INSERT INTO request_type (service_id, id, name)
    VALUES
        (8, 1, 'ContactMerge'),
        (8, 2, 'MojeidCancelAccount'),
        (8, 3, 'MojeidDeactivateOTP'),
        (8, 4, 'DataMigration'),
        (8, 5, 'MojeidValidateISIC'),
        (8, 6, 'MojeidDeactivateAutor'),
        (8, 7, 'MojeidResetPassword'),
        (8, 8, 'AkmTurnOn'),
        (8, 9, 'AkmRollover'),
        (8, 10, 'AkmTurnOff'),
        (8, 11, 'SAMLConsumerRegistration'),
        (8, 12, 'ConsumerRegistration'),
        (8, 13, 'CreateExpiredDomain'),
        (8, 14, 'MojeidDeactivateFido2'),
        (8, 15, 'MojeidDeactivateNiaAuthenticators');

INSERT INTO result_code (service_id, result_code, name)
    VALUES
        (8, 1, 'Success'),
        (8, 2, 'Fail'),
        (8, 3, 'Error');
