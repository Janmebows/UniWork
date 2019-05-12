
clear all
close all
%%Question 1
%part 4
%simulate the SIRS model
tbounds = [0,100];
beta = 15/13;
gamma = 1/13;
mu = 1/(60*365) ;
N = 100;
i0 = 10;

figure
hold on
for i=1:10
[t,IS] = SIRS_Sim(tbounds,beta,gamma,mu,N,i0);
plot(t,IS(:,1),'-r')
plot(t,IS(:,2),'-b')
end
hold off
axis([0,100,0,100])
xlabel("t")
ylabel("Infected, Susceptible")
%%Try, Catch so it doesn't get cranky since
%my file hierarchy is dodgy
%if the Assignments folder doesn't exist
try
    saveas(gcf,"Assignments/TopicBA2Q14.eps",'epsc')
catch
    saveas(gcf,"TopicBA2Q14.eps",'epsc')
end

%%
%%Question 1
%part 5
%calculate E(I(t) |I(t) >0)
%and the deterministic version
close all
clear all
tbounds = [0,100];
beta = 15/13;
gamma = 1/13;
mu = 1/(60*365) ;
N = 100;
i0 = 10;

total = 0;
%number of cases we want without rejection
numberWanted = 200;
maxFailCount = 10000;
failcount = 0;
AverageIS = zeros(tbounds(2),2);

equispacedTime = linspace(0,tbounds(2));
%We want to at least succeed numberWanted times
%and not fail too many times
totals = zeros(length(equispacedTime),1);
for i=1:numberWanted
[t,IS] = SIRS_Sim(tbounds,beta,gamma,mu,N,i0);
%bin the times into equispace
    for i=1:length(equispacedTime)
        timeSnapshot = find(t >= equispacedTime(i),1,'first');
        %if we get a value
        if timeSnapshot
            AverageIS(i,:) = AverageIS(i,:) + IS(timeSnapshot,:);
            totals(i) = totals(i)+1;
        end
    end
end


AverageIS = AverageIS./totals;
plot(equispacedTime,AverageIS(:,1),'--b')
hold on
params =[N,beta,gamma,mu];
%solve the deterministic model numerically
[t,deterministicIS] = ode45(@SIRS_DE_deterministic,[0,100],[i0,N-i0],[],params);

plot(t,deterministicIS(:,1),'-m')
hold off
title("Deterministic and Stochastic models ignoring extinction")
xlabel("t")
ylabel("I(t)")
legend("Average of non-extinct simulations","Deterministic approximation",'location','northeast')


%my file hierarchy is dodgy
try
    saveas(gcf,"Assignments/TopicBA2Q15.eps",'epsc')
catch
    saveas(gcf,"TopicBA2Q15.eps",'epsc')
end

%%
%%Question 2
%part 2
%show the pmf at times 0,1,5,50
%by solving the forward equation
close all
N = 15;
beta = 1.6;
gamma = 1;
InfectedAndSusceptible = [N-1,1];
[Q1,Q2] = SIRQ(N);
Q=beta*Q1+gamma*Q2;
%Cleaner, more memory efficient way to allocate the initial state since it
%only has one element
initState = sparse(1,2,1,1,length(Q),1);
probt = IEMethodReturnAll(Q,initState,[0,1,5,50]);


probt0NumInfected = InvertDaMap(probt(1,:),N);
probt1NumInfected = InvertDaMap(probt(2,:),N);
probt5NumInfected = InvertDaMap(probt(3,:),N);
probt50NumInfected = InvertDaMap(probt(4,:),N);
figure
title("Probability distributions of number infected at various times")
subplot(2,2,1)
bar(probt0NumInfected)
xlabel("Number infected")
ylabel("Probability")
title("t = 0")
subplot(2,2,2)
bar(probt1NumInfected)
xlabel("Number infected")
ylabel("Probability")
title("t = 1")
subplot(2,2,3)
bar(probt5NumInfected)
xlabel("Number infected")
ylabel("Probability")
title("t = 5")
subplot(2,2,4)
bar(probt50NumInfected)
xlabel("Number infected")
ylabel("Probability")
title("t = 50")
hold off
%my file hierarchy is dodgy
try
    saveas(gcf,"Assignments/TopicBA2Q22.eps",'epsc')
