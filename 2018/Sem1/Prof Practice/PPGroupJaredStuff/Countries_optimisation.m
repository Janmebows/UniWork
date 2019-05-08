%Constraint matrix
M=[400 500 520; 
    50 70 40; 
    70 80 150; 
    30 40 50; 
    1 1 1]; %A matrix
%w matrices are amount of resources allowed
wAus=[500000;50000;100000;50000;1000]; %b array for Aus
wBan = [500000;60000;80000;40000;1500]; %b array for Ban
wCan_1=[600000 ; 50000 ; 120000 ; 60000 ;  800]; %Before 2021: b array for Can
wCan_2=[600000 ; 50000 ; 120000 ; 60000 ; 1100]; %2021 and After: b array for Can

%Profit matrices 
%These were pre-calculated on excel
cAus=[5356; 6010; 8116]; %Profit array for Aus
cBan = [6262; 8690; 10264]; %Profit array for Ban
cCan_NoPD  = [4943.25 ; 5774.25 ; 7697.25]; %No Paint Deal: Profit array for Can
cCan_YesPD = [5288.25 ; 6234.25 ; 8272.25]; %Yes Paint Deal: Profit array for Can
%OPEX received in the handouts
OPEX_Aus = 1000000;
OPEX_Ban = 500000;
OPEX_Can = 1000000;
%Paint deal requires losing a single adventurer
SP_Adventurer = 16995;%Sale Price of Adventurer in Canada

%Australia
[max_val, max_arg_Aus] = Optimisation(M, wAus, cAus);
profit_Aus = max_val-OPEX_Aus;

%Bangladesh
[max_val, max_arg_Ban] = Optimisation(M, wBan, cBan);
profit_Ban = max_val-OPEX_Ban;

%For the Canada ones, 
%The second case is after 2021 
%as the production increases  

% Canada No Paint Deal
[max_val, max_arg_Can_1_NoPD] = Optimisation(M, wCan_1, cCan_NoPD);
profit_Can_1_NoPD = max_val-OPEX_Can;
[max_val, max_arg_Can_2_NoPD] = Optimisation(M, wCan_2, cCan_NoPD);
profit_Can_2_NoPD = max_val-OPEX_Can;

% Canada Yes Paint Deal
[max_val, max_arg_Can_1_YesPD] = Optimisation(M, wCan_1, cCan_YesPD);
profit_Can_1_YesPD = max_val-OPEX_Can-SP_Adventurer;
[max_val, max_arg_Can_2_YesPD] = Optimisation(M, wCan_2, cCan_YesPD);
profit_Can_2_YesPD = max_val-OPEX_Can-SP_Adventurer;
%Concatenate the canada cases
Profit_CanM = [profit_Can_1_NoPD, profit_Can_1_YesPD;
                        profit_Can_2_NoPD, profit_Can_2_YesPD];
                    
t = 20; %Number of years
Profit = zeros(4,t); %row 1=Aus, row 2=Ban, row 3= Can No PD, row 4 = Can Yes PD
Profit(:,1) = [profit_Aus;profit_Ban; Profit_CanM(1,1); Profit_CanM(1,2)];
Profit(:,2) = [0;0;Profit(3,1)+Profit(3,1)/(1.1); Profit(4,1)+Profit(4,1)/(1.1)];
for j=1:2
    for i=2:t
        Profit(j,i) = Profit(j,i-1)+Profit(j,1)/((1.1)^(i-1));
    end
end

for j=3:4
    for i=3:t
        Profit(j,i) = Profit(j,i-1)+Profit_CanM(2,j-2)/((1.1)^(i-1));
    end
end

Profit = [zeros(4,1),Profit] - 20000000;
plot((0:t)+2019,Profit(1,:),(0:t)+2019,Profit(2,:),(0:t)+2019,Profit(3,:),(0:t)+2019,Profit(4,:));
hold on 
plot((0:t+1)+2019,zeros(t+2),'k:');
legend('Australia', 'Bangladesh', 'Canada without Paint Deal', 'Canada with Paint Deal','location','northwest');
xlabel('Year');
ylabel('Net-Profit ($AUD)');
xlim([2019,2040]);
hold off
