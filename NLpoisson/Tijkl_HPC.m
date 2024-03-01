%% T_ijkl - Fourth Order Tensor


clc
% Moments of PCE - Multiplication Tensor 
clearvars;

dim = 2;

in_ord = 2;

out_ord = 9;


% One dimensional polynomial order (maximum of input and output order)
if(in_ord > out_ord)
    ord = in_ord;
else
    ord = out_ord;
end

% Number of terms in input expansion (i index for MultiDimensional Moment )

n_pce_in = factorial(in_ord + dim)/(factorial(in_ord)*factorial(dim));

% Number of terms in output expansion (j,k and l index for MultiDimensional Moment)

n_pce_out = factorial(out_ord + dim)/(factorial(out_ord)*factorial(dim));


% point to UQTk directopry
uqtk_path = '/Users/sudhipv/documents/UQTk_v3.0.4/UQTk-install/bin';
cd(uqtk_path);
level = 2 * ord +1;

dim_one = 1;

[status,out] = system(['./generate_quad -d ', num2str(dim_one),' -p ', num2str(level), ' -g HG -x full']);

status;
out;
% load the quadrature points and weights
x =load('qdpts.dat'); % Need to scale each variable, qdpts = f(qdpts)
w =load('wghts.dat');

n_qd = size(x,1);

psi = zeros(n_qd,ord+1);
psi_N = zeros(n_qd,ord+1);

% 1-st order Hermite PC: it is always fixed to psi(1) = 1
psi(:,1) = 1;
psi_N(:,1) = 1;

if(ord > 1 || ord == 1 )
% 2nd order Hermite PC: it?s always fixed to psi(2) = x if (nord > 0)
psi(:,2) = x;
psi_N(:,2) = x;

% 3rd and more order Hermite PC?s are solved by recursive formula for i = 3 : nord+1
    for i = 3:ord+1
        psi(:,i) = x .* psi(:,i-1) - (i-2) * psi(:,i-2);
        psi_N(:,i) = psi(:,i)/sqrt(factorial(i-1));
    end
end

% 1D Moments of Hermite PC basis <psi_i psi_j psi_k>
moment_1D = zeros(ord + 1, ord + 1, ord + 1);
moment_1D_N = zeros(ord + 1, ord + 1, ord + 1);


for l = 1 : ord + 1
    for k = 1 : ord + 1
        for j = 1 : ord + 1
            for i = 1 : ord + 1

                      mult = 0;
                      mult_N = 0;

                      for m = 1:n_qd
                      mult = mult + psi(m,i)*psi(m,j)*psi(m,k)*psi(m,l)*w(m);
                      mult_N = mult_N + psi_N(m,i)*psi_N(m,j)*psi_N(m,k)*psi_N(m,l)*w(m);
                      end

                      moment_1D(i,j,k,l) = mult; 
                      moment_1D_N(i,j,k,l) = mult_N;%   *((1/(factorial(i-1))^(1/dim))); 

            end
        end
    end
end

moment_1D;
moment_1D_N;


% Creating Multi indices from UQTk

% % % point to UQTk directopry
uqtk_path = '/Users/sudhipv/documents/UQTk_v3.0.4/UQTk-install/bin';
cd(uqtk_path);

[status,out] = system(['./gen_mi -p', num2str(out_ord), ' -q', num2str(dim) , '-x TO']);

m_index_in = load('mindex.dat');


[status,out] = system(['./gen_mi -p', num2str(out_ord), ' -q', num2str(dim) , '-x TO']);

m_index_out = load('mindex.dat');


% Multi Dimensional Moments from 1D moments <Psi_i Psi_j Psi_k> = 
  
tol = 1e-6;

