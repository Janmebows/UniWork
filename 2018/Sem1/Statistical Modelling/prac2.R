library(ggplot2)
library(tidyverse)
att = read.csv("att.csv")
head(att)
att[5,]
att[,2]
att[,"hours"]
att$hours

att$os[is.na(att$os)] = 'MVS'
#att = att%>%
 # filter(!is.na(noother))%>%
#  filter(!is.na(os))


ggplot(att,aes(fpoints,hours)) +geom_point()
#not closely related - as fpoints increases, hours increases.

ggplot(att,aes(fpoints,hours)) +geom_point(aes(col=lang,shape=db))
#from this, can see that they are related in some way


ggplot(att,aes(os,hours)) + geom_boxplot()
ggplot(att,aes(db,hours)) + geom_boxplot()
ggplot(att,aes(lang,hours)) + geom_boxplot()
ggplot(att,aes(noother,hours)) + geom_boxplot()
#they all seem to have some sort of relationship, however noother has less of a relationship





with(att,table(os,db,lang,noother))

X = model.matrix(~ db + lang + noother, data=att)
head(X)
#Categoricals are listed as logical booleans (1/0)
dim(X)
#9 columns 99 rows

det(X%*%t(X))
#this = 0 so there is linear dependence
#this is because noother directly relates to lang

#Remove noother from the matrix
summary(lm(hours~ db + lang, data=att))
summary(lm(hours ~ db + lang + noother, data=att))
#the one with noother gives NAs for nootherTRUE - it omits it?

lm0 = lm(hours ~ fpoints + os + db + lang, data=att)

par(mfrow=c(2,2))
plot(lm0)
par(mfrow=c(1,1))
#oh boy the does not look goooood can probably assume normality, homoscedasticity, linearity and independence, 
#but the residuals and normal don't quite match
lm1 = lm(log(hours)~ fpoints + os + db + lang, data=att)
par(mfrow=c(2,2))
plot(lm1)
par(mfrow=c(1,1))
#significantly more grotty


lm2 = lm(log(hours)~ log(fpoints)  + db + lang+ os, data=att)
par(mfrow=c(2,2))
plot(lm2)
par(mfrow=c(1,1))
#LM 2 is god tier - use that one
lm2a = lm(log(hours)~log(fpoints) + db + lang, data=att)
anova(lm2a,lm2)
summary(lm2)


lm3a = lm(log(hours) ~log(fpoints) + db,data=att)
lm3 = lm(log(hours)~ log(fpoints) + db + lang, data=att)
anova(lm3a,lm3)

