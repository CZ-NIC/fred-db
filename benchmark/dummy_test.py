#!/usr/bin/env python
# vim:set ts=4 sw=4:

import sys, pg, ConfigParser
from executor import *
import time


def usage():
	"""Print usage information"""
	
	return "   " + sys.argv[0] + " [config]" + """

	config	- configuration file (default is bench.conf)
"""


def setDefaults():
	return {
		"dbname":"benchdb", "host":"localhost", "port":"5432",
		"user":"benchuser", "passwd":"benchpw"
		}


if __name__ == "__main__":
	# get command line argument (config file)
	if len(sys.argv) > 2:
		sys.stderr.write(usage())
		sys.exit(1)
	if len(sys.argv) < 2: configfile = "bench.conf"
	else: configfile = sys.argv[1]
	# set config defaults and parse configuration file
	config = ConfigParser.ConfigParser(setDefaults())
	config.read([configfile])
	# insert possibly missing sections
	if config.has_section("test") == False: config.add_section("test")
	# get config values
	cfg_dbname = config.get("test", "dbname")
	cfg_host = config.get("test", "host")
	cfg_port = config.getint("test", "port")
	cfg_user = config.get("test", "user")
	cfg_passwd = config.get("test", "passwd")
	# connect to database
	try:
		db = pg.DB(dbname = cfg_dbname, host = cfg_host, port = cfg_port, \
				user = cfg_user, passwd = cfg_passwd)
	except Exception, e:
		sys.stderr.write("Could not connect to database: %s\n" % e)
		sys.exit(1)
	# create executor which transforms EPP commands into SQL queries
	exe = Executor(db)
	# get handles of all objects
	domains, contacts, nssets = exe.getHandles()
	start = time.time()
	for i in range(5):
		exe.check_domain(domains[i])
		exe.info_domain(domains[i])
	end = time.time()
	print end - start
	# try this dummy test
	db.close()

