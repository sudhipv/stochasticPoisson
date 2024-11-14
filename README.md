# stochasticPoisson : based on the article "Multilevel Scalable Solvers for Stochastic Linear and Nonlinear Problems" (https://arxiv.org/abs/2310.14649)

Linear and Nonlinear Poisson problems with diffusion coefficient modelled as random process solved using multilevel domain decomposition-based methods.


# Folder Structure

1. poisson/NLPoisson  : Codes and files related to stochastic linear Poisson problem
2. poisson/kledata : Multiplication tensors required for running the stochastic code
3. poisson/macro_0X_DX : pre generated macros to run the main code for different number random variables and order of expansion. can be copied over to macros folder while running.
4. poisson/macros : current generated macros for the problem
5. poisson/output : outputs with .vtu files
6. poisson/cluster : files required for running the code in cluster

# Software needed
1. FreeFEM : Installation instructions for FreeFEM in Digital Alliance of Canada clusters is given in ./cluster/install_FreeFEM.txt
2. Paraview
3. g++
4. MATLAB


# Instructions to run stochastic Poisson in cluster


1. Install the FreeFEM package as detailed in : ./cluster/install_FreeFEM.txt

2. Use the instructions inside ./cluster/instructions_parallel.txt for compiling the code interactively or by submitting a batch script.

3. A batch script is provided inside ./cluster/runff_beluga_withparam.sh. Note that, you need to change the path to your installation and filename accordingly.



# Instructions to run stochastic Poisson in user machine 


1. run the preprocessing step first, sequentially - single core.

        1.1 FreeFem++ generate.edp -nRV 2 -ordOUT 3

        output files are created inside ./macro/
                   ssinit.edp
		  ssolution.edp
		  ssweakform1.edp
		  ssweakform2.edp

          1.2 Change the values of random parameters inside "weakformL.cpp/weakformNL.cpp" according to the "ssinit.edp" values.

			int ordIN = 2;
  			int nRV = 3;
    			int ordOUT = 3;

		
        1.3 g++ weakformNL.cpp
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



# Please cite the article and the repository if you use this code

