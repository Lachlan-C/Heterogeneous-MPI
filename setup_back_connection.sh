
for server in $@ ; do ssh pi@${server} ssh -o StrictHostKeyChecking=no pi@${1} 'uname -a'; done
echo established connections from server back to main