#!/usr/bin/env python3

### Example Usage ###
# dev/lexcdiff.py apertium-eng-kaz.kaz.lexc ../apertium-kaz/apertium-kaz.kaz.lexc --lex Nouns

import sys, re
import argparse

parser = argparse.ArgumentParser(description='Find stems missing in a base lexc.  Useful for merging two lexc files.')

parser.add_argument('lexc1', type=argparse.FileType('r'),
	default=sys.stdin, help='the base file')
parser.add_argument('lexc2', type=argparse.FileType('r'),
	help='the file to look find extra stems in')
parser.add_argument('--lex', dest='lexicon', action='store', 
	help='which lexicon to extract')

args = parser.parse_args()


theLexicon = re.compile("\s*LEXICON\s*%s\s*" % args.lexicon)
anyLexicon = re.compile("\s*LEXICON.*")

def getLexicon(lexc):
	global theLexicon, anyLexicon
	capture = False
	output = ""

	for line in lexc:
		if capture and anyLexicon.match(line):
			capture = False
			break
		if capture:
			output += line
		if theLexicon.match(line):
			capture = True
	
	return output

#cleanStem = re.compile("^(.*):.*")
cleanStem = re.compile("^.*(?=\:.* ;)")

def getStem(line):
	stem = ""
	#print(line)
	matcher = cleanStem.search(line)
	if matcher:
		stem = matcher.group(0).strip()
		return stem
	else:
		return False

def getStems(lexc):
	stems = set()
	for line in lexc.split('\n'):
		stem = getStem(line)
		if stem: stems.add(stem)
	return stems


lexc1 = getLexicon(args.lexc1)
lexc2 = getLexicon(args.lexc2)

stems1 = getStems(lexc1)
stems2 = getStems(lexc2)

print(stems1 - stems2)

#print(lexc1)
