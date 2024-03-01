
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

	These files are saved inside ./macros folder in the current directory

        1.2 Change the values of 

  			int nRV = 3;
    			int ordOUT = 3;
    			int inPC = 10;
    			int outPC = 20;

		inside "weakformNL.cpp" according to the "ssinit.edp" values.

        1.3 g++ "weakformNL.cpp"
        1.4 ./a.out

        output :

	The file "ssweakcom.edp" is generated inside ./macros


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






