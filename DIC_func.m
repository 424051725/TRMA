function dic=DIC_func(y,yhat,link)

switch link 
case 'binomial'
    yhat(yhat < 0.01) = 0.01;
    yhat(yhat >= 0.99 & yhat <= 1) = 0.99;
    dic = -2 * sum(y .* log(yhat) + (1 - y) .* log(1 - yhat)); 
case  'normal'
    dic = sum((y - yhat).^2);
case 'poisson'
    y(y < 0.01) = 0.01;
    yhat(yhat < 0.01) = 0.01;
    dic = -2 * sum(y .* log(y ./ yhat) - (y - yhat));  
otherwise
    error('unknown distribution function');
end