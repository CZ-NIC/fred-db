#!/usr/bin/env python
# vim:set ts=4 sw=4:
"""
This module simulates EPP commands by executing same types and sequences of
sql commands.

It creates a level of abstraction so that benchmark program
does not have to execute all the needed sql statements but can simply call
just EPP commands.
"""

import pg
from myrand import *
from sql import *

class ExecutorError(Exception):
	def __init__(self, value):
		self.value = value
	def __str__(self):
		return repr(self.value)

class Executor:
	"""
	och
	"""
	def __init__(self, db):
		self.db = db
		res = self.db.query("SELECT count(*) from registrar;").getresult()
		self.maxregid = int( res[0][0] )
	def __del__(self):
		pass
	#
	# private members
	#
	def _begin_xaction(self):
		self.db.query("BEGIN WORK;")
	def _end_xaction(self):
		self.db.query("END WORK;")
	def _get_seq_nextval(self, name):
		res = self.db.query("SELECT nextval('%s');" % name).getresult()
		return int( res[0][0] )
	#
	# class interface
	#
	def getHandles(self):
		try:
			res = self.db.query("SELECT fqdn FROM domain;").getresult()
			domains = [ item[0] for item in res ]
			res = self.db.query("SELECT handle FROM contact;").getresult()
			contacts = [ item[0] for item in res ]
			res = self.db.query("SELECT handle FROM nsset;").getresult()
			nssets = [ item[0] for item in res ]
			return (domains, contacts, nssets)
		except pg.DatabaseError, e:
			raise ExecutorError(e.__str__())
	def check_domain(self, fqdn):
		try:
			self._begin_xaction()
			id = self._get_seq_nextval('action_id_seq')
			self.db.query(get_ins_action( id, randint(1, self.maxregid) , 500 ))
			self.db.query(get_sel_domainid(fqdn))
			self.db.query(get_upd_action(id))
			self._end_xaction()
		except pg.DatabaseError, e:
			raise ExecutorError(e.__str__())
	def info_domain(self, fqdn):
		try:
			self._begin_xaction()
			id = self._get_seq_nextval('action_id_seq')
			self.db.query(get_ins_action( id, randint(1, self.maxregid) , 501 ))
			self.db.query(get_sel_regid( randint(1, self.maxregid) ))
			self.db.query(get_sel_domain(fqdn))
			self.db.query(get_upd_action(id))
			self._end_xaction()
		except pg.DatabaseError, e:
			raise ExecutorError(e.__str__())


if __name__ == "__main__":
	print """
This module cannot be used directly. It has to be imported. See module's
documentation for more details ( help(executor) ).
	"""

