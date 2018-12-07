#!/usr/bin/env python
#
# Copyright (C) 2006-2018  CZ.NIC, z. s. p. o.
#
# This file is part of FRED.
#
# FRED is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# FRED is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with FRED.  If not, see <https://www.gnu.org/licenses/>.

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

