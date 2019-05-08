library(readxl)
library("dplyr")
###Q6----
Num = read_xlsx('catheter.xlsx');
Height = pull(Num[,2])
Weight = pull(Num[,3])


#a is the first column of L1 and L2
#calculate span of L1 & L2
a  = array(1,12)
b1 = Height
b2 = Weight

#Using span to calculate projection vectors
projection1 = (a%*%b1/(norm(a,"2")^2))%*%a
projection2 = (a%*%b2/(norm(a,"2")^2))%*%a

u = as.vector(b1 - projection1)
v = as.vector(b2 - projection2)

#Calculating the angle between spaces
costheta = (u%*%v)/(norm(u,"2")*norm(v,"2"))
thetarad = acos(costheta)
thetadeg = 180*thetarad/pi