hold on
SIodesolve;

beta = 2;
I0 = 1/100;
Tvec = [0:0.01:5];
Ivec = zeros(1,length(Tvec));
for ind=1:length(Tvec)
   Ivec(ind) = SIexplicit(beta,I0,Tvec(ind));
end
plot(Tvec,Ivec,'r-.')

function IatT = SIexplicit(beta,I0,T)

%Explicit solution to the SI model
%Inputs - beta = effective transmission rate; I0 = initial infectious
%proportion; T = time of evaluation.

IatT = I0/(I0 + (1-I0)*exp(-beta*T));
end

function [T,Y] = SIodesolve()

window = [0,5];
%set tolerances low
options = odeset('RelTol',1e-8,'AbsTol',1e-8);
%not sure why we use params rather than just beta for now...
params = [2];
[T,Y] = ode45(@SIode,window,1/100,options,params);

%plot garbage
plot(T,Y)
xlabel('Time, t')
ylabel('Proportion infected')
title('SI ODE')
end

function dy = SIode(t,y,params)
dy = params(1)*y*(1-y);
end

function T1 = SIDurationExp(beta,N,IO)
%
T1 = log((N-1)*(1-IO)/IO)/beta;
end

function T1 =  SIDurationode(beta,N,IO)

T1 = ode45()
end



