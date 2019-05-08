###Question 4 A3
library(MASS)
setwd("~/Uni/2018/Statistical Modelling")

pdf(file="PairsPlotA3.pdf")
##a --
#read in the data
prostate = read.csv("prostate-a3.csv",header=T)
#convert to factors

prostate$svi = as.factor(prostate$svi)
prostate$gleason=as.factor(prostate$gleason)
#remove lpsa and train as they aren't defined for the given model
prostate$lpsa = NULL
prostate$train = NULL
##i
#plot pairwise scatterplots
pairs(prostate)
##ii
#correlation matrix
cor(prostate[sapply(prostate,is.numeric)])
##iii
#no code
##iv
#no code
##b --
#Use boxcox to find lambda
basemodel = lm(psa~lcavol+lweight+age+lbph+svi+lcp+gleason+pgg45,data=prostate)
boxcox(basemodel)
#Lambda contains 0, and 0 is the easiest - effectively take the log transform
##c --
#Refit the model, using transformed variables
transmodel= lm(log(psa)~lcavol+lweight+age+lbph+svi+lcp+gleason+pgg45,data=prostate)
##d --
#use stepwise model selection
#minimising AIC is the same as minimising the Cp, so just doing step is good
s2=sum((transmodel$residuals)^2)/transmodel$df
newnewmodel= step(object = transmodel,scale= s2)
#note aic approx Cp
##e --
#Obtain diagnostic plots
tmp = par(mfrow=c(2,2))
plot(newnewmodel)
par(tmp)
#residual plots
tmp = par(mfrow=c(2,2))
plot(prostate$lcavol,rstudent(transmodel))
plot(prostate$lweight,rstudent(transmodel))
plot(prostate$age,rstudent(transmodel))
plot(prostate$lbph,rstudent(transmodel))
plot(prostate$svi,rstudent(transmodel))
plot.new()
plot.new()
plot.new()
par(tmp)

##f --
#Obtain a scatter of psa vs lcavol showing 95% prediction bounds

plot(y=prostate$psa,x=prostate$lcavol)
pred= predict(newnewmodel, interval="prediction")
lines(lowess(prostate$lcavol,exp(pred[,3])),col="blue")
lines(lowess(prostate$lcavol,exp(pred[,2])),col="blue")
dev.off()
