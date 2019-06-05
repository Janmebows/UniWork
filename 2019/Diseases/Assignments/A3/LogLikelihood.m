function logLikelihood = LogLikelihood(params,data)
%Amended SIR finalsize code from Josh
%Amended by Andrew Martin
%calculates log likelihood for a given R0,alpha1,alpha2
logLikelihood = 0;
% R0      = params(1);
% alpha1  = params(2);
% alpha2  = params(3);
NVec = data(:,1);
%[R0, a1R0, a2R0]
paramsModified = [params(1),params(1)*params(2),params(1)*params(3)];
%yay matlab uses 1 based indexing
R0index = data(:,3)+1;


for iterator=1:length(data)
    N = NVec(iterator);
    relevantParam = paramsModified(R0index(iterator));
    q = zeros(N+1,1);
    q(2) = 1;
    %Proportions for each number of infection events
    %could vectorise, but this is more meaningful
    for Z2 = 0:N
        for Z1 = Z2+1:N-1
            %infection probability (jump prob)
            infProb = 1 / ( 1 + ((N-1)/(relevantParam*(N-Z1))));
            q(Z1+2) = q(Z1+2) + q(Z1+1)*infProb;
            q(Z1+1) = q(Z1+1)*(1-infProb);
        end
    end
    %sum of the log likelihoods (product of likelihoods)
    logLikelihood= logLikelihood + log(q(data(iterator,2)+1));
end


end

