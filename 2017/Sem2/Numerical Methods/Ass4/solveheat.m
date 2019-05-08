function [u,x,rnorm] = solveheat(alpha,func,L,u0,uL,N,tol,maxits)
%Function solveheat
%solves the heat PDE in one dimension in the form d^2u/dx^2 - alpha * u = - f(x)
%Andrew Martin
%8/10
%a1704466
%INPUTS
%----
%alpha - the value corresponding to alpha in the PDE
%func  - the function f(x) to equate to
%L     - length of the 'heated rod'
%u0    - initial condition corresponding to the LHS of the rod
%uL    - initial condition corresponding to the RHS of the rod
%N     - number of points to solve over
%tol   - solution tolerance - if the equation varies by less than this over
%        an iteration, break.
%OUTPUTS
%----
%u     - the solution to the PDE at x
%x     - the vector of N evenly distributed points between 0 and L
%rnorm - the value 

h = L/(N-1);
u=zeros(N,1);
u(1) = u0;
u(N) = uL;
j=1:N;
i=2:N-1;
x = (j-1)'*h;
fx = func(x);
r = zeros(N,1);
Dinv = 1/(2+alpha*h^2);
for iteration=1:maxits
    r(i)= u(i-1) - (2+alpha*h^2)*u(i) + u(i+1) + h^2 * fx(i);
    u(i) = u(i) + Dinv * r(i);
    rnorm = norm(r);
    if(rnorm<tol)
        disp(iteration);
        break;
    end
end

end
