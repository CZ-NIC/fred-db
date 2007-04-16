CREATE TABLE enum_filetype (
	id smallint PRIMARY KEY,
	name varchar(300)
);

INSERT INTO enum_filetype (id, name) VALUES (1, 'invoice pdf');
INSERT INTO enum_filetype (id, name) VALUES (2, 'invoice xml');
INSERT INTO enum_filetype (id, name) VALUES (3, 'accounting xml');
INSERT INTO enum_filetype (id, name) VALUES (4, 'banking statement');

CREATE TABLE files (
	id SERIAL PRIMARY KEY,
	name varchar(300) NOT NULL,
	path varchar(300) NOT NULL,
	mimetype varchar(100) NOT NULL DEFAULT 'application/octet-stream',
	crdate timestamp NOT NULL DEFAULT now(),
	filesize integer NOT NULL,
	filetype smallint REFERENCES enum_filetype(id)
);

