#!/usr/bin/env python
# vim:set ts=4 sw=4:

from myrand import *


def get_ins_action(id, regid, action):
	"""
Insert into action table. Used to begin action.
	"""
	return \
"INSERT INTO action (id, clientid, action, clienttrid) \
VALUES (%d, %d, %d, 'client_trid');" \
% (id, regid, action)


def get_upd_action(id):
	"""
Update into action table. Used to end action.
	"""
	return \
"UPDATE action SET response=1000 , enddate=now() , servertrid=%s WHERE id = %d;"\
% ( randstr(50, 120) , id )


def get_sel_domainid(fqdn):
	"""
Select domain's id from domain table. Used for EPP command check-domain.
	"""
	return "SELECT id FROM domain WHERE fqdn ILIKE '%s';" % fqdn


def get_sel_domain(fqdn):
	"""
Select domain record from domain table. Used for EPP command info-domain.
	"""
	return "SELECT * FROM domain WHERE fqdn ILIKE '%s';" % fqdn


def get_sel_regid(id):
	"""
Select registrator's regid from login table. Used in EPP command info-domain.
	"""
	return "SELECT registrarid FROM login WHERE id = %d;" % id

