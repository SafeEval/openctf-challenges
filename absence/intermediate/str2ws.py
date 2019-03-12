#!/usr/bin/python

"""
File that turns a string into a "hello world" style Whitespace program.
Interpreter can be found at: http://ws2js.luilak.net/interpreter.html
"""

text = " lo0kin-fo]"
outfile = 'tester.ws'

def c2ws( c ):
  bs = bin(ord(c))
  return ('<%s>'%c) + bs.replace('0','S ').replace('1','T\t').replace('b','')

def addops( line ):
  return "S S S S %sL\n" % line

def addpostop(line):
  return '%sT\tL\n' % line

def addtrail(l):
  return l.append('S S L\nL\nL\n')

result = list()
for c in text:
  result.append(c2ws(c))

for i in range(0,len(result)):
  result[i] = addops(result[i])
  result[i] = addpostop(result[i])
addtrail(result)

f = open(outfile,'w')
for i in range(0,len(result)):
  f.write(result[i])
f.close()
