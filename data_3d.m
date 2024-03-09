% True 3D signal: 32-by-32-by-32 "two-cube"
b1 = 1-imread(['pic_64\',num2str(pic_name),'.png']);
b1 = array_resize(b1,[32,32]);
b = zeros(32,32,32);
for i = 8:1:17
    b(:,:,i) = b1;
end
[p1, p2, p3] = size(b);
% true coefficients for regular covariates
p0 = 1;
b0 = ones(p0,1);

%%
% Simulate covariates
n_test = n/5;
X_train = randn(n,p0);   % n-by-p regular design matrix
M_train = tensor(randn(p1,p2,p3,n));  % p1-by-p2-by-p3 3D variates
X_test = repmat(randn(n_test,p0),50,1);   % n-by-p regular design matrix
M_test = tensor(repmat(randn(p1,p2,p3,n_test),1,1,1,50));  % p1-by-p2-by-p3 3D variates
disp(size(M_train));

%%
% Simulate responses
mu_train = X_train*b0 + double(ttt(M_train,tensor(b),1:3));
mu_test = X_test*b0 + double(ttt(M_test,tensor(b),1:3));
switch link
    case 'binomial'
        X_train = X_train*0.1 ;   % n-by-p regular design matrix
        M_train = M_train*0.1;  % p1-by-p2-by-p3 3D variates
        X_test = X_test*0.1;   % n-by-p regular design matrix
        M_test = M_test*0.1;  % p1-by-p2-by-p3 3D variates
        mu_train = X_train*b0 + double(ttt(M_train,tensor(b),1:3));
        mu_test = X_test*b0 + double(ttt(M_test,tensor(b),1:3));
        y_train = binornd(1, exp(mu_train)./(1+exp(mu_train)));
        y_test = binornd(1, exp(mu_test)./(1+exp(mu_test)));
    case 'normal'
        y_train = mu_train + sigma*randn(n,1);
        y_test = mu_test +sigma*randn(1000,1) ;
    case 'poisson'
        X_train = X_train*0.01 ;   % n-by-p regular design matrix
        M_train = M_train*0.01;  % p1-by-p2-by-p3 3D variates
        X_test = X_test*0.01;   % n-by-p regular design matrix
        M_test = M_test*0.01;  % p1-by-p2-by-p3 3D variates
        mu_train = X_train*b0 + double(ttt(M_train,tensor(b),1:3));
        mu_test = X_test*b0 + double(ttt(M_test,tensor(b),1:3));
        y_train = poissrnd(exp(mu_train),n,1);
        y_test = poissrnd(exp(mu_test),1000,1);
end
