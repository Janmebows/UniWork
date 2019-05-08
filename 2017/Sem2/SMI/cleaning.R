gumtree = read_xlsx("Gumtree_dogs.xlsx")
gumtree$price[gumtree$price=="NA"]=NA
gumtree$price=as.numeric(gumtree$price)
gumtree$age[gumtree$age=="NA"]=NA
gumtree$age=as.numeric(gumtree$age)
gumtree = gumtree%>%
  filter(age>=0,age<=25)
gumtree$cross[gumtree$cross=="NA"]=NA
gumtree$vacc[gumtree$vacc=="NA"]=NA
gumtree$micro[gumtree$micro=="NA"]=NA
gumtree$desex[gumtree$desex=="NA"]=NA
gumtree$relinquished[gumtree$relinquished=="NA"]=NA
gumtree$state[gumtree$state=="NA"]=NA

gumtree$cross = factor(gumtree$cross)
gumtree$vacc=  factor(gumtree$vacc)
gumtree$micro=  factor(gumtree$micro)
gumtree$desex=  factor(gumtree$desex)
gumtree$relinquished=  factor(gumtree$relinquished)
gumtree$state=  factor(gumtree$state)

test=gumtree %>%
  filter(!is.na(price))

fullnolog = price~(age+cross+vacc+micro+desex+relinquished+state)^2
#fullnolog = price~(age+cross+micro+desex+relinquished+state)^2
smallestnolog = price ~ 1
backwardsnolog = lm(fullnolog,data=gumtree)
forwardsnolog = lm(smallestnolog,data = gumtree)
backwardsnologmodel = step(backwardsnolog,direction = "both")
forwardsnologmodel = step(forwardsnolog,scope= fullnolog,direction= "both")

gumtree1 =read_rds("2.gumtree.rds")
gumtree1==gumtree
