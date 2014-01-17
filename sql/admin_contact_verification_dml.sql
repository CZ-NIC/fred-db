-- Parse::SQL::Dia      version 0.22                              
-- Documentation        http://search.cpan.org/dist/Parse-Dia-SQL/
-- Environment          Perl 5.018001, /usr/bin/perl              
-- Architecture         x86_64-linux-gnu-thread-multi             
-- Target Database      postgres                                  
-- Input file           db_rev5_source.dia                        
-- Generated at         Wed Jan  8 13:38:54 2014                  
-- Typemap for postgres not found in input file                   

-- get_inserts
insert into enum_contact_check_status (id, name, description) values('1', 'enqueued', 'Check is planned to run but hasn''t started yet.') ;
insert into enum_contact_check_status (id, name, description) values('2', 'running', 'Tests contained in this check haven''t finished yet.') ;
insert into enum_contact_check_status (id, name, description) values('3', 'auto_to_be_decided', 'Automatic tests evaluation gave no result.') ;
insert into enum_contact_check_status (id, name, description) values('4', 'auto_ok', 'Automatic tests evaluation proposes status ok.') ;
insert into enum_contact_check_status (id, name, description) values('5', 'auto_fail', 'Automatic tests evaluation proposes status fail. ') ;
insert into enum_contact_check_status (id, name, description) values('6', 'ok', 'Data were manually evaluated as valid.') ;
insert into enum_contact_check_status (id, name, description) values('7', 'fail', 'Data were manually evaluated as invalid.') ;
insert into enum_contact_check_status (id, name, description) values('8', 'invalidated', 'Check was manually set to be ignored.') ;
insert into enum_contact_test_status (id, name, description) values('1', 'enqueued', 'Test is ready to be runned.') ;
insert into enum_contact_test_status (id, name, description) values('2', 'running', 'Test is running.') ;
insert into enum_contact_test_status (id, name, description) values('3', 'skipped', 'Test run was intentionally skipped.') ;
insert into enum_contact_test_status (id, name, description) values('4', 'error', 'Error happened during test run.') ;
insert into enum_contact_test_status (id, name, description) values('5', 'manual', 'Result is inconclusive and evaluation by human is needed.') ;
insert into enum_contact_test_status (id, name, description) values('6', 'ok', 'Test result is OK.') ;
insert into enum_contact_test_status (id, name, description) values('7', 'fail', 'Test result is FAIL.') ;
insert into enum_contact_testsuite (name, description) values('automatic', 'Tests without any contact owner cooperation.') ;
insert into enum_contact_testsuite (name, description) values('manual', 'Tests where contact owner is actively taking part or is being informed.') ;
insert into enum_contact_test (id, name, description) values('1', 'name_syntax', 'Testing syntactical validity of name') ;
insert into enum_contact_test (id, name, description) values('2', 'phone_syntax', 'Testing syntactical validity of phone') ;
insert into enum_contact_test (id, name, description) values('3', 'email_syntax', 'Testing syntactical validity of e-mail') ;
insert into enum_contact_test (id, name, description) values('4', 'cz_address_existence', 'Testing address against official dataset (CZ only)') ;
insert into contact_testsuite_map (enum_contact_test_id, enum_contact_testsuite_id) values('1', '1') ;
insert into contact_testsuite_map (enum_contact_test_id, enum_contact_testsuite_id) values('2', '1') ;
insert into contact_testsuite_map (enum_contact_test_id, enum_contact_testsuite_id) values('3', '1') ;
insert into contact_testsuite_map (enum_contact_test_id, enum_contact_testsuite_id) values('4', '1') ;
insert into enum_filetype (id, name) values('8', 'admin contact verification_contact_update_call') ;
insert into message_type (id, type) values('9', 'admin_contact_verification_contact_update_call') ;
