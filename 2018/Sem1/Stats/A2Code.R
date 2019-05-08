n=1000000
UV=matrix(data=NA,nrow=n,ncol=2)
for( i in 1:n){
  u = runif(1)
  v = runif(1,max=u)
  UV[i,1]=u
  UV[i,2]=v
}
