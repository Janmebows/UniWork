function prob = IEMethod(Q,initState,t)
%this will do 1000 iterations
%prob is the probability mass function for the number of infected people at
%time t
prob = initState;
if t==0
return
end
N = length(Q);
tstep=0.02;
invertedPart =speye(N)-tstep*Q ;
for i=tstep:tstep:t
    prob = prob/invertedPart ;
end 
end
