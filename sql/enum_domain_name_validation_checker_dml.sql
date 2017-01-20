INSERT INTO enum_domain_name_validation_checker (id, name, description)
    VALUES (2, 'dncheck_no_consecutive_hyphens', 'forbid consecutive hyphens');
INSERT INTO enum_domain_name_validation_checker (id, name, description)
    VALUES (5, 'dncheck_not_empty_domain_name', 'forbid empty domain name');
INSERT INTO enum_domain_name_validation_checker (id, name, description)
    VALUES (6, 'dncheck_rfc1035_preferred_syntax', 'enforces rfc1035 preferred syntax');
INSERT INTO enum_domain_name_validation_checker (id, name, description)
    VALUES (7, 'dncheck_single_digit_labels_only', 'enforces single digit labels (for enum domains)');
INSERT INTO enum_domain_name_validation_checker (id, name, description)
    VALUES (8, 'dncheck_no_idn_punycode', 'forbid idn punycode encoding');
