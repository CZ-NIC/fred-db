CREATE TABLE enum_filetype (
	id smallint PRIMARY KEY,
	name varchar(300)
);

INSERT INTO enum_filetype (id, name) VALUES (1, 'faktura');
INSERT INTO enum_filetype (id, name) VALUES (2, 'bankovni vypis');

CREATE TABLE files (
	id SERIAL PRIMARY KEY,
	name varchar(300) NOT NULL,
	path varchar(300) NOT NULL,
	mimetype varchar(100) NOT NULL DEFAULT 'application/octet-stream',
	filetype smallint REFERENCES enum_filetype(id),
	crdate timestamp NOT NULL DEFAULT now(),
	filesize integer NOT NULL
);

