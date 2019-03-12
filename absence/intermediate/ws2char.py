#!/usr/bin/python

"""
Decodes characters from the Whitespace programming language.
"""

ws = [
  'TSSTSSS',
  'SSTTSSTST',
  'SSTTSTTSS',
  'SSTTSTTSS',
  'SSTTSTTTT',
  'SSTSTTSS',
  'SSTSSSSS',
  'SSTTTSTTT',
  'SSTTSTTTT',
  'SSTTTSSTS',
  'SSTTSTTSS',
  'SSTTSSTSS',
  'SSTSSSST',
]

for i in ws:
  bs = i.replace('S','0').replace('T','1').strip()
  b = int(bs,2)
  print('%s \t--> %s \t--> %s' % (i, bs, chr(b)))

