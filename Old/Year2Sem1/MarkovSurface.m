Singleperson=[];
for B=5:10
    for Y=5:10
            P=[99,1]; %population vector S,I where S is susceptible and I is infected
            Vect=projection(P,B,Y);
            Singleperson=[Singleperson, Vect'];  
    end
end
figure
surf([Singleperson(3,:);Singleperson(2,:);Singleperson(1,:)]);

%Repeat for 'Plane load"
Planeload=[];
for B=5:10
    for Y=5:10
            P=[90,10]; %population vector S,I where S is susceptible and I is infected
            Vect=projection(P,B,Y);
            Planeload=[Planeload, Vect'];  
    end
end
figure
surf([Planeload(3,:);Planeload(2,:);Planeload(1,:)]);


Compare=Planeload==Singleperson


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
        
        if (P(1)<=0)
            P(1)=0;
        end 
        if (P(2)<=0)
            P(2)=0;
        end
        
        Vect=[P(1),B,Y];
    end
    %disp(P)
    %plot(Vect)

end