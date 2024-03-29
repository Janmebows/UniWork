function fractalcoast(x,y)
Gridwidth = 1000;
randnum = rand*.1 + 0.3;
for i = 1:10
    [x,y]=superinsertpoints(x,y,randnum);
end
x(x>1)=2-x(x>1);
y(y>1)=2-y(y>1);
x=abs(floor(x*Gridwidth));
 
y=abs(floor(y*Gridwidth));
plot(x,y,'.',[0,1000,1000,0,0],[0,0,1000,1000,0],'r-')
end



function [xnew, ynew] = superinsertpoints(x,y,d)
%The function take input arguments 
%   -   x, the original vertices x-coordinates
%   -   y, the original vertices y-coordinates
%   -   d, the factor of pertubation
%Describing the vertices of a series of line segments
%It then splits each line segment in half and peturbs these new midpoints
%by an amount between -d/2*line length and d/2*line length
n = length(x); %Amount of vertex points
xmid = 0.5*(x(2:n) + x(1:n-1)); %Array of x coordinates of midpoints for each line segment
ymid = 0.5*(y(2:n) + y(1:n-1)); %Array of y coordinates of midpoints for each line segment
dr = ((x(2:n) - x(1:n-1)).^2 + (y(2:n) - y(1:n-1)).^2).^0.5; 
dx = d*dr.*(2*rand(1,n-1)-1);
dy = d*dr.*(2*rand(1,n-1)-1);
xnew(1:2:2*n-1)=x;
ynew(1:2:2*n-1)=y;
xnew(2:2:2*n-2)=xmid+dx;
ynew(2:2:2*n-2)=ymid+dy;
end
