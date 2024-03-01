#!/bin/bash
#SBATCH --account=def-asarkar
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=40
#SBATCH --time=00:30:00
#SBATCH --mem-per-cpu=3700M
#SBATCH --job-name=ff_mpi
#SBATCH --output=%x-%j.out
#SBATCH --mail-user=sudhipv@cmail.carleton.ca
#SBATCH --mail-type=ALL
#SBATCH --mail-type=FAIL

module load StdEnv/2023

#Already loaded by default

# module load intelmpi/2019.7.217

which mpiexec
which mpirun
#/home/sudhipv/packages/FreeFem-sources/src/mpi/ff-mpirun -np 40 poisson_petsc_ddm.edp -nw -log_view


mpirun -np 80 /home/sudhipv/ff_test/FreeFem-sources-4.13/src/mpi/FreeFem++-mpi filename.edp -m 200 -n 200 -nw -log_view

#-Dpartitioner=parmetis

#mpirun -n 80 hello_mpi
#diffusion-3d-minimal-direct.edp
exit
