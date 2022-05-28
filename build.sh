KNOWN_ARCHS=""
for server in $@ ; 
do 
    ARCH=$(ssh pi@${server} 'uname -a | rev | cut -d "' '" -f 2 | rev');
    if (echo "$KNOWN_ARCHS" | fgrep -qw $ARCH);
    
    then
        # Copy executiable with name of ARCH and rename to executable
        scp $ARCH pi@${server}:/home/pi/MPI
        ssh -A pi@${server} 'mv MPI/$ARCH MPI/executable'

    else

        #copy code
        scp code.c pi@${server}:/home/pi
        #build code
        ssh -A pi@${server} 'mpicc code.c -o $ARCH'
        echo $ARCH

        #copy back to main node $1
        ssh -A pi@${server} 'scp $ARCH pi@${1}:/home/pi'

        #copy and rename locally to executable
        ssh -A pi@${server} 'mv $ARCH executable'
        ssh -A pi@${server} 'mv executable MPI'

        #ADD to list
        KNOWN_ARCHS=$KNOWN_ARCHS" "$ARCH; 
    fi
done

echo $KNOWN_ARCHS