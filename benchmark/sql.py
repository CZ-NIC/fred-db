#!/usr/bin/env python
# vim:set ts=4 sw=4:

from myrand import *


def get_ins_action(id, regid, action):
	"""
Insert into action table. Used to begin action.
	"""
	str = \
"INSERT INTO action (id, clientid, action, clienttrid) \
VALUES (%d, %d, %d, 'client_trid')" \
% (id, regid, action)
	print  str
	return str


def get_upd_action(id):
	"""
Update into action table. Used to end action.
	"""
	return \
"UPDATE action SET response=1000 , enddate=now() , servertrid=%s WHERE id = %d"\
% ( randstr(50, 120) , id )


def get_sel_zone(fqdn):
	"""
Select zone which the domain belongs to. Used for EPP command renew-domain.
	"""
	return "SELECT zone FROM domain WHERE fqdn ILIKE '%s'" % fqdn


def get_sel_zone_min(id):
	"""
Select minimal zone's period. Used for EPP command renew-domain.
	"""
	return "SELECT ex_period_min FROM zone WHERE id = %d" % id


def get_sel_domainid(fqdn):
	"""
Select domain's id from domain table. Used for EPP command check-domain.
	"""
	return "SELECT id FROM domain WHERE fqdn ILIKE '%s'" % fqdn


def get_sel_contactid(handle):
	"""
Select contact's id from contact table. Used for EPP command check-contact.
	"""
	return "SELECT id FROM contact WHERE handle ILIKE '%s'" % handle


def get_sel_nssetid(handle):
	"""
Select nsset's id from nsset table. Used for EPP command check-nsset.
	"""
	return "SELECT id FROM nsset WHERE handle ILIKE '%s'" % handle


def get_sel_domain(fqdn):
	"""
Select domain record from domain table. Used for EPP command info-domain.
	"""
	return "SELECT * FROM domain WHERE fqdn ILIKE '%s'" % fqdn


def get_sel_domain_all(id):
	"""
Select * from domain table. Used for saving domain in history.
	"""
	return "SELECT * FROM domain WHERE id = %d" % id


def get_sel_enumval_all(id):
	"""
Select * from enumval table. Used for saving enumval in history.
	"""
	return "SELECT * FROM enumval WHERE domainid = %d" % id


def get_sel_domain_contact_map_all(id):
	"""
Select * from domain_contact_map table. Used for saving mapping in history.
	"""
	return "SELECT * FROM domain_contact_map WHERE domainid = %d" % id


def get_sel_nsset_contact_map_all(id):
	"""
Select * from nsset_contact_map table. Used for saving mapping in history.
	"""
	return "SELECT * FROM nsset_contact_map WHERE nssetid = %d" % id


def get_sel_contact(handle):
	"""
Select contact record from contact table. Used for EPP command info-contact.
	"""
	return "SELECT * FROM contact WHERE handle ILIKE '%s'" % handle


def get_sel_contact_all(id):
	"""
Select * from contact table. Used for saving contact in history.
	"""
	return "SELECT * FROM contact WHERE id = %d" % id


def get_sel_nsset(handle):
	"""
Select nsset record from nsset table. Used for EPP command info-nsset.
	"""
	return "SELECT * FROM nsset WHERE handle ILIKE '%s'" % handle


def get_sel_nsset_all(id):
	"""
Select * from nsset table. Used for saving nsset in history.
	"""
	return "SELECT * FROM nsset WHERE id = %d" % id


def get_sel_domain_clid(id):
	"""
Select client ID from domain table. Used for EPP tranform commands.
	"""
	return "SELECT clID FROM domain WHERE id = %d" % id


def get_sel_nsset_clid(id):
	"""
Select client ID from nsset table. Used for EPP transform commands.
	"""
	return "SELECT clID FROM nsset WHERE id = %d" % id


def get_sel_domain_status(id):
	"""
Select status array from domain table. Used for EPP transfer commands.
	"""
	return "SELECT status FROM domain WHERE id = %d" % id


def get_sel_nsset_status(id):
	"""
Select status array from nsset table. Used for EPP transfer commands.
	"""
	return "SELECT status FROM nsset WHERE id = %d" % id


def get_sel_contact_status(id):
	"""
Select status array from contact table. Used for EPP transfer commands.
	"""
	return "SELECT status FROM contact WHERE id = %d" % id


def get_sel_domain_authinfo(id):
	"""
Select authinfo from domain table. Used for EPP command transfer-domain.
	"""
	return "SELECT authinfopw FROM domain WHERE id = %d" % id


def get_sel_nsset_authinfo(id):
	"""
Select authinfo from nsset table. Used for EPP command transfer-nsset.
	"""
	return "SELECT authinfopw FROM nsset WHERE id = %d" % id


def get_upd_domain_xfer(id, regid):
	"""
Update trdate, clID fields in domain table. Used for EPP command transfer-domain.
	"""
	return "UPDATE domain SET trdate = now(), clID = %d WHERE id = %d" \
			% (regid, id)


