syms x y z l1 l2 real
assume(x>0)
assume(y>0)
assume(z>0)
eqn1 = y*z + l1*(y+z) + l2 ==0;
eqn2 = x*z + l1*(x+z) + l2 ==0;
eqn3 = x*y + l1*(x+y) + l2 ==0;
eqn4 = x*y + x*z + y*z -1  ==0;
eqn5 = x + y + z -3        ==0;
sols = solve(eqn1,eqn2,eqn3,eqn4,eqn5)
sols.x(3)
sols.y(3)
sols.z(3)


h(x,y,z,l1,l2) = x*y*z + l1*(x*y + x*z + y*z -1) + l2*(x+y+z-3)
H = hessian(h);
H=subs(H,x,sols.x(3));
H=subs(H,y,sols.y(3));
H=subs(H,z,sols.z(3));
H=subs(H,l1,sols.l1(3));
H=subs(H,l2,sols.l2(3));
eig(H)