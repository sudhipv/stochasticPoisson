#!/bin/bash
#SBATCH --account=def-asarkar
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=40
#SBATCH --time=00:30:00
##SBATCH --mem-per-cpu=3700M
#SBATCH --job-name=LP_test2rv
#SBATCH --output=%x-%j.out
#SBATCH --mail-user=sudhipv@cmail.carleton.ca
#SBATCH --mail-type=ALL

module load CCEnv
module load StdEnv/2020


which mpiexec
which mpirun


# /home/a/asarkar/sudhipv/software/FreeFem-sources/src/nw/FreeFem++-nw generate.edp -nRV 5 -ordOUT 3


mpirun -np 4 /home/a/asarkar/sudhipv/software/FreeFem-sources/src/mpi/FreeFem++-mpi poisson_process2L.edp -m 50 -n 50 -nw -log_view


#cd ./c++

#g++ weakform.cpp

#./a.out

# mpirun -np 160 /home/a/asarkar/sudhipv/software/FreeFem-sources/src/mpi/FreeFem++-mpi poissonNL_process2L.edp -m 283 -n 283 -nw -log_view


# mpirun -np 400 /home/a/asarkar/sudhipv/software/FreeFem-sources/src/mpi/FreeFem++-mpi poissonNL_process2L.edp -m 447 -n 447 -nw -log_view

# mpirun -np 640 /home/a/asarkar/sudhipv/software/FreeFem-sources/src/mpi/FreeFem++-mpi poissonNL_process2L.edp -m 566 -n 566 -nw -log_view


# mpirun -np 800 /home/a/asarkar/sudhipv/software/FreeFem-sources/src/mpi/FreeFem++-mpi poissonNL_process2L.edp -m 633 -n 633 -nw -log_view


# echo "#############################################################################################################"
# echo "#############################################################################################################"
# echo "########     Finsihed Code with NL 10 Processors             #################################################"
# echo "#############################################################################################################"
# echo "#############################################################################################################"


########### weak scalability #####################


# 80 - 200 x 200

# 160 - 283 x 283

# 320 - 400 x 400

# 400 - 447 x 447


# 640 - 566 x 566

# 800 - 633 x 633







exit
