#!/bin/sh
#Update System
apt update && apt upgrade -y
echo "SERVER UP TO DATE"

#Install MPI
apt install -y libopenmpi-dev

#Install MPI4Python
apt install python3
apt install pip
# echo | pip install mpi4py