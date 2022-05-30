#setup env variables
main=$(head -n 1 servers)
num=$(cat servers | wc -l)
tail=$(tail -n $num servers)
all=$(cat servers)
filename=$(echo $1 | rev | cut -c 3- | rev)

#copy over code to each of the worker nodes
for server in $tail ; do scp MPI-CODE/C-Code/$1 pi@${server}:/home/pi/Heterogeneous-MPI/MPI-CODE/C-Code ; done

#build on each worker node
for server in $all ; do ssh pi@${server} mpicc /home/pi/Heterogeneous-MPI/MPI-CODE/C-Code/$! -o /home/pi/Heterogeneous-MPI/MPI-CODE/Compiled/$!; done