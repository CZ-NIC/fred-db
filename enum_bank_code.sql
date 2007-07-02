-- classifier of error messages reason
-- DROP TABLE enum_bank_code  CASCADE;
CREATE TABLE enum_bank_code (
      code char(4) PRIMARY KEY,
      name_short varchar(4) UNIQUE NOT NULL , -- short cut 
      name_full varchar(64) UNIQUE  NOT NULL -- full name
);

INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'ABN AMRO BANK N.V.' , 'AMRO'  , '5400' );
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'HVB CZECH REPUBLIC, A. S.' , 'HVB' ,'2700' );
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'BNP-DRESDNER BANK (ČR) A.S.' , 'BNP' , '4000' ); 
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'CITIBANK A.S.' , 'CITI' ,	'2600' );
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'COMMERZBANK AG' , 'COMM'	, '6200'  );
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'ČESKÁ SPOŘITELNA A.S.' , 'CS' ,	'0800'  );
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'ČESKOMOR. HYPOTÉČNÍ BANKA A.S.' ,  'CMHB' 	,'2100');
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'ČESKOMORAVSKÁ STAVEBNÍ SPOŘITELNA' , 'CMSS' 	,'7960');
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'ČESKOSLOVENSKÁ OBCHODNÍ BANKA A.S.' , 'CSOB' 	,'0300' );
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'DEUTSCHE BANK A.G.', 'DB'  ,	'7910');
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'EBANKA', 'EB' , '2400' );
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'GE CAPITAL BANK, A. S.' , 'GE' , '0600');
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'HYPO STAVEBNÍ SPOŘITELNA' , 'HYPO' ,	'8070');
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'IC BANKA A.S.'  , 'IC' , '6100');
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'ING BANK N. V.' , 'ING' ,	'3500');
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'INTERBANKA A.S.'  , 'INTB' ,  '2500' ); 
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'J & T BANKA, A. S.' , 'J&T' , 	'5800');
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'KOMERČNÍ BANKA A.S.' , 'KB' ,	'0100');
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'KONSOLIDAČNÍ BANKA PRAHA' ,  'KONS'	,'3300');
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'PLZEŇSKÁ BANKA A.S.' , 'PILS' 	, '4600');
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'PPF BANKA A.S.' , 'PPF' 	,'6000');
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'RAIFFEISEN STAVEBNÍ SPOŘITELNA, A. S.' , 'RFSS', 	'7950');
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'RAIFFEISENBANK A.S.' , 'RF' ,	 '5500' );
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'STAVEBNÍ SPOŘITELNA ČESKÉ SPOŘITELNY, A. S.'  , 'SSCS', 	'8060' );
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'UNION BANKA A.S.' , 'UB' ,	'3400' );
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'VOLKSBANK CZ, A. S.' , 'VB' 	,'6800');
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'VŠEOB.ÚVĚR.BANKA POB. PRAHA' , 'VUB'	,'6700');
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'VŠEOBECNÁ STAV.SPOŘITELNA' , 'VSS' ,	'7990' );
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'WUSTENROT STAVEBNÍ SPOŘITELNA' , 'WS'  , 	'7970');
INSERT INTO  enum_bank_code (name_full,name_short,code) VALUES ( 'ŽIVNOSTENSKÁ BANKA A.S.' , 'ZB' , 	'0400');
