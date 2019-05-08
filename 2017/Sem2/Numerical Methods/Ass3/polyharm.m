function f = polyharm(x,y,xj,yj,fj)
%Polyharm calculates a polyharmonic 2D spline
%INPUTS
%x - matrix of x values to interpolate the function over
%y - matrix of y values to interpolate the function over
%xj - x values corresponding to known function points
%yj - y values corresponding to known function points
%fj - known function data points f(xj,yj)
%---
%Outputs
%f - the resulting matrix f(x,y) 
%---
%Andrew Martin
%a1704466
%11/9/2017

N=length(fj);
[Xj, X] = meshgrid(xj,xj);
[Yj, Y] = meshgrid(yj,yj);
r2 = (X-Xj).^2 + (Y-Yj).^2; %log(sqrt (x)) = 0.5*log(x)
phi = 0.5*r2.*log(r2);
phi(isnan(phi))=0;
A = [zeros(3,3) [ones(N,1) xj yj]' ; [ones(N,1) xj yj phi]];
abc = A\[zeros(3,1); fj]; %vector of coefficients


[Xj, X]   = meshgrid(xj,x);
[Yj, Y]   = meshgrid(yj,y);
r2 = (X-Xj).^2 + (Y-Yj).^2;
phi = 0.5*r2.*log(r2);
phi(isnan(phi))=0;
f=zeros(size(x));
f(:) = abc(1) + abc(2)*x(:) + abc(3)*y(:) + phi*abc(4:N+3);