#!/usr/bin/python
from binascii import unhexlify


hex_file = open('formatted_hex.txt', 'r')
hex_str = hex_file.read().strip().replace(' ', '')
hex_file.close()

rot13_str = unhexlify(hex_str)
source_str = ''
for c in rot13_str:
  source_str += chr(ord(c)-13)

code_file = open('program.cbl', 'w')
code_file.write(source_str)
code_file.close()