def get_upd_nsset_xfer(id, regid):
	"""
Update trdate, clID fields in nsset table. Used for EPP command transfer-nsset.
	"""
	return "UPDATE nsset SET trdate = now(), clID = %d WHERE id = %d" \
			% (regid, id)


def get_upd_domain(id, regid):
	"""
Update upid, update, authinfopw fields in domain table. Used for EPP command
update-domain.
	"""
	return "UPDATE domain SET upid = %d, update = now(), authinfopw = %s \
			WHERE id = %d" % (regid, randstr(3,25), id)


def get_upd_domain_renew(id):
	"""
Update exdate field in domain table. Used for EPP command renew-domain.
	"""
	return "UPDATE domain SET exdate = now() + '1 year' WHERE id = %d" % id


def get_ins_history(id, actid):
	"""
Insert row in history table. Used for every transform EPP command.
	"""
	return "INSERT INTO history (id, action) VALUES (%d, %d)" % (id, actid)


def get_ins_history_domain(id, rec):
	"""
Insert old domain record in history. Used for transform domain commands.
	"""
	return "INSERT INTO domain_history (historyid, zone, id, roid, fqdn, \
status, clid, crid, crdate, upid, exdate, trdate, authinfopw, update, \
registrant, nsset) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, \
%s, %s, %s, %s, %s, %s)" % (id, rec["zone"], rec["id"], rec["roid"], \
rec["fqdn"], rec["status"], rec["clid"], rec["crid"], rec["crdate"], \
rec["upid"], rec["exdate"], rec["trdate"], rec["authinfopw"], rec["update"], \
rec["registrant"], rec["nsset"])


def get_ins_history_enumval(id, rec):
	"""
Insert old enumval record in history. Used for transform domain commands.
	"""
	return "INSERT INTO enumval_history (historyid, domainid, exdate) \
VALUES (%s, %s, %s)" % (id, rec["domainid"], rec["exdate"])


def get_ins_history_domain_contact_map(id, rec):
	"""
Insert old domain_contact_map record in history. Used for transform domain cmds.
	"""
	return "INSERT INTO domain_contact_map_history (historyid, domainid, \
contactid) VALUES (%s, %s, %s)" % (id, rec["domainid"], rec["contactid"])


def get_ins_history_nsset(id, rec):
	"""
Insert old nsset record in history. Used for transform nsset commands.
	"""
	return "INSERT INTO nsset_history (historyid, id, roid, handle, \
status, clid, crid, crdate, upid, trdate, authinfopw, update) VALUES \
(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)" % (id, rec["id"], \
rec["roid"], rec["handle"], rec["status"], rec["clid"], rec["crid"], \
rec["crdate"], rec["upid"], rec["trdate"], rec["authinfopw"], rec["update"])


def get_ins_history_nsset_contact_map(id, rec):
	"""
Insert old nsset_contact_map record in history. Used for transform nsset cmds.
	"""
	return "INSERT INTO nsset_contact_map_history (historyid, nssetid, \
contactid) VALUES (%s, %s, %s)" % (id, rec["nssetid"], rec["contactid"])


def get_ins_history_contact(id, rec):
	"""
Insert old contact record in history. Used for transform contact commands.
	"""
	return "INSERT INTO contact_history (historyid, id, roid, handle, \
status, crid, crdate, upid, update, name, organization, street1, street2, \
street3, city, stateorprovince, postalcode, country, telephone, fax, email, \
disclosename, discloseorganization, discloseaddress, disclosetelephone, \
disclosefax, discloseemail, notifyemail, vat, ssn) VALUES \
(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, \
%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)" % (id, rec["id"], \
rec["roid"], rec["handle"], rec["status"], rec["crid"], rec["crdate"], \
rec["upid"], rec["update"], rec["name"], rec["organization"], rec["street1"], \
rec["street2"], rec["street3"], rec["city"], rec["stateorprovince"], \
rec["postalcode"], rec["country"], rec["telephone"], rec["fax"], rec["email"], \
rec["disclosename"], rec["discloseorganization"], rec["discloseaddress"], \
rec["disclosetelephone"], rec["disclosefax"], rec["discloseemail"], \
rec["notifyemail"], rec["vat"], rec["ssn"])


def get_upd_nsset(id, regid):
	"""
Update upid, update, authinfopw fields in domain table. Used for EPP command
update-domain.
	"""
	return "UPDATE nsset SET upid = %d, update = now(), authinfopw = %s \
			WHERE id = %d" % (regid, randstr(3,25), id)


def get_upd_contact(id, regid):
	"""
Update upid, update, name fields in contact table. Used for EPP command
update-contact.
	"""
	return "UPDATE contact SET upid = %d, update = now(), name = %s \
			WHERE id = %d" % (regid, randstr(3,30), id)


def get_sel_regid(id):
	"""
Select registrator's regid from login table. Used in EPP command info-domain.
	"""
	return "SELECT registrarid FROM login WHERE id = %d" % id

