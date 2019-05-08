library(tidyverse)
setwd("D:/Documents/Uni/Smi")


##Q3
X0 = c(1,1,1,1,1,1,1)
X1=c(-3,-2,-1,0,1,2,3)
X2=c(5,0,-3,-4,-3,0,5)
X3=c(-1,1,1,0,-1,-1,1)
X =cbind(X0,X1,X2,X3)
Y=c(1,0,0,1,2,3,3)
XTXinv =  solve(t(X)%*%X)
betahat = XTXinv%*%t(X)%*%Y

Ypredict = c(1,1,-3,-1) %*% betahat

##Hypothesis testing
lambda = c(0,0,0,1)
n=7
p=4
stderror = (1/(n-p)) * t(Y-X%*%betahat)%*%(Y-X%*%betahat)
teststat =t(lambda)%*%betahat/(sqrt(stderror*t(lambda)%*%XTXinv%*%lambda))
pval = dt(teststat,n-p)
#reject Ho as p-val < 0.05
lambda2 = c(1,1,-3,-1)
teststat2 =t(lambda2)%*%betahat/(sqrt(stderror*t(lambda2)%*%XTXinv%*%lambda2))
tval= qt(0.975,n-p)
CI = t(lambda2)%*%betahat+c(-1,1)*tval*(sqrt(stderror*t(lambda2)%*%XTXinv%*%lambda2))
## Q4 ----
##read in msleep
data(msleep)
summary(msleep)
##generate boxplots
#this will speed things up
temp = msleep%>%
  filter(order %in% c("Carnivora","Rodentia"))

pdf(file="BoxplotSleepTotal.pdf")
ggplot(data=temp,aes(x=order,y=sleep_total)) + geom_boxplot() + labs(title="Side-by-side boxplot of the sleep totals for Carnivora and Rodentia")+xlab("Order")+ylab("Total sleep")
dev.off()
#pooled could be used as the bulk of the data seems to have similar spread, however there is a slight variance difference in the plots


t.test(sleep_total~order,data=temp)



msleeplin = lm(sleep_total~order,data=temp)

summary(msleeplin)
library(broom)
tidy(msleeplin)
pdf(file="Graphs.pdf")
tmp = par(mfrow = c(2,2))
plot(msleeplin)
dev.off()

par(tmp)
