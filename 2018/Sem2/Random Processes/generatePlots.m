%%Less than ideal script to make a few plots
seed='reproducible!';
rng(sum(uint8(seed)))
Ns = [200,800,5000,26000];
numsimss = [100,50,20,10];
I = 10;
TP = 200;
set(0,'defaultlinelinewidth',1);
xlabel('Time t');
ylabel('Number infectious at time t');
axis([0,inf,0,inf])
    cost=zeros(3,4);

%%%Different population sizes
plotcounter=1;
for i=1:4
    N = Ns(i);
    numsims= numsimss(i);
    %figure('DefaultAxesFontSize',12);
    if(plotcounter > 2)
        
        plotcounter=plotcounter-2;
        saveas(gcf,'Graphs1.eps','epsc')
        figure
    end
    subplot(2,1,plotcounter)
    hold on
    title('Worst case out of ' + string(numsims) +' realisations of stochastic model with ' + string(N) +' people')


    
    
    %masks = false, antivirals = false
    [infectedCell,timeCell,maxInfected,minInfected,costtemp] = School(I,N, TP, numsims, false, false,false);
    [~,worstSimIndex] = max(maxInfected(:,1));
    plot(timeCell{worstSimIndex}(1:end-1),infectedCell{worstSimIndex}(1:end-1))
    cost(i,1)=costtemp(worstSimIndex);
    maxInfected(worstSimIndex,:)
    %masks = true, antivirals = false
    [infectedCell,timeCell,maxInfected,~,costtemp] = School(I,N, TP, numsims, true, false,false);
    [~,worstSimIndex] = max(maxInfected(:,1));
    plot(timeCell{worstSimIndex}(1:end-1),infectedCell{worstSimIndex}(1:end-1))
    cost(i,2)=costtemp(worstSimIndex);
    maxInfected(worstSimIndex,:)
    %masks = false, antivirals = true
    [infectedCell,timeCell,maxInfected,~,costtemp] = School(I,N, TP, numsims, false, true,false);
    [~,worstSimIndex] = max(maxInfected(:,1));
    plot(timeCell{worstSimIndex}(1:end-1),infectedCell{worstSimIndex}(1:end-1))
    cost(i,3)=costtemp(worstSimIndex);
    maxInfected(worstSimIndex,:)
    %masks = true, antivirals = true
    [infectedCell,timeCell,maxInfected,~,costtemp] = School(I,N, TP, numsims, true, true,false);
    [~,worstSimIndex] = max(maxInfected(:,1));
    plot(timeCell{worstSimIndex}(1:end-1),infectedCell{worstSimIndex}(1:end-1))
    cost(i,4)=costtemp(worstSimIndex);
    maxInfected(worstSimIndex,:)
    legend( 'masks = false, antivirals = false',...
        'masks = true, antivirals = false',...
        'masks = false, antivirals = true',...
        'masks = true, antivirals = true')
    
        title('Numsims = ' + string(numsims) +', N = ' + string(N))

    hold off
    plotcounter=plotcounter+1;
end
saveas(gcf,'Graphs2.eps','epsc')



