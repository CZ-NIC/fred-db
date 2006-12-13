CREATE TABLE files (
	id SERIAL PRIMARY KEY,
	name varchar(300) NOT NULL,
	path varchar(300) NOT NULL,
	mimetype varchar(100) NOT NULL DEFAULT 'application/octet-stream',
	crdate timestamp NOT NULL DEFAULT now(),
	filesize integer NOT NULL
);

