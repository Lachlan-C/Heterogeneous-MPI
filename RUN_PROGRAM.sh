#!/bin/sh

#using RPI OS 32-bit arm
#using Ubuntu 20.04 x86_64 
#assumes access to first server and that the username and password are the same for each

#count number of servers from servers file

num=$(cat servers | wc -l)
echo $((num+1)) servers to setup

username=pi

# Creates updated system and MPI user
#for server in $(cat servers) ; do ssh -o "StrictHostKeyChecking no" $username@${server} 'sudo bash -s' < ./update_system.sh ; done

#set up main machine to connect to others
main=$(head -n 1 servers)
tail=$(tail -n $num servers)
all=$(cat servers)

#setup main to connect to workers
./setup_connections.sh $tail

#setup main to connect to workers
./setup_keys.sh $tail

#create requried directories on  each node
for server in $(cat servers) ; do ssh $username@${server} 'mkdir -p ~/Heterogeneous-MPI/MPI-CODE' ; done

#setup host file on eack worker node
for server in $tail ; do scp servers $username@${server}:/home/$username/Heterogeneous-MPI ; done

#copy over code to each of the worker nodes
for server in $tail ; do scp MPI-CODE/* $username@${server}:/home/$username/Heterogeneous-MPI/MPI-CODE ; done

#get architecture
#ARCH=$(ssh pi@ip_address 'uname -a | rev | cut -d "' '" -f 2 | rev')

#build on remote computer with arch
#ssh -A $username@$main 'bash -s' < ./build.sh $all