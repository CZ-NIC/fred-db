#!/usr/bin/env python
# vim:set ts=4 sw=4:

import pgdb
from test import main

def open_pg_db(pars):
	"""
Hook for openning postgresql database. Rest is the same for all DB API 2
database modules. Parameter pars is dictionary and following keys with
appropriate values must be inside: user, passwd, host, dbname.
	"""
	try:
		# connect to database
		conn = pgdb.connect("%s:%s:%s:%s" % (pars["host"], pars["dbname"], \
				pars["user"], pars["passwd"]) )
	except Exception, e:
		raise Exception("Could not connect to database: %s" % e)
	return conn

def close_pg_db(conn):
	"""
Close connection to postgresql database.
	"""
	conn.close()

def get_pg_seq(name):
	"""
Getting sequence value in Postgresql is different from oracle.
	"""
	return "SELECT nextval('%s')" % name

if __name__ == "__main__":
	main(open_pg_db, close_pg_db, get_pg_seq)

