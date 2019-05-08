
h=0.01;
t= 0:h:2000;
hold on
start = 10/h +1;
for Mu = [8.25, 8.5, 8.75]
    Mu
    %func = @(x) vanderpolresidualf(x,t,Mu);
    %s=newton(func,50,1e-8); %guessing 1 would time out
    y0=[0.5;1];%s];
    func = @(tt,yy) vanderpolf(tt,yy,Mu);
    solf = rk4(func,t,y0);
    
    plot(t(start:end),solf(:,start:end));
    %axis equal
    xlabel("t")
    ylabel("y solutions")
    title("\mu = " + num2str(Mu))
    figure
    %plot(solf(1,start:end),solf(2,start:end))

end
% 
% %t=0:h:2000;
% %start=10/h +1;
% solf = rk4(func,t,y0);
%     plot(t(start:end),solf(:,start:end));
%     %axis equal
%     xlabel("t")
%     ylabel("y solutions")
%     title("\mu = " + num2str(Mu))
