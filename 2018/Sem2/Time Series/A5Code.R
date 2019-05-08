pdf(file="A5Plots.pdf")
fyw = function(w){1/(1.64 - 1.6*cos(w))}
plot(fyw,0,pi)

aw2 = function(w){-2*cos(w)}
plot(aw2,0,pi)

fuw = function(w){-2*cos(w)/(1.64 - 1.6*cos(w))}
plot(fuw,0,pi)

dev.off()