DELETE FROM zone_domain_name_validation_checker_map WHERE checker_id IN (SELECT id FROM enum_domain_name_validation_checker WHERE name IN ('dncheck_letters_digits_hyphen_chars_only', 'dncheck_no_label_beginning_hyphen', 'dncheck_no_label_ending_hyphen'));
DELETE FROM enum_domain_name_validation_checker WHERE name IN ('dncheck_letters_digits_hyphen_chars_only', 'dncheck_no_label_beginning_hyphen', 'dncheck_no_label_ending_hyphen');
SELECT setval('enum_domain_name_validation_checker_id_seq', (SELECT MAX(id) FROM enum_domain_name_validation_checker));
SELECT setval('zone_domain_name_validation_checker_map_id_seq', (SELECT MAX(id) FROM zone_domain_name_validation_checker_map));
