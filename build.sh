#setup env variables
main=$(head -n 1 servers)
tail=$(tail -n $num servers)
all=$(cat servers)

KNOWN_ARCHS=""
for server in $all ; 
do 
    ARCH=$(ssh pi@${server} 'uname -a | rev | cut -d "' '" -f 2 | rev');
    if (echo "$KNOWN_ARCHS" | fgrep -qw $ARCH);
    
    then
        # Copy executiable with name of ARCH and rename to executable
        scp MPI-CODE/$ARCH pi@${server}:/home/pi/Heterogeneous-MPI/MPI-CODE/C-Code
        ssh pi@${server} 'mv Heterogeneous-MPI/MPI-Code/$ARCH Heterogeneous-MPI/MPI-Code/C-Code/$1'

    else

        #copy code
        scp MPI-Code/C-Code/$1 pi@${server}:/home/pi
        #build code
        ssh pi@${server} 'mpicc ${1} -o $ARCH'
        echo $ARCH

        #copy back to main node
        ssh -A pi@${server} 'scp $ARCH pi@${main}:/home/pi/Heterogeneous-MPI/MPI-CODE'

        #copy and rename locally to executable 
        ssh pi@${server} 'mv $ARCH Heterogeneous-MPI/MPI-CODE/C-Code'
        ssh pi@${server} 'mv $ARCH $1 | rev | cut -c 3- | rev'
       

        #clean up after build
        ssh pi@${server} 'rm Heterogeneous-MPI/MPI-CODE/C-Code'

        #ADD to list
        KNOWN_ARCHS=$KNOWN_ARCHS" "$ARCH; 
    fi
done

echo $KNOWN_ARCHS