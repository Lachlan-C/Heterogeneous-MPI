#!/bin/sh

#using RPI OS 32-bit arm
#using Ubuntu 20.04 x86_64 
#assumes access to first server and that the username and password are the same for each

#count number of servers from servers file

num=$(cat servers | wc -l)
echo $((num+1)) servers to setup

username=pi

# Creates updated system and MPI user
#for server in $(cat servers) ; do ssh -o "StrictHostKeyChecking no" pi@${server} 'sudo bash -s' < ./update_system.sh ; done

#setup env variables
main=$(head -n 1 servers)
tail=$(tail -n $num servers)
all=$(cat servers)

#setup main to connect to workers
./setup_connections.sh $all

#setup main to connect to workers
./setup_keys.sh $all

#setup connections back to main node
./setup_back_connection.sh $all

echo manually run these commands
echo 'eval $(ssh-agent)'
echo 'ssh-add id_rsa' 

#get architecture
#ARCH=$(ssh pi@ip_address 'uname -a | rev | cut -d "' '" -f 2 | rev')

#build on remote computer with arch
#ssh -A pi@$main 'bash -s' < ./build.sh $all