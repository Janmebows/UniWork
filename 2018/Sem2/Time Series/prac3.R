library(MASS)
setwd("~/Uni/2018/Sem2/Time Series")
#linspace(0,1,512)
x=c(1:512)/512
x = ts(x)
plot(x)



#periodogram
spectrum(x,log="no", detrend="F")
spectrum(x,log="yes", detrend="F")
spectrum(x,log="yes", detrend="T")
spectrum(x,log="no", detrend="T")
#Throws error (supposed to) 
#
y = cos(2*pi*x)
y=ts(y)
spectrum(y,log="no")
spectrum(y,log="yes")
#c
y = sin(2*pi*x)
y=ts(y)
spectrum(y,log="no")
spectrum(y,log="yes")

y = cos(4*pi*x)
y=ts(y)
spectrum(y,log="no")
spectrum(y,log="yes")

y = cos(8*pi*x)
y=ts(y)
spectrum(y,log="no")
spectrum(y,log="yes")

y = cos(8.5*pi*x)
y=ts(y)
spectrum(y,log="no")
spectrum(y,log="yes")

#d/e
y = sin(2*pi*x)+cos(20*pi*x)
y=ts(y)
spectrum(y,log="no")
spectrum(y,log="yes")
#2
u=rnorm(512)
u=ts(u)
plot(u)
spectrum(u,log="no")
spectrum(u,log="yes")
#3 
z = y+u
z=ts(z)
spectrum(z,log="no")
spectrum(z,log="yes")
 
z = y+2*u
z=ts(z)
spectrum(z,log="no")
spectrum(z,log="yes")

