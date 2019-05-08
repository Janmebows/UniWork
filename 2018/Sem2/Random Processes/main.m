
Ns = [200,800,5000,26000];
numsimss = [100,50,20,10];
I = 10;
TP = 200;
set(0,'defaultlinelinewidth',1);
xlabel('Time t');
ylabel('Number infectious at time t');
axis([0,inf,0,inf])


for i=1:4
    %figure('DefaultAxesFontSize',12);

    subplot(2,2,i)
    hold on
    title('Worst case out of ' + string(numsims) +' realisations of stochastic model with ' + string(N) +' people')

    N = Ns(i);
    numsims= numsimss(i);
    cost=zeros(3,4);
    
    
    %masks = false, antivirals = false
    [infectedCell,timeCell,maxInfected,minInfected,costtemp] = School(I,N, TP, numsims, false, false,false);
    [~,worstSimIndex] = max(maxInfected(:,1));
    plot(timeCell{worstSimIndex}(1:end-1),infectedCell{worstSimIndex}(1:end-1))
    %saveas(gcf,string(N)+string(numsims)+'ff.epsc')
    cost(i,1)=costtemp(:,worstSimIndex);
    
    %masks = true, antivirals = false
    [infectedCell,timeCell,maxInfected,~,costtemp] = School(I,N, TP, numsims, true, false,false);
    [~,worstSimIndex] = max(maxInfected(:,1));
    plot(timeCell{worstSimIndex}(1:end-1),infectedCell{worstSimIndex}(1:end-1))
    %saveas(gcf,string(N)+string(numsims)+'tf.epsc')
    cost(i,2)=costtemp(:,worstSimIndex);
    
    %masks = false, antivirals = true
    [infectedCell,timeCell,maxInfected,~,costtemp] = School(I,N, TP, numsims, false, true,false);
    [~,worstSimIndex] = max(maxInfected(:,1));
    plot(timeCell{worstSimIndex}(1:end-1),infectedCell{worstSimIndex}(1:end-1))
    %saveas(gcf,string(N)+string(numsims)+'ft.epsc')
    cost(i,3)=costtemp(:,worstSimIndex);
    
    %masks = true, antivirals = true
    [infectedCell,timeCell,maxInfected,~,costtemp] = School(I,N, TP, numsims, true, true,false);
    [~,worstSimIndex] = max(maxInfected(:,1));
    plot(timeCell{worstSimIndex}(1:end-1),infectedCell{worstSimIndex}(1:end-1))
    %saveas(gcf,string(N)+string(numsims)+'tt.epsc')
    cost(i,4)=costtemp(:,worstSimIndex);
    
    legend( 'masks = false, antivirals = false',...
        'masks = true, antivirals = false',...
        'masks = false, antivirals = true',...
        'masks = true, antivirals = true')
    
        title('Worst case out of ' + string(numsims) +' realisations of stochastic model with ' + string(N) +' people')

    hold off
end
saveas(gcf,'test','png')