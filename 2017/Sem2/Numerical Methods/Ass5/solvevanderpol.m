%A group of solutions to the van der pol equation
%Andrew Martin
%1704466
%23/10

h=0.01;
t= 0:h:100;
hold on
start = 10/h +1;
for Mu = 8%0:0.5:4
    Mu
    func = @(x) vanderpolresidual(x,t,Mu);
    s=newton(func,0.5,1e-8); %guessing 1 would time out
    y0=[0.5;s];
    func = @(tt,yy) vanderpol(tt,yy,Mu);
    sol = rk4(func,t,y0);
    plot(sol(1,start:end),sol(2,start:end))
end
axis equal
xlabel("y_1 solution")
ylabel("y_2 solution")

hold off