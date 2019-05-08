setwd("~/Uni/2018/Sem2/Time Series")
pdf(file="A2Plots.pdf")
data(LakeHuron)
#It is already time series format
plot(LakeHuron)
#Correlogram
acf(LakeHuron)
#looks like there is some dependence between the values up until lag 10


##Different smoothers
#3 point
plot(LakeHuron)
lines(filter(LakeHuron,filter=rep(1/3,3)),col="blue")
#twice 3 point
plot(LakeHuron)
lines(filter(filter(LakeHuron,filter=rep(1/3,3)),filter=rep(1/3,3)),col="purple")

#5 point
plot(LakeHuron)
lines(filter(LakeHuron,filter=rep(1/5,5)),col="red")

#Smoothing spline
plot(LakeHuron)
lines(smooth.spline(LakeHuron),col="#00aa00")

##Differenced series
dLakeHuron = diff(LakeHuron)
plot(dLakeHuron)
acf(dLakeHuron)
qqnorm(dLakeHuron)

dev.off()
