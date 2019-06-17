function [vars,accRate,exitflag]= MetropolisHastingsPassLikelihood...
    (distStruct,startVars,numIterations)
%Most generic Log Likelihood MetropolisHastings
%%INPUTS
%distStruct is a struct containing: 
%  the function handles
%   -PriorPDF - the PDF of the prior to obtain likelihood
%   -ProposalDist - the proposed distribution to pull new values
%   -ProposalConstraints - the constraints that the params must abide
%   -LogLikelihoodFunc - the function to obtain the log likelihood
%startVars - the initial values for the vars to estimate
%numIterations - the number of times to iterate through the algorithm
%%OUTPUTS
%vars - the full matrix of variables accepted [nxd] where n is 
%       num iterations and d is the number of variables to predict
%accRate - the acceptance rate for the algorithm, a good value is 
%           in 0.2 - 0.27
%exitflag - An enum to log the outcome of the algorithm
%          -1, acceptance rate was low (try decreasing proposed variance)
%           0, good acceptance rate
%           1, acceptance rate was high (try increase proposed variance)
numAccepted = 0;
%extract all the functions
PriorPDF = distStruct.PriorPDF;
ProposalDist = distStruct.ProposalDist;
BreaksProposalConstraints = distStruct.ProposalConstraints;
LogLikelihoodFunc = distStruct.LogLikelihoodFunc;
vars = zeros(numIterations,length(startVars));
vars(1,:) = startVars;

for i=2:numIterations
    %get x'
   proposal = ProposalDist(vars(i-1,:));
   %if breaks constraints
   if BreaksProposalConstraints(proposal)
       vars(i) = vars(i-1);
   else
       %log(a) = ...
        candidateProbTop = LogLikelihoodFunc(proposal)...
            + log(PriorPDF(proposal(1)));
        candidateProbBottom = LogLikelihoodFunc(vars(i-1,:))...
            + log(PriorPDF(vars(i-1,1)));
        candidateProb = candidateProbTop - candidateProbBottom;
        acceptProb= log(rand);
        %should we accept this state?
        if acceptProb< candidateProb
            vars(i,:) = proposal;
            numAccepted = numAccepted +1;
        else
            vars(i,:) = vars(i-1,:);
        end
   end    
end
accRate = numAccepted/numIterations;

%Warn if the acceptance rate is suboptimal
%apparently 0.24 is roughly perfect
if  accRate < 0.2
    warning("Bad acceptance rate - too low, accRate = "+num2str(accRate));
    exitflag = -1;
elseif accRate >0.27
    exitflag = 1;
    warning("Bad acceptance rate - too high, accRate = "+num2str(accRate));
else
    exitflag = 0;
    
end

    
end