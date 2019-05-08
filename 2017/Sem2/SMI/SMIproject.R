###PROJECT ----
library(tidyverse)
library(broom)
library(readxl)
##Read in the data
gumtree = read_xlsx("Gumtree_dogs.xlsx")
gumtree <- gumtree %>% select(price, age, cross, vacc, micro, desex, relinquished, state)


##Cleaning ----

#Set 'NA' to R's NA
gumtree$price[gumtree$price=='NA'] = NA
gumtree$price[gumtree$age=='NA'] = NA

#Turning the variables into factors will help for later!
gumtree$cross <- factor(gumtree$cross)
gumtree$vacc <- factor(gumtree$vacc)
gumtree$micro <- factor(gumtree$micro)
gumtree$desex <- factor(gumtree$desex)
gumtree$relinquished <- factor(gumtree$relinquished)
gumtree$state <- factor(gumtree$state)

#Price and age should be numeric
gumtree$price <- as.numeric(gumtree$price)
gumtree$age <- as.numeric(gumtree$age)

#Given dogs can't be older than 25 or younger than 0
gumtree  <- gumtree %>%
  filter(age > 0, age <= 25)

#dogs cannot be sold for negative dollars
summary(gumtree$price < 0)
#All false so they are all >=0
##Later on will use log(price)
logprice = log(gumtree$price)

#the nasty little NAs changed to -Inf so we have to fix that
logprice[logprice==-Inf]=NA

##Variable description ----
pdf(file="varAnalPlots.pdf")
summary(gumtree$price)
ggplot(gumtree,aes(price)) + geom_histogram(col = "black", fill = "orange")

summary(gumtree$age)
ggplot(gumtree,aes(age)) + geom_histogram(col = "black", fill = "orange")

summary(gumtree$cross)
ggplot(gumtree,aes(gumtree$cross, fill =gumtree$cross)) + 
  geom_bar(show.legend = FALSE) + 
  scale_fill_brewer(palette = "Set1") +
  labs(x = "Crossbreed status", y = "Frequency")

summary(gumtree$vacc)
ggplot(gumtree,aes(gumtree$vacc, fill =gumtree$vacc)) + 
  geom_bar(show.legend = FALSE) + 
  scale_fill_brewer(palette = "Set1")+
  labs(x = "Vaccination status", y = "Frequency")

summary(gumtree$micro)
ggplot(gumtree,aes(gumtree$micro, fill =gumtree$micro)) + 
  geom_bar(show.legend = FALSE) + 
  scale_fill_brewer(palette = "Set1") +
  labs(x = "Microchipped status", y = "Frequency")

summary(gumtree$desex)
ggplot(gumtree,aes(gumtree$desex, fill =gumtree$desex)) + 
  geom_bar(show.legend = FALSE) + 
  scale_fill_brewer(palette = "Set1") +
  labs(x = "Desexed status", y = "Frequency")

summary(gumtree$relinquished)
ggplot(gumtree,aes(gumtree$relinquished, fill =gumtree$relinquished)) + 
  geom_bar(show.legend = FALSE) + 
  scale_fill_brewer(palette = "Set1") +
  labs(x = "Relinquished status", y = "Frequency")

summary(gumtree$state)
ggplot(gumtree,aes(gumtree$state, fill =gumtree$state)) + 
  geom_bar(show.legend = FALSE) + 
  scale_fill_brewer(palette = "Set1") +
  labs(x = "State", y = "Frequency")
dev.off()
##Bivariate analysis ----
pdf(file="ProjectGraphs.pdf")
#Age
ggplot(aes(x=age,y=price),data=subset(gumtree,!is.na(age))) + geom_point()+
  ggtitle("Bivariabe analysis: Age against price")+xlab("Age of dog")+ylab("Price of dog")

#Cross breeding
ggplot(aes(x=cross,y=price),data=subset(gumtree,!is.na(cross))) + geom_boxplot()+
  ggtitle("Bivariate analysis: Cross-breeding against price")+xlab("Cross breed or not")+ylab("Price of dog") + ylim(0,3000)
