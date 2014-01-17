-- Parse::SQL::Dia      version 0.22                              
-- Documentation        http://search.cpan.org/dist/Parse-Dia-SQL/
-- Environment          Perl 5.018001, /usr/bin/perl              
-- Architecture         x86_64-linux-gnu-thread-multi             
-- Target Database      postgres                                  
-- Input file           db_rev5_source.dia                        
-- Generated at         Fri Jan 17 09:22:32 2014                  
-- Typemap for postgres not found in input file                   

-- get_constraints_drop 

-- get_permissions_drop 

-- get_view_drop

-- get_schema_drop

-- get_smallpackage_pre_sql 

-- get_schema_create
create table enum_contact_test (
   id     integer not null,
   handle varchar NOT NULL,
   constraint pk_enum_contact_test primary key (id)
)   ;
create table contact_testsuite_map (
   enum_contact_test_id      integer NOT NULL,
   enum_contact_testsuite_id integer NOT NULL
)   ;
create table enum_contact_testsuite (
   id     integer not null,
   handle varchar NOT NULL,
   constraint pk_enum_contact_testsuite primary key (id)
)   ;
create table contact_check (
   id                           bigserial not null                                    ,
   create_time                  timestamp  default (NOW() AT TIME ZONE 'utc') NOT NULL,
   contact_history_id           int       NOT NULL                                    ,
   logd_request_id              bigint    NULL                                        ,
   enum_contact_testsuite_id    int       NOT NULL                                    ,
   update_time                  timestamp  default (NOW() AT TIME ZONE 'utc') NOT NULL,
   enum_contact_check_status_id int       NOT NULL                                    ,
   handle                       uuid      NOT NULL                                    ,
   constraint pk_contact_check primary key (id)
)   ;
create table enum_contact_check_status (
   id     integer not null,
   handle varchar NOT NULL,
   constraint pk_enum_contact_check_status primary key (id)
)   ;
create table contact_test_result (
   id                          bigserial not null                                    ,
   contact_check_id            bigint    NOT NULL                                    ,
   enum_contact_test_id        int       NOT NULL                                    ,
   error_msg                   varchar   NULL                                        ,
   logd_request_id             bigint    NULL                                        ,
   enum_contact_test_status_id int       NOT NULL                                    ,
   create_time                 timestamp  default (NOW() AT TIME ZONE 'utc') NOT NULL,
   update_time                 timestamp  default (NOW() AT TIME ZONE 'utc') NOT NULL,
   constraint pk_contact_test_result primary key (id)
)   ;
create table enum_contact_test_status (
   id     integer not null,
   handle varchar NOT NULL,
   constraint pk_enum_contact_test_status primary key (id)
)   ;
create table contact_test_result_history (
   id                          bigserial not null,
   contact_test_result_id      bigint    NOT NULL,
   error_msg                   varchar   NULL    ,
   logd_request_id             bigint    NULL    ,
   enum_contact_test_status_id int       NOT NULL,
   update_time                 timestamp NOT NULL,
   constraint pk_contact_test_result_history primary key (id)
)   ;
create table contact_check_history (
   id                           bigserial not null,
   contact_check_id             bigint    NOT NULL,
   logd_request_id              bigint    NULL    ,
   update_time                  timestamp NOT NULL,
   enum_contact_check_status_id int       NOT NULL,
   constraint pk_contact_check_history primary key (id)
)   ;
create table contact_check_message_map (
   id                 bigserial not null,
   contact_check_id   bigint    NOT NULL,
   mail_archive_id    bigint    NULL    ,
   message_archive_id bigint    NULL    ,
   constraint pk_contact_check_message_map primary key (id)
)   ;
create table contact_check_object_state_map (
   id               bigserial not null,
   contact_check_id bigint    NOT NULL,
   object_state_id  bigint    NOT NULL,
   constraint pk_contact_check_object_state_map primary key (id)
)   ;
create table contact_check_poll_message_map (
   id               bigserial not null,
   contact_check_id bigint    NOT NULL,
   poll_message_id  bigint    NOT NULL,
   constraint pk_contact_check_poll_message_map primary key (id)
)   ;
create table enum_contact_test_status_localization (
   id          integer not null,
   lang        varchar NOT NULL,
   name        varchar NOT NULL,
   description varchar NOT NULL,
   constraint pk_enum_contact_test_status_localization primary key (id)
)   ;
create table enum_contact_check_status_localization (
   id          integer not null,
   lang        varchar NOT NULL,
   name        varchar NOT NULL,
   description varchar NOT NULL,
   constraint pk_enum_contact_check_status_localization primary key (id)
)   ;
create table enum_contact_testsuite_localization (
   id          integer not null,
   lang        varchar NOT NULL,
   name        varchar NOT NULL,
   description varchar NULL    ,
   constraint pk_enum_contact_testsuite_localization primary key (id)
)   ;
create table enum_contact_test_localization (
   id          integer not null,
   lang        varchar NOT NULL,
   name        varchar NOT NULL,
   description varchar NULL    ,
   constraint pk_enum_contact_test_localization primary key (id)
)   ;

