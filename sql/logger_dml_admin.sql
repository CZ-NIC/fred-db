INSERT INTO service (id, partition_postfix, name)
    VALUES
        (8, 'admin_', 'Admin');

INSERT INTO request_type (service_id, id, name)
    VALUES
        (8, 1, 'ContactMerge');

INSERT INTO result_code (service_id, result_code, name)
    VALUES
        (8, 1, 'Success'),
        (8, 2, 'Fail'),
        (8, 3, 'Error');
