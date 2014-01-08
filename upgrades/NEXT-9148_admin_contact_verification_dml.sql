-- Parse::SQL::Dia      version 0.22                              
-- Documentation        http://search.cpan.org/dist/Parse-Dia-SQL/
-- Environment          Perl 5.018001, /usr/bin/perl              
-- Architecture         x86_64-linux-gnu-thread-multi             
-- Target Database      postgres                                  
-- Input file           db_rev5_source.dia                        
-- Generated at         Fri Nov 22 10:41:28 2013                  
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
