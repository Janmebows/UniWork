library(MASS)
setwd("~/Uni/2018/Statistical Modelling")

skin = read.table(file = "skin.txt" ,header = TRUE)

y= with(skin,cbind(Cases,Population-Cases) )
skin$Town = as.factor(skin$Town)
skin.glm = glm(y~ Town + Age, data=skin, family='binomial')
summary(skin.glm)
#coef is 0.855
#corresponds to an increase in death prob by 0.8
#If you are in Fort Worth
skin.glm0=glm(y~Town, data=skin, family='binomial')
summary(skin.glm0)
G2 = deviance(skin.glm0)-deviance(skin.glm)
#null hypothesis is that B_age == 0
#I.e. all the age factors are == 0
#G2 = 2202
#Will have chi^2_df dist df= p-p0
#Reject if G2 >= chi2
p  = df.residual(skin.glm0)
p0 = df.residual(skin.glm)
df = p-p0


qchisq(0.95,df=df)
#gives 14 much less than 2000
#Reject H0
ageAdj = c(9.5+10*c(1,2,3,4,5,6,7),85)
ageAdj= c(ageAdj,ageAdj)
ageAdj = ageAdj[-15]
skin.glm2 = glm(y~Town+ageAdj, data=skin, family='binomial')
summary(skin.glm2)
p2 =  df.residual(skin.glm2)
G22 = deviance(skin.glm2)-deviance(skin.glm)
df2 = p2-p0