#Vacc
ggplot(aes(x=vacc,y=price),data=subset(gumtree,!is.na(vacc))) + geom_boxplot()+
  ggtitle("Bivariate analysis: Vaccincation against price")+xlab("Vaccinated or not")+ylab("Price of dog") +ylim(0,2500)

#Micro
ggplot(aes(x=micro,y=price),data=subset(gumtree,!is.na(micro))) + geom_boxplot()+
  ggtitle("Bivariate analysis: Microchipped against price")+xlab("Microchipped or not")+ylab("Price of dog")+ylim(0,2000)
#Desexing
ggplot(aes(x=desex,y=price),data=subset(gumtree,!is.na(desex))) + geom_boxplot()+
  ggtitle("Bivariate analysis: Desexing against price")+xlab("Desexed or not")+ylab("Price of dog")+ylim(0,4000)
#Relinquished
ggplot(aes(x=relinquished,y=price),data=subset(gumtree,!is.na(relinquished))) + geom_boxplot()+
  ggtitle("Bivariate analysis: Relinquished against price")+xlab("Relinquished or not")+ylab("Price of dog")+ylim(0,3000)
#State
ggplot(aes(x=state,y=price),data=subset(gumtree,!is.na(state))) + geom_boxplot()+ 
  ggtitle("Bivariate analysis: State against price")+xlab("State of seller")+ylab("Price of dog") +ylim(0,2000)


##Log bivar
#Age
ggplot(aes(x=age,y=logprice),data=subset(gumtree,!is.na(age))) + geom_point()+
  ggtitle("Bivariabe analysis: Age against logprice")+xlab("Age of dog")+ylab("logprice of dog")

#Cross breeding
ggplot(aes(x=cross,y=logprice),data=subset(gumtree,!is.na(cross))) + geom_boxplot()+
  ggtitle("Bivariate analysis: Cross-breeding against logprice")+xlab("Cross breed or not")+ylab("logprice of dog") + ylim(0,log(3000))
#Vacc
ggplot(aes(x=vacc,y=logprice),data=subset(gumtree,!is.na(vacc))) + geom_boxplot()+
  ggtitle("Bivariate analysis: Vaccincation against logprice")+xlab("Vaccinated or not")+ylab("logprice of dog") +ylim(0,log(2500))

#Micro
ggplot(aes(x=micro,y=logprice),data=subset(gumtree,!is.na(micro))) + geom_boxplot()+
  ggtitle("Bivariate analysis: Microchipped against logprice")+xlab("Microchipped or not")+ylab("logprice of dog")+ylim(0,log(2000))
#Desexing
ggplot(aes(x=desex,y=logprice),data=subset(gumtree,!is.na(desex))) + geom_boxplot()+
  ggtitle("Bivariate analysis: Desexing against logprice")+xlab("Desexed or not")+ylab("logprice of dog")+ylim(0,log(4000))
#Relinquished
ggplot(aes(x=relinquished,y=logprice),data=subset(gumtree,!is.na(relinquished))) + geom_boxplot()+
  ggtitle("Bivariate analysis: Relinquished against logprice")+xlab("Relinquished or not")+ylab("logprice of dog")+ylim(0,log(3000))
#State
ggplot(aes(x=state,y=logprice),data=subset(gumtree,!is.na(state))) + geom_boxplot()+ 
  ggtitle("Bivariate analysis: State against logprice")+xlab("State of seller")+ylab("logprice of dog") +ylim(0,log(2000))

##SQRT Bivar
#Age
ggplot(aes(x=age,y=sqrt(price)),data=subset(gumtree,!is.na(age))) + geom_point()+
  ggtitle("Bivariabe analysis: Age against sqrt(price)")+xlab("Age of dog")+ylab("sqrt(price) of dog")

#Cross breeding
ggplot(aes(x=cross,y=sqrt(price)),data=subset(gumtree,!is.na(cross))) + geom_boxplot()+
  ggtitle("Bivariate analysis: Cross-breeding against sqrt(price)")+xlab("Cross breed or not")+ylab("sqrt(price) of dog") + ylim(0,100)
#Vacc
ggplot(aes(x=vacc,y=sqrt(price)),data=subset(gumtree,!is.na(vacc))) + geom_boxplot()+
  ggtitle("Bivariate analysis: Vaccincation against sqrt(price)")+xlab("Vaccinated or not")+ylab("sqrt(price) of dog") +ylim(0,80)

