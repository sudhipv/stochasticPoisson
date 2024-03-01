#include <iostream>
#include <fstream>
using namespace std;



int fact(int n){

         return (n==0) || (n==1) ? 1 : n* fact(n-1);
    }




int main () {




// ############Change here the location of file and output PC########
    int ordIN = 2;
    int nRV = 3;
    int ordOUT = 3;
    int inPC = fact(ordIN + nRV)/(fact(ordIN) * fact(nRV));
    int outPC = fact(ordOUT + nRV)/(fact(ordOUT) * fact(nRV));;

    cout << "input PC is " << inPC << endl;
    cout << "output PC is " << outPC << endl;



// ########################################################

    char locc[100];

    sprintf(locc,"./kledata/cijk000%d000%d",ordOUT,nRV);

    cout << "Cijk file is " << locc << endl;

    ifstream file1(locc);

    int nCijk;
    double k2,k3,k4,k5;


    file1 >> nCijk;

    cout << "number of nonzero elements in cijk is " << nCijk << endl;

    double Cijk[nCijk][4];

    for (int i = 0; i < nCijk ; i++)
    {

    file1 >> k2 >> k3 >> k4 >> k5;

    //cout << k2 << k3 << k4 << k5 << endl;

    Cijk[i][0] = k2-1;
    Cijk[i][1] = k3-1;
    Cijk[i][2] = k4-1;
    Cijk[i][3] = k5;

    }

    //cout << "Cijk is " << Cijk << endl;

// ########################################################


    char loct[100];
    sprintf(loct,"./kledata/Tijkl/Tijkl_O%d_D%d",ordOUT,nRV);

    cout << "Tijkl file is " << loct << endl;

    ifstream file2(loct);

    int nTijkl;
    double h2,h3,h4,h5,h6;


    file2 >> nTijkl;

    cout << "number of elements in Tijkl is" << nTijkl << endl;

    double Tijkl[nTijkl][5];

    for (int i = 0; i < nTijkl ; i++)
    {

    file2 >> h2 >> h3 >> h4 >> h5 >> h6;

    //cout << k2 << k3 << k4 << k5 << endl;

    Tijkl[i][0] = h2-1;
    Tijkl[i][1] = h3-1;
    Tijkl[i][2] = h4-1;
    Tijkl[i][3] = h5-1;
    Tijkl[i][4] = h6;


    }


    ofstream myfile;
    myfile.open ("./macros/ssweakcomp.edp");


    myfile<< "macro UtransV(u,v)(u*v + ";
    for(int i = 0; i < outPC-1; ++i) {
        myfile << "u#" << i+1 << "*" << "v#"<< i+1;
        if(i != outPC-2)
            myfile << " + ";
        else
            myfile << ")//EOM";
    }
    myfile << endl;


    myfile<< "[Uprev,";
    for(int i = 0; i < outPC-1; ++i) {
        myfile << "Uprev" << i+1;
        if(i != outPC-2)
            myfile << ",";
        else
            myfile << "] ";
    }


    myfile<< "=[1,";
    for(int i = 0; i < outPC-1; ++i) {
        myfile << "0";
        if(i != outPC-2)
            myfile << ",";
        else
            myfile << "];";
    }


    myfile << endl;

    myfile<< "[b,";
    for(int i = 0; i < outPC-1; ++i) {
        myfile << "b" << i+1;
        if(i != outPC-2)
            myfile << ",";
        else
            myfile << "] ";
    }


    myfile<< "=[f,";
    for(int i = 0; i < outPC-1; ++i) {
        myfile << "0";
        if(i != outPC-2)
            myfile << ",";
        else
            myfile << "];";
    }


    myfile << endl;

    cout << "finished initial part of ssweakcomp.edp" << endl;





    myfile << endl << "macro coeffmultNL(u,v)(" << endl;


// ########################################################
   // Loop to construct weakform starts
// ########################################################




int checkL = 0;
int flagL = 0;

for (int k =0; k< outPC ; k++)
{


        for(int j =0; j< outPC ; j++)
        {

                for(int i=0; i< inPC ; i++)
                {


                        for(int id = 0; id < nCijk ; id ++ )
                        {

                            //cout << Cijk[id][0] << "  " << Cijk[id][0] << "  " << Cijk[id][2]  << endl;
                            if(Cijk[id][0] == i && Cijk[id][1] == j && Cijk[id][2] == k )
                            {

                                cout << " i " << i <<" j "<< j << " k " << k << endl;

                                if(flagL ==0)
                                {
                                    myfile << "(";
                                }
                                else
                                {
                                   myfile << "+";
                                }

                                myfile << Cijk[id][3] <<"*Cd["<< i << "]" ;

                                checkL = checkL + 1;
                                flagL = 1;
                                break;

                            }

                        }


                }


        if(flagL == 1)
        {
            myfile << " ) * " ;
            if(j == 0 )
            {
                myfile << " Grad(u)' * ";
            }
            else
            {
               myfile << " Grad(u#" << j << ")' * ";
            }

            if(k == 0 )
            {
                myfile << " Grad(v) ";
            }
            else
            {
               myfile << " Grad(v#" << k << ") ";
            }

            if(k == outPC-1 && j == outPC-1)
                 myfile << " +" << endl;
            else
                myfile << " + " << endl;

        }

        flagL = 0;

    }


}







// Nonlinear part starting



    int checkNL = 0;
    int flagNL = 0;

    for(int l =0; l< outPC ; l++)
    {
        for(int k =0; k< outPC ; k++)
        {


            for(int j =0; j< outPC ; j++)
            {


                for(int i=0; i< inPC ; i++)
                {


                        for (int id = 0; id < nTijkl ; id ++ )

                        {


                            if(Tijkl[id][0] == i && Tijkl[id][1] == j && Tijkl[id][2] == k && Tijkl[id][3] == l )
                            {

                                //cout << " id "<< id << " j " << j <<" k "<< k << " l " << l << endl;

                                cout << " i " << i << " j " << j <<" k "<< k << " l " << l << endl;

                                if(flagNL == 0)
                                {
                                    myfile << "(";
                                }
                                else
                                {
                                   myfile << "+";
                                }

                                //cout << Td(id,3) << " "<< j << " "<< k << " " << l  << endl;
                                if(j != 0)
                                {

                                    myfile << Tijkl[id][4] <<"*Cd["<< i << "]" << "* Uprev#"<<j;
                                    // Exact values
                                    //myfile << "ucnl"<<j<<"j"<<k<<"k"<<"["<<l<<"]" << "* Uprev#"<<j;

                                    // For checking the expression
                                    //fg << " Td("<< j <<","<< k <<","<< l << ")" << "* Uprev#"<<j;
                                }
                                else
                                {

                                    myfile << Tijkl[id][4] <<"*Cd["<< i << "]" << "* Uprev";
                                    // Exact values
                                    //myfile << "ucnl"<<j<<"j"<<k<<"k"<<"["<<l<<"]"  << "* Uprev ";

                                    // For checking the expression
                                    //fg << " Td("<< j <<","<< k <<","<< l << ")" << "* Uprev";
                                }

                                checkNL = checkNL + 1;
                                flagNL = 1;
                                break;

                            }

                        }


                } // I loop finished



            } // J loop finishes



        if(flagNL == 1)
        {

            myfile << " ) * " ;
            if(k == 0 )
            {
                myfile << " Grad(u)' * ";
            }
            else
            {
               myfile << " Grad(u#" << k << ")' * ";
            }

            if(l == 0 )
            {
                myfile << " Grad(v) ";
            }
            else
            {
               myfile << " Grad(v#" << l << ") ";
            }

            if(l == outPC-1 && k== outPC-1)
                 myfile << " ) //EOM";
            else
                myfile << " + ";


            myfile << endl;

        }

        flagNL = 0;

        } // K loop

    } // L loop finishes



    myfile << endl;

    cout << "Linear loop finished with number of elements" << checkL << endl;
    cout << "Non Linear loop finished with number of elements" << checkNL << endl;


    myfile.close();
    return 0;






}



















