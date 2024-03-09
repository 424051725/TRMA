function [beta,gamma,AIC,BIC,DIC,y_hat,glmstats] = model(M,X,y,maxrank,link)
beta = cell(maxrank,1);
gamma = cell(maxrank,1);
y_hat = cell(maxrank,1);
glmstats = cell(maxrank,1);
p = size(M); 
[n,p0] = size(X);
d = ndims(M)-1; 
if length(size(M)) >= 4
    for i = 1:1:maxrank
        [~,beta{i,1},temp,dev_final] = kruskal_reg(X,M,y,i,link,'Replicates',5);
        y_hat{i,1} = temp{end}.yhat;
        gamma{i,1} = temp{end}.beta;
        glmstats{i,1} = temp{end};
        AIC(i,1) = dev_final + 2*(i*(sum(p(1:end-1))-d+1)+p0);
        BIC(i,1) = dev_final + log(n)*(i*(sum(p(1:end-1))-d+1)+p0);
        DIC(i,1) = DIC_func(y,y_hat{i,1},link);
    end
elseif length(size(M)) == 3
    for i = 1:1:maxrank
        [~,beta{i,1},temp,dev_final] = kruskal_reg(X,M,y,i,link,'Replicates',1);
        y_hat{i,1} = temp{end}.yhat;
        gamma{i,1} = temp{end}.beta;
        glmstats{i,1} = temp{end};
        AIC(i,1) = dev_final + 2*(i*(sum(p(1:end-1))-d+1)+p0);
        BIC(i,1) = dev_final + log(n)*(i*(sum(p(1:end-1))-d+1)+p0);
        DIC(i,1) = DIC_func(y,y_hat{i,1},link);
    end
else 
    error('wrong dimension')
end

end