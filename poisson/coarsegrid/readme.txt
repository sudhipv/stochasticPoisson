
 ###################### Sudhi P ######################
###################### Ph.D Student ######################
###################### Civil and Environmental Engineering ######################
###################### Carleton University ######################
###################### 13/11/2022 ######################


### TESTED IN NARVAL ############

Currently Loaded Modules:
  1) CCconfig            6) ucx/1.14.1            11) flexiblas/3.3.1
  2) gentoo/2023   (S)   7) libfabric/1.18.0      12) blis/0.9.0
  3) gcccore/.12.3 (H)   8) pmix/4.2.4            13) StdEnv/2023     (S)
  4) gcc/12.3      (t)   9) ucc/1.2.0             14) mii/1.1.2
  5) hwloc/2.9.1        10) openmpi/4.1.5    (m)

  Where:
   S:  Module is Sticky, requires --force to unload or purge
   m:  MPI implementations / Implémentations MPI
   t:  Tools for development / Outils de développement
   H:             Hidden Module

#################################################################


The adapted coarse grid code is created to generate an approximate coarse space while constructing the multilevel preconditioner.


We can understand the formulation by following through the article "Multilevel Scalable Solvers for Stochastic Linear and Nonlinear Problems". This formulation is slightly different from the general Kronecker product formulation of stochatsic PDEs found in literature.
As explained in Section 2.1, the stochastic PDE is transformed into a system of deterministic PDEs which are assembled as a vector-valued PDE with the solution vector at each node having "N + 1" (total output terms in the PCE) elements corresponding to the PCE coefficients.

Thus in the implementations, you can see that each spatial node will have N+1 associated PCE coefficients.




1. Run the generate.edp file from inside poisson/coarsegrid folder

	/home/sudhipv/projects/def-asarkar/sudhipv/FreeFem-sources-4.13/src/mpi/ff-mpirun -np 1 generate.edp





After you run the generate.edp as you will generate many .edp input files inside macros folder. Inside 'ssinit.edp' you can see that the function space created is of size 20 for the nRV = 3 and ordOUT =3 which has 20 output PCE terms.
However, this function space utilizes all the stochastic terms and we may not require all these terms to construct the coarse preconditioner.


2. Run "weakformL.cpp" to generate the stochastic weak form equations for fine grid

Note: sometimes you might have to change the number of RV, output expansion values according to "ssinit.edp" or what you have prescribed inside the weakformL.cpp before running.

	g++ weakformL.cpp
	./a.out




Output :

input PC is 10
output PC is 20
Cijk file is ./kledata/cijk00030003
number of nonzero elements in cijk is 218
finished initial part of ssweakcomp.edp
 i 0 j 0 k 0
 i 1 j 1 k 0
 i 2 j 2 k 0
 i 3 j 3 k 0
 i 4 j 4 k 0
 i 5 j 5 k 0
 i 6 j 6 k 0
 i 7 j 7 k 0
 i 8 j 8 k 0
 i 9 j 9 k 0
 i 1 j 0 k 1
 i 0 j 1 k 1
 i 4 j 1 k 1
 i 5 j 2 k 1
 i 6 j 3 k 1
 i 1 j 4 k 1
 i 2 j 5 k 1
 i 3 j 6 k 1
 i 4 j 10 k 1
 i 5 j 11 k 1
 i 6 j 12 k 1
 i 7 j 13 k 1
 i 8 j 14 k 1
 i 9 j 15 k 1

.....

......


......


 i 5 j 14 k 17
 i 8 j 16 k 17
 i 0 j 17 k 17
 i 7 j 17 k 17
 i 9 j 17 k 17
 i 8 j 18 k 17
 i 9 j 2 k 18
 i 8 j 3 k 18
 i 3 j 8 k 18
 i 2 j 9 k 18
 i 6 j 14 k 18
 i 5 j 15 k 18
 i 8 j 17 k 18
 i 0 j 18 k 18
 i 7 j 18 k 18
 i 9 j 18 k 18
 i 8 j 19 k 18
 i 9 j 3 k 19
 i 3 j 9 k 19
 i 6 j 15 k 19
 i 8 j 18 k 19
 i 0 j 19 k 19
 i 9 j 19 k 19
Linear loop finished with number of elements218






