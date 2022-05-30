#setup env variables
main=$(head -n 1 servers)
num=$(cat servers | wc -l)
tail=$(tail -n $num servers)
all=$(cat servers)
code=$(ls MPI-CODE/C-Code)

#Auto Build every C code file

for file in $code ; do echo $file; echo $file | rev | cut -c 3- | rev ; ./build.sh $file; done
