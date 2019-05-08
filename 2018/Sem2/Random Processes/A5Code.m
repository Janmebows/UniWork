%%Calculate the blocking probability on route 2 using EFPM
%%Andrew Martin
%%1704466
%%25/10/2018


%%declaring variables
alpha = zeros(9,1);
y = zeros(9,1);
c=[3;3;3;6;6;3;6;3;3]';
a=[1;2;2;1];
BlockProb=zeros(4,1);
numLinks=9;
numRoutes=4;
A =[1,0,0,0;
    1,0,0,0;
    0,0,0,1;
    0,1,0,0;
    0,0,1,1;
    0,0,1,0;
    0,1,1,0;
    0,0,0,1;
    0,1,0,0];
%Termination conditions for the while loop
tol=100*eps;
ticker=1;

%to enter the loop since matlab doesn't have do-while loops
alphatemp=inf*ones(9,1);
%while we are outside our tolerance
while (sum(abs(alphatemp - alpha)) > tol && ticker<=1000)
    alphatemp=alpha;
    for j=1:numLinks
         %Find r s.t. j in r 
          r = find(A(j,:));
          
          temp=0;
          
          %r will give multiple values
          for index = 1:length(r)
              i = find(A(:,r(index)));
              %remove the i==j case
              i(i==j) = [];
              prodpart = prod(1- alpha(i));
              temp = temp + (a(r(index)).*  prodpart);
              
              
          end
          y(j) = temp;

        alpha(j) = B(c(j),y(j));
    end
    ticker= ticker +1;
end

for r=1:4    
    BlockProb(r) = 1- prod((1-alpha).^A(:,r));
end

%just to print it lazily
BlockProb(2)


%Calcualtes the Erlang B formula recursively
function Bout = B(c,y)
if(c==0)
    Bout = 1;
else
    temp = B(c-1,y);
    
    Bout = y*temp/(c+y*temp);
end
end