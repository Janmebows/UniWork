%%%%Q2
%%Primal
z =[5,-1,4];
A=[2,2,-4;2,2,2];
b = [1;4];
lb = [0,0,0];
[x,zval] = linprog(z,[],[],A,b,lb,[]);
%of course zval is actually giving the negative since it had to be swapped
zval = -zval;
%%Dual
w = [1,4];
B = [-2,-2;-2,-2;4,-2];
a = [5;-1;4];

[y,wval] = linprog(w,B,a);
%%%%Q3
q1 = 10;
q2 = 1;
q3 = 20;
z = [-4,-8,-5,0.3 *q1, 0.3 *q2, 0.3 * q3, 0.5*q1, 0.5*q2,0.5 *q3, 0.2*q1,0.2*q2,0.2*q3]
A = -[1,0,0,1,0,0,0,0,0,0,0,0;
      1,0,0,0,0,0,1,0,0,0,0,0;
      1,0,0,0,0,0,0,0,0,1,0,0;
      0,1,0,0,1,0,0,0,0,0,0,0;
      0,1,0,0,0,0,0,1,0,0,0,0;
      0,1,0,0,0,0,0,0,0,0,1,0;
      0,0,1,0,0,1,0,0,0,0,0,0;
      0,0,1,0,0,0,0,0,1,0,0,0;
      0,0,1,0,0,0,0,0,0,0,0,1;
      -2,-3,-1,0,0,0,0,0,0,0,0,0;
      -1,-2,-2,0,0,0,0,0,0,0,0,0];
b = -[8;10;13;6;10;11;1;3;6;-80;-70];
lb=zeros(1,12)
[x,zval] = linprog(z,A,b,[],[],lb,[]);
zval=-zval;







%%%%Q4
rng(1704466);
%Matlab uses the inverse version so make sure
%b = 1/3 instead of 3
lambda = 3;
pd = makedist('Gamma','a',2,'b',1/lambda);
X= random(pd,[1,10]);
probx = ((1/length(X))* lambda^2 .*X .*exp(-lambda.* X));
probx = probx./sum(probx);

%
numintervals = 20;
scatter(X,probx)
%intervals = linspace(0,