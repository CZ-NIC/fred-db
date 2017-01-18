INSERT INTO enum_domain_name_validation_checker (id, name, description)
    VALUES (1, 'dncheck_letters_digits_hyphen_chars_only', 'enforces letter, digit or hyphen characters');
INSERT INTO enum_domain_name_validation_checker (id, name, description)
    VALUES (2, 'dncheck_no_consecutive_hyphens', 'forbid consecutive hyphens');
INSERT INTO enum_domain_name_validation_checker (id, name, description)
    VALUES (3, 'dncheck_no_label_beginning_hyphen', 'forbid hyphen at the label beginning');
INSERT INTO enum_domain_name_validation_checker (id, name, description)
    VALUES (4, 'dncheck_no_label_ending_hyphen', 'forbid hyphen at the label ending');
INSERT INTO enum_domain_name_validation_checker (id, name, description)
    VALUES (5, 'dncheck_not_empty_domain_name', 'forbid empty domain name');
INSERT INTO enum_domain_name_validation_checker (id, name, description)
    VALUES (6, 'dncheck_rfc1035_preferred_syntax', 'enforces rfc1035 preferred syntax');
INSERT INTO enum_domain_name_validation_checker (id, name, description)
    VAlUES (7, 'dncheck_single_digit_labels_only', 'enforces single digit labels (for enum domains)');
INSERT INTO enum_domain_name_validation_checker (id, name, description)
    VAlUES (7, 'dncheck_no_idn_punycode', 'forbid idn punycode encoding');
