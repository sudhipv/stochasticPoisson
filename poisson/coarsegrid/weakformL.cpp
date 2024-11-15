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





    myfile << endl << "macro coeffmult(u,v)(" << endl;


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
                 myfile << " ) //EOM" << endl;
            else
                myfile << " + " << endl;

        }

        flagL = 0;

    }


}



    myfile << endl;

    cout << "Linear loop finished with number of elements" << checkL << endl;


    myfile.close();
    return 0;






}



















