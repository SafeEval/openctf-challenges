#!/usr/bin/python

from binascii import hexlify

flag = "f1@g[This is not the code you're "

fa = ''
print len(flag)
for c in flag:
  byte1 = ord(c)
  byte = chr((byte1)^0x6c)
  hexbyte = '0x%s,' % hexlify(byte)
  fa += hexbyte

print fa