catch
    saveas(gcf,"TopicBA2Q22.eps",'epsc')
end


%%Question 2
%Part 3
%probability exactly 12 people are infected
Z = SIR_DA_mapping(N);
probt50 = probt(4,:);
probt50TotalInfected = zeros(size(probt50));
for i=1:N
    %i infection events is Z(:,1)==i
probt50TotalInfected(i)= sum(probt50(Z(:,1) ==i));
end
probt50TotalInfected(12)

%%
%%Question 2
%Part 4
%E(I(t)) using implicit euler
N=100;
beta = 1.6;
gamma = 1;
[Q1,Q2] = SIRQ(N);
Q=beta*Q1+gamma*Q2;
%Cleaner, more memory efficient way to allocate the initial state since it
%only has one element
initState = sparse(1,2,1,1,length(Q),1);
indexArray = 0:N;
expectationAtT = zeros(1,100);
t = linspace(0,100);

probt = IEMethodReturnAll(Q,initState, t);
invertedprobt = zeros(length(t),N+1);
for i=1:length(t)
    invertedprobt(i,:) = InvertDaMap(probt(i,:),N,true);
end
expectationAtT =  sum(invertedprobt.*indexArray,2);
params = [N,beta,gamma,0];
%We can just use the SIRS DE model and set mu =0
[deterministicT,deterministicIS] = ode45(@SIRS_DE_deterministic,[0,100],[1,N-1],[],params);
plot(t,expectationAtT)
hold on
plot(deterministicT,deterministicIS(:,1))
hold off
title("Expected number of infected against time")
xlabel("t")
ylabel("E(I(t))")
legend("Implicit Euler","Deterministic")
%my file hierarchy is -wait-for-it- dodgy
try
    saveas(gcf,"Assignments/TopicBA2Q24.eps",'epsc')
catch
    saveas(gcf,"TopicBA2Q24.eps",'epsc')
end

%%
%%Question 2 
%part 5
%probability of a minor outbreak
t = 100;
N = [50,100,500];
beta = 1.6;
gamma =1 ;
for i=1:3
    n = N(i);
    [Q1,Q2] = SIRQ(n);
    Q = beta*Q1 + gamma*Q2;
    initState = sparse(1,2,1,1,length(Q),1);
    probN = IEMethodReturnAll(Q,initState,50);
    Z = SIR_DA_mapping(n);
    %we want the total infection events
    %so we want to group probN by Z(:,1)
    for j=1:n
    probNumInfections(j) = sum(probN(Z(:,1)==j));
    end
    subplot(3,1,i)
    bar(probNumInfections,1)
    sol(i) = sum(probNumInfections(1:n/2));
    xlabel('Number of Infection events')
    ylabel('Probability')
end
sol

%my file hierarchy is dodgy
try
    saveas(gcf,"Assignments/TopicBA2Q25.eps",'epsc')
catch
    saveas(gcf,"TopicBA2Q25.eps",'epsc')
end
%%
%%Question 3
%Part 2
%solve q = -f\Qb
%params
N = 20;
beta = 0.6;
gamma = 1/3;
a = 2;
b = 5;
%get the DA mapping 
Z = SIR_DA_mapping(N);
[Q1,Q2] = SIRQ(N);
%full Q matrix
Q = beta*Q1 + gamma*Q2; 
%get the number of infected
indexer = Z(:,1) - Z(:,2);
f = a*indexer + b*ceil(indexer/4);
%all states where 0 infected accumulate 0 cost
f(indexer==0) = [];
Q(indexer==0,:)=[];
Q(:,indexer==0)=[];
q = Q\-f;
%There is dependence on the number of recovered
%so inverting it is wrong.
%q = InvertDaMap(q,N,false);


plot(1:20,q(1:20))
xlabel('Initial Number infected')
ylabel('Expected Cost')
title("Expected Cost")
%my file hierarchy is dodgy
try
    saveas(gcf,"Assignments/TopicBA2Q32.eps",'epsc')
catch
    saveas(gcf,"TopicBA2Q32.eps",'epsc')
end