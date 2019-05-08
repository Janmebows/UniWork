function [xnew,ynew] = fractalisland(x,y,d)

if(isrow(x))
    x=[x;x];
    y=[y;y];
end

n = length(x);
%calculates x&y midpoints
xmid = 0.5*(x(2:n) + x(1:n-1)); 
ymid = 0.5*(y(2:n) + y(1:n-1)); 
%2.7 finds magnitude
dr=sqrt(((x(:,2:n)-x(:,1:n-1)).^2+(y(:,2:n)-y(:,1:n-1)).^2));
%2.8 generate random numbers for X, Y, and then calculate random
%perturbations
X=rand([2 n-1]);
Y=rand([2 n-1]);
dx=d*dr.*((2*X)-1);
dy=d*dr.*((2*Y)-1);
%odd indices are inputted points
xnew(:,1:2:2*n)=x;
ynew(:,1:2:2*n)=y;
%even are the midpoints
xnew(:,2:2:2*n-1)=xmid+dx;
ynew(:,2:2:2*n-1)=ymid+dy;


end