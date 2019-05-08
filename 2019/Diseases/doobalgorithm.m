function [t,infected] = doobalgorithm(tbounds,beta,gamma,N,initInfected)

t(1) =tbounds(1);

tfinish = tbounds(2);
infected(1) = initInfected;
q = @(i) [beta*i*(N-i)/N,gamma*i];

while t(end) <tfinish && infected(end) > 0
    currentInfected = infected(end);
    curq = q(currentInfected);
    sumq = sum(curq);
    t = [t , exprnd(1/sumq)];
    if rand*sumq  < curq(1)
    infected = [infected,currentInfected+1];
    
    else
    infected = [infected,currentInfected-1];
        
    end
    
    
end