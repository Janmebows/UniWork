W = [3, 2;
     2, 5;
     1, 0;
    -1, 0;
     0, 1;
     0,-1];
A =[W,-eye(6)];

f = [0,0,1,1,1,1,1,1];
h= [0;0;4;-3.6;4;-6.4];
h1 = [0;0;4;-2.4;4;-3.2];
h2 = [0;0;6;-3.6;8;-6.4];
%Tx = 0 since x = 0

T =[-1,0;0,-1;zeros(4,2)];
[u1,w1]=linprog(f,A,h1,[],[],zeros(1,8))

[u2,w2]=linprog(f,A,h2,[],[],zeros(1,8))


%Dual

[sigma1,~]=linprog(-h1,A',f',[],[],[],zeros(1,6))
[sigma2,~]=linprog(-h2,A',f',[],[],[],zeros(1,6))

D = sigma'*T;
d1 = sigma' * h1;
d2 = sigma' * h2;