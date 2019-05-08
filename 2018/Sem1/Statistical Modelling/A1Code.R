library(tidyverse)
library(ggplot2)
setwd("~/Uni")
fev =read.table(file='fev-1.txt',header=TRUE)
##a
X=model.matrix(~Sex + Height + Smoker + Age,data=fev)
head(X,10)

#b
contrasts(fev$Sex)
contrasts(fev$Smoker)

#c
pdf(file="PairsPlot.pdf")
pairs(FEV~Sex + Height + Smoker + Age,data=fev)
pairs(log(FEV) ~ Sex + Height + Smoker + Age, data=fev)

#d
logfevmodel=lm(log(FEV)~X+0,data=fev)
fevmodel=lm(FEV~X+0,data=fev)

tmp = par(mfrow = c(2,2))
plot(logfevmodel)
plot(fevmodel)
par(tmp)
dev.off()
#e
summary(fevmodel)

#f
summary(fevmodel)
summary(logfevmodel)

predict(logfevmodel,newdata = ,interval="prediction",se.fit=T)
predict(fevmodel,interval="prediction",se.fit=T)
