library(MASS)
setwd("~/Uni/2018/Sem2/Time Series")
#2
ldeaths = ldeaths
plot(ldeaths)
spectrum(ldeaths)
acf(ldeaths)
cpgram(ldeaths)
spectrum(ldeaths,log="no")

#3
#simulating an MA process
z = rnorm(1001)
y = rep(0,1001)
b=0.95
for(i in 2:1000) y[i]=z[i]+b*z[i-1]
y=y[-1]
y=ts(y)
acf(y)
spectrum(y)
cpgram(y)


#simulating AR(1)
z=rnorm(2000)
y=rep(0,2000)
a=0.5
for(i in 2:2000) y[i]=a*y[i-1]+z[i]
y=ts(y[1001:2000])


#Now doing 10000 obvs with a = 0.9
z=rnorm(20000)
y=rep(0,20000)
a=0.9
for(i in 2:20000) y[i]=a*y[i-1]+z[i]
y=ts(y[1001:20000])
plot(y)
acf(y)

spectrum(y)
cpgram(y)

#Simulating AR(2)
z=rnorm(2000)
y=rep(0,2000)
a=0.5
for(i in 3:2000) y[i]=-0.5*y[i-1] + 0.4*y[i-2]+z[i]
y=ts(y[1001:2000])
plot(y)
polyroot(c(1,0.5,-0.4))
#roots lay outside unit circle
#stationarity holds

z=rnorm(2000)
y=rep(0,2000)
a=0.5
for(i in 3:2000) y[i]=-0.5*y[i-1] + 0.505*y[i-2]+z[i]
y=ts(y[1001:2000])
plot(y)

polyroot(c(1,0.5,-0.505))
#one of the roots has length < 1 so it is inside the unit circle
#stationarity doesn't hold

#ARMA(2,2) model
Z=rnorm(20000)
Y=rep(0,20000)
for(t in 3:20000) Y[t] =- 0.1* Y[t-1] - 0.25*Y[t-2] + Z[t] + 0.5*Z[t-1] + 0.5*Z[t-2]
Y = ts(Y[10001:20000])
plot(Y)
#Same but better
q6 = arima.sim(n=10000,list(ar = c(0.1,0.25), ma=c(0.5,0.5)))
plot(q6)

