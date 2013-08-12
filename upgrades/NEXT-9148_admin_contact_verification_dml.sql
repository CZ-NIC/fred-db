-- Parse::SQL::Dia      version 0.22                              
-- Documentation        http://search.cpan.org/dist/Parse-Dia-SQL/
-- Environment          Perl 5.014002, /usr/bin/perl              
-- Architecture         x86_64-linux-gnu-thread-multi             
-- Target Database      postgres                                  
-- Input file           db_rev5_source.dia                        
-- Generated at         Mon Aug 12 09:45:37 2013                  
-- Typemap for postgres not found in input file                   

-- get_inserts
insert into enum_contact_check_status (name, description) values('enqueued', 'Check is planned to run but hasn''t started yet.') ;
insert into enum_contact_check_status (name, description) values('running', 'Tests contained in this check haven''t finished yet.') ;
insert into enum_contact_check_status (name, description) values('to_be_decided', 'Tests have finished and check result is to be inferred by human.') ;
insert into enum_contact_check_status (name, description) values('ok', 'Contact data were OK.') ;
insert into enum_contact_check_status (name, description) values('fail', 'Contact data were invalid. ') ;
insert into enum_contact_check_status (name, description) values('invalidated', 'Check was manually invalidated.') ;
insert into enum_contact_test_status (name, description) values('running', 'Automatic phase of test is still running.') ;
insert into enum_contact_test_status (name, description) values('manual', 'Automatic phase of test has finished but result is to be inferred manually.') ;
insert into enum_contact_test_status (name, description) values('ok', 'Test result is OK.') ;
insert into enum_contact_test_status (name, description) values('fail', 'Test result is FAIL.') ;
