function y = rk4(func,t,y0)
%rk4 solves y' = func(t,y) given y(0) = y_0.
%Andrew Martin
%1704466
%22/10
%INPUTS
%func is a function handle corresponding to f(t,y)
%t - a row vector of values in ascending order
%y0 - a column vector of initial conditions
%OUTPUTS
%y - a matrix containing the solution

y(:,1)=y0;
for k = 1 : length(t) -1 
h = t(k+1) - t(k);
F1 = h*func(t(k),y(:,k));
F2 = h* func(t(k)+0.5*h,y(:,k)+0.5*F1);
F3 = h*func(t(k)+0.5*h,y(:,k)+0.5*F2);
F4 = h*func(t(k+1),y(:,k)+F3);
y(:,k+1) = y(:,k) + 1/6 * (F1 + 2*(F2+F3)+F4);
end


end