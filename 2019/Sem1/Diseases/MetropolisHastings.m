function prob = MetropolisHastings(distStruct,numIterations)
%Most generic MetropolisHastings
%distStruct has fields
%-priorDist - the prior to pull from 
%-proposalDist - the proposed distribution

priorDist = distStruct.priorDist;
proposalDist = distStruct.proposalDist;
prob = zeros(numIterations,1);
prob(1) = randDist();

for i=2:numIterations
   probOfProb = normrnd(prob(i-1),stdDev);
   if probOfProb < 0 || probOfProb > 1
       prob(i) = prob(i-1);
   else
      candidateProb = priorDist(probOfProb)* proposalDist(prob(i-1))/(priorDist(prob(i-1))*(proposalDist(probOfProb)));
      acceptProb= rand();

        if acceptProb< candidateProb
            prob(i) = probOfProb;
        else
            prob(i) = prob(i-1);
        end
   end    
end