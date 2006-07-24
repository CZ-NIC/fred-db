#!/usr/bin/env python
# vim:set ts=4 sw=4:
"""
This module simulates EPP commands by executing same types and sequences of
sql commands.

It creates a level of abstraction so that benchmark program
does not have to execute all the needed sql statements but can simply call
just EPP commands.
"""

import sys, pg
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
	def __init__(self, db, debug = False):
		self.db = db
		res = self.db.query("SELECT count(*) from registrar;").getresult()
		self.maxregid = int( res[0][0] )
		self.debug = debug
		if self.debug: sys.stderr.write("Instantiating Executor object "\
				"(number of registrars: %d)\n" % self.maxregid)
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
	def _tosql(self, dict):
		for col in dict:
			if dict[col] == None:
				# convert None -> NULL
				dict[col] = "NULL"
			elif type(dict[col]) == type("str"):
				# convert "string" -> "'string'"
				dict[col] = "'%s'" % dict[col]
			else:
				# convert 123 -> '123'
				dict[col] = dict[col].__str__()
		return dict
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
		if self.debug: sys.stderr.write("\tcheck_domain\n")
		try:
			self._begin_xaction()
			id = self._get_seq_nextval('action_id_seq')
			self.db.query(get_ins_action( id, randint(1, self.maxregid) , 500 ))
			self.db.query(get_sel_domainid(fqdn))
			self.db.query(get_upd_action(id))
			self._end_xaction()
		except pg.DatabaseError, e:
			raise ExecutorError(e.__str__())
	def check_contact(self, handle):
		if self.debug: sys.stderr.write("\tcheck_contact\n")
		try:
			self._begin_xaction()
			id = self._get_seq_nextval('action_id_seq')
			self.db.query(get_ins_action( id, randint(1, self.maxregid) , 500 ))
			self.db.query(get_sel_contactid(handle))
			self.db.query(get_upd_action(id))
			self._end_xaction()
		except pg.DatabaseError, e:
			raise ExecutorError(e.__str__())
	def check_nsset(self, handle):
		if self.debug: sys.stderr.write("\tcheck_nsset\n")
		try:
			self._begin_xaction()
			id = self._get_seq_nextval('action_id_seq')
			self.db.query(get_ins_action( id, randint(1, self.maxregid) , 500 ))
			self.db.query(get_sel_nssetid(handle))
			self.db.query(get_upd_action(id))
			self._end_xaction()
		except pg.DatabaseError, e:
			raise ExecutorError(e.__str__())
	def info_domain(self, fqdn):
		if self.debug: sys.stderr.write("\tinfo_domain\n")
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
	def info_contact(self, handle):
		if self.debug: sys.stderr.write("\tinfo_contact\n")
		try:
			self._begin_xaction()
			id = self._get_seq_nextval('action_id_seq')
			self.db.query(get_ins_action( id, randint(1, self.maxregid) , 501 ))
			self.db.query(get_sel_regid( randint(1, self.maxregid) ))
			self.db.query(get_sel_contact(handle))
			self.db.query(get_upd_action(id))
			self._end_xaction()
		except pg.DatabaseError, e:
			raise ExecutorError(e.__str__())
	def info_nsset(self, handle):
		if self.debug: sys.stderr.write("\tinfo_nsset\n")
		try:
			self._begin_xaction()
			id = self._get_seq_nextval('action_id_seq')
			self.db.query(get_ins_action( id, randint(1, self.maxregid) , 501 ))
			self.db.query(get_sel_regid( randint(1, self.maxregid) ))
			self.db.query(get_sel_nsset(handle))
			self.db.query(get_upd_action(id))
			self._end_xaction()
		except pg.DatabaseError, e:
			raise ExecutorError(e.__str__())
	def transfer_domain(self, fqdn):
		if self.debug: sys.stderr.write("\ttransfer_domain\n")
		try:
			self._begin_xaction()
			actid = self._get_seq_nextval('action_id_seq')
			self.db.query(get_ins_action(actid, randint(1, self.maxregid), 505 ))
			res = self.db.query(get_sel_domainid(fqdn)).getresult()
			id = res[0][0]
			self.db.query(get_sel_regid( randint(1, self.maxregid) ))
			self.db.query(get_sel_domain_clid(id))
			self.db.query(get_sel_domain_status(id))
			self.db.query(get_sel_domain_authinfo(id))
			histid = self._get_seq_nextval('history_id_seq')
			self.db.query(get_ins_history(histid, actid))
			res = self.db.query(get_sel_domain_all(id)).dictresult()
			res[0] = self._tosql(res[0])
			self.db.query(get_ins_history_domain( histid, res[0] ))
			res = self.db.query(get_sel_enumval_all(id)).dictresult()
			if len(res) > 0:
				res[0] = self._tosql(res[0])
				self.db.query(get_ins_history_enumval( histid, res[0] ))
			res = self.db.query(get_sel_domain_contact_map_all(id)).dictresult()
			res[0] = self._tosql(res[0])
			self.db.query(get_ins_history_domain_contact_map( histid, res[0] ))
			self.db.query(get_upd_domain_xfer( id, randint(1, self.maxregid) ))
			self.db.query(get_upd_action(actid))
			self._end_xaction()
		except pg.DatabaseError, e:
			raise ExecutorError(e.__str__())
	def transfer_nsset(self, handle):
		if self.debug: sys.stderr.write("\ttransfer_nsset\n")
		try:
			self._begin_xaction()
			actid = self._get_seq_nextval('action_id_seq')
			self.db.query(get_ins_action(actid, randint(1, self.maxregid), 405 ))
			res = self.db.query(get_sel_nssetid(handle)).getresult()
			id = res[0][0]
			self.db.query(get_sel_regid( randint(1, self.maxregid) ))
			self.db.query(get_sel_nsset_clid(id))
			self.db.query(get_sel_nsset_status(id))
			self.db.query(get_sel_nsset_authinfo(id))
			histid = self._get_seq_nextval('history_id_seq')
			self.db.query(get_ins_history(histid, actid))
			res = self.db.query(get_sel_nsset_all(id)).dictresult()
			res[0] = self._tosql(res[0])
			self.db.query(get_ins_history_nsset( histid, res[0] ))
			self.db.query(get_upd_nsset_xfer( id, randint(1, self.maxregid) ))
			self.db.query(get_upd_action(actid))
			self._end_xaction()
		except pg.DatabaseError, e:
			raise ExecutorError(e.__str__())
	def renew_domain(self, fqdn):
		if self.debug: sys.stderr.write("\trenew_domain\n")
		try:
			self._begin_xaction()
			actid = self._get_seq_nextval('action_id_seq')
			self.db.query(get_ins_action(actid, randint(1, self.maxregid), 506 ))
			res = self.db.query(get_sel_domainid(fqdn)).getresult()
			id = res[0][0]
			self.db.query(get_sel_regid( randint(1, self.maxregid) ))
			self.db.query(get_sel_domain_clid(id))
			res = self.db.query(get_sel_zone(fqdn)).getresult()
			zoneid = res[0][0]
			self.db.query(get_sel_zone_min(zoneid))
			self.db.query(get_sel_domain_status(id))
			histid = self._get_seq_nextval('history_id_seq')
			self.db.query(get_ins_history(histid, actid))
			res = self.db.query(get_sel_domain_all(id)).dictresult()
			res[0] = self._tosql(res[0])
			self.db.query(get_ins_history_domain( histid, res[0] ))
			res = self.db.query(get_sel_enumval_all(id)).dictresult()
			if len(res) > 0:
				res[0] = self._tosql(res[0])
				self.db.query(get_ins_history_enumval( histid, res[0] ))
			res = self.db.query(get_sel_domain_contact_map_all(id)).dictresult()
			res[0] = self._tosql(res[0])
			self.db.query(get_ins_history_domain_contact_map( histid, res[0] ))
			self.db.query(get_upd_domain_renew(id))
			self.db.query(get_upd_action(actid))
			self._end_xaction()
		except pg.DatabaseError, e:
			raise ExecutorError(e.__str__())
	def update_domain(self, fqdn):
		if self.debug: sys.stderr.write("\tupdate_domain\n")
		try:
			self._begin_xaction()
			actid = self._get_seq_nextval('action_id_seq')
			self.db.query(get_ins_action(actid, randint(1, self.maxregid), 503 ))
			res = self.db.query(get_sel_domainid(fqdn)).getresult()
			id = res[0][0]
			self.db.query(get_sel_regid( randint(1, self.maxregid) ))
			self.db.query(get_sel_domain_clid(id))
			self.db.query(get_sel_domain_status(id))
			histid = self._get_seq_nextval('history_id_seq')
			self.db.query(get_ins_history(histid, actid))
			res = self.db.query(get_sel_domain_all(id)).dictresult()
			res[0] = self._tosql(res[0])
			self.db.query(get_ins_history_domain( histid, res[0] ))
			res = self.db.query(get_sel_enumval_all(id)).dictresult()
			if len(res) > 0:
				res[0] = self._tosql(res[0])
				self.db.query(get_ins_history_enumval( histid, res[0] ))
			res = self.db.query(get_sel_domain_contact_map_all(id)).dictresult()
			res[0] = self._tosql(res[0])
			self.db.query(get_ins_history_domain_contact_map( histid, res[0] ))
			self.db.query(get_upd_domain(id, randint(1, self.maxregid) ))
			self.db.query(get_upd_action(actid))
			self._end_xaction()
		except pg.DatabaseError, e:
			raise ExecutorError(e.__str__())
	def update_nsset(self, handle):
		if self.debug: sys.stderr.write("\tupdate_nsset\n")
		try:
			self._begin_xaction()
			actid = self._get_seq_nextval('action_id_seq')
			self.db.query(get_ins_action(actid, randint(1, self.maxregid), 403 ))
			res = self.db.query(get_sel_nssetid(handle)).getresult()
			id = res[0][0]
			self.db.query(get_sel_regid( randint(1, self.maxregid) ))
			self.db.query(get_sel_nsset_clid(id))
			self.db.query(get_sel_nsset_status(id))
			histid = self._get_seq_nextval('history_id_seq')
			self.db.query(get_ins_history(histid, actid))
			res = self.db.query(get_sel_nsset_all(id)).dictresult()
			res[0] = self._tosql(res[0])
			self.db.query(get_ins_history_nsset( histid, res[0] ))
			res = self.db.query(get_sel_nsset_contact_map_all(id)).dictresult()
			res[0] = self._tosql(res[0])
			self.db.query(get_ins_history_nsset_contact_map( histid, res[0] ))
			self.db.query(get_upd_nsset( id, randint(1, self.maxregid) ))
			self.db.query(get_upd_action(actid))
			self._end_xaction()
		except pg.DatabaseError, e:
			raise ExecutorError(e.__str__())
	def update_contact(self, handle):
		if self.debug: sys.stderr.write("\tupdate_contact\n")
		try:
			self._begin_xaction()
			actid = self._get_seq_nextval('action_id_seq')
			self.db.query(get_ins_action(actid, randint(1, self.maxregid), 203 ))
			res = self.db.query(get_sel_contactid(handle)).getresult()
			id = res[0][0]
			self.db.query(get_sel_regid( randint(1, self.maxregid) ))
			self.db.query(get_sel_contact_status(id))
			histid = self._get_seq_nextval('history_id_seq')
			self.db.query(get_ins_history(histid, actid))
			res = self.db.query(get_sel_contact_all(id)).dictresult()
			res[0] = self._tosql(res[0])
			self.db.query(get_ins_history_contact( histid, res[0] ))
			self.db.query(get_upd_contact( id, randint(1, self.maxregid) ))
			self.db.query(get_upd_action(actid))
			self._end_xaction()
		except pg.DatabaseError, e:
			raise ExecutorError(e.__str__())


if __name__ == "__main__":
	print """
This module cannot be used directly. It has to be imported. See module's
documentation for more details ( help(executor) ).
	"""

