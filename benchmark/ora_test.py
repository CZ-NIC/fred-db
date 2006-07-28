#!/usr/bin/env python
# vim:set ts=4 sw=4:

import cx_Oracle
from test import main

def open_ora_db(pars):
	"""
Hook for openning oracle database. Rest is the same for all DB API 2
database modules. Parameter pars is dictionary and following keys with
appropriate values must be inside: user, passwd, host.
	"""
	try:
		# connect to database
		conn = cx_Oracle.connect("%s/%s@%s" % \
				(pars["user"], pars["passwd"], pars["host"]) )
	except Exception, e:
		raise Exception("Could not connect to database: %s" % e)
	# one more special thing - disable all autonumbering triggers
	cur = conn.cursor()
	cur.execute("ALTER TRIGGER action_trigger DISABLE")
	cur.execute("ALTER TRIGGER history_trigger DISABLE")
	cur.close()
	return conn

def close_ora_db(conn):
	"""
Close connection to oracle database. BTW enable triggers which we
have disabled at the beginning.
	"""
	cur = conn.cursor()
	cur.execute("ALTER TRIGGER action_trigger ENABLE")
	cur.execute("ALTER TRIGGER history_trigger ENABLE")
	cur.close()
	conn.close()

def get_ora_seq(name):
	"""
Getting sequence value in Oracle is different from postgresql.
	"""
	return "SELECT %s.nextval FROM dual" % name

if __name__ == "__main__":
	main(open_ora_db, close_ora_db, get_ora_seq)

