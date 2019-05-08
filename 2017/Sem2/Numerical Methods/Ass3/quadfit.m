function u = quadfit(t,tj,uj)
%Quadfit fits a quatratic to any data set
%INPUTS
%tj - column vector containing known t values
%uj - column vector containing known u corresponding to known t
%t - column vector of values wanting to fit the function to
%OUTPUTS
%u is a column vector with corresponding values for t
A= [ones(size(tj)),tj,tj.^2];
[q,r ] = qr(A);
R=r(1:3,:);
Qb=q(:,1:3)'*uj;
x=R\Qb;
%regression from stats
%x=inv(A'*A)*A'*uj
u=x(1)+x(2)*t+x(3)*t.^2;
