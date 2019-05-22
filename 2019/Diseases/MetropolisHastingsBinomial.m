numIterations = 10^4;
stdDev = 0.1;
prob = zeros(numIterations,1);

numTrials = 30;
numSuccesses = 7;
prob(1) = rand(1);

for i=2:numIterations
   probOfProb = normrnd(prob(i-1),stdDev);
   if probOfProb < 0 || probOfProb > 1
       prob(i) = prob(i-1);
   else
      %since we have uniform prior annd proposal is symmetric
      candidateProb = binopdf(numSuccesses,numTrials,probOfProb)/binopdf(numSuccesses,numTrials,prob(i-1));
      acceptProb= rand(1);
        if acceptProb< candidateProb
            prob(i) = probOfProb;
        else
            prob(i) = prob(i-1);
        end
   end    
end