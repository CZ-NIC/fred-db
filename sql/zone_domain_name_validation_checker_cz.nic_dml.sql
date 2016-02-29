INSERT INTO zone_domain_name_validation_checker_map
    VALUES
        (
            default,
            (SELECT id FROM enum_domain_name_validation_checker WHERE name = 'dncheck_letters_digits_hyphen_chars_only'),
            (SELECT id FROM zone WHERE fqdn = 'cz')
        );
INSERT INTO zone_domain_name_validation_checker_map
    VALUES
        (
            DEFAULT,
            (SELECT id FROM enum_domain_name_validation_checker WHERE name = 'dncheck_no_label_beginning_hyphen'),
            (SELECT id FROM zone WHERE fqdn = 'cz')
        );
INSERT INTO zone_domain_name_validation_checker_map
    VALUES
        (
            DEFAULT,
            (SELECT id FROM enum_domain_name_validation_checker WHERE name = 'dncheck_no_label_ending_hyphen'),
            (SELECT id FROM zone WHERE fqdn = 'cz')
        );
INSERT INTO zone_domain_name_validation_checker_map
    VALUES
        (
            DEFAULT,
            (SELECT id FROM enum_domain_name_validation_checker WHERE name = 'dncheck_no_consecutive_hyphens'),
            (SELECT id FROM zone WHERE fqdn = 'cz')
        );
INSERT INTO zone_domain_name_validation_checker_map
    VALUES
        (
            DEFAULT,
            (SELECT id FROM enum_domain_name_validation_checker WHERE name = 'dncheck_single_digit_labels_only'),
            (SELECT id FROM zone WHERE fqdn = '0.2.4.e164.arpa')
        );
