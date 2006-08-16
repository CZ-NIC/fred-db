-- ciselnik funkci
-- DROP TABLE enum_ssntype CASCADE;
CREATE TABLE enum_ssntype (
        id SERIAL PRIMARY KEY,
        type varchar(8) UNIQUE NOT NULL,
        description varchar(64) UNIQUE NOT NULL
        );

-- prihlasovaci funkce
INSERT INTO enum_ssntype  VALUES(1 , 'RC' , 'rodne cislo');
INSERT INTO enum_ssntype  VALUES(2 , 'OP' , 'cislo obcanky');
INSERT INTO enum_ssntype  VALUES(3 , 'PASS' , 'cislo pasu');
INSERT INTO enum_ssntype  VALUES(4 , 'ICO' , 'ico');
INSERT INTO enum_ssntype  VALUES(5 , 'MPSV' , 'identifikator ministerstva prace s soc. veci');
