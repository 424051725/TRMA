function kl=obj_func(w,theta,y,link)
theta_w = theta*w;

switch link 
case 'binomial'
    theta_w(theta_w>=100)=100;
    theta_w(theta_w<=-100)=-100;
    kl = sum(log(1+exp(theta_w)))-theta_w'*y;
case  'normal'
    kl = theta_w'*theta_w/2-theta_w'*y;
case 'poisson'
    kl = sum(exp(theta_w))-theta_w'*y;    
otherwise
    error('unknown distribution function');
end