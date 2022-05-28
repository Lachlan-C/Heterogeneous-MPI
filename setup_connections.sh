#!/bin/sh
# setup ssh keys to other servers

# connect for first time and valid the fingerprint
for server in $@ ; do ssh -o "StrictHostKeyChecking no" pi@${server} 'uname'; done
echo established connections to other servers