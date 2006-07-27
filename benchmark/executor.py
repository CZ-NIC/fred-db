#!/usr/bin/env python
# vim:set ts=4 sw=4:
"""
This module simulates EPP commands by executing same types and sequences of
sql commands.

It creates a level of abstraction so that benchmark program
does not have to execute all the needed sql statements but can simply call
just EPP commands.
"""

import sys
from pgdb import *
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
	def __init__(self, dbtype, pars, debug = False):
		try:
			# connect to database
			self.conn = connect("%s:%s:%s:%s" % (pars["host"], pars["dbname"], \
					pars["user"], pars["passwd"]) )
		except Exception, e:
			sys.stderr.write("Could not connect to database: %s\n" % e)
			sys.exit(1)
		cur = self.conn.cursor()
		cur.execute("SELECT count(*) from registrar")
		res = cur.fetchone()
		cur.close()
		self.maxregid = res[0]
		self.debug = debug
		if self.debug: sys.stderr.write("Instantiating Executor object "\
				"(number of registrars: %d)\n" % self.maxregid)
	def __del__(self):
		self.conn.close()
	#
	# private members
	#
	def _commit(self):
		self.conn.commit()
	def _get_seq_nextval(self, name):
		cur = self.conn.cursor()
		cur.execute("SELECT nextval('%s')" % name)
		res = cur.fetchone()
		cur.close()
		return res[0]
	def _tosql(self, row, desc):
		res = []
		for col in row:
			if col == None:
				# convert None -> NULL
				res.append("NULL")
			elif type(col) == type(123):
				# convert 123 -> '123'
				res.append(col.__str__())
			else:
				# convert anything -> "'string'"
				res.append("'%s'" % col)
		dict = {}
		for i in range(len(desc)):
			dict[desc[i][0]] = res[i]
		return dict
	#
	# class interface
	#
	def getHandles(self):
		try:
			cur = self.conn.cursor()
			cur.execute("SELECT fqdn FROM domain")
			res = cur.fetchall()
			domains = [ item[0] for item in res ]
			cur.execute("SELECT handle FROM contact")
			res = cur.fetchall()
			contacts = [ item[0] for item in res ]
			cur.execute("SELECT handle FROM nsset")
			res = cur.fetchall()
			nssets = [ item[0] for item in res ]
			cur.close()
			return (domains, contacts, nssets)
		except DatabaseError, e:
			raise ExecutorError(e.__str__())
	def check_domain(self, fqdn):
		if self.debug: sys.stderr.write("\tcheck_domain\n")
		try:
			id = self._get_seq_nextval('action_id_seq')
			cur = self.conn.cursor()
			cur.execute(get_ins_action( id, randint(1, self.maxregid) , 500 ))
			cur.execute(get_sel_domainid(fqdn))
			cur.execute(get_upd_action(id))
			cur.close()
			self._commit()
		except DatabaseError, e:
			raise ExecutorError(e.__str__())
	def check_contact(self, handle):
		if self.debug: sys.stderr.write("\tcheck_contact\n")
		try:
			id = self._get_seq_nextval('action_id_seq')
			cur = self.conn.cursor()
			cur.execute(get_ins_action( id, randint(1, self.maxregid) , 500 ))
			cur.execute(get_sel_contactid(handle))
			cur.execute(get_upd_action(id))
			cur.close()
			self._commit()
		except DatabaseError, e:
			raise ExecutorError(e.__str__())
	def check_nsset(self, handle):
		if self.debug: sys.stderr.write("\tcheck_nsset\n")
		try:
			id = self._get_seq_nextval('action_id_seq')
			cur = self.conn.cursor()
			cur.execute(get_ins_action( id, randint(1, self.maxregid) , 500 ))
			cur.execute(get_sel_nssetid(handle))
			cur.execute(get_upd_action(id))
			cur.close()
			self._commit()
		except DatabaseError, e:
			raise ExecutorError(e.__str__())
	def info_domain(self, fqdn):
		if self.debug: sys.stderr.write("\tinfo_domain\n")
		try:
			id = self._get_seq_nextval('action_id_seq')
			cur = self.conn.cursor()
			cur.execute(get_ins_action( id, randint(1, self.maxregid) , 501 ))
			cur.execute(get_sel_regid( randint(1, self.maxregid) ))
			cur.execute(get_sel_domain(fqdn))
			cur.execute(get_upd_action(id))
			cur.close()
			self._commit()
		except DatabaseError, e:
			raise ExecutorError(e.__str__())
	def info_contact(self, handle):
		if self.debug: sys.stderr.write("\tinfo_contact\n")
		try:
			id = self._get_seq_nextval('action_id_seq')
			cur = self.conn.cursor()
			cur.execute(get_ins_action( id, randint(1, self.maxregid) , 501 ))
			cur.execute(get_sel_regid( randint(1, self.maxregid) ))
			cur.execute(get_sel_contact(handle))
			cur.execute(get_upd_action(id))
			cur.close()
			self._commit()
		except DatabaseError, e:
			raise ExecutorError(e.__str__())
	def info_nsset(self, handle):
		if self.debug: sys.stderr.write("\tinfo_nsset\n")
		try:
			id = self._get_seq_nextval('action_id_seq')
			cur = self.conn.cursor()
			cur.execute(get_ins_action( id, randint(1, self.maxregid) , 501 ))
			cur.execute(get_sel_regid( randint(1, self.maxregid) ))
			cur.execute(get_sel_nsset(handle))
			cur.execute(get_upd_action(id))
			cur.close()
			self._commit()
		except DatabaseError, e:
			raise ExecutorError(e.__str__())
	def transfer_domain(self, fqdn):
		if self.debug: sys.stderr.write("\ttransfer_domain\n")
		try:
			actid = self._get_seq_nextval('action_id_seq')
			cur = self.conn.cursor()
			cur.execute(get_ins_action(actid, randint(1, self.maxregid), 505 ))
			cur.execute(get_sel_domainid(fqdn))
			id = cur.fetchone()[0]
			cur.execute(get_sel_regid( randint(1, self.maxregid) ))
			cur.execute(get_sel_domain_clid(id))
			cur.execute(get_sel_domain_status(id))
			cur.execute(get_sel_domain_authinfo(id))
			histid = self._get_seq_nextval('history_id_seq')
			cur.execute(get_ins_history(histid, actid))
			cur.execute(get_sel_domain_all(id))
			res = self._tosql(cur.fetchone(), cur.description)
			cur.execute(get_ins_history_domain( histid, res ))
			cur.execute(get_sel_enumval_all(id))
			if cur.rowcount > 0:
				res = self._tosql(cur.fetchone(), cur.description)
				cur.execute(get_ins_history_enumval( histid, res ))
			cur.execute(get_sel_domain_contact_map_all(id))
			res = self._tosql(cur.fetchone(), cur.description)
			cur.execute(get_ins_history_domain_contact_map( histid, res ))
			cur.execute(get_upd_domain_xfer( id, randint(1, self.maxregid) ))
			cur.execute(get_upd_action(actid))
			cur.close()
			self._commit()
		except DatabaseError, e:
			raise ExecutorError(e.__str__())
	def transfer_nsset(self, handle):
		if self.debug: sys.stderr.write("\ttransfer_nsset\n")
		try:
			actid = self._get_seq_nextval('action_id_seq')
			cur = self.conn.cursor()
			cur.execute(get_ins_action(actid, randint(1, self.maxregid), 405 ))
			cur.execute(get_sel_nssetid(handle))
			id = cur.fetchone()[0]
			cur.execute(get_sel_regid( randint(1, self.maxregid) ))
			cur.execute(get_sel_nsset_clid(id))
			cur.execute(get_sel_nsset_status(id))
			cur.execute(get_sel_nsset_authinfo(id))
			histid = self._get_seq_nextval('history_id_seq')
			cur.execute(get_ins_history(histid, actid))
			cur.execute(get_sel_nsset_all(id))
			res = self._tosql(cur.fetchone(), cur.description)
			cur.execute(get_ins_history_nsset( histid, res ))
			cur.execute(get_upd_nsset_xfer( id, randint(1, self.maxregid) ))
			cur.execute(get_upd_action(actid))
			cur.close()
			self._commit()
		except DatabaseError, e:
			raise ExecutorError(e.__str__())
	def renew_domain(self, fqdn):
		if self.debug: sys.stderr.write("\trenew_domain\n")
		try:
			actid = self._get_seq_nextval('action_id_seq')
			cur = self.conn.cursor()
			cur.execute(get_ins_action(actid, randint(1, self.maxregid), 506 ))
			cur.execute(get_sel_domainid(fqdn))
			id = cur.fetchone()[0]
			cur.execute(get_sel_regid( randint(1, self.maxregid) ))
			cur.execute(get_sel_domain_clid(id))
			cur.execute(get_sel_zone(fqdn))
			zoneid = cur.fetchone()[0]
			cur.execute(get_sel_zone_min(zoneid))
			cur.execute(get_sel_domain_status(id))
			histid = self._get_seq_nextval('history_id_seq')
			cur.execute(get_ins_history(histid, actid))
			cur.execute(get_sel_domain_all(id))
			res = self._tosql(cur.fetchone(), cur.description)
			cur.execute(get_ins_history_domain( histid, res ))
			cur.execute(get_sel_enumval_all(id))
			if cur.rowcount > 0:
				res = self._tosql(cur.fetchone(), cur.description)
				cur.execute(get_ins_history_enumval( histid, res ))
			cur.execute(get_sel_domain_contact_map_all(id))
			res = self._tosql(cur.fetchone(), cur.description)
			cur.execute(get_ins_history_domain_contact_map( histid, res ))
			cur.execute(get_upd_domain_renew(id))
			cur.execute(get_upd_action(actid))
			cur.close()
			self._commit()
		except DatabaseError, e:
			raise ExecutorError(e.__str__())
	def update_domain(self, fqdn):
		if self.debug: sys.stderr.write("\tupdate_domain\n")
		try:
			cur = self.conn.cursor()
			actid = self._get_seq_nextval('action_id_seq')
			cur.execute(get_ins_action(actid, randint(1, self.maxregid), 503 ))
			cur.execute(get_sel_domainid(fqdn))
			id = cur.fetchone()[0]
			cur.execute(get_sel_regid( randint(1, self.maxregid) ))
			cur.execute(get_sel_domain_clid(id))
			cur.execute(get_sel_domain_status(id))
			histid = self._get_seq_nextval('history_id_seq')
			cur.execute(get_ins_history(histid, actid))
			cur.execute(get_sel_domain_all(id))
			res = self._tosql(cur.fetchone(), cur.description)
			cur.execute(get_ins_history_domain( histid, res ))
			cur.execute(get_sel_enumval_all(id))
			if cur.rowcount > 0:
				res = self._tosql(cur.fetchone(), cur.description)
				cur.execute(get_ins_history_enumval( histid, res ))
			cur.execute(get_sel_domain_contact_map_all(id))
			res = self._tosql(cur.fetchone(), cur.description)
			cur.execute(get_ins_history_domain_contact_map( histid, res ))
			cur.execute(get_upd_domain(id, randint(1, self.maxregid) ))
			cur.execute(get_upd_action(actid))
			cur.close()
			self._commit()
		except DatabaseError, e:
			raise ExecutorError(e.__str__())
	def update_nsset(self, handle):
		if self.debug: sys.stderr.write("\tupdate_nsset\n")
		try:
			actid = self._get_seq_nextval('action_id_seq')
			cur = self.conn.cursor()
			cur.execute(get_ins_action(actid, randint(1, self.maxregid), 403 ))
			cur.execute(get_sel_nssetid(handle))
			id = cur.fetchone()[0]
			cur.execute(get_sel_regid( randint(1, self.maxregid) ))
			cur.execute(get_sel_nsset_clid(id))
			cur.execute(get_sel_nsset_status(id))
			histid = self._get_seq_nextval('history_id_seq')
			cur.execute(get_ins_history(histid, actid))
			cur.execute(get_sel_nsset_all(id))
			res = self._tosql(cur.fetchone(), cur.description)
			cur.execute(get_ins_history_nsset( histid, res ))
			cur.execute(get_sel_nsset_contact_map_all(id))
			res = self._tosql(cur.fetchone(), cur.description)
			cur.execute(get_ins_history_nsset_contact_map( histid, res ))
			cur.execute(get_upd_nsset( id, randint(1, self.maxregid) ))
			cur.execute(get_upd_action(actid))
			cur.close()
			self._commit()
		except DatabaseError, e:
			raise ExecutorError(e.__str__())
	def update_contact(self, handle):
		if self.debug: sys.stderr.write("\tupdate_contact\n")
		try:
			actid = self._get_seq_nextval('action_id_seq')
			cur = self.conn.cursor()
			cur.execute(get_ins_action(actid, randint(1, self.maxregid), 203 ))
			cur.execute(get_sel_contactid(handle))
			id = cur.fetchone()[0]
			cur.execute(get_sel_regid( randint(1, self.maxregid) ))
			cur.execute(get_sel_contact_status(id))
			histid = self._get_seq_nextval('history_id_seq')
			cur.execute(get_ins_history(histid, actid))
			cur.execute(get_sel_contact_all(id))
			res = self._tosql(cur.fetchone(), cur.description)
			cur.execute(get_ins_history_contact( histid, res ))
			cur.execute(get_upd_contact( id, randint(1, self.maxregid) ))
			cur.execute(get_upd_action(actid))
			cur.close()
			self._commit()
		except DatabaseError, e:
			raise ExecutorError(e.__str__())


if __name__ == "__main__":
	print """
This module cannot be used directly. It has to be imported. See module's
documentation for more details ( help(executor) ).
	"""

