# stochasticPoisson : based on the article "Multilevel Scalable Solvers for Stochastic Linear and Nonlinear Problems" (https://arxiv.org/abs/2310.14649)

Linear and Nonlinear Poisson problems with diffusion coefficient modelled as random process solved using multilevel domain decomposition-based methods.


# Folder Structure

1. poisson  : Codes and files related to stochastic linear Poisson problem

 1.1 kledata : Multiplication tensors required for running the stochastic code
 1.2 macro_0X_DX : pre generated macros to run the main code for different number random variables and order of expansion. can be copied over to macros folder while running.
 1.3 macros : current generated macros for the problem
 1.1 output : outputs with .vtu files

# Software needed
1. FreeFEM
2. Paraview
3. g++
4. MATLAB

# Instructions to run stochastic Poisson in user machine 


1. run the preprocessing step first, sequentially - single core.

        1.1 FreeFem++ generate.edp -nRV 2 -ordOUT 3

        output files are created inside ./macro/
                   ssinit.edp
		  ssolution.edp
		  ssweakform1.edp
		  ssweakform2.edp

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


# Instructions to run stochastic Poisson in cluster

1. Use the given batch script : runff_niagara. Note this requires FreeFEM to be installed in the cluster.

# Please refer to the article below and the repository if you use this code :
 https://arxiv.org/abs/2310.14649 (arXiv)
 
 






