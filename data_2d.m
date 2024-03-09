b = 1-imread(['pic_64\',num2str(pic_name),'.png']);
b = double(b);
[p1,p2] = size(b);

%%
% True coefficients for regular (non-array) covariates
p0 = 5;
b0 = ones(p0,1);

%%
% Simulate covariates
n_test = n/5;
X_train = randn(n,p0);   % n-by-p0 regular design matrix
M_train = tensor(randn(p1,p2,n));  % p1-by-p2-by-n matrix variates
X_test = randn(n_test,p0);   % n-by-p0 regular design matrix
M_test = tensor(randn(p1,p2,n_test));  % p1-by-p2-by-n matrix variates
disp(size(M_train));

%%
% Simulate responses
mu_train = X_train*b0 + double(ttt(tensor(b), M_train, 1:2));
mu_test = X_test*b0 + double(ttt(tensor(b), M_test, 1:2));
switch link
    case 'binomial'
        X_train = X_train*0.1 ;  
        M_train = M_train*0.1;  
        X_test = X_test*0.1;   
        M_test = M_test*0.1;  
        y_train = binornd(1, exp(mu_train)./(1+exp(mu_train)));
        y_test = binornd(1, exp(mu_test)./(1+exp(mu_test)));
    case 'normal'
        y_train = mu_train + sigma*randn(n,1);
        y_test = mu_test +sigma*randn(n_test,1) ;
    case 'poisson'
        X_train = X_train*0.01 ;   
        M_train = M_train*0.01;  
        X_test = X_test*0.01;   
        M_test = M_test*0.01;  
        y_train = poissrnd(exp(mu_train),n,1);
        y_test = poissrnd(exp(mu_test),n_test,1);
end
