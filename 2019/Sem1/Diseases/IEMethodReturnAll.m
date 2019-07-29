function probMatrix = IEMethodReturnAll(Q,initState,t)
%An improved version of the Implicit Euler method
%returns a Matrix with columns corresponding to the times contained in
%time vector t
%if t is a scalar then it will simply return the probability vector at
%time t
%prob is the probability mass function for the number of infected people at
%time t
prob = initState;
N = length(Q);
probMatrix = sparse([],[],[],length(t),N,length(t)*N);

if t(1) ==0
    probMatrix(1,:)=prob;
end
tstep=0.02;
invertedPart =speye(N)-tstep*Q ;
%allocate the sparse matrix
for i=tstep:tstep:t(end)
    prob = prob/invertedPart ;
    %if there is a point within tstep of i 
    tIndex= find(abs(t-i) < tstep);
    if(tIndex)
        probMatrix(tIndex,:) = prob;
    end
end 
end
