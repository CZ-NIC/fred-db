#!/usr/bin/env python
# vim:set ts=4 sw=4:
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

