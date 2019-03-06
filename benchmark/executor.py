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
This module simulates EPP commands by executing same types and sequences of
sql commands.
"""

import sys
from myrand import *
from sql import *


class Executor:
	"""
This class creates a level of abstraction so that benchmark program
does not have to execute all the needed sql statements but can simply call
just EPP commands.
	"""
	def __init__(self, db, seq_hook, debug = False):
		self.conn = db
		self.seq_hook = seq_hook
		cur = self.conn.cursor()
		cur.execute("SELECT count(*) from registrar")
		res = cur.fetchone()
		cur.close()
		self.maxregid = res[0]
		self.debug = debug
		if self.debug: sys.stderr.write("Instantiating Executor object "\
				"(number of registrars: %d)\n" % self.maxregid)
	#
	# private members
	#
	def _get_seq_nextval(self, name):
		cur = self.conn.cursor()
		cur.execute(self.seq_hook(name))
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
			dict[desc[i][0].lower()] = res[i]
		return dict
	#
	# class interface
	#
	def getHandles(self):
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
	def check_domain(self, fqdn):
		if self.debug: sys.stderr.write("\tcheck_domain\n")
		id = self._get_seq_nextval('action_id_seq')
		cur = self.conn.cursor()
		cur.execute(get_ins_action( id, randint(1, self.maxregid) , 500 ))
		cur.execute(get_sel_domainid(fqdn))
		cur.execute(get_upd_action(id))
		cur.close()
		self.conn.commit()
	def check_contact(self, handle):
		id = self._get_seq_nextval('action_id_seq')
		cur = self.conn.cursor()
		cur.execute(get_ins_action( id, randint(1, self.maxregid) , 500 ))
		cur.execute(get_sel_contactid(handle))
		cur.execute(get_upd_action(id))
		cur.close()
		self.conn.commit()
	def check_nsset(self, handle):
		if self.debug: sys.stderr.write("\tcheck_nsset\n")
		id = self._get_seq_nextval('action_id_seq')
		cur = self.conn.cursor()
		cur.execute(get_ins_action( id, randint(1, self.maxregid) , 500 ))
		cur.execute(get_sel_nssetid(handle))
		cur.execute(get_upd_action(id))
		cur.close()
		self.conn.commit()
	def info_domain(self, fqdn):
		if self.debug: sys.stderr.write("\tinfo_domain\n")
		id = self._get_seq_nextval('action_id_seq')
		cur = self.conn.cursor()
		cur.execute(get_ins_action( id, randint(1, self.maxregid) , 501 ))
		cur.execute(get_sel_regid( randint(1, self.maxregid) ))
		cur.execute(get_sel_domain(fqdn))
		cur.execute(get_upd_action(id))
		cur.close()
		self.conn.commit()
	def info_contact(self, handle):
		if self.debug: sys.stderr.write("\tinfo_contact\n")
		id = self._get_seq_nextval('action_id_seq')
		cur = self.conn.cursor()
		cur.execute(get_ins_action( id, randint(1, self.maxregid) , 501 ))
		cur.execute(get_sel_regid( randint(1, self.maxregid) ))
		cur.execute(get_sel_contact(handle))
		cur.execute(get_upd_action(id))
		cur.close()
		self.conn.commit()
	def info_nsset(self, handle):
		if self.debug: sys.stderr.write("\tinfo_nsset\n")
		id = self._get_seq_nextval('action_id_seq')
		cur = self.conn.cursor()
		cur.execute(get_ins_action( id, randint(1, self.maxregid) , 501 ))
		cur.execute(get_sel_regid( randint(1, self.maxregid) ))
		cur.execute(get_sel_nsset(handle))
		cur.execute(get_upd_action(id))
		cur.close()
		self.conn.commit()
	def transfer_domain(self, fqdn):
		if self.debug: sys.stderr.write("\ttransfer_domain\n")
		actid = self._get_seq_nextval('action_id_seq')
		cur = self.conn.cursor()
		str = get_ins_action(actid, randint(1, self.maxregid), 505 )
		cur.execute(str)
		cur.execute(get_sel_domainid(fqdn))
		id = cur.fetchone()[0]
		cur.execute(get_sel_regid( randint(1, self.maxregid) ))
		cur.execute(get_sel_domain_clid(id))
		cur.execute(get_sel_domain_status(id))
		cur.execute(get_sel_domain_authinfo(id))
		histid = self._get_seq_nextval('history_id_seq')
		str = get_ins_history(histid, actid)
		cur.execute(str)
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
		self.conn.commit()
	def transfer_nsset(self, handle):
		if self.debug: sys.stderr.write("\ttransfer_nsset\n")
		actid = self._get_seq_nextval('action_id_seq')
		cur = self.conn.cursor()
		str = get_ins_action(actid, randint(1, self.maxregid), 505 )
		cur.execute(str)
		cur.execute(get_sel_nssetid(handle))
		id = cur.fetchone()[0]
		cur.execute(get_sel_regid( randint(1, self.maxregid) ))
		cur.execute(get_sel_nsset_clid(id))
		cur.execute(get_sel_nsset_status(id))
		cur.execute(get_sel_nsset_authinfo(id))
		histid = self._get_seq_nextval('history_id_seq')
		str = get_ins_history(histid, actid)
		cur.execute(str)
		cur.execute(get_sel_nsset_all(id))
		res = self._tosql(cur.fetchone(), cur.description)
		cur.execute(get_ins_history_nsset( histid, res ))
		cur.execute(get_upd_nsset_xfer( id, randint(1, self.maxregid) ))
		cur.execute(get_upd_action(actid))
		cur.close()
		self.conn.commit()
	def renew_domain(self, fqdn):
		if self.debug: sys.stderr.write("\trenew_domain\n")
		actid = self._get_seq_nextval('action_id_seq')
		cur = self.conn.cursor()
		str = get_ins_action(actid, randint(1, self.maxregid), 505 )
		cur.execute(str)
		cur.execute(get_sel_domainid(fqdn))
		id = cur.fetchone()[0]
		cur.execute(get_sel_regid( randint(1, self.maxregid) ))
		cur.execute(get_sel_domain_clid(id))
		cur.execute(get_sel_zone(fqdn))
		zoneid = cur.fetchone()[0]
		cur.execute(get_sel_zone_min(zoneid))
		cur.execute(get_sel_domain_status(id))
		histid = self._get_seq_nextval('history_id_seq')
		str = get_ins_history(histid, actid)
		cur.execute(str)
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
		self.conn.commit()
	def update_domain(self, fqdn):
		if self.debug: sys.stderr.write("\tupdate_domain\n")
		cur = self.conn.cursor()
		actid = self._get_seq_nextval('action_id_seq')
		str = get_ins_action(actid, randint(1, self.maxregid), 505 )
		cur.execute(str)
		cur.execute(get_sel_domainid(fqdn))
		id = cur.fetchone()[0]
		cur.execute(get_sel_regid( randint(1, self.maxregid) ))
		cur.execute(get_sel_domain_clid(id))
		cur.execute(get_sel_domain_status(id))
		histid = self._get_seq_nextval('history_id_seq')
		str = get_ins_history(histid, actid)
		cur.execute(str)
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
		self.conn.commit()
	def update_nsset(self, handle):
		if self.debug: sys.stderr.write("\tupdate_nsset\n")
		actid = self._get_seq_nextval('action_id_seq')
		cur = self.conn.cursor()
		str = get_ins_action(actid, randint(1, self.maxregid), 505 )
		cur.execute(str)
		cur.execute(get_sel_nssetid(handle))
		id = cur.fetchone()[0]
		cur.execute(get_sel_regid( randint(1, self.maxregid) ))
		cur.execute(get_sel_nsset_clid(id))
		cur.execute(get_sel_nsset_status(id))
		histid = self._get_seq_nextval('history_id_seq')
		str = get_ins_history(histid, actid)
		cur.execute(str)
		cur.execute(get_sel_nsset_all(id))
		res = self._tosql(cur.fetchone(), cur.description)
		cur.execute(get_ins_history_nsset( histid, res ))
		cur.execute(get_sel_nsset_contact_map_all(id))
		res = self._tosql(cur.fetchone(), cur.description)
		cur.execute(get_ins_history_nsset_contact_map( histid, res ))
		cur.execute(get_upd_nsset( id, randint(1, self.maxregid) ))
		cur.execute(get_upd_action(actid))
		cur.close()
		self.conn.commit()
	def update_contact(self, handle):
		if self.debug: sys.stderr.write("\tupdate_contact\n")
		actid = self._get_seq_nextval('action_id_seq')
		cur = self.conn.cursor()
		str = get_ins_action(actid, randint(1, self.maxregid), 505 )
		cur.execute(str)
		cur.execute(get_sel_contactid(handle))
		id = cur.fetchone()[0]
		cur.execute(get_sel_regid( randint(1, self.maxregid) ))
		cur.execute(get_sel_contact_status(id))
		histid = self._get_seq_nextval('history_id_seq')
		str = get_ins_history(histid, actid)
		cur.execute(str)
		cur.execute(get_sel_contact_all(id))
		res = self._tosql(cur.fetchone(), cur.description)
		cur.execute(get_ins_history_contact( histid, res ))
		cur.execute(get_upd_contact( id, randint(1, self.maxregid) ))
		cur.execute(get_upd_action(actid))
		cur.close()
		self.conn.commit()


if __name__ == "__main__":
	print """
This module cannot be used directly. It has to be imported. See module's
documentation for more details ( help(executor) ).
	"""

