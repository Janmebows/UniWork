%Generating the z more safely...
%yk is the y_j^(k) coefficients
yk = [1/3,2/3,1];
%change into a min function and repeat the yk
z = -[0,0,0,yk,yk,yk];
%big constraint matrix, doesnt acknowledge the y_j^(k) <= h_j^(k)
A = [ 1,1.5,  2, 0, 0, 0, 0, 0, 0, 0, 0, 0;
     -1,  0,  0, 1, 0, 0, 0, 0, 0, 0, 0, 0;
      0, -1,  0, 0, 1, 0, 0, 0, 0, 0, 0, 0;
      0,  0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 0;
     -1,  0,  0, 0, 0, 0, 1, 0, 0, 0, 0, 0;
      0, -1,  0, 0, 0, 0, 0, 1, 0, 0, 0, 0;
      0,  0, -1, 0, 0, 0, 0, 0, 1, 0, 0, 0;      
     -1,  0,  0, 0, 0, 0, 0, 0, 0, 1, 0, 0;
      0, -1,  0, 0, 0, 0, 0, 0, 0, 0, 1, 0;
      0,  0, -1, 0, 0, 0, 0, 0, 0, 0, 0, 1];
%other side of the inequalities for Ax <=b
b = [200; zeros(9,1)];
%upper bounds corresponding to the hjk (the first 3 are max number of seats
%(not totally necessary)
upper = [200,200/1.5,100,200,50,20,175,25,10,150,10,5];
%lower bounds
lower = zeros(1,12);

%solve the problem
[x,zval] = linprog(z,A,b,[],[],lower,upper);
%convert the value back to a maximum
zval=-zval;
%print the x matrix and optimal value
x
zval