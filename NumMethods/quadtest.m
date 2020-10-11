%Andrew Martin
%a1704466
%14/08/2017
Nmin=11;
x=linspace(0,2*pi,1000);
xj=linspace(0,2*pi,Nmin);
fj=cos(xj).^2;
fx=cos(x).^2;
fprimej=-2*sin(2*x);

[p, px] = quadinterp(x,xj,fj);

%removes graphs for tidyness
close all

%error plot
error = abs(fx-p);
figure
plot(x,error)
title("Error of the interpolant")
axis([0,2*pi , 0 ,0.15]);
xlabel('x');
ylabel('Error');


%N comparison
xj=linspace(0,2*pi,2*Nmin-1);
fj=cos(xj).^2;

[p2, ~] = quadinterp(x,xj,fj);
error2 = abs(fx-p2);
xj=linspace(0,2*pi,4*Nmin-3);
fj=cos(xj).^2;
[p3,~]= quadinterp(x,xj,fj);

error3=abs(fx-p3);
figure
plot(x,error,'b-',x,error2,'y-',x,error3,'r-');
title("Comparison of varying Ns");
xlabel('x');
ylabel('approximation');
legend('N=11','N=21','N=41')
axis([0,2*pi , 0 ,0.15]);



%Graph of the function
figure
plot(x,p,'-',xj,fj,'o');
title("Known data points and the Interpolated function");
xlabel('x');
ylabel('approximation');

%Graph of the derivatives
figure
plot(x,px,'b-',x,fprimej,'r-');
title("Interpolated function's derivative");
xlabel('x');
ylabel('Approximation of slope at x');
legend('Approximation of derivative','Actual derivative')



%Bay city section
%note baydata is in metres
baydata=importdata('bay_city.dat');
N=11;
xj=baydata(1,:);
fj=baydata(2,:);
x=linspace(0,12000,N); %given the race is a 12Km race
[p, px] = quadinterp(x,xj,fj);

%max elevation
[mx, indx] = max(p);
maxpoint=x(indx);
figure
plot(x,p,'-',xj,fj,'bo',maxpoint,mx,'ro');
title("Bay city race height map");
xlabel('x');
ylabel('Height');
legend('Approximation','Known Values','Max height','location','southeast')



%max slope
[ma, ind] = max(px);
maxslopepoint =x(ind);

figure
plot(x,px,'-',maxslopepoint,ma,'o');
title("Bay city race slope map");
xlabel('x');
ylabel('Slope');
legend('Approximation of derivative','Max','Location','southeast')

