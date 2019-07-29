syms x y c b
xeqn = c - x - 4*x*y/(1+x^2)
yeqn = b*x*(1 - y/(1+x^2))
xx =diff(xeqn,x)
xy = diff(xeqn,y)
yx = diff(yeqn,x)
yy = diff(yeqn,y)

xx = subs(xx,x,c/5);
xx = subs(xx,y,1+c^2/25);
xx = simplify(xx)

xy = subs(xy,x,c/5);
xy = subs(xy,y,1+c^2/25);
xy = simplify(xy)

yx = subs(yx,x,c/5);
yx = subs(yx,y,1+c^2/25);
yx = simplify(yx)

yy = subs(yy,x,c/5);
yy = subs(yy,y,1+c^2/25);
yy = simplify(yy)

J = [xx,xy;yx,yy]
latex(J)
det(J)
trace(J)
