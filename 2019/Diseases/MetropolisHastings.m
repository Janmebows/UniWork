function prob = MetropolisHastings(distStruct,numIterations)
priorDist = distStruct.priorDist;
proposalDist = distStruct.proposalDist;
randDist = distStruct.randDist;
prob = zeros(numIterations,1);
prob(1) = randDist();

for i=2:numIterations
   probOfProb = normrnd(prob(i-1),stdDev);
   if probOfProb < 0 || probOfProb > 1
       prob(i) = prob(i-1);
   else
      %since we have uniform prior annd proposal is symmetric
      candidateProb = priorDist(probOfProb)* proposalDist(prob(i-1))/(priorDist(prob(i-1))*(proposalDist(probOfProb)));
      acceptProb= randDist();

        if acceptProb< candidateProb
            prob(i) = probOfProb;
        else
            prob(i) = prob(i-1);
        end
   end    
end