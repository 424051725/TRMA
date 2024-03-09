function w_hat = trma(M,X,y,fold,maxrank,link)
n=length(y);
n0=fix(n/fold);

if length(size(M))>=4    
    p1=size(M,1);
    p2=size(M,2);
    p3=size(M,3);
    theta = zeros(n,maxrank);
    for i = 1:1:maxrank
        for j = 1:1:fold
            y_j = y;
            y_j((j-1)*n0+1:min(j*n0,n)) = [];
            X_j = X;
            X_j((j-1)*n0+1:min(j*n0,n),:) = [];
            M_j = double(M);
            M_j(:,:,:,(j-1)*n0+1:min(j*n0,n)) = [];
            M_j = tensor(M_j);
            [~,beta_rk_j,glmstats_j] = kruskal_reg(X_j,M_j,y_j,i,link,'Replicates',5);
            gamma_j = glmstats_j{end}.beta;
            M_rest = M(:,:,:,(j-1)*n0+1:min(j*n0,n));
            X_rest = X((j-1)*n0+1:min(j*n0,n),:);
            theta((j-1)*n0+1:min(j*n0,n),i) = theta_cv(beta_rk_j,gamma_j ,M_rest, X_rest);
        end
    end
elseif length(size(M))==3
    theta = zeros(n,maxrank);
    for i = 1:1:maxrank
        for j = 1:1:fold
            y_j = y;
            y_j((j-1)*n0+1:min(j*n0,n)) = [];
            X_j = X;
            X_j((j-1)*n0+1:min(j*n0,n),:) = [];
            M_j = double(M);
            M_j(:,:,(j-1)*n0+1:min(j*n0,n)) = [];
            M_j = tensor(M_j);
            [~,beta_rk_j,glmstats_j] = kruskal_reg(X_j,M_j,y_j,i,link);
            gamma_j = glmstats_j{end}.beta;
            M_rest = M(:,:,(j-1)*n0+1:min(j*n0,n));
            X_rest = X((j-1)*n0+1:min(j*n0,n),:);
            theta((j-1)*n0+1:min(j*n0,n),i) = theta_cv(beta_rk_j,gamma_j ,M_rest, X_rest);
        end
    end
else
    error('wrong dimension of M');
end
w = ones(maxrank,1)/maxrank;
Aeq = ones(1,maxrank);
beq = 1;

[w_hat,~] = fmincon(@(x) obj_func(x,theta,y,link),w,[],[],Aeq,beq,zeros(1,maxrank),ones(1,maxrank));

end