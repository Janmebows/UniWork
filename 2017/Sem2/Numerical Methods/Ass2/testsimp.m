%%1.2
funca = @(t) t*cos(t);
funcb = @(t) sqrt(t-1);
ha=[];
ea=[];
hb=[];
eb=[];
for k=1:10
   n=2^k + 1; 
   [qa,ha(k)]=simp(funca,0,pi,n);
   ea(k) = abs(-2-qa);
   [qb,hb(k)]=simp(funcb,1,2,n);
   eb(k) =abs(2/3 - qb);
end

logha=log10(ha);
loghb=log10(hb);
logea=log10(ea);
logeb=log10(eb);
figure
plot(logha,logea,'',loghb,logeb,'')
xlabel('log of h')
ylabel('error bound')
legend('Error for tcost','Error for sqrt{t-1}')

%%
%2.3
%Generating the besselj plot
a=0;
b=pi;

n=1001;
x=linspace(0,20);
I0 = simp(@(t) besselint(t,x,0),a,b,n);
I1 = simp(@(t) besselint(t,x,1),a,b,n);
I2 = simp(@(t) besselint(t,x,2),a,b,n);

figure
plot(x,I0,'r-',x,I1,'b--',x,I2,'g-.')

axis([0,20,-0.5,1.1])
xlabel('x');
ylabel('J_{\nu}');
legend('\nu=0','\nu=1','\nu=2')


%%
