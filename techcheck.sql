--CREATE TABLE check_enum_reason (
--	id SERIAL PRIMARY KEY,
--	reason varchar(100)
--);
--INSERT INTO check_enum_reason (reason) VALUES ('EPP');
--INSERT INTO check_enum_reason (reason) VALUES ('MANUAL');
--INSERT INTO check_enum_reason (reason) VALUES ('REGULAR');
--INSERT INTO check_enum_reason (reason) VALUES ('OTHER');

CREATE TABLE check_test (
	id INTEGER PRIMARY KEY, -- urcute poradi testu
	name VARCHAR(100) NOT NULL, -- nazev testu
	severity SMALLINT NOT NULL, -- uroven testu
	description VARCHAR(300) NOT NULL, -- textovy popis testu
	disabled BOOLEAN NOT NULL DEFAULT False,
	script VARCHAR(300) NOT NULL -- script ktery realizuje test
);

INSERT INTO check_test (id, name, severity, description, disabled, script)
VALUES (10, 'autonomous', 2, '', False, 'autonomous.sh');
INSERT INTO check_test (id, name, severity, description, disabled, script)
VALUES (20, 'existance', 1, '', False, 'existance.sh');
INSERT INTO check_test (id, name, severity, description, disabled, script)
VALUES (30, 'authoritative', 1, '', False, 'authoritative.sh');
INSERT INTO check_test (id, name, severity, description, disabled, script)
VALUES (40, 'heterogenous', 3, '', False, 'heterogenous.sh');
INSERT INTO check_test (id, name, severity, description, disabled, script)
VALUES (50, 'recursive', 2, '', False, 'recursive.sh');
INSERT INTO check_test (id, name, severity, description, disabled, script)
VALUES (60, 'recursive4all', 2, '', False, 'recursive4all.sh');

CREATE TABLE check_dependance (
	id SERIAL PRIMARY KEY,
	addictid INTEGER REFERENCES check_test (id),
	testid INTEGER REFERENCES check_test (id)
);

INSERT INTO check_dependance (addictid, testid) VALUES (30, 20);
INSERT INTO check_dependance (addictid, testid) VALUES (40, 20);
INSERT INTO check_dependance (addictid, testid) VALUES (50, 20);
INSERT INTO check_dependance (addictid, testid) VALUES (60, 20);

CREATE TABLE check_domain (
	id SERIAL PRIMARY KEY,
	domain_id INTEGER REFERENCES object_registry (id), -- domain
	-- domain version, actual in time of record creation
	domain_hid INTEGER REFERENCES domain_history (historyid),
	checkdate TIMESTAMP NOT NULL DEFAULT now(),
	reason SMALLINT NOT NULL,
	overallstatus BOOLEAN NOT NULL
);

CREATE TABLE check_result (
	id SERIAL PRIMARY KEY,
	checkid INTEGER references check_domain(id),
	testid INTEGER references check_test(id),
	passed BOOLEAN NOT NULL,
	note TEXT
);

