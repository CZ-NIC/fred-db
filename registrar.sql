DELETE FROM Registrar;
INSERT INTO Registrar ( id,zone, handle , organization , name , url ) VALUES( 100,   '{1 }' , 'REG-GENERAL-REGISTRY' ,  'GENERAL REGISTRY, s.r.o.' ,     'DomainMaster',   'www.domainmaster.cz');
INSERT INTO Registrar ( id,zone,  handle ,organization , name , url ) VALUES( 300 ,   '{1 }' , 'REG-ACTIVE24'  ,'ACTIVE 24, s. r. o.' ,    'DOMENY.CZ' , 'www.domeny.cz');
INSERT INTO Registrar ( id, zone, handle , organization , name , url ) VALUES( 400 ,  '{1 }' ,'REG-HAVEL'  ,'ha-vel internet s.r.o.' ,       'ha-vel' , 'domeny.ha-vel.cz');
INSERT INTO Registrar ( id,zone,   handle ,organization , name , url ) VALUES( 500,   '{1 }' ,'REG-IGNUM'   , 'IGNUM, s.r.o.' ,                 'DOMENA.CZ' ,   ' www.domena.cz');
INSERT INTO Registrar ( id, zone, handle , organization , name , url ) VALUES( 600 ,  '{1 }' , 'REG-INTERNET-CZ',  'INTERNET CZ, a.s.' ,       'Velkoobchod domen' ,  'domeny.velkoobchod.cz');
INSERT INTO Registrar ( id,  zone, handle ,organization , name , url ) VALUES( 700,  '{1 }' ,  'REG-MIRAMO' , 'MIRAMO spol. s r.o.' ,          '9net.cz' ,  'www.9net.cz');
INSERT INTO Registrar ( id,zone,  handle ,organization , name , url ) VALUES( 800,   '{1 }' ,  'REG-ZONER' , 'ZONER software, s.r.o.' ,       'RegZone!' ,  'www.regZone.cz');
INSERT INTO Registrar ( id, zone, handle ,organization , name , url ) VALUES( 200,   '{1 }' ,'REG-CT'   , 'CESKY TELECOM, a.s.' ,          'Internet OnLine' , 'domeny.iol.cz');
INSERT INTO Registrar ( id,zone,  handle ,organization , name , url ) VALUES( 110,  '{1 }' ,'REG-KRAXNET'  ,   'KRAXNET s.r.o.' ,               'XNET'   ,   'www.xnet.cz');
INSERT INTO Registrar ( id,zone, handle , organization , name , url ) VALUES(120,  '{1 }' ,  'REG-MEDIA4WEB',    'Media4web s.r.o.' ,          'Media4web'   , 'www.media4web.cz');
INSERT INTO Registrar ( id,zone, handle , organization , name , url ) VALUES(130,  '{1 }' ,'REG-ONE'   ,   'ONE.CZ s.r.o.' ,                 'REGISTRATOR.CZ'  , 'www.registrator.cz');
INSERT INTO Registrar ( id, zone, handle ,organization , name , url ) VALUES( 140,   '{1 }' ,'REG-WEB4U'  ,'Web4U s.r.o.' ,                  'Sprava domen',  'www.spravadomen.cz');
INSERT INTO Registrar ( id,zone, handle , organization , name , url ) VALUES( 150 ,  '{1 }' , 'REG-NEXTRA' ,  'NEXTRA Czech Republic s.r.o.' ,  'NEXTRA'   ,   'domeny.nextra.cz');
INSERT INTO Registrar ( id,zone, handle , organization , name , url ) VALUES( 160 , '{1 }' ,'REG-IPEX'  , 'IPEX a.s.'              ,       'IPEX'        ,    'www.ipex.cz');
INSERT INTO Registrar ( id, zone, handle ,organization , name , url ) VALUES( 170 , '{1 }' , 'REG-SKYNET',   'SkyNet, a.s.'            ,      'SkyNet'    ,        'www.skynet.cz');
INSERT INTO Registrar ( id, zone, handle ,organization , name , url ) VALUES( 1,  '{1 , 2 , 3 }' , 'REG-LRR',    'CZ.NIC, z.s.p.o.'          ,    'LRR'         ,      'www.lrr.cz');

-- nastav credit 
UPDATE registrar set credit=1000000.0;