#Micro
ggplot(aes(x=micro,y=sqrt(price)),data=subset(gumtree,!is.na(micro))) + geom_boxplot()+
  ggtitle("Bivariate analysis: Microchipped against sqrt(price)")+xlab("Microchipped or not")+ylab("sqrt(price) of dog")+ylim(0,80)
#Desexing
ggplot(aes(x=desex,y=sqrt(price)),data=subset(gumtree,!is.na(desex))) + geom_boxplot()+
  ggtitle("Bivariate analysis: Desexing against sqrt(price)")+xlab("Desexed or not")+ylab("sqrt(price) of dog")+ylim(0,100)
#Relinquished
ggplot(aes(x=relinquished,y=sqrt(price)),data=subset(gumtree,!is.na(relinquished))) + geom_boxplot()+
  ggtitle("Bivariate analysis: Relinquished against sqrt(price)")+xlab("Relinquished or not")+ylab("sqrt(price) of dog")+ylim(0,100)
#State
ggplot(aes(x=state,y=sqrt(price)),data=subset(gumtree,!is.na(state))) + geom_boxplot()+ 
  ggtitle("Bivariate analysis: State against sqrt(price)")+xlab("State of seller")+ylab("sqrt(price) of dog") +ylim(0,100)


dev.off()

##Model Fitting ----
#Normal model
full = price~(age+cross+vacc+micro+desex+relinquished+state)^2
smallest = price ~ 1
backwards= lm(full,data=gumtree)
forwards = lm(smallest,data = gumtree)
forwardsmodel = step(forwards,scope= full,direction= "forward")
backwardsmodel = step(backwards,direction = "backward")
stepautomodel = step(backwards,scope = full,direction = "both" )



#LOG
fulllog = logprice~(age+cross+vacc+micro+desex+relinquished+state)^2
smallestlog = logprice ~ 1
backwardslog = lm(fulllog,data=gumtree)
forwardslog = lm(smallestlog,data = gumtree)
forwardslogmodel = step(forwardslog,scope= fulllog,direction= "forward")
backwardslogmodel = step(backwardslog,direction = "backward")
stepautologmodel = step(backwardslog,scope = fulllog,direction = "both" )

#SQRT
fullsqrt = sqrt(price)~(age+cross+vacc+micro+desex+relinquished+state)^2
smallestsqrt = price^2 ~ 1
backwardssqrt = lm(fullsqrt,data=gumtree)
forwardssqrt = lm(smallestsqrt,data = gumtree)
forwardssqrtmodel = step(forwardssqrt,scope= fullsqrt,direction= "forward")
backwardssqrtmodel = step(backwardssqrt, direction = "backward")
stepautosqrtmodel = step(backwardssqrt, scope = fullsqrt,direction = "both" )


#Compare the model selection methods
glance(forwardslogmodel)
glance(backwardslogmodel)
glance(stepautologmodel)
#Forwards is slightly different but they are all similar so they agree!


#Compare the different models
glance(stepautomodel)
glance(stepautologmodel)
glance(stepautosqrtmodel)

#Getting the terms from the log model
list(value = stepautologmodel)%>%
  map_df(broom::tidy, .id = "Model")%>%
  select(Model,term,estimate)%>%
  spread(Model,estimate)

##Assumption checking----
pdf(file="Assumptions.pdf")
tmp = par(mfrow = c(1,3))
plot(stepautomodel, which=1:3, main = "Stepwise using Price")

plot(stepautologmodel, which=1:3, main = "Stepwise using log(Price)")
#This looks good! Check to see if theres anything better though

plot(stepautosqrtmodel, which=1:3, main= "Stepwise using sqrt(Price)")
#Thats also pretty good
dev.off()


##Prediction ----
#NA is still a factor!!
example = data.frame(state="SA",age=1,cross="yes",vacc="Vaccinated",desex="Desexed",relinquished="yes",micro="NA")
anslog = predict(stepautologmodel,newdata=example)
exp(anslog)
#Just to see what the other model would give:
anssqrt=predict(stepautosqrtmodel, newdata=example)
(anssqrt)^2
