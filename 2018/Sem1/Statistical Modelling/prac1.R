library(MASS)

data(Rubber)
#loss - abrasion loss in gh^_1, 
#hard - hardness in Shore units, 
#tens - tensile strength in kg m^-2
head(Rubber)
pairs(Rubber) #creates a scatter plot matrix
rubber.lm = lm(loss~hard+tens,data=Rubber) #using hard and tens as predictors
summary(rubber.lm)

rubber.resid = residuals(rubber.lm)
rubber.fits = fitted(rubber.lm)

par(mfrow=c(2,2)) #2x2 lattice of plots
plot(rubber.fits,rubber.resid) # The 3 here have reasonably even spread
plot(Rubber$hard,rubber.resid) # 
plot(Rubber$tens,rubber.resid) # 
qqnorm(rubber.resid) #roughly straight line - normal
#assume independence as a design assumption

plot(rubber.lm)
#Residuals vs fitted shows some issues at the ends. Normality is fine on normal qq plot

rubber.new = data.frame(hard=c(50,65),tens=c(200,190))
rubber.new
predict(rubber.lm,newdata=rubber.new)
predict(rubber.lm,newdata=rubber.new, se.fit=TRUE)
predict(rubber.lm,newdata=rubber.new, interval="confidence")
predict(rubber.lm,newdata=rubber.new,interval="prediction")

mean = c(281.7573,196.9379)
t= qt(0.025,df=27,lower.tail = FALSE)
sig = c(13.100995,7337753)
CI = c(mean[1]- t*sig[1],mean[1]+t*sig[1])
CI2 = c(mean[2]- t*sig[2],mean[2]+t*sig[2])

X= model.matrix(rubber.lm)
y = Rubber$loss
betahat = solve((t(X)%*%X))%*%t(X)%*%y
etahat = X%*%betahat
squarese = as.numeric(1/27  * t(y-etahat)%*%(y-etahat))
se = sqrt(squarese)
summary(rubber.lm)#rse 36.49
V = squarese * solve(t(X)%*%X)
vcov(rubber.lm)
sqrt(diag(V))
summary(rubber.lm) #yup they agree
X0 = data.frame(c(1,1),c(50,65),c(200,190))
X0 = data.matrix(X0)
varX0 = X0%*%V%*%t(X0) 
