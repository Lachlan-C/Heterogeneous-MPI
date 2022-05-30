
for server in $@ ; do ssh -A "StrictHostKeyChecking no" pi@${server} ssh "StrictHostKeyChecking no" pi@${1}; done
echo established connections from server back to main