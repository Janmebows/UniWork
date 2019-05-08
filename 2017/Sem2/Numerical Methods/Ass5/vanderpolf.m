function f = vanderpolf(t,y,Mu)
%function vanderpol solves the Van der Pol oscillator: 
%y'' - \mu(1-y^2)y' + y = 0
%Andrew Martin
%1704466
%22/10
%INPUTS
%t  - the vector of times to solve over
%y  - the column vector to solve over
%Mu - is the paramater \mu
%OUTPUTS
%f  - the column vector f(t,y) of solutions

%NOT FORCED
%f = [y(2);Mu*(1-y(1)^2)*y(2)-y(1)];

%FORCED
f = [y(2);Mu*(1-y(1)^2)*y(2)-y(1)+1.2*cos(2*pi*t/10)];



end