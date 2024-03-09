function w_klmin = minkl(beta,gamma,M_test,X_test,y_test,link,maxrank)

for i = 1:1:maxrank
theta_test_hat(:,i) = X_test*gamma{i,1}(1:end-1) + double(ttt(M_test,tensor(beta{i,1}),1:length(size(M_test))-1));
end
w = ones(maxrank,1)/maxrank;
Aeq = ones(1,maxrank);
beq = 1;

[w_klmin,~] = fmincon(@(x) obj_func(x,theta_test_hat,y_test,link),w,[],[],Aeq,beq,zeros(1,maxrank),ones(1,maxrank));