-- get_view_create

-- get_permissions_create

-- get_inserts
-- manually erased

-- get_smallpackage_post_sql
CREATE FUNCTION propagate_contact_check_change_into_contact_check_history() 
RETURNS trigger 
AS 
$contact_check_change$
BEGIN
	IF NEW.enum_contact_check_status_id IS DISTINCT FROM OLD.enum_contact_check_status_id 
           OR NEW.logd_request_id IS DISTINCT FROM OLD.logd_request_id
        THEN
		INSERT INTO contact_check_history 
		(	contact_check_id,
                        logd_request_id,
			update_time,
			enum_contact_check_status_id )
		VALUES (
			OLD.id, 
			OLD.logd_request_id, 
			OLD.update_time,
			OLD.enum_contact_check_status_id
		);
		IF NEW.update_time IS NULL THEN
         		NEW.update_time = NOW() AT TIME ZONE 'utc';
		END IF;
	END IF;

	RETURN NEW;
END;
$contact_check_change$ 
LANGUAGE plpgsql;
  
CREATE TRIGGER update_contact_check_history 
   BEFORE UPDATE ON contact_check
   FOR EACH ROW EXECUTE PROCEDURE propagate_contact_check_change_into_contact_check_history();

COMMENT ON TRIGGER update_contact_check_history ON contact_check IS 
'creates history of each contact_check changes: contact_check -> contact_check_history';
CREATE FUNCTION propagate_contact_test_result_change_into_test_result_history() 
RETURNS trigger 
AS 
$contact_test_result_change$
BEGIN
	IF NEW.enum_contact_test_status_id IS DISTINCT FROM OLD.enum_contact_test_status_id 
           OR NEW.error_msg IS DISTINCT FROM OLD.error_msg
           OR NEW.logd_request_id IS DISTINCT FROM OLD.logd_request_id 
        THEN
		INSERT INTO contact_test_result_history 
		(	contact_test_result_id,
			error_msg,
			logd_request_id,
			enum_contact_test_status_id,
			update_time )
		VALUES (
			OLD.id, 
			OLD.error_msg, 
			OLD.logd_request_id, 
			OLD.enum_contact_test_status_id, 
			OLD.update_time
		);
		IF NEW.update_time IS NULL THEN
			NEW.update_time = NOW() AT TIME ZONE 'utc';
		END IF;
	END IF;		
	RETURN NEW;
END;
$contact_test_result_change$ 
LANGUAGE plpgsql;
  
CREATE TRIGGER update_contact_test_result_history 
   BEFORE UPDATE ON contact_test_result
   FOR EACH ROW EXECUTE PROCEDURE propagate_contact_test_result_change_into_test_result_history();

