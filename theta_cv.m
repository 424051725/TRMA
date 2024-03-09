function theta = theta_cv(B,gamma,M,X)
theta = zeros(size(X,1),1);
for i = 1:1:size(X,1)
    if length(size(M))==4
        temp = times(B,M(:,:,:,i));
    elseif length(size(M))==3
        temp = times(B,M(:,:,i));
    else
        error('wrong dimension of M');
    end
    theta(i) = theta(i)+sum(temp(:))+X(i,:)*gamma(1:end-1);
end
end