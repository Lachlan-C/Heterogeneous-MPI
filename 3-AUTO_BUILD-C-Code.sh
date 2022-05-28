#setup env variables
main=$(head -n 1 servers)
tail=$(tail -n $num servers)
all=$(cat servers)
code=$(ls MPI-CODE/C-Code)

Auto Build every C code file
for file in $code ; do ./build.sh $file; done
