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
