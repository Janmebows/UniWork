#Assignment 3
library(tidyverse)
library(ggplot2)
library(magrittr)
setwd("D:/Documents/Uni/Smi")

##Loading gumtree
gumtree = readRDS("gumtree.rds")


##Pet offered by
#Storing the column in its own variable so ggplot cooperates
pob = gumtree$"Pet Offered By:"
#storing graphs in a pdf
pdf(file="Graphs.pdf")
ggplot(data=gumtree,aes(x=pob, y=price)) + geom_boxplot()+ggtitle("Fig 1: Effect of seller on price")+xlab("Pet offered by")+ylab("Price of dog")+ylim(0,4000)
##Micro
ggplot(data=subset(gumtree,!is.na(micro)),aes(x=micro, y=price)) + geom_boxplot()+ ggtitle("Fig 2: Effect of Microchipped status on price")+xlab("Microchip status")+ylab("Price of dog")+ylim(0,2000)


##Vacc
ggplot(data=subset(gumtree,!is.na(vacc)),aes(x=vacc, y=price)) + geom_boxplot()+ ggtitle("Fig 3: Effect of Vaccination status on price")+xlab("Vaccination status")+ylab("Price of dog")+ylim(0,2500)


##Desex
ggplot(data=subset(gumtree,!is.na(desex)),aes(x=desex, y=price)) + geom_boxplot()+ ggtitle("Fig 4: How desex status effects price")+xlab("Desex status")+ylab("Price of dog")+ylim(0,4000)


##State
ggplot(data=subset(gumtree,!is.na(state)),aes(x=state, y=price)) + geom_boxplot()+ ggtitle("Fig 5: Prices for each stats")+xlab("State")+ylab("Price of dog")+ylim(0,2000)


##Relinquished
ggplot(data=subset(gumtree,!is.na(relinquished)),aes(x=relinquished, y=price)) + geom_boxplot()+ ggtitle("Fig 6: How whether or not the dog is relinquished changes price")+xlab("Relinquished?")+ylab("Price of dog")+ylim(0,3000)

##Age
ggplot(data=subset(gumtree,!is.na(age)),aes(x=age, y=price)) + geom_point() + ggtitle("Fig 7: Effect of age on price")+xlab("Age")+ylab("Price of dog")

ggplot(data=subset(gumtree,!is.na(age)),aes(x=age, y=price)) + geom_point() + ggtitle("Fig 8: Effect of age on price - capped y")+xlab("Age")+ylab("Price of dog")+ylim(0,2000)

dev.off()
