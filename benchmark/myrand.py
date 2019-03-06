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
Tiny module gathering functions for generating random interegers,
booleans and strings.
"""

import random

def seed():
	"""
It's just a wrapper around the function of the same name from random
module and is provided for convinience reasons.
	"""
	return random.seed()


def randint(min, max):
	"""
It's just a wrapper around the function of the same name from random
module and is provided for convinience reasons.
	"""
	return random.randint(min, max)

def choice(list):
	"""
It's just a wrapper around the function of the same name from random
module and is provided for convinience reasons.
	"""
	return random.choice(list)

def randbool():
	"""
Generate random boolean (true of false) in form of 't' or 'f'.
	"""
	if random.randint(0, 1) == 1: return "'t'"
	else: return "'f'"

def randstr(min, max):
	"""
Generage random string of random length between min, max composed from
letters a-z. The resulting string is already quoted.
	"""
	letters = "abcdefghijklmnoprsuvwtxyz" # chars to choose from
	result = ""
	n = random.randint(min, max) # select random lenght of string
	for i in range(n):
		result += random.choice(letters)
	return "'" + result + "'" # quote string

