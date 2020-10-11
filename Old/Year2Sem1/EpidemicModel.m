N=100;
time=100;
Fullvector=[];
for B=5:10
    for Y=5:10
        for P1=[90,99]
            P2=N-P1;
            P=[P1,P2]; %population vector S,I where S is susceptible and I is infected
            Vect=projection(P,B,Y);
            Fullvector=[Fullvector, Vect];
            Surfacevector(B-4,Y-4)=Vect(end)
        end
    
    end
end

figure
plot(0:time,Fullvector);
xlabel('Time');
ylabel('Population distribution')

figure
plot(0:time,Fullvector(:,1:2:size(Fullvector)));
xlabel('Time');
ylabel('Susceptible')
figure
plot(0:time,Fullvector(:,2:2:size(Fullvector)));
xlabel('Time');
ylabel('Infected')



function Vect = projection(P,B,Y)
%using markov chains, finds the population infected with the disease and
%sceceptible at a given time
    N=100; %population
    dt=10^-3;
    time=100; %ending point
    Vect=P;
    for i=1:time

        I=P(2); %infected person from the previous time in the population matrix
        SI=B*I*(N-I)*dt/(N-1); %susceptible -> infected
        SS=1-SI; %susceptible -> susceptible
        IS=Y*I*dt; %infected -> susceptible
        II=1-IS; %infected -> infected
        trans=[SS,SI;IS,II]; %probability transition matrix
        P=P*trans;
        
        
        Vect=[Vect;P];
    end
    %disp(P)
    %plot(Vect)

end