COMMENT ON TRIGGER update_contact_test_result_history ON contact_test_result IS 
'creates history of each contact_test_result changes: contact_test_result -> contact_test_result_history';
COMMENT ON COLUMN contact_check_history.update_time IS 
'time when contact_check got into state represented by this record';
COMMENT ON COLUMN contact_check.update_time IS 
'time when contact_check got into state represented by this record';
COMMENT ON COLUMN contact_test_result_history.update_time IS 
'time when contact_test_result got into state represented by this record';
COMMENT ON COLUMN contact_test_result.update_time IS 
'time when contact_test_result got into state represented by this record';
COMMENT ON COLUMN contact_check.enum_contact_testsuite_id IS 
'Column is used ONLY during transition from enqueued->running for generating 
appropriate tests. Set of tests in contact_testsuite can be freely changed afterwards. 
To get tests evaluated during certain contact_check see records in table contact_test_result referring 
to id of that contact_check via contact_test_result.contact_check_id.';
CREATE FUNCTION assure_reffered_enum_contact_test_handles_dont_change() 
RETURNS trigger 
AS 
$contact_test_handle_to_change$
BEGIN
	IF OLD.handle == NEW.handle THEN
		RETURN NEW;
	END IF;
	
	SELECT id FROM contact_test_result WHERE enum_contact_test_id = OLD.id;
	IF NOT FOUND THEN
		RETURN NEW;
	END IF;
	
	RAISE EXCEPTION 'Contact test is already in results and is identified for public interface by it''s handle';
END;
$contact_test_handle_to_change$ 
LANGUAGE plpgsql;
  
CREATE TRIGGER contact_test_handle_to_change
   BEFORE UPDATE ON enum_contact_test
   FOR EACH ROW EXECUTE PROCEDURE assure_reffered_enum_contact_test_handles_dont_change();

COMMENT ON TRIGGER contact_test_handle_to_change ON enum_contact_test IS 
'There is at least one history record of this test execution so the handle must stay unchanged.';
-- get_associations_create
create unique index idx_enum_contact_test_handle on enum_contact_test (handle) ;
create index idx_contact_testsuite_map_enum_test_id on contact_testsuite_map (enum_contact_test_id) ;
create index idx_contact_testsuite_map_enum_testsuite_id on contact_testsuite_map (enum_contact_testsuite_id) ;
create unique index idx_contact_testsuite_map_unique_pair on contact_testsuite_map (enum_contact_test_id,enum_contact_testsuite_id) ;
create unique index idx_enum_contact_testsuite_handle on enum_contact_testsuite (handle) ;
create index idx_contact_check_contact_history_id on contact_check (contact_history_id) ;
create index idx_contact_check_log_request_id on contact_check (logd_request_id) ;
create index idx_contact_check_enum_testsuite_id on contact_check (enum_contact_testsuite_id) ;
create index idx_contact_check_enum_check_status_id on contact_check (enum_contact_check_status_id) ;
create unique index idx_contact_check_handle on contact_check (handle) ;
create unique index idx_enum_contact_check_status_handle on enum_contact_check_status (handle) ;
create index idx_contact_test_result_contact_check_id on contact_test_result (contact_check_id) ;
create index idx_contact_test_result_enum_test_id on contact_test_result (enum_contact_test_id) ;
create index idx_contact_test_result_log_request_id on contact_test_result (logd_request_id) ;
create index idx_contact_test_result_enum_test_status_id on contact_test_result (enum_contact_test_status_id) ;
create unique index idx_contact_test_result_unique_check_test_pair on contact_test_result (contact_check_id,enum_contact_test_id) ;
create unique index idx_enum_contact_test_status_handle on enum_contact_test_status (handle) ;
create index idx_contact_test_result_history_contact_test_result_id on contact_test_result_history (contact_test_result_id) ;
create index idx_contact_test_result_history_log_request_id on contact_test_result_history (logd_request_id) ;
create index idx_contact_test_result_history_enum_test_status_id on contact_test_result_history (enum_contact_test_status_id) ;
create index idx_contact_check_history_contact_check_id on contact_check_history (contact_check_id) ;
create index idx_contact_check_history_log_request_id on contact_check_history (logd_request_id) ;
create index idx_contact_check_history_enum_check_status_id on contact_check_history (enum_contact_check_status_id) ;
create index idx_contact_check_message_map_contact_check_id on contact_check_message_map (contact_check_id) ;
create index idx_contact_check_message_map_mail_archive_id on contact_check_message_map (mail_archive_id) 		;
create index idx_contact_check_message_map_message_archive_id on contact_check_message_map (message_archive_id) 		;
create index idx_contact_check_object_state_map_contact_check_id on contact_check_object_state_map (contact_check_id) ;
create index idx_contact_check_object_state_map_object_state_id on contact_check_object_state_map (object_state_id) ;
create index idx_contact_check_poll_message_map_contact_check_id on contact_check_poll_message_map (contact_check_id) ;
create index idx_contact_check_poll_message_map_poll_message_id on contact_check_poll_message_map (poll_message_id) ;
create index idx_enum_contact_test_status_localization_lang on enum_contact_test_status_localization (lang) ;
create index idx_enum_contact_check_status_localization_lang on enum_contact_check_status_localization (lang) ;
create index idx_enum_contact_testsuite_localization_lang on enum_contact_testsuite_localization (lang) ;
create index idx_enum_contact_test_localization_lang on enum_contact_test_localization (lang) ;
alter table contact_testsuite_map add constraint contact_testsuite_map_fk_Enum_contact_test_id 
    foreign key (enum_contact_test_id)
    references enum_contact_test (id) ;
