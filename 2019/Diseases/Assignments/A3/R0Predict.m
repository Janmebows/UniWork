%Pretty plots
set(groot, 'DefaultLineLineWidth', 1, ...
    'DefaultAxesLineWidth', 1, ...
    'DefaultAxesFontSize', 12, ...
    'DefaultTextFontSize', 12, ...
    'DefaultTextInterpreter', 'latex', ...
    'DefaultLegendInterpreter', 'latex', ...
    'DefaultColorbarTickLabelInterpreter', 'latex', ...
    'DefaultAxesTickLabelInterpreter','latex');



%Speeds up the code for multiple runs
%get the dataset once only
if ~exist('dataMat','var')
    %dataMat has format [#people, #infected, #action]
    dataMat = readmatrix('NorovirusDataA3.txt');
    %print the first few rows
    dataMat(1:5,:)
end

%Observation of dataset
%how many of them correspond to the disease effectively dying out?
amountOfData = length(dataMat(:,1))
propDiedOut = sum(dataMat(:,2)<=0.1*dataMat(:,1))/amountOfData



%consistency
rng(1)



%since we are expecting approximately 66% 
%getting the right prior
%we want the dist to be N'(2.5,sigma) 
%where sigma is the variance to have approx 66% in (2-3).
%N' since we will drop values below 0 and above 5 
%N' will still be symmetric
sigma = -(3-2.5)/norminv((1-0.66)/2);
variance = sigma* speye(3);

varR0 = 0.01;
distStruct.ProposalDist = @(x) mvnrnd(x,diag([varR0,0.01,0.01]));
distStruct.PriorPDF = @(x) normpdf(x,2.5,sigma);
distStruct.LogLikelihoodFunc =@(params) LogLikelihood(params,dataMat);
%constrain a_1,a_2 in [0,2]
distStruct.ProposalConstraints = @(vars) ...
    ProposalConstraints(vars,[0,0,0],[5,2,2]);
%overshoot, undershoot and approximately close to the true solutions
startVars = [4,1.5,1.5;
             0.5,0.5,0.5;
             2,0.7,0.7];

vars = zeros(10000,3,3);
for index = 1:3
    startPoint = startVars(index,:)
    exitflag = 1;
    while exitflag~=0
        [varsTemp,accrate,exitflag]= MetropolisHastingsPassLikelihood...
            (distStruct,startPoint,10000);
        %using exitflag change the variance to get a reasonaable acceptance
        %rate between 0.2, 0.27
        if exitflag==-1
            %acceptance was too low
            %variance is too high
            varR0 = varR0 *2/3;
            distStruct.ProposalDist = @(x) mvnrnd(x,diag([varR0,0.01,0.01]));
            warning('retrying with decreased variance')
        elseif exitflag==1
            %acceptance was too high
            %variance is too low
            varR0 = varR0*2;
            distStruct.ProposalDist = @(x) mvnrnd(x,diag([varR0,0.01,0.01]));
            warning('retrying with decreased variance')
        end
        %store all the solution sets
        vars(:,:,index) = varsTemp;
    end
    

end
%%
cumVars = cumsum(vars,1)./(1:length(vars))';
tstr = ["$$R_0$$","$$\alpha_1$$","$$\alpha_2$$"];
for burnin = 0:1
    figure
    for i=1:3
        hold on
        subplot(3,1,i)
        hold on
        %trace plots & trendlines
        plot(vars(:,i,1),'b')
        plot(cumVars(:,i,1),'k')
        plot(vars(:,i,2),'m')
        plot(cumVars(:,i,2),'k')
        plot(vars(:,i,3),'r')
        plot(cumVars(:,i,3),'k')
        title(tstr(i))

        if burnin
            axis([0,1000,-inf,inf])
        end
    end
        saveas(gcf,"MHplot"+num2str(burnin)+".eps","epsc")
end
    axis([0,1000,-inf,inf])
    xlabel('Iteration')

%% 
%%Analysis
%just take one set since they all converged
%and omit the burnin
varsClean = vars(500:end,:,3);

%density plot
%and obtain estimates for R0, a1, a2
%axis labels for later
labs = ["$$R_0$$","$$\alpha_1$$","$$\alpha_2$$"];

%est is the estimated [R0,a1,a2]
est = [0,0,0];
for i=1:3
    figure   
    [prob,val] = ksdensity(varsClean(:,i));
    prob = prob./sum(prob);
    plot(val,prob)
    xlabel(labs(i))
    ylabel("Probability")
    title("Probability density for "+labs(i))
    [~,ind] =max(prob);
    %assuming there is no dependence
    est(i) = val(ind);
    saveas(gcf,"Probdensity"+num2str(i),"epsc")
end
%print out R0,a1,a2
est
%print out R0a1, R0a2
est(2:3) * est(1)

%covariance-scatter plots
for i=1:2
    for j=i+1:3
        figure
        binscatter(varsClean(:,i),varsClean(:,j),60,'HandleVisibility','off')
        hold on
        scatter(est(i),est(j),'xr')
        xlabel(labs(i))
        ylabel(labs(j))
        legend("Independent approximation")
        colormap(gca,'parula')
        saveas(gcf,"BinScatter"+num2str(i)+num2str(j),"epsc")
    end
end


