#Assignment 3
library(tidyverse)
library(magrittr)
setwd("D:/Documents/Uni/Smi")


#Question 2
#n = number of trials
#smean = sample mean
#s = sample std dev
#df = degrees of freedom
n=65
smean=50.34
s2=10.72^2
df=n-1
## b ----
#Symmetric 95% CI
bChiRight = qchisq(0.025,n-1)
bChiLeft = qchisq(0.025,n-1,lower.tail = FALSE)
bCI = c((n-1)*s2/bChiLeft , (n-1)*s2/bChiRight)

## c ----
#Lower 95% CI
cChi = qchisq(0.05,n-1,lower.tail = FALSE)
cCI = (n-1)*s2/cChi
## d ----
#Upper 95% CI
dChi = qchisq(0.05,n-1,lower.tail = TRUE)
dCI = (n-1)*s2/dChi




#Question 3
#using the gumtree given by Jono
gumtree = readRDS("1.gumtree.rds")


## a ----
#Using summary stats and hists check that values pass the stupidity test 
#AGE
summary(gumtree$age)
ggplot(gumtree, aes(x=age)) + geom_histogram()
#values go up to 545.8 and below 0 -> has to be fixed
#given that dogs cannot age longer than 25 years, all values above this are set to NA
gumtree$age[gumtree$age>25]=NA
#and all values below 0 are set to NA
gumtree$age[gumtree$age<0] = NA
#PRICE
#assumption: dogs cannot cost more than $10000
summary(gumtree$price)
#no problems here
ggplot(gumtree,aes(x=price)) + geom_histogram()


## b ----
# Calculate 95% CI for the mean for each level of the variables
#Function get Confidence interval as given in prac 2
source("get_ci.R")



# Pet offered by

gumtree%>%
  split(.$'Pet Offered By:')%>%
  map_df(~get_ci(.$price), .id = 'Pet Offered By:')

# Microchip    
gumtree%>%
  split(.$micro)%>%
  map_df(~get_ci(.$price), .id = 'micro')

  # Vaccinataion 
gumtree%>%
  split(.$vacc)%>%
  map_df(~get_ci(.$price), .id = 'vacc')
# Desexing status
gumtree%>%
  split(.$desex)%>%
  map_df(~get_ci(.$price), .id = 'desex')
# State          
gumtree%>%
  split(.$state)%>%
  map_df(~get_ci(.$price), .id = 'state')
# Relinquished   
gumtree%>%
  split(.$relinquished)%>%
  map_df(~get_ci(.$price), .id = 'relinquished')