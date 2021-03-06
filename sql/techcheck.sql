--CREATE TABLE check_enum_reason (
--	id SERIAL PRIMARY KEY,
--	reason varchar(100)
--);
--INSERT INTO check_enum_reason (reason) VALUES ('EPP');
--INSERT INTO check_enum_reason (reason) VALUES ('MANUAL');
--INSERT INTO check_enum_reason (reason) VALUES ('REGULAR');
--INSERT INTO check_enum_reason (reason) VALUES ('OTHER');

CREATE TABLE check_test (
	id INTEGER CONSTRAINT check_test_pkey PRIMARY KEY, -- provide test order
	name VARCHAR(100) NOT NULL, -- test name
	severity SMALLINT NOT NULL, -- test level
	description VARCHAR(300) NOT NULL, -- test description
	disabled BOOLEAN NOT NULL DEFAULT False,
	script VARCHAR(300) NOT NULL, -- script name, which realised test
	need_domain SMALLINT NOT NULL DEFAULT 0 -- whether test make sense only with concrete fqdn of domain
);

INSERT INTO check_test (id, name, severity, description, disabled, script,
	need_domain)
VALUES (0,  'glue_ok',          1, '', False, '', 2);
INSERT INTO check_test (id, name, severity, description, disabled, script,
	need_domain)
VALUES (1,  'existence',     1, '', False, 'existance.py', 2);
INSERT INTO check_test (id, name, severity, description, disabled, script,
	need_domain)
VALUES (10, 'autonomous',    5, '', False, 'autonomous.py', 0);
INSERT INTO check_test (id, name, severity, description, disabled, script,
	need_domain)
VALUES (20, 'presence',      2, '', False, 'presence.py', 1);
INSERT INTO check_test (id, name, severity, description, disabled, script,
	need_domain)
VALUES (30, 'authoritative', 3, '', False, 'authoritative.py', 1);
INSERT INTO check_test (id, name, severity, description, disabled, script,
	need_domain)
VALUES (40, 'heterogenous',  6, '', False, 'heterogenous.py', 0);
INSERT INTO check_test (id, name, severity, description, disabled, script,
	need_domain)
VALUES (50, 'notrecursive',     4, '', False, 'recursive.py', 2);
INSERT INTO check_test (id, name, severity, description, disabled, script,
	need_domain)
VALUES (60, 'notrecursive4all', 4, '', False, 'recursive4all.py', 0);
INSERT INTO check_test (id, name, severity, description, disabled, script,
	need_domain)
VALUES (70, 'dnsseckeychase', 3, '', False, 'dnsseckeychase.py', 3);

CREATE TABLE check_dependance (
	id SERIAL CONSTRAINT check_dependance_pkey PRIMARY KEY,
	addictid INTEGER CONSTRAINT check_dependance_addictid_fkey REFERENCES check_test (id),
	testid INTEGER CONSTRAINT check_dependance_testid_fkey REFERENCES check_test (id)
);

INSERT INTO check_dependance (addictid, testid) VALUES ( 1, 0);
INSERT INTO check_dependance (addictid, testid) VALUES (10, 0);
INSERT INTO check_dependance (addictid, testid) VALUES (20, 0);
INSERT INTO check_dependance (addictid, testid) VALUES (30, 0);
INSERT INTO check_dependance (addictid, testid) VALUES (40, 0);
INSERT INTO check_dependance (addictid, testid) VALUES (50, 0);
INSERT INTO check_dependance (addictid, testid) VALUES (60, 0);
INSERT INTO check_dependance (addictid, testid) VALUES (10, 1);
INSERT INTO check_dependance (addictid, testid) VALUES (20, 1);
INSERT INTO check_dependance (addictid, testid) VALUES (30, 1);
INSERT INTO check_dependance (addictid, testid) VALUES (30,20);
INSERT INTO check_dependance (addictid, testid) VALUES (40, 1);
INSERT INTO check_dependance (addictid, testid) VALUES (50, 1);
INSERT INTO check_dependance (addictid, testid) VALUES (60, 1);
INSERT INTO check_dependance (addictid, testid) VALUES (70, 1);
INSERT INTO check_dependance (addictid, testid) VALUES (70, 20);

select setval('check_dependance_id_seq', 16);

CREATE TABLE check_nsset (
	id SERIAL CONSTRAINT check_nsset_pkey PRIMARY KEY,
	-- nsset version, actual in time of record creation
	nsset_hid INTEGER CONSTRAINT check_nsset_nsset_hid_fkey REFERENCES nsset_history (historyid),
	checkdate TIMESTAMP NOT NULL DEFAULT now(),
	-- 0 = UNKNOWN
	-- 1 = EPP
	-- 2 = MANUAL
	-- 3 = REGULAR
	reason SMALLINT NOT NULL DEFAULT 0,
	-- 0 = all tests were passed
	-- 1 = one or more tests failed
	-- 2 = one or more tests have unknown status and none has failed
	overallstatus SMALLINT NOT NULL,
	-- Here are stored fqdns of domains which were tested with nsset and
	-- are not part of registry
	extra_fqdns VARCHAR(300)[],
	-- if domains associated with nsset were also tested
	dig BOOLEAN NOT NULL,
	-- what attempt it is (1th, 2nd or 3rd)
	attempt SMALLINT NOT NULL DEFAULT 1
);

CREATE INDEX check_nsset_nsset_hid_idx ON check_nsset (nsset_hid);

CREATE TABLE check_result (
	id SERIAL CONSTRAINT check_result_pkey PRIMARY KEY,
	checkid INTEGER CONSTRAINT check_result_checkid_fkey references check_nsset(id) ON UPDATE CASCADE ON DELETE CASCADE,
	testid INTEGER CONSTRAINT check_result_testid_fkey references check_test(id),
	-- three-state logic (0=passed, 1=failed, 2=unknown)
	--    unknown occurs if script failed for unknown reason
	status SMALLINT NOT NULL,
	note TEXT, -- output of test script (stderr)
	data TEXT  -- test-specific text data (stdout)
);

CREATE INDEX check_result_checkid_idx ON check_result (checkid);
