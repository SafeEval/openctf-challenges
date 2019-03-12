#!/usr/bin/python
from binascii import unhexlify


hex_file = open('formatted_hex.txt', 'r')
hex_str = hex_file.read().strip().replace(' ', '')
hex_file.close()

plain_str = unhexlify(hex_str)

code_file = open('middle.exe', 'w')
code_file.write(plain_str)
code_file.close()
