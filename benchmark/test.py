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

"""
Module handles high-level phase of testing. The routines performing
individual tests (low-level part) are elsewhere.
"""

import sys, os, signal, time, ConfigParser
from executor import *


global terminate

def usage():
	"""Print usage information"""
	
	return "   " + sys.argv[0] + " database [config]" + \
	"""
	database is one of:
		ora :oracle database is used
		pg  :postgresql database is used
	config: configuration file (default is bench.conf)
	"""

def setDefaults():
	"""
Return default values for configuration directives in form of a dictionary.
	"""
	return {
		"dbname":"benchdb", "host":"localhost", "user":"benchuser",
		"passwd":"benchpw", "iterations":"3", "timeout":"0",
		"par":"1"
		}

def print_stats(count, time, throughput):
	"""
Print final results of testing.
	"""
	sys.stderr.write(\
		"Total: %d EPP commands\nTime: %f seconds\nThroughput: %f cmds/sec\n" \
		% (count, time, throughput))

def sig_term_handler(sig, frame):
	"""
SigTerm signal is used to terminate children after specified timeout
from main process. This routine handles the signal.
	"""
	global terminate
	terminate = True

def child_body(pars, open_db_hook, close_db_hook, seq_hook):
	"""
Body of process performing testing of database.
	"""
	global terminate
	terminate = False
	signal.signal(signal.SIGTERM, sig_term_handler)
	# desync the random number generators (has to be unique for each child)
	seed()
	# create executor which transforms EPP commands into SQL queries
	db = open_db_hook(pars)
	exe = Executor(db, seq_hook, False)
	# get handles of all objects
	domains, contacts, nssets = exe.getHandles()
	epp_count = 0
	print "starting"
	start = time.time()
	for i in range(pars["iter"]):
		if terminate: break
		# select random EPP command manipulating with domain object
		epp_cmd = choice([exe.check_domain, exe.info_domain,
				exe.transfer_domain, exe.renew_domain, exe.update_domain])
		try: epp_cmd(choice(domains))
		except Exception: print '.',
		# select random EPP command manipulating with contact object
		epp_cmd = choice([exe.check_contact, exe.info_contact,
				exe.update_contact])
		try: epp_cmd(choice(contacts))
		except Exception: print '.',
		# select random EPP command manipulating with nsset object
		epp_cmd = choice([exe.check_nsset, exe.info_nsset,
				exe.transfer_nsset, exe.update_nsset])
		try: epp_cmd(choice(nssets))
		except Exception: print '.',
		# update counter
		epp_count += 3
	end = time.time()
	close_db_hook(db)
	print_stats(epp_count, end - start, epp_count / (end - start))


def main(open_db_hook, close_db_hook, seq_hook):
	"""
The entry point for testing. It parses configuration file and invokes
processes that do the actual testing. open_db_hook is a function which
returns object "connection" defined in python DB API 2.0.
	"""
	# get command line argument (config file)
	if len(sys.argv) > 2:
		sys.stderr.write(usage())
		sys.exit(1)
	if len(sys.argv) == 1: configfile = "bench.conf"
	else: configfile = sys.argv[2]
	# set config defaults and parse configuration file
	config = ConfigParser.ConfigParser(setDefaults())
	config.read([configfile])
	# insert possibly missing sections
	if config.has_section("test") == False: config.add_section("test")
	# get config values
	cfgs = {}
	cfgs["dbname"] = config.get("test", "dbname")
	cfgs["host"] = config.get("test", "host")
	cfgs["user"] = config.get("test", "user")
	cfgs["passwd"] = config.get("test", "passwd")
	cfgs["iter"] = config.getint("test", "iterations")
	cfg_time = config.getint("test", "timeout")
	cfg_par = config.getint("test", "par")
	# fork new tester-processes
	children = []
	for i in range(cfg_par):
		pid = os.fork()
		if (pid == 0):
			child_body(cfgs, open_db_hook, close_db_hook, seq_hook)
			sys.exit(0)
		else:
			children.append(pid)
	if (cfg_time == 0):
		# wait for all children to terminate
		for pid in children: os.waitpid(pid, 0)
	else:
		# kill all children after specified timeout
		time.sleep(cfg_time)
		for pid in children: os.kill(pid, signal.SIGTERM)
		for pid in children: os.waitpid(pid, 0)

if __name__ == "__main__":
	print """
This module cannot be used directly. It has to be imported. See module's
documentation for more details ( help(test) ).
	"""

