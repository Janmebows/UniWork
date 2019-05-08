
function [xnew, ynew] = newinsertpoints(x,y,d)
% NEWINSERTPOINTS finds midpoints of line segments and applies noise
%The function takes input arguments 
%   -   x, vector of the original vertices x-coordinates
%   -   y, vector of the original vertices y-coordinates
%   -   d, the factor of pertubation
%Describing the vertices of a series of line segments
%It then splits each line segment in half and peturbs these new midpoints
%by an amount between -d/2*line length and d/2*line length
% Jayden Robert Inglis 01/08/2017

n = length(x); 
points=[x;y];  
mid = movmean(points,2,2,'endpoints','discard'); %midpoint coordinates for each line segment
dr = sum(diff(points,1,2).^2).^0.5; %the length of each line segment
delta = d*dr.*(2*rand(2,n-1)-1); %random purtubation in range [-d*line length, d*line length]
new(:,1:2:2*n-1)=points; %inserting existing points in the odd columns
new(:,2:2:2*n-2)=mid+delta; %inserting the purterbed midpoints in each even column
xnew=new(1,:) ; ynew=new(2,:); %extracting each row of 'new' to get seperate x and y coordinate vectors


