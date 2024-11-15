
 ###################### Sudhi P
######################
###################### Ph.D Student ######################
######################Civil and Environmental Engineering######################
###################### Carleton University ######################
###################### 13/11/2022 ######################


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






