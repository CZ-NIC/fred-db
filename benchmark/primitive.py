#!/usr/bin/env python
# vim: set ts=4 sw=4:
import sys, random

if __name__ == '__main__':
	quant = 10000
	for i in range(quant):
		id = random.randint(1, 20000)
		domain = "domain_%d.cz" % id
		sys.stdout.write("SELECT * FROM domain WHERE fqdn = '%s';\n" % domain)
		id = random.randint(1, 20000)
		contact = "contact_%d" % id
		sys.stdout.write("SELECT * FROM contact WHERE handle = '%s';\n"% contact)
		id = random.randint(1, 20000)
		nsset = "nsset_%d" % id
		sys.stdout.write("SELECT * FROM nsset WHERE handle = '%s';\n" % nsset)
	for i in range(quant):
		id = random.randint(1, 20000)
		sys.stdout.write("SELECT * FROM domain WHERE id = %d;\n" % id)
		id = random.randint(1, 20000)
		sys.stdout.write("SELECT * FROM contact WHERE id = %d;\n"% id)
		id = random.randint(1, 20000)
		sys.stdout.write("SELECT * FROM nsset WHERE id = %d;\n" % id)
	for i in range(quant):
		id = random.randint(1, 20000)
		sys.stdout.write("SELECT * FROM domain_contact_map WHERE domainid = %d;\n" % id)
		id = random.randint(1, 20000)
		sys.stdout.write("SELECT * FROM host WHERE nssetid = %d;\n"% id)
		id = random.randint(1, 20000)
		sys.stdout.write("SELECT * FROM nsset_contact_map WHERE nssetid = %d;\n" % id)
