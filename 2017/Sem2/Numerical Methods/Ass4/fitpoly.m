function [y,coefs,c] = fitpoly(x,xj,yj,n)
%function fitpoly performs polynomial regression of degree n to the data xj and yj 
%INPUTS
%----
%x - vector to calculate y values for the polynomial generated
%xj - column vector of known x values
%yj - column vector of known y values corresponding to the xj vector
%n - 
%OUTPUTS
%----
%y - column vector of the values corresponding to the inputted x vector
%coefs - the coeficients corresponding to the solutions to the LSE
%c - the condition number of the regression matrix
%
%----
%Andrew Martin
%a1704466
%9/10


i = 0:n;
A = xj.^(i);
coefs = A\yj;
c = cond(A);
y = x.^(i) * coefs ;
end
