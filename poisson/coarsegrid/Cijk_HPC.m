

clc
% Moments of PCE - Multiplication Tensor 
clearvars;

dim_i = 2;

dim_o = 2;

in_ord = 2;

out_ord = 9;


% One dimensional polynomial order (maximum of input and output order)
if(in_ord > out_ord)
    ord = in_ord;
else
    ord = out_ord;
end

% Number of terms in input expansion (k index for MultiDimensional Moment )

n_pce_in = factorial(in_ord + dim_i)/(factorial(in_ord)*factorial(dim_i));

% Number of terms in output expansion (i and j index for MultiDimensional Moment)

n_pce_out = factorial(out_ord + dim_o)/(factorial(out_ord)*factorial(dim_o));


% point to UQTk directopry
uqtk_path = '/Users/sudhipv/documents/UQTk_v3.0.4/UQTk-install/bin';
cd(uqtk_path);
level = 2 * ord +1;

dim_one = 1;

[status,out] = system(['./generate_quad -d ', num2str(dim_one),' -p ', num2str(level), ' -g HG -x full']);

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

for k = 1 : ord + 1
    for j = 1 : ord + 1
        for i = 1 : ord + 1
             
                  mult = 0;
                  mult_N = 0;
                  
                  for m = 1:n_qd
                  mult = mult + psi(m,i)*psi(m,j)*psi(m,k)*w(m);
                  mult_N = mult_N + psi_N(m,i)*psi_N(m,j)*psi_N(m,k)*w(m);
                  end
                  
                  moment_1D(i,j,k) = mult; 
                  moment_1D_N(i,j,k) = mult_N;%   *((1/(factorial(i-1))^(1/dim))); 
             
        end
    end
end

moment_1D;
moment_1D_N;


% Creating Multi indices from UQTk

% % % point to UQTk directopry
uqtk_path = '/Users/sudhipv/documents/UQTk_v3.0.4/UQTk-install/bin';
cd(uqtk_path);

[status,out] = system(['./gen_mi -p', num2str(out_ord), ' -q', num2str(dim_i) , '-x TO']);

m_index_in = load('mindex.dat');


[status,out] = system(['./gen_mi -p', num2str(out_ord), ' -q', num2str(dim_o) , '-x TO']);

m_index_out = load('mindex.dat');


% Multi Dimensional Moments from 1D moments <Psi_i Psi_j Psi_k> = 
  
tol = 1e-6;

nZcijk = [];
ijk = [];
cijk = [];
indexi = 1;
    
    for i = 1:n_pce_in
        
        nZ = 0;
        
        for j = 1: n_pce_out
            
            for k = 1:n_pce_out
                
                product = 1;
                product_N = 1;
                norm_product = 1;
                
                    for d = 1: dim_o
                        
                       mi1 = m_index_in(i,d)+1;
                       mi2 = m_index_out(j,d)+1;
                       mi3 = m_index_out(k,d)+1;
                      
                       
                       %% Each Basis normalized
                       moment_N = product_N * moment_1D_N(mi1,mi2,mi3);
                       product_N = moment_N;
                       
%                        if(d < 2 || d ==2)
                           norm_mik = m_index_out(k,d);
                           norm_moment = norm_product * factorial(norm_mik);
                           norm_product = norm_moment;
%                        end

                    end
                    
                  
                   temp1 = product_N;
                    if (temp1 > tol)
                        nZ = nZ+1;
                        indexi;
                        ijk = [ijk, [i;j;k]];
                        cijk = [cijk, temp1];
                    end
                    indexi = indexi+1; 
                 

            end
              
        end
        
        nZcijk = [nZcijk;nZ];
        
    end
   
 %%%%%%% Ajit's Code to replicate the same Cijk format for HPC
 
nZijk = [];
ijk3 = ijk';
ijk23 = ijk3(:,2:3);
ijk23 = unique(ijk23,'rows');
ijk2 = ijk23(:,1);
for i=1:n_pce_out
    nZZ = 0;
    for j=1:length(ijk2)
        if (i==ijk2(j))
            nZZ = nZZ+1;
        end
    end
    nZijk = [nZijk;nZZ];
end
 

str1 = strcat('000',int2str(out_ord));

str2 = strcat('000',int2str(dim_o));   

str3 = strcat('cijk',str1,str2);


cd ('/Users/sudhipv/documents/nl_ff/ff_codes/SSFEM/intrusive/dd_stochastic/process/poisson/kledata/')



fileID = fopen(str3,'w');
fprintf(fileID,'%d\n',size(ijk,2));
for i = 1:size(ijk,2)
   fprintf(fileID,'%d %d %d %17.8E\n',ijk(:,i),cijk(i));
end
fclose(fileID);

 

str4 = strcat('multiIndex',str1,str2,'.dat');
dlmwrite(str4,m_index_out, '\t')



%! cp nZijk.dat ../

% cijk = dlmread(str3);
% ijk_new = cijk(2:end,1:3);

% plot(ijk_new(:,1),ijk_new(:,2),'gs',...
%     'LineWidth',2,...
%     'MarkerSize',10,...
%     'MarkerEdgeColor','r',...
%     'MarkerFaceColor',[0.5,0.5,0.5])
% set(gca,'YDir','reverse')
% axis([0 n_pce_out+1 0 n_pce_out+1])
% axis square

 
 
 
   
