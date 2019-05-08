library(MASS)
setwd("~/Uni/2018/Statistical Modelling")
##1A
#Why use WLS over OLS?
#since the e_i are uncorrelated w unequal variances
#w = 1/v so in this case w = 1/number
##1B
#would expect B0 = 0 as no oil lost in no oil spills
##1C
oil = read.table(file = 'oil.txt',header = TRUE)
head(oil)
plot(oil$total,oil$number)
##1D
olsmodel = lm(total~number,data=oil)
wlsmodel = lm(total~number,data=oil,weights=1/number)
tmp=par(mfrow=c(2,2))
plot(olsmodel)
plot(wlsmodel)
##1E
summary(wlsmodel)
#that is a v big pvalue for intercept
##1F

##2a
cherry = read.table(file='cherry.txt',header=TRUE)
##2b
model = lm(Volume~Height + Diam,data=cherry)
boxcox(model,lambda=seq(0.1,by=0.05))
#choose lambda = 0.3
##2c
lambda = 1/3
y=(cherry$Volume^lambda - 1)/lambda 
bcmodel = lm(y~Height+Diam,data=cherry)

##2d
par(tmp)
plot(cherry$Height,rstudent(bcmodel))
plot(cherry$Diam,rstudent(bcmodel))
tmp=par(mfrow=c(2,2))
plot(bcmodel)

#NO ES BUENO

##2e

##2f
par(tmp)
boxcox(lm(Volume~log(Height)+log(Diam),data=cherry))
#lambda = 0
newbcmodel= lm(log(Volume)~log(Height)+log(Diam),data=cherry)
par(tmp)
plot(cherry$Height,rstudent(newbcmodel))
plot(cherry$Diam,rstudent(newbcmodel))
tmp=par(mfrow=c(2,2))
plot(bcmodel)
