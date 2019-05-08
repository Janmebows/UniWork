function res = vanderpolresidual(x,t,Mu)
%vanderpolresidual uses RK4 to integrate the van der pol system of ODEs
%given the initial conditions y_1(0) = 0.5 and y_2(0) = x
%Andrew Martin
%1704466
%23/10
%INPUTS
%x - the guessed value of the initial condition y_2(0)=x
%t - a row vector of the independent variable in ascending order
%Mu - the paramater \mu for the van der pol equation
%OUTPUTS
%res is the scalar value of y_1(T)-1

y= rk4(@(tt,yy) vanderpol(tt,yy,Mu),t,[0.5;x]);
n=length(t);
res = y(1,n) - 1;



end