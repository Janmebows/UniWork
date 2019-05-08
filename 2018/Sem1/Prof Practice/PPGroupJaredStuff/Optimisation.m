function [max_val, max_arg] = Optimisation(M, w, c)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{      
             
This function solves linear optimisation problems.

INPUT is a set of constraints defining the feasible region, 
to be entered entered as 

(1) a k times l matrix M = [m11, m12, ..., m1l; m21, m22, ..., m2l; ... ; mk1, mn2, ..., mkl]

and

(2) a k-dimensional colomn vector w = [w1; w2; w3; ...; wk]

giving k constraints

Mx <= w

on an l-dimensional column vector x. 

And also 

(3) the linear objective function to be maximised: 
a function f that assigns a number to each l-dimensional vector x. 
This function should be input as the column
vector c = [c1; c2; ...; cl], such that

f(x) = c1 x1 + c2 x2 + ... + cl xl,

if x = [x1, x2, ..., xl].


ABOUT THE ALGORITHM

The condition that the elements of x should be nonnegative is imposed
automatically by putting M inside an (k+l) times l matrix A, with minus the l times
l identity matrix inserted below M, 
and putting w inside a (k+l)-dimensional vector b by adding l zeroes below
w.

The script then computes the array Vertices of vertices of the feasible region
defined by the constraints. Here Vertices is an n times l matrix, 
with n the number of vertices, 
and every row of Vertices is a vertex (an l-dimensional *row* vector)
 
Finally, the function f is applied to all vertices in Vertices. 
The maximal value on these vertices is the maximum of f on the feasible region.

OUTPUT is the maximum value max_val of f and *an* l-dimensional row vector
max_arg where f takes this maximum. 
(f may take its maximum value at other points as well)

v1 Kate Bridges May 2015

%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Include condition that the variables are nonnegative %%%
 
[k, l] = size(M);

A = [M; -eye(l)];

b = [w; zeros(l,1)];
 
%%% Finding vertices %%%

Vertices = lcon2vert(A,b);

%%% Maximum value of f at vertices %%%

Values = Vertices*c; 

[max_val, max_index] = max(Values);

%%% Point where f reaches maximum %%%

max_arg = Vertices(max_index, :);


