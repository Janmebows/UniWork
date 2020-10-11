x=linspace(-5,5);
n=1:10;


%cos part i.e. even function
%c,d, are just to break it apart into multiple statements
a=3/8;

c=cos((pi/2).*n)./((pi^2).*(n.^2));
d=cos(pi.*n)./((pi^2).*(n.^2));

an=2*(c-d);

yc=a+an*cos(n'*x*pi);
plot(x,yc);
axis([-5 5 -0.2 1]);


%Sin Part (I.E. Odd function)

%sb, sc, sp to shorten bn
sb=sin((pi/2).*n)./(pi^2.*n.^2);
sc=(cos((pi/2).*n)./(2*pi.*n));
sp=1./(pi.*n);
bn=sb-sc+sp;

ys=bn*sin(n'*x*pi);
plot(x,ys);
grid on
axis([-5 5 -1 1]);
