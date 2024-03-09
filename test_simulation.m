function [beta_w,beta_rmse,y_kl] = test_simulation(w,b0,beta,gamma,M_train,X_train,y_train,M_test,X_test,y_test,beta0,link)

for i = 1:1:length(w)
    if i == 1
        beta_w = beta{i,1}*w(i);
        gamma_w = gamma{i,1}*w(i);
    else
        beta_w = beta_w+beta{i,1}*w(i);
        gamma_w = gamma_w+gamma{i,1}*w(i);
    end
end
theta_test_hat = X_test*gamma_w(1:end-1) + double(ttt(M_test,tensor(beta_w),1:length(size(M_test))-1));
theta_test = X_test*b0 + double(ttt(M_test,tensor(beta0),1:length(size(M_test))-1));
theta_train = X_train*b0 + double(ttt(M_train,tensor(beta0),1:length(size(M_train))-1));

switch link
    case 'normal'
        y_kl = sum(theta_test_hat.*theta_test_hat-theta_test.*theta_test)/2-y_test'*(theta_test_hat-theta_test);
        y_kl = y_kl/length(y_test);
    case 'binomial'
        y_kl = sum(log(1+exp(theta_test_hat))-log(1+exp(theta_test)))-y_test'*(theta_test_hat-theta_test);
        y_kl = y_kl/length(y_test);
    case 'poisson'
        mu = exp(theta_test);
        y_kl = sum(exp(theta_test_hat)-exp(theta_test))-y_test'*(theta_test_hat-theta_test);
        y_kl = y_kl/length(y_test);
    otherwise
        error('unknown distribution')
end

if size(beta0) <=0
    beta_rmse = 0;
else 
    temp = (double(beta_w)-(beta0)).^2;
    beta_rmse = sqrt(mean(temp(:)));
end
