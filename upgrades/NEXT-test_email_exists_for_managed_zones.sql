insert into enum_contact_test (id, handle) values('8', 'email_existence_in_managed_zones') ;
insert into enum_contact_test_localization (id, lang, name, description) values('8', 'en', 'email_existence_in_managed_zones', 'Testing if e-mail hosts from managed zones are valid.') ;
insert into contact_testsuite_map (enum_contact_test_id, enum_contact_testsuite_id) values('8', '1') ;
