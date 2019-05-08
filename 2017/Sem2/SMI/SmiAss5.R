library(tidyverse)
library(broom)
setwd("D:/Documents/Uni/Smi")
pdf(file="Graphs.pdf")
##Read in the data
gumtree = readRDS("2.gumtree.rds")

##Filter to only 'sold' dogs
gumtree = gumtree %>%
  filter(price> 10)

##Model 1
model1lm = lm(price~age,data=gumtree)
tmp = par(mfrow = c(2,2))
plot(model1lm)
par(tmp)

##Model 2
model2lm = lm(log(price)~age,data=gumtree)
tmp = par(mfrow = c(2,2))
plot(model2lm)
par(tmp)
#assuming age is in years
newdat = data.frame(age=1)
predict(model2lm, newdata=newdat, interval="prediction")
##Model 3
model3lm = lm(log(price)~state,data=gumtree)
tmp = par(mfrow = c(2,2))
plot(model3lm)
par(tmp)
dev.off()
#price of dog from SA
summary(model3lm)
#95% prediction interval
newdat = data.frame(state="SA")
predict(model3lm, newdata=newdat, interval="prediction")