nZTijkl = [];
ijkl = [];
Tijkl = [];
indexi = 1;
    
    for i = 1:n_pce_in
        
        nZ = 0;
        
        for j = 1: n_pce_out
            
            for k = 1:n_pce_out
                
                for l = 1:n_pce_out
                
                product = 1;
                product_N = 1;
                norm_product = 1;
                
                    for d = 1: dim
                        
                       mi1 = m_index_in(i,d)+1;
                       mi2 = m_index_out(j,d)+1;
                       mi3 = m_index_out(k,d)+1;
                       mi4 = m_index_out(l,d)+1;
                      
                       
                       %% Each Basis normalized
                       moment_N = product_N * moment_1D_N(mi1,mi2,mi3,mi4);
                       product_N = moment_N;
                       

                    end
                    
                  
                   temp1 = product_N;
                    if (temp1 > tol)
                        nZ = nZ+1;
                        indexi;
                        ijkl = [ijkl, [i;j;k;l]];
                        Tijkl = [Tijkl, temp1];
                    end
                    indexi = indexi+1; 
                 
                end

            end
              
        end
        
        nZTijkl = [nZTijkl;nZ];
        
    end
   
 %%%%%%% Ajit's Code to replicate the same Cijk format for HPC
%  
% nZijkl = [];
% ijk3 = ijkl';
% ijk23 = ijk3(:,2:3);
% ijk23 = unique(ijk23,'rows');
% ijk2 = ijk23(:,1);
% for i=1:n_pce_out
%     nZZ = 0;
%     for j=1:length(ijk2)
%         if (i==ijk2(j))
%             nZZ = nZZ+1;
%         end
%     end
%     nZijkl = [nZijkl;nZZ];
% end
%  



str1 = strcat('_O',int2str(out_ord));

str2 = strcat('_D',int2str(dim));   

str3 = strcat('Tijkl',str1,str2);


 
% setup the output

cd ('/Users/sudhipv/documents/nl_ff/ff_codes/SSFEM/intrusive/dd_stochastic/process/NLpoisson/kledata/')


cd ('./Tijkl/')

fileID = fopen(str3,'w');
fprintf(fileID,'%d\n',size(ijkl,2));
for i = 1:size(ijkl,2)
   fprintf(fileID,'%d %d %d %d %17.8E\n',ijkl(:,i),Tijkl(i));
end
fclose(fileID);

 

str4 = strcat('multiIndex',str1,str2,'.dat');



dlmwrite(str4,m_index_out, '\t')


 

%%%%%%% code to write Tlkj summed up i indices only

% Tjkl = [];
% id = 1;
% nx =1;
% flag =0;
% 
% 
% for l = 1:n_pce_out
% 
% for k = 1:n_pce_out
%     
%     
%     for j = 1:n_pce_out
%         
%         flag =0;
%         
%         for i = 1:n_pce_in
%             
%             
%             for id = 1: size(ijkl,2)
%                 
%                 if( ijkl(1,id) == i && ijkl(2,id) == j && ijkl(3,id) == k && ijkl(4,id) == l)
% 
% 
%                         Tjkl(nx,1) = j-1;
%                         Tjkl(nx,2) = k-1;
%                         Tjkl(nx,3) = l-1;
% %                         Tjkl(nx,4) = Tijkl(id);
% 
%                         nx = nx +1;
% 
%                         flag = 1;
%                         
%                         break;
% 
%                 end
%             
%      
%             end
%             
%                 if(flag==1) 
%                     break;
%                 end
%             
%         end
%         
%         
%     end
%     
%     
% end
% 
% end

%%%%% Above code takes too long time and can be replaced  by matlab
%%%%% functions of unique and sort easily for large RV.



%%% load or take ijkl from the generated code.



% cd '/Users/sudhipv/documents/nl_ff/ff_codes/SSFEM/intrusive/dd_stochastic/process/NLpoisson/kledata/Tijkl';
% kk = load('Tijkl_O3_D9'); 
% 
% 
% 
% 
% [Td,ia,ic] = unique(kk(:,2:4),'rows','stable');
% Td = Td -1;
% Tdsorted = sortrows(Td,[3 2 1]);
% dlmwrite('Tijkl_O3_D9',Tdsorted, '\t')

% str5 = strcat('Td',str1,str2);
% dlmwrite(str5,Tjkl, '\t')


 
 
 
   
