CREATE TABLE epp_info_buffer_content (
	id INTEGER NOT NULL, 
	registrar_id INTEGER NOT NULL REFERENCES registrar (id), 
	object_id INTEGER NOT NULL, 
	PRIMARY KEY (id,registrar_id)
);

CREATE TABLE epp_info_buffer (
	registrar_id INTEGER NOT NULL REFERENCES registrar (id),
	current INTEGER, 
	FOREIGN KEY (registrar_id, current) REFERENCES epp_info_buffer_content (registrar_id, id),
    PRIMARY KEY (registrar_id)
);

CREATE INDEX epp_info_buffer_content_registrar_id_idx ON epp_info_buffer_content (registrar_id);