3. Run "weakformL_coarse.cpp" to generate the stochastic weak form equations for coarse grid

	g++ weakformL_coarse.cpp
	./a.out

output :

input PC is 10
output PC is 4
Cijk file is ./kledata/cijk00020003
number of nonzero elements in cijk is 82
finished initial part of ssweakcomp_coarse.edp
 i 0 j 0 k 0
 i 1 j 1 k 0
 i 2 j 2 k 0
 i 3 j 3 k 0
 i 1 j 0 k 1
 i 0 j 1 k 1
 i 4 j 1 k 1
 i 5 j 2 k 1
 i 6 j 3 k 1
 i 2 j 0 k 2
 i 5 j 1 k 2
 i 0 j 2 k 2
 i 7 j 2 k 2
 i 8 j 3 k 2
 i 3 j 0 k 3
 i 6 j 1 k 3
 i 8 j 2 k 3
 i 0 j 3 k 3
 i 9 j 3 k 3
Linear loop finished with number of elements19



Here, we generated "ssinit_coarse.edp" inside ./macros/ which has a function space of 4, corresponding to a first order output expansion for 3 random variables.


Check the difference between the "ssweakcomp_coarse.edp" and "ssweakcomp.edp" inside macros folder. Also see, the difference between "ssweakform_coarse.edp" and "ssweakform1.edp".
The weakform is constructed only with 4 terms for coarse grid.




Sudhi has implemented this adaptive coarse in the code. However, the challenge is that it doesn't utilize the adapted coarse grid, but rather runs on the usual coarse grid with all terms.



4. Run the poisson code

	/home/sudhipv/projects/def-asarkar/sudhipv/FreeFem-sources-4.13/src/mpi/ff-mpirun -np 20 poisson_process2L_coarse.edp -ksp_view >> coarse_testout.txt


Check the "coarse_testout.txt" file which has output for a test run with the adapted coarse grid. The code works, but the solver didn't converge after 200 iterations.
The whole details of the solver and preconditioner used can also be seen at the bottom.



FOR COMPARISON, TRY RUNNING THE CODE WITHOUT THIS ADAPTED COARSE GRID INSIDE ./poisson folder REPEATING THE SAME STEPS ABOVE WITHOUT THE COARSE GRID STEPS.



/home/sudhipv/projects/def-asarkar/sudhipv/FreeFem-sources-4.13/src/mpi/ff-mpirun -np 20 poisson_process2LV2.edp -ksp_view >> poisson_testout.txt
















// ######################Instructions to run NL stochastic Poisson in user machine ##############################################


1. run the preprocessing step first, sequentially - single core.

        1.1 FreeFem++ generate_NLprocess.edp -nRV 2 -ordOUT 3

        output :
                    finished ssinit.edp
                    finished ssweakform.edp
                    finished ucoeffloop.edp
                    finished coeffinit.edp
                    finished coeffNLinit.edp
                    finished uNLcoeffloop.edp


            Note that for small number of RV up to 4 and order 3, the code finishes fast, however for large number of random variables and order use the c++ code given inside folder c++.
            One can change this particular code in to c++ to have just a single file to run preprocessing step too since nothing particular to FF is implemented in this.

        1.2 cd c++/
        1.3 g++ weakform.cpp
        1.4 ./a.out

        output :
            td has 730 elements
            finished initial part of ssweakcomp.edp
             j 0 k 0 l 0
             j 1 k 0 l 0
             j 2 k 0 l 0
             j 3 k 0 l 0
             j 4 k 0 l 0
             j 5 k 0 l 0
             j 0 k 1 l 0
             j 1 k 1 l 0
             j 2 k 1 l 0
             .........
             ........
             ........

        1.5 cd -



2. run the main code

    2.1 ff-mpirun -n 4 poissonNL_process2L.edp -m 50 -n 50


    output :


            Number of Vertices for coarse grid  2601
            Number of Vertices for fine mesh is  10201
            3
                -111111   2   3
            number of random variable  2
            order of input  2
            order of output  3
            Number of input PC   6
            Number of output PC  10
            Mean of Gaussian  0
            Sd of Gaussian  0.1
            Size of linear System  102010
            sindex is 25 2
                   1   1
                   1   2
                   2   1
                   2   2
                   1   3
                   3   1




3. .vtu files inside ./output folder.