alter table contact_testsuite_map add constraint contact_testsuite_map_fk_Enum_contact_testsuite_id 
    foreign key (enum_contact_testsuite_id)
    references enum_contact_testsuite (id) ;
alter table contact_check add constraint contact_check_fk_Enum_contact_testsuite_id 
    foreign key (enum_contact_testsuite_id)
    references enum_contact_testsuite (id) ;
alter table contact_check add constraint contact_check_fk_Enum_contact_check_status_id 
    foreign key (enum_contact_check_status_id)
    references enum_contact_check_status (id) ;
alter table contact_test_result add constraint contact_test_result_fk_Contact_check_id 
    foreign key (contact_check_id)
    references contact_check (id) ;
alter table contact_test_result add constraint contact_test_result_fk_Enum_contact_test_status_id 
    foreign key (enum_contact_test_status_id)
    references enum_contact_test_status (id) ;
alter table contact_test_result_history add constraint contact_test_result_history_fk_Contact_test_result_id 
    foreign key (contact_test_result_id)
    references contact_test_result (id) ;
alter table contact_check_history add constraint contact_check_history_fk_Enum_contact_check_status_id 
    foreign key (enum_contact_check_status_id)
    references enum_contact_check_status (id) ;
alter table contact_check_history add constraint contact_check_history_fk_Contact_check_id 
    foreign key (contact_check_id)
    references contact_check (id) ;
alter table contact_test_result add constraint contact_test_result_fk_Enum_contact_test_id 
    foreign key (enum_contact_test_id)
    references enum_contact_test (id) ;
alter table contact_check_message_map add constraint contact_check_message_map_fk_Contact_check_id 
    foreign key (contact_check_id)
    references contact_check (id) ;
alter table contact_check_object_state_map add constraint contact_check_object_state_map_fk_Contact_check_id 
    foreign key (contact_check_id)
    references contact_check (id) ;
alter table contact_check_poll_message_map add constraint contact_check_poll_message_map_fk_Contact_check_id 
    foreign key (contact_check_id)
    references contact_check (id) ;
alter table contact_test_result_history add constraint contact_test_result_history_fk_Enum_contact_test_status_id 
    foreign key (enum_contact_test_status_id)
    references enum_contact_test_status (id) ;
alter table enum_contact_test_status_localization add constraint enum_contact_test_status_localization_fk_Id 
    foreign key (id)
    references enum_contact_test_status (id) ;
alter table enum_contact_check_status_localization add constraint enum_contact_check_status_localization_fk_Id 
    foreign key (id)
    references enum_contact_check_status (id) ;
alter table enum_contact_testsuite_localization add constraint enum_contact_testsuite_localization_fk_Id 
    foreign key (id)
    references enum_contact_testsuite (id) ;
alter table enum_contact_test_localization add constraint enum_contact_test_localization_fk_Id 
    foreign key (id)
    references enum_contact_test (id) ;
