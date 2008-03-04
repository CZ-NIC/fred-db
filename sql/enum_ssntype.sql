-- function classifier
-- DROP TABLE enum_ssntype CASCADE;
CREATE TABLE enum_ssntype (
        id SERIAL PRIMARY KEY,
        type varchar(8) UNIQUE NOT NULL,
        description varchar(64) UNIQUE NOT NULL
        );

-- login function
INSERT INTO enum_ssntype  VALUES(1 , 'RC' , 'born number');
INSERT INTO enum_ssntype  VALUES(2 , 'OP' , 'identity card number');
INSERT INTO enum_ssntype  VALUES(3 , 'PASS' , 'passwport');
INSERT INTO enum_ssntype  VALUES(4 , 'ICO' , 'organization identification number');
INSERT INTO enum_ssntype  VALUES(5 , 'MPSV' , 'social system identification');
INSERT INTO enum_ssntype  VALUES(6 , 'BIRTHDAY' , 'day of birth');

comment on table enum_ssntype is
'Table of identification number types

types:
id - type   - description
 1 - RC     - born number
 2 - OP     - identity card number
 3 - PASS   - passport number
 4 - ICO    - organization identification number
 5 - MPSV   - social system identification
 6 - BIRTHDAY - day of birth';
comment on column enum_ssntype.type is 'type abbrevation';
comment on column enum_ssntype.description is 'type description';
