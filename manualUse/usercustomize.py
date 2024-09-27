import sys
sys.ps1="\033[32m>>> " # Sometimes the SGR sequences need to be enclosed by \x01 and \x02, primarily for some older versions of Python

def delete(*args): # I'm sad that this doesn't work :/
	del args