CREATE TABLE enum_filetype (
	id smallint CONSTRAINT enum_filetype_pkey PRIMARY KEY,
	name varchar(300)
);

INSERT INTO enum_filetype (id, name) VALUES (1, 'invoice pdf');
INSERT INTO enum_filetype (id, name) VALUES (2, 'invoice xml');
INSERT INTO enum_filetype (id, name) VALUES (3, 'accounting xml');
INSERT INTO enum_filetype (id, name) VALUES (4, 'banking statement');
INSERT INTO enum_filetype (id, name) VALUES (5, 'expiration warning letter');

comment on table enum_filetype is 'list of file types

id - name
 1 - invoice pdf
 2 - invoice xml
 3 - accounting xml
 4 - banking statement
 5 - expiration warning letter';

CREATE TABLE files (
	id SERIAL CONSTRAINT files_pkey PRIMARY KEY,
	name varchar(300) NOT NULL,
	path varchar(300) NOT NULL,
	mimetype varchar(100) NOT NULL DEFAULT 'application/octet-stream',
	crdate timestamp NOT NULL DEFAULT now(),
	filesize integer NOT NULL,
	filetype smallint CONSTRAINT files_filetype_fkey REFERENCES enum_filetype(id)
);

comment on table files is
'table of files';
comment on column files.id is 'unique automatically generated identifier';
comment on column files.name is 'file name';
comment on column files.path is 'path to file';
comment on column files.mimetype is 'file mimetype';
comment on column files.crdate is 'file creation timestamp';
comment on column files.filesize is 'file size';
comment on column files.filetype is 'file type from table enum_filetype';
