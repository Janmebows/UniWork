library(MASS)
setwd("~/Uni/2018/Sem2/Time Series")


#R indexing starts at 1 so we will have to shift everything forward one element
#So t= 2,3,4,...,1000
t = seq(2,1000,1)
Z = rnorm(1000,0,1)
Y = vector(mode ="double", length = 1000)
Y[1] = Z[1]


for (i in 2:1000){
  Y[i] = (sqrt(1-(1/(i^2))) * Y[i-1]) + ((1/i) * Z[i])
}
  
Y[t] = (sqrt(1-(1/(t^2))) * Y[t-1]) + ((1/t) * Z[t])
plot(ts(Y))





#White noise series
noise=rnorm(1000)

noise=ts(noise)
plot(noise)


#To compare
lines(Y,col="blue")

plot(NULL, xlim=c(0,1000), ylim=c(-1,1), ylab="Y", xlab="Time")

for (i in 1:100){
  Z = rnorm(1000,0,1)
Y = vector(mode ="double", length = 1000)
Y[1] = Z[1]
Y[t] = (sqrt(1-(1/(t^2))) * Y[t-1]) + ((1/t) * Z[t])
#plotting each y set with a different colour
lines(ts(Y), col=rgb(runif(1,min=0,max=1),runif(1,min=0,max=1),runif(1,min=0,max=1),1))

}

