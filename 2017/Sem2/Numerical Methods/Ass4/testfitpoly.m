data = importdata('facebook.dat');
xj = data(:,1);
yj = data(:,2);
maxn=length(xj); %458 as that is n=m
AIC = inf; %initialise to a maximum possible value
x = xj;
for n=1:maxn
    [y,coefs,c] = fitpoly(x,xj,yj,n);
    ej = y - yj;
    AICn = 2*n + 458*log(sum(ej.^2));
    if(AICn > AIC)
        AIC = AICn;
        break;
    end
    AIC = AICn;
    
end
hold on 
plot(x,y,'r-')
plot(xj,yj,'b.')
title("Polynomial regression on Facebook search data")
xlabel("Number of years since 1 January 2007")
ylabel("Normalised weekly search volume counts for Facebook")
legend(["Polynomial corresponding to minimum AIC, n = " + num2str(n)],"Given Facebook data")
hold off
%%1.6
figure
x = linspace(min(xj),11,500)';
[y,~,~] = fitpoly(x,xj,yj,n);
plot(x,y,'b',x(end),y(end),'r.')
title("Prediction for 2017")
xlabel("Number of years since 1 January 2007")
ylabel("Normalised weekly search volume counts for Facebook")

%%1.7
[y,coefs,c] = fitpoly(xj,xj,yj,20);