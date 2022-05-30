#setup env variables
main=$(head -n 1 servers)
num=$(cat servers | wc -l)
tail=$(tail -n $num servers)
all=$(cat servers)
codefile=$1
filename= $(echo $1 | rev | cut -c 3- | rev)

KNOWN_ARCHS=""
for server in $all ; 
do 
    ARCH=$(ssh pi@${server} 'uname -a | rev | cut -d "' '" -f 2 | rev');
    echo $ARCH
    echo $filename
    if (echo "$KNOWN_ARCHS" | fgrep -qw $ARCH);
    
    then
        echo "old node detected"    
        # Copy executiable with name of ARCH and rename to executable
        echo "copy over compiled code"
        scp MPI-CODE/$ARCH pi@${server}:/home/pi/Heterogeneous-MPI/MPI-CODE/Compiled
        echo "rename compile"
        ssh pi@${server} mv /home/pi/Heterogeneous-MPI/MPI-CODE/Compiled/$ARCH /home/pi/Heterogeneous-MPI/MPI-CODE/Compiled/$filename

    else
        echo "new node arch detected"
        #copy code
        echo "copy code to target machine"
        scp MPI-CODE/C-Code/$codefile pi@${server}:/home/pi/Heterogeneous-MPI/MPI-CODE/C-Code

        
        #build code
        echo "build code on new node"
        ssh pi@${server} "mpicc /home/pi/Heterogeneous-MPI/MPI-CODE/C-Code/$codefile -o /home/pi/Heterogeneous-MPI/MPI-CODE/Compiled/$ARCH"
        
        #copy back to main node
        echo "copy code back to main node"
        eval $(ssh-agent)
        ssh-add id_rsa
        ssh -A pi@${server} scp /home/pi/Heterogeneous-MPI/MPI-CODE/Compiled/$ARCH pi@${main}:/home/pi/Heterogeneous-MPI/MPI-CODE

        #copy and rename locally to executable
        #echo "Move compiled to correct place"
        #ssh pi@${server} mv /home/pi/Heterogeneous-MPI/MPI-CODE/Compiled/$ARCH /home/pi/Heterogeneous-MPI/MPI-CODE/Compiled/
        echo "rename compile from $ARCH to $filename"
        ssh pi@${server} mv /home/pi/Heterogeneous-MPI/MPI-CODE/Compiled/$ARCH /home/pi/Heterogeneous-MPI/MPI-CODE/Compiled/$filename

        #ADD to list
        KNOWN_ARCHS=$KNOWN_ARCHS" "$ARCH; 
    fi
done

echo $KNOWN_ARCHS