-- Parse::SQL::Dia      version 0.27                              
-- Documentation        http://search.cpan.org/dist/Parse-Dia-SQL/
-- Environment          Perl 5.018002, /usr/bin/perl              
-- Architecture         x86_64-linux-gnu-thread-multi             
-- Target Database      postgres                                  
-- Input file           db_rev5_source.dia                        
-- Generated at         Mon Apr  7 15:55:09 2014                  
-- Typemap for postgres not found in input file                   

-- get_inserts
insert into enum_contact_check_status (id, handle) values('1', 'enqueue_req') ;
insert into enum_contact_check_status (id, handle) values('2', 'enqueued') ;
insert into enum_contact_check_status (id, handle) values('3', 'running') ;
insert into enum_contact_check_status (id, handle) values('4', 'auto_to_be_decided') ;
insert into enum_contact_check_status (id, handle) values('5', 'auto_ok') ;
insert into enum_contact_check_status (id, handle) values('6', 'auto_fail') ;
insert into enum_contact_check_status (id, handle) values('7', 'ok') ;
insert into enum_contact_check_status (id, handle) values('8', 'fail') ;
insert into enum_contact_check_status (id, handle) values('9', 'invalidated') ;
insert into enum_contact_test_status (id, handle) values('1', 'enqueued') ;
insert into enum_contact_test_status (id, handle) values('2', 'running') ;
insert into enum_contact_test_status (id, handle) values('3', 'skipped') ;
insert into enum_contact_test_status (id, handle) values('4', 'error') ;
insert into enum_contact_test_status (id, handle) values('5', 'manual') ;
insert into enum_contact_test_status (id, handle) values('6', 'ok') ;
insert into enum_contact_test_status (id, handle) values('7', 'fail') ;
insert into enum_contact_testsuite (id, handle) values('1', 'automatic') ;
insert into enum_contact_testsuite (id, handle) values('2', 'manual') ;
insert into enum_contact_testsuite (id, handle) values('3', 'thank_you') ;
insert into enum_contact_test (id, handle) values('1', 'name_syntax') ;
insert into enum_contact_test (id, handle) values('2', 'phone_syntax') ;
insert into enum_contact_test (id, handle) values('3', 'email_syntax') ;
insert into enum_contact_test (id, handle) values('4', 'cz_address_existence') ;
insert into enum_contact_test (id, handle) values('5', 'contactability') ;
insert into enum_contact_test (id, handle) values('6', 'email_host_existence') ;
insert into enum_contact_test (id, handle) values('7', 'send_letter') ;
insert into contact_testsuite_map (enum_contact_test_id, enum_contact_testsuite_id) values('1', '1') ;
insert into contact_testsuite_map (enum_contact_test_id, enum_contact_testsuite_id) values('2', '1') ;
insert into contact_testsuite_map (enum_contact_test_id, enum_contact_testsuite_id) values('3', '1') ;
insert into contact_testsuite_map (enum_contact_test_id, enum_contact_testsuite_id) values('4', '1') ;
insert into contact_testsuite_map (enum_contact_test_id, enum_contact_testsuite_id) values('5', '2') ;
insert into contact_testsuite_map (enum_contact_test_id, enum_contact_testsuite_id) values('6', '1') ;
insert into contact_testsuite_map (enum_contact_test_id, enum_contact_testsuite_id) values('7', '3') ;
insert into enum_contact_test_status_localization (id, lang, name, description) values('1', 'en', 'enqueued', 'Test is ready to be run.') ;
insert into enum_contact_test_status_localization (id, lang, name, description) values('2', 'en', 'running', 'Test is running.') ;
insert into enum_contact_test_status_localization (id, lang, name, description) values('3', 'en', 'skipped', 'Test run was intentionally skipped.') ;
insert into enum_contact_test_status_localization (id, lang, name, description) values('4', 'en', 'error', 'Error happened during test run.') ;
insert into enum_contact_test_status_localization (id, lang, name, description) values('5', 'en', 'manual', 'Result is inconclusive and evaluation by human is needed.') ;
insert into enum_contact_test_status_localization (id, lang, name, description) values('6', 'en', 'ok', 'Test result is OK.') ;
insert into enum_contact_test_status_localization (id, lang, name, description) values('7', 'en', 'fail', 'Test result is FAIL.') ;
insert into enum_contact_check_status_localization (id, lang, name, description) values('1', 'en', 'enqueue_req', 'Request to create check.') ;
insert into enum_contact_check_status_localization (id, lang, name, description) values('2', 'en', 'enqueued', 'Check is created.') ;
insert into enum_contact_check_status_localization (id, lang, name, description) values('3', 'en', 'running', 'Tests contained in this check haven''t finished yet.') ;
insert into enum_contact_check_status_localization (id, lang, name, description) values('4', 'en', 'auto_to_be_decided', 'Automatic tests evaluation gave no result.') ;
insert into enum_contact_check_status_localization (id, lang, name, description) values('5', 'en', 'auto_ok', 'Automatic tests evaluation proposes status ok.') ;
insert into enum_contact_check_status_localization (id, lang, name, description) values('6', 'en', 'auto_fail', 'Automatic tests evaluation proposes status fail. ') ;
insert into enum_contact_check_status_localization (id, lang, name, description) values('7', 'en', 'ok', 'Data were manually evaluated as valid.') ;
insert into enum_contact_check_status_localization (id, lang, name, description) values('8', 'en', 'fail', 'Data were manually evaluated as invalid.') ;
insert into enum_contact_check_status_localization (id, lang, name, description) values('9', 'en', 'invalidated', 'Check was manually set to be ignored.') ;
insert into enum_contact_testsuite_localization (id, lang, name, description) values('1', 'en', 'automatic', 'Tests without any contact owner cooperation.') ;
insert into enum_contact_testsuite_localization (id, lang, name, description) values('2', 'en', 'manual', 'Tests where contact owner is actively taking part or is being informed.') ;
insert into enum_contact_testsuite_localization (id, lang, name, description) values('3', 'en', 'thank_you', '"Thank you" letter used for contactability testing') ;
insert into enum_contact_test_localization (id, lang, name, description) values('1', 'en', 'name_syntax', 'Testing syntactical validity of name') ;
insert into enum_contact_test_localization (id, lang, name, description) values('2', 'en', 'phone_syntax', 'Testing syntactical validity of phone') ;
insert into enum_contact_test_localization (id, lang, name, description) values('3', 'en', 'email_syntax', 'Testing syntactical validity of e-mail') ;
insert into enum_contact_test_localization (id, lang, name, description) values('4', 'en', 'cz_address_existence', 'Testing address against official dataset (CZ only)') ;
insert into enum_contact_test_localization (id, lang, name, description) values('5', 'en', 'contactability', 'Testing if contact is reachable by e-mail or letter') ;
insert into enum_contact_test_localization (id, lang, name, description) values('6', 'en', 'email_host_existence', 'Testing if e-mail host exists') ;
insert into enum_contact_test_localization (id, lang, name, description) values('7', 'en', 'send_letter', 'Testing if contact is reachable by letter') ;
insert into enum_filetype (id, name) values('8', 'admin contact correction notice') ;
insert into enum_filetype (id, name) values('9', 'admin contact confirm correction') ;
insert into message_type (id, type) values('9', 'admin_contact_correction_notice') ;
insert into message_type (id, type) values('10', 'admin_contact_confirm_correction') ;
