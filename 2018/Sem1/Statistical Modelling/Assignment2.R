library(tidyverse)
library(ggplot2)
library(gridExtra)
setwd("~/Uni/2018/Statistical Modelling")
sleep = read.table("sleep.txt", header=T)

#Put it all in a tidy pdf

pdf(file="DiagPlotsAssignment2.pdf")

###a
#histograms of BrainWt, BodyWt, LifeSpan, and  Gestation on each scale
ggplot(aes(BrainWt),data = sleep) + geom_histogram()
ggplot(aes(log(BrainWt)),data = sleep) + geom_histogram()
ggplot(aes(BodyWt),data = sleep) + geom_histogram()
ggplot(aes(log(BodyWt)),data = sleep) + geom_histogram()
ggplot(aes(LifeSpan),data = sleep) + geom_histogram()
ggplot(aes(log(LifeSpan)),data = sleep) + geom_histogram()
ggplot(aes(Gestation),data = sleep) + geom_histogram()
ggplot(aes(log(Gestation)),data = sleep) + geom_histogram()
###b
#fit model and obtain diagnostic plot
lm1=lm(log(TotalSleep)~log(BodyWt)+log(BrainWt)+log(LifeSpan)
       +log(Gestation)+Exposure+Danger+Predation,data=sleep)

## Given plot code ##
par(mfrow=c(2,2))
plot(lm1)
Residuals1=residuals(lm1)
# Because there are some missing values, the vector of residuals is not the
# same length as the original variables.
# First construct an indictor for complete observations (not missing
# any values) required for the regression

##Code so the given code works...
TotalSleep = sleep$TotalSleep
BodyWt = sleep$BodyWt
BrainWt = sleep$BrainWt
LifeSpan = sleep$LifeSpan
Gestation = sleep$Gestation
Exposure = sleep$Exposure
Danger = sleep$Danger
Predation = sleep$Predation

complete=!is.na(TotalSleep)&!is.na(BodyWt)&!is.na(BrainWt)&!is.na(LifeSpan)&
          !is.na(Gestation)&!is.na(Exposure)&!is.na(Danger)&!is.na(Predation)

# Plot the residuals vs individual predictors for the complete data subset.
plot(log(BodyWt[complete]),Residuals1[complete],main="Residuals vs log(BodyWt)",pch=20)
plot(log(BrainWt[complete]),Residuals1[complete],main="Residuals vs log(BrainWt)",pch=20)
plot(log(LifeSpan[complete]),Residuals1[complete],main="Residuals vs log(LifeSpan)",pch=20)
plot(log(Gestation[complete]),Residuals1[complete],main="Residuals vs log(Gestation)",pch=20)
plot(Exposure[complete],Residuals1[complete],main="Residuals vs Exposure",pch=20)
plot(Danger[complete],Residuals1[complete],main="Residuals vs Danger",pch=20)
plot(Predation[complete],Residuals1[complete],main="Residuals vs Predation",pch=20)
plot.new() #this is just to fill a spot for formatting purposes
###c
#remove non-sig terms and find good model
summary(lm1)
#this is just lm1 but using sleep[complete,]
lm2=lm(log(TotalSleep)~log(BodyWt)+log(BrainWt)+log(LifeSpan)
       +log(Gestation)+Exposure+Danger+Predation,data=sleep[complete,])
#step function makes this step trivial
newmodel = step(lm2,direction = "both")
summary(newmodel) 
#this didn't omit predation (it notices its an interaction term) omit for this problem though
newmodel = lm(log(TotalSleep)~log(BodyWt)+log(Gestation)+Danger ,data=sleep[complete,])


###e
#Diagnostic plots for the new model
Residualsfull = residuals(newmodel)
plot(log(BodyWt[complete]),Residualsfull[complete],main="Residuals vs log(BodyWt)",pch=20)
plot(log(Gestation[complete]),Residualsfull[complete],main="Residuals vs log(Gestation)",pch=20)
plot(Danger[complete],Residualsfull[complete],main="Residuals vs Danger",pch=20)
plot.new()
plot(newmodel)


###f
#Replace danger with predation
#fit model and check significance
newmodelpred =  lm(log(TotalSleep)~log(BodyWt)+log(Gestation)+Predation ,data=sleep[complete,])


dev.off()
