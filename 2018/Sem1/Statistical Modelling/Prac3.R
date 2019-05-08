setwd("~/Uni/2018/Statistical Modelling")
hills = read.csv("hills.csv",header=T)
feettometre=3.28084
milestokm = 0.621371
hills$dist = hills$dist * milestokm
hills$climb = hills$climb * feettometre

plot(climbasmetre,distaskm)
model = lm(time ~ climb + dist, data = hills)
summary(model)
#F-stat is 181.7 on 2 and 32 DF, pvalue <2.2e-16
#Reject h0 -> it has nonzero slopes
X= model.matrix(~ climb + dist, data = hills)
H = X%*%solve(t(X)%*%X) %*% t(X)
hills$h_ii = diag(H)
hatvalues(model = model)
plot(h_ii ~ race,data=hills,las=3)
tmp = par(mfrow = c(2,2))
plot(model)
par(tmp)
#the point labelled 7 is the worstpoint 18 is just okay tho
asd = 2*dim(X)[2]/dim(X)[1]
cook1 = 4/dim(X)[1]
cook2 =4/(dim(X)[1]-dim(X)[2]-1)
plot(model,which=5,cook.levels=c(cook1,1))
#o no now 18 is of concern too! and 11!
hillsimproved = hills[-c(7,11,18) , ]
model2 =  lm(time ~ climb + dist, data = hillsimproved)
tmp = par(mfrow = c(2,2))
plot(model2)
par(tmp)

model3 = lm(time ~ climb*dist, data=hills)
summary(model3)
tmp = par(mfrow = c(2,2))
plot(model3)
par(tmp)
