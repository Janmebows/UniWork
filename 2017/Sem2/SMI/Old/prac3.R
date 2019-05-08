library(tidyverse)
data(mpg)
setwd("D:/Documents/Uni/SMI")

?mpg


#Geom_point is a scatter plot, the information is colour-coded against wheel drive type 
ggplot(mpg,aes(x=displ,y=cty, col=class, shape=drv))+ geom_point() + theme(legend.position ="bottom")

ggplot(mpg,aes(x=displ,y=cty))+ geom_point() + facet_grid(class~drv)

ggplot(mpg,aes(x=displ,y=cty))+ geom_point() + facet_wrap(~class,ncol=2)


ggplot(mpg,aes(x=displ,y=cty))+ geom_point() + theme(legend.position ="bottom")+geom_smooth(method="lm")+facet_wrap(drv~class)

ggplot(mpg,aes(x=drv,y=cty))+geom_boxplot()
