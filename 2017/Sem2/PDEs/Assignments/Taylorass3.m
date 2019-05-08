syms u(x) v(x) h r 
ux(x) = (u(x+h)-u(x-h))/(2*h);
v(x) = (u(x-h)-2*u(x)+u(x+h))/(h^2);
vxx(x) = (v(x-h)-2*v(x)+v(x+h))/(h^2);
vterm = taylor(((30/7)*u(x)^2 - r)*v(x),h);
simpv = simplify(vterm)
vxxterm = taylor((-34/231)*vxx(x),h);
simpvxx = simplify(vxxterm)
duterm = taylor(60/7*u(x)*ux(x)^2,h);
simpdu = simplify(duterm)