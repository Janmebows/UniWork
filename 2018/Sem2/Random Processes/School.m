function [maxInfected,maxHitTime,minInfected,minHitTime,cost] = School(I, numsims, masks, antivirals)
%%School simulates and plots the school disease outbreak problem for fixed
%%infection and recovery rates, given a population of 200
%%%Inputs:
%I - number of infected individuals at time t=0
%TP - termination time 
%numsims - the number of times to repeat the simulation
%
%%Optional inputs:
%masks(default false) - boolean for whether face masks are to be used
%the masks increase cost by $0.50 per day, and reduce transmission by 25%
%antivirals(default false) - boolean for whether antivirals are to be used
%increase cost by $2 per infected per day, and increase recovery rate
%
%%%Outputs:
%maxInfected - the peak number of infected people for each simulation
%maxHitTime - time at which the peak was hit for each sim
%cost - cost over the period for each sim ($0 if masks false,antivirals false)
%minInfected - the minimum number of infected people AFTER the maximum is
%reached for each sim
%minHitTime - the time at which minInfected is hit for each sim
   
%%%Dealing with inputs

%%if masks and antivirals not specified
if nargin <4 && nargin~=0
   masks=false;
   antivirals = false;
%so that it does something if ran without inputs
elseif nargin==0
    warning("You did not put in any inputs! Defaults have been used.");
    I=randi([1,50]);
    fprintf("Selected I = %i\n",I)
    numsims=10;
    masks=false;
    antivirals = false;
end


beta = 1.6/3;
gamma = 1/3;

N = 200;
S = N - I;

TP=40;




%make sure inputs are acceptible
if (S <=0 || I<=0|| TP <=0 ||numsims <=0 )
    error("check your inputs - something is not correct");

end

%%Style sheet for the plot
figure('DefaultAxesFontSize',12);
set(0,'defaultlinelinewidth',1);
title('Realisations of stochastic model: Masks = '+string(masks) + ', Antivirals = ' +string(antivirals) +', and I = '+string(I))
xlabel('Time t');
ylabel('Number infectious at time t');
axis([0,TP,0,N])
hold


%masks reduce infection rate by 25%
if(masks)
beta = beta * 0.75;
end
%antivirals reduce infection period to 2/3rds of default
if(antivirals)
gamma = gamma * 3/2;
end

%Initialise all the output variables
cost=zeros(1,numsims);
maxInfected=zeros(1,numsims);
maxHitTime=zeros(1,numsims);
minInfected=zeros(1,numsims);
minHitTime=zeros(1,numsims);


%%%Solving the problem
%%Iterate through the number of simulations
for nsi = 1:numsims
    %initial state is based on inputs
    state = [S, I, N-S-I];
    time = 0;
    %%while there are infected people, and we are within the time interval
    while (state(end,2)>0 && time(end) < TP)
        %rates = [infection rate, recovery rate]
        rates = [beta * state(end,1) * state(end,2)/(N-1), gamma *state(end,2)];
        Crates = cumsum(rates);
        Srates = Crates(end);
        tstep = exprnd(1/Srates);
        time = [time, time(end) + tstep];
        Nurv = rand*Srates;
        if Nurv < Crates(1)
            state = [state; state(end,:) + [-1, 1, 0]];
        elseif Nurv < Crates(2)
            state = [state; state(end,:) + [0, -1, 1]];
        end

    end
    time = [time, TP];
    state = [state;state(end,:)];
    if(masks || antivirals)
        cost(nsi) = costfn(time,state,masks,antivirals);
    end
    
    [maxInfected(nsi),index] = max(state(:,2));
    maxHitTime(nsi) = time(index);
    [minInfected(nsi),index] = min(state(:,2));
    minHitTime(nsi) = time(index);
    
  
    
    
    
    plot(time,state(:,2),'-')
    drawnow
end

%all the logistic pieces of info

 plot(maxHitTime,maxInfected,'^k')
 plot(minHitTime,minInfected,'vk')


hold off


    %separating the cost calculation to keep things clean
    function cost = costfn(time,state,masks,antivirals)
        %remove the last time and state - we don't have to pay for these
        time(end)=[];
        state(end,:) = [];
        maskcost = 200*masks * 0.5 * ceil(time(end));
        %doing some lazy stuff to iterate through time
        i = 0;
        %initialising K for good reason
        K=find(time >=2*i,1,'first');
        antiviralsused = 0;
        while(K>0)
            %the number of antivirals for this day
            antiviralsused = antiviralsused + 2 * state(K,1);
            i=i+1;
            K=find(time >=2*i,1,'first');
        end
        antiviralcost = antivirals * antiviralsused;
        cost = maskcost + antiviralcost;
    end

end     