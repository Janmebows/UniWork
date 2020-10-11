B=10; %infection rate
Y=5; %recovery rate
N=100; %population
I=1; %initial infected population
S=N-I; %initial susceptible population
dt=10^-3;
endpoint=10000;
P=[S,I];
for i=1:endpoint
    if S<=0 || I<=0
        break
    end
    SI=B*I*(N-I)*dt/(N-1);%susceptible -> infected

    IS=Y*I*dt; %infected -> susceptible

    
    
    infect=rand; %infection check
    if infect>SI
        I=I+1;
        S=S-1;
    end
    if infect>IS
        S=S+1;
        I=I-1;
        
    end
    P(i,:)=[S,I];
    fprintf("Susceptible: %u, Infected: %u, \n",S,I);
    
    

end
t=1:length(P);
axis([0,length(P),0,inf])
plot(t,P);
