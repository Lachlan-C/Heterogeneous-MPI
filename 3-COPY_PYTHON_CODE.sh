#setup env variables
main=$(head -n 1 servers)
tail=$(tail -n $num servers)
all=$(cat servers)

#copy over code to each of the worker nodes
for server in $tail ; do scp MPI-CODE/Python-Code pi@${server}:/home/pi/Heterogeneous-MPI/MPI-CODE/Python-Code ; done