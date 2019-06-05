function [vars,accRate,exitflag]= MetropolisHastingsPassLikelihood(distStruct,startVars,data,numIterations)
%Most generic MetropolisHastings
%distStruct has fields
%-priorDist - the prior to pull from 
%-proposalDist - the proposed distribution

numAccepted = 0;
PriorPDF = distStruct.PriorPDF;
ProposalDist = distStruct.ProposalDist;
BreaksProposalConstraints = distStruct.ProposalConstraints;
LogLikelihoodFunc = distStruct.LogLikelihoodFunc;
vars = zeros(numIterations,length(startVars));
vars(1,:) = startVars;

for i=2:numIterations
   proposal = ProposalDist(vars(i-1,:));
   %if breaks constraints
   if BreaksProposalConstraints(proposal)
       vars(i) = vars(i-1);
   else
        candidateProbTop = LogLikelihoodFunc(proposal,data)  + log(PriorPDF(proposal(1)));
        candidateProbBottom = LogLikelihoodFunc(vars(i-1,:),data) + log(PriorPDF(vars(i-1,1)));
        candidateProb = candidateProbTop - candidateProbBottom;
        acceptProb= log(rand);

        if acceptProb< candidateProb
            vars(i,:) = proposal;
            numAccepted = numAccepted +1;
        else
            vars(i,:) = vars(i-1,:);
        end
   end    
end
accRate = numAccepted/numIterations;

if  accRate < 0.2
    warning("Bad acceptance rate - too low, accRate = "+num2str(accRate));
    exitflag = -1;
else if accRate >0.27
    exitflag = 1;
    warning("Bad acceptance rate - too high, accRate = "+num2str(accRate));
else
    exitflag = 0;
    end
end

    
end