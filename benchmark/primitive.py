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
