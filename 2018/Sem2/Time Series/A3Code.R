library(MASS)
setwd("~/Uni/2018/Sem2/Time Series")
pdf(file="A3Plots.pdf")

##Q2----
#a) Read in electricity as a ts object

elec = read.csv("electricity-1.csv")
elec = ts(elec,deltat=1/12)

#b) plot log and periodogram
plot(log(elec))
spectrum(elec,log="yes")

#c) detrend by using cubic regression on time. 
#Plot detrended data & periodogram
#describe and interpret features of periodogram
et = time(elec)
eres = residuals(lm(log(elec)~et + I(et^2) + I(et^3)))
eres =ts(eres,deltat=1/12)
plot(ts(eres))
spectrum(eres)

#d) estimate the periodic component 
#corresponding to the dominant frequency of residuals
#plot it over a cycle of 12 months
#the dominant freq is 1
t = time(eres)
c12 = cos(2*pi*t)
s12 = cos(2*pi*t)
plot(fitted(lm(eres~c12+s12))[1:12],type = "l")


##Q3----
sun = sunspots
st = time(sun)
  
#a) obtain residuals from cubic regression
sres = residuals(lm(sun~st + I(st^2) + I(st^3)))
sres = ts(sres,start=1749,deltat=1/12)

#b) cumulative periodogram for the residuals
cpgram(sres)
#c) periodogram from the residuals
sspec = spectrum(sres)
#d) dominant frequency
#estimate the periodic component of the dominant frequency

sMaxIndex = which.max(sspec$spec)
sMaxFreq = sspec$freq[22]
#Corresponds to a 10.9 yearly cycle
speriod = 1/sMaxFreq

#e) 
t = time(sres)
cosPart = cos(2 * pi * t * sMaxFreq)
sinPart = sin(2 * pi * t * sMaxFreq)
plot(sres)
cosSints =  ts(fitted(lm(sres~cosPart+sinPart)),start=1749,deltat=1/12)
lines(cosSints,col="magenta")


dev.off()
