function [p, px] = quadinterp(x,xj,fj)
%[p, px] = quadinterp(x,xj,fj)
%Function quadinterp uses piecewise Lagrange quadratic interpolation to
%find values for [xj,fj] over x. 
%INPUTS ----
%x  - row vector of points to calculate the interpolant on
%xj - row vector of x values corresponding to the known function values in fj, in
%ascending order
%fj - row vector containing the data values for xj values
%OUTPUTS ----
%p  - row vector of the value of the piecewise quadratic interpolant applied to x 
%px - row vector of the first derivative or p at each value x
%The outputs p and px will both have length x
%
%Andrew Martin
%a1704466
%14/08/2017
%matrix to compare X and XJ
[X,XJ] = meshgrid(x,xj);
%largest corresponding j for each point
j=sum(XJ<=X);
%j must be 1,3,5,7,...,N-2
%so moves j by 1 if it is an endpoint, and by 1 if it is even
j=j-(j==length(xj));
j=j+(j==0);
j=j-(mod(j,2)==0);


%application of the equations found in 1.1
p=fj(j).*(x-xj(j+1))./(xj(j)-xj(j+1)) .*(x-xj(j+2))./(xj(j)-xj(j+2));
p=p+fj(j+1).*(x-xj(j))./(xj(j+1)-xj(j)) .*(x-xj(j+2))./(xj(j+1)-xj(j+2));
p=p+fj(j+2).*(x-xj(j))./(xj(j+2)-xj(j)) .*(x-xj(j+1))./(xj(j+2)-xj(j+1));
%Derivative
px=fj(j).*(2*x-xj(j+1)-xj(j+2))./((xj(j)-xj(j+1)).*(xj(j)-xj(j+2)));
px=px+fj(j+1).*(2*x-xj(j)-xj(j+2))./((xj(j+1)-xj(j)).*(xj(j+1)-xj(j+2)));
px=px+fj(j+2).*(2*x-xj(j)-xj(j+1))./((xj(j+2)-xj(j)).*(xj(j+2)-xj(j+1)));



end