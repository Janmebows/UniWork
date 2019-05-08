function [t,IS] = SIRS_Sim(tbounds,beta,gamma,mu,n,i0)
%%%SIRS_Sim simulates the SIRS model until tbounds(2) or until extinction
%%%IN
%%%tbounds is the vector of the simulation's [initial time, end time] 
%%%beta - infection rate
%%%gamma - recovery rate
%%%mu - replenishment rate (death of recovery & birth of susceptible)
%%%n - population size
%%%i0 - initial number of infected individuals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%OUT
%%%t - vector of the times corresponding to event occurrences
%%%IS - vector of the state space for each time 



%initial time
t(1) =tbounds(1);
%termination time
tfinish = tbounds(2);
IS = [i0,n-i0];
%transition rates as an vector anonymous function
%qis = @(in) [beta*in(1)*in(2)/(n-1) - gamma*in(1),...
%    -beta*in(1)*in(2)/(n-1), mu(n-in(1)-in(2))];
events = @(in) [beta*in(1)*in(2)/(n-1),...
    gamma*in(1), mu*(n-in(1)-in(2))];

while t(end) <tfinish && IS(end,1) > 0
    currentInfected = IS(end,:);
    currentEvents = events(currentInfected);
    sumq = sum(currentEvents);
    t = [t ; t(end)+ exprnd(1/sumq)];
    %if infection event
    if rand*sumq  < currentEvents(1)
        IS = [IS;IS(end,1)+1,IS(end,2)-1];
    %if recovery event
    elseif rand*sumq < currentEvents(1)+currentEvents(2)
        IS = [IS;IS(end,1)-1,IS(end,2)];
    %otherwise someone is reborn    
    else
        IS = [IS;IS(end,1),IS(end,2)+1];
    
    end
    
    
end



end