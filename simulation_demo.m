%% 2-D simulation
clear;
clc;

%% parameter setting
n = 1000;% sample size
sigma = 1;% noise level
fold = 5; % CV fold number
maxrank = 5; % max rank, the candidate models include rank-1 to rank-maxrank CP tensor regression model
link = 'normal'; %'normal', 'binomial' or 'poisson'
pic_name = 1; % 6 different images are provided

%% generate 2-D simulation data
run('data_2d.m');
% run('data_3d.m') 
%% calculate optimal model averaging weight
w_trma = trma(M_train, X_train, y_train, fold, maxrank, link);

%% calculate model of each rank
[beta,gamma,AIC,BIC,DIC,y_hat,glmstats] = model(M_train,X_train,y_train,maxrank,link);

%% calculate weight of other model averaging methods
[min_xic,where] = min(AIC);
AIC_new =AIC-min_xic ;
w_aic = zeros(1,maxrank);
w_aic(1,where) = 1;
[min_xic,where] = min(BIC);
BIC_new =BIC-min_xic ;
w_bic = zeros(1,maxrank);
w_bic(1,where) = 1;
w_saic = exp(-0.5*AIC_new)/sum(exp(-0.5*AIC_new));
w_sbic = exp(-0.5*BIC_new)/sum(exp(-0.5*BIC_new));
[min_xic,where] = min(DIC);
DIC_new =DIC-min_xic ;
w_bma = exp(-0.5*DIC_new)/sum(exp(-0.5*DIC_new));
w_max = zeros(1,maxrank);
w_max(maxrank) = 1;
w_equal = ones(1,maxrank)/maxrank;

%% calculate KL loss on the testing data
[beta_w{1,1},beta_rmse(1),y_kl(1)] = test_simulation(w_aic,b0,beta,gamma,M_train,X_train,y_train,M_test,X_test,y_test,b,link);
[beta_w{1,2},beta_rmse(2),y_kl(2)] = test_simulation(w_bic,b0,beta,gamma,M_train,X_train,y_train,M_test,X_test,y_test,b,link);
[beta_w{1,3},beta_rmse(3),y_kl(3)] = test_simulation(w_saic,b0,beta,gamma,M_train,X_train,y_train,M_test,X_test,y_test,b,link);
[beta_w{1,4},beta_rmse(4),y_kl(4)] = test_simulation(w_sbic,b0,beta,gamma,M_train,X_train,y_train,M_test,X_test,y_test,b,link);
[beta_w{1,5},beta_rmse(5),y_kl(5)] = test_simulation(w_max,b0,beta,gamma,M_train,X_train,y_train,M_test,X_test,y_test,b,link);
[beta_w{1,6},beta_rmse(6),y_kl(6)] = test_simulation(w_bma,b0,beta,gamma,M_train,X_train,y_train,M_test,X_test,y_test,b,link);
[beta_w{1,7},beta_rmse(7),y_kl(7)] = test_simulation(w_equal,b0,beta,gamma,M_train,X_train,y_train,M_test,X_test,y_test,b,link);
[beta_w{1,8},beta_rmse(8),y_kl(8)] = test_simulation(w_trma,b0,beta,gamma,M_train,X_train,y_train,M_test,X_test,y_test,b,link);

%% print recovered image and save results
if length(size(M_train))==3
model_name = {'AIC','BIC','SAIC','SBIC','MAX','BMA','EQMA','TRMA'};
r = num2cell([beta_rmse',y_kl']);
if ~exist(['2d\',num2str(n),'_e=',num2str(sigma)],'dir')
mkdir(['2d\',num2str(n),'_e=',num2str(sigma)]);
end
%xlswrite(['2d\',num2str(n),'_e=',num2str(sigma),'\',num2str(pic_name),'w_trma.xlsx'],w_trma);
xlswrite(['2d\',num2str(n),'_e=',num2str(sigma),'\',num2str(pic_name),'result.xlsx'],vertcat({'model','BETA_RMSE','Y_KL'},[model_name',r]));


for i = 1:1:length(model_name)    
    figure('visible','on');  
    imagesc(double(-beta_w{1,i}));
    colormap(gray);
    axis equal;
    axis tight;
    set(gca,'FontSize',25);
    saveas(gca, ['2d\',num2str(n),'_e=',num2str(sigma),'\',num2str(pic_name),'_',char(model_name(i))],'png')
end

elseif length(size(M_train))==4
model_name = {'AIC','BIC','SAIC','SBIC','MAX','BMA','EQMA','TRMA'};
r = num2cell([beta_rmse',y_kl']);
if ~exist(['3d\',num2str(n),'_',char(link),'_',num2str(pic_name)],'dir')
mkdir(['3d\',num2str(n),'_',char(link),'_',num2str(pic_name)]);
end
xlswrite(['3d\',num2str(n),'_',char(link),'_',num2str(pic_name),'\','result.xlsx'],vertcat({'model','BETA_RMSE','Y_RMSE','Y_TEST_RMSE','Y_KL'},[model_name',r]));
end




