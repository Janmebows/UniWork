library(MASS)
setwd("~/Uni/2018/Sem2/Time Series")

air = read.csv(file="airpass.csv")
airseries = ts(air,start=1949,frequency=12)
with(air,plot(Passengers))
is.ts(airseries)
attributes(airseries)
tsp(airseries)
start(airseries)
end(airseries)
frequency(airseries)
deltat(airseries)
cycle(airseries)


murders = read.csv(file="murders.csv")
murdersts = ts(murders,start=1950,end=2004,frequency = 12)
with(murders,plot(rate))
lines(smooth.spline(murdersts),col="red")
plot(murdersts)
lines(filter(murdersts,filter=rep(1/3,3)),col="blue")
lines(filter(murdersts,filter=rep(1/5,5)),col="red")
lines(filter(murdersts,filter=rep(1/9,9)),col="purple")



noise = rnorm(200)
noise = ts(noise)
plot(noise)
lines(filter(noise,filter=rep(1/3,3)),col="red")
lines(filter(noise,filter=rep(1/9,9)),col="#a000e0")


signal= 3*sin(seq(0,2*pi,length=200))
signal= ts(signal)
plot(signal)
lines(filter(signal,filter=rep(1/3,3)),col="red")
lines(filter(signal,filter=rep(1/9,9)),col="purple")

series = signal + noise
plot(series)
lines(filter(series,filter=rep(1/3,3)),col="red")
lines(filter(series,filter=rep(1/9,9)),col="#a000e0")
lines(smooth.spline(series),col="#416cab")
