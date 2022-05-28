#setup env variables
main=$(head -n 1 servers)
num=$(cat servers | wc -l)
tail=$(tail -n $num servers)
all=$(cat servers)

#create requried directories on  each node
for server in $all ; do ssh pi@${server} 'mkdir -p ~/Heterogeneous-MPI/MPI-CODE/C-Code' ; done
for server in $all ; do ssh pi@${server} 'mkdir -p ~/Heterogeneous-MPI/MPI-CODE/Python-Code' ; done

#setup host file on eack worker node
for server in $tail ; do scp servers pi@${server}:/home/pi/Heterogeneous-MPI ; done