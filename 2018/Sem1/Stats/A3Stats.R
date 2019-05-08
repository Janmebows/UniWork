x1 = runif(100000)
x2 = runif(100000)
y = sqrt(x1) * x2
pdf("A3Stats.pdf")
hist(y,freq=FALSE)
##line corresponding to y = 2-2x
abline(2,-2)
dev.off()
