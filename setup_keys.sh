#!/bin/sh
#generate ssh keys
ssh-keygen -t rsa -N "" -f id_rsa

#copy keys over
for server in $@ ; do ssh-copy-id -f -i ~/id_rsa pi@${server} ; done
