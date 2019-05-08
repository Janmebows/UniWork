import turtle 
import random
import time

delay = 0.3 #deplay between refreshing the model
scalar = 1 #changes the size of the model

baseBeta = 0.5333
baseGamma = 0.3333
faceMasks = True
vacination = True
 
NumOfPeriods = 6
NumOfSubPeriods = 3
initialInfectedNumber = 1

beta = baseBeta / NumOfPeriods / NumOfSubPeriods
gamma = baseGamma / NumOfPeriods /NumOfSubPeriods

if faceMasks:
    beta = 0.75*beta
if vacination:
    gamma = 0.66 * gamma


#setting up the screen 
wn = turtle.Screen()
wn.title("epidemic in school")
wn.bgcolor("white")
wn.setup(width=600*scalar, height=600*scalar)
wn.tracer(0) #turns off the screen updates

#drawer to draw the buildings
drawer = turtle.Turtle()
drawer.speed(0)
drawer.pensize(5)
drawer.penup()
drawer.shapesize(0.1)
#Classes
class Student:
    def __init__(self):
        self.student = turtle.Turtle()
        self.student.speed(0)
        self.student.penup()
        self.xlocation=0
        self.ylocation=0
        self.susceptible = True 
        self.infected = False
        self.recovered = False
        self.timetable =  random.sample(range(1,9),NumOfPeriods)

    def Move(self,xpos,ypos):
        self.xlocation +=xpos
        self.ylocation +=ypos
        self.student.goto(self.xlocation,self.ylocation)

    def Goto(self, xpos, ypos):
        self.xlocation = xpos
        self.ylocation = ypos
        self.student.goto(self.xlocation, self.ylocation)

    def Suscept(self):
        self.susceptible = True
        self.student.color("black")

    def Infect(self):
        self.infected = True
        self.student.color("red")

    def Recover(self):
        self.infected = False
        self.recovered = True
        self.student.color("green")

        
class Room():
    def __init__(self, xpos, ypos,xdim, ydim, colour):
        DrawRoom(xpos, ypos,xdim, ydim, colour)
        self.xlocation = xpos
        self.ylocation = ypos
        self.infectousRating = 0

#functions 
def DrawRoom(xpos, ypos,xdim, ydim, colour):
    #draws a room, 
    #xpos, ypos are the center of the room
    #xdim, ydim are the x and y length and width of the room
    #color is the colour of the boarder
    drawer.color(colour)
    drawer.goto(xpos-(xdim/2),ypos-(ydim/2))
    drawer.pendown()
    drawer.goto(xpos+(xdim/2),ypos-(ydim/2))
    drawer.goto(xpos+(xdim/2),ypos+(ydim/2))
    drawer.goto(xpos-(xdim/2),ypos+(ydim/2))
    drawer.goto(xpos-(xdim/2),ypos-(ydim/2))
    drawer.penup()
 
#keyboard bindings
#wn.listen()
# wn.onkeypress(go_up, "w")

#main simulation loop
classList =[Student() for i in range(200)]
schoolRooms =[Room(0,0,100*scalar,400*scalar,"Black"),
        #right rooms
        Room(100*scalar, 150*scalar, 100*scalar, 100*scalar, "black"),
        Room(100*scalar, 50*scalar, 100*scalar, 100*scalar, "black"),
        Room(100*scalar, -50*scalar, 100*scalar, 100*scalar, "black"),
        Room(100*scalar, -150*scalar, 100*scalar, 100*scalar, "black"),
        #left rooms
        Room(-100*scalar, 150*scalar, 100*scalar, 100*scalar, "black"),
        Room(-100*scalar, 50*scalar, 100*scalar, 100*scalar, "black"),
        Room(-100*scalar, -50*scalar, 100*scalar, 100*scalar, "black"),
        Room(-100*scalar, -150*scalar, 100*scalar, 100*scalar, "black")]

for i in range(200):
    #sends all students to the first element on their timetable 
    classListTimtable = classList[i].timetable[0]
    classList[i].Goto(schoolRooms[classListTimtable].xlocation,schoolRooms[classListTimtable].ylocation)
    classList[i].Move(random.randint(-40,40),random.randint(-40,40))

#print(classList[3].timetable)

sickNumber = 1
for i in range(initialInfectedNumber):
    classList[i].Infect() #makes the first effected person
recoverNumber = 0
currentPeriod = 0
currentSubPeriod = 0
while True:
    wn.update()

    for i in range(200):
        if classList[i].infected==True:
            schoolRooms[classList[i].timetable[currentPeriod]].infectousRating +=1

    for i in range(200):
        if schoolRooms[classList[i].timetable[currentPeriod]].infectousRating > 0: #in an infected class room
            if classList[i].recovered == False:
                sick = random.random()
                if sick>1-beta*(schoolRooms[classList[i].timetable[currentPeriod]].infectousRating)/25:
                    classList[i].Infect()
                    sickNumber +=1

    for i in range(200):
        if classList[i].infected == True:
            recov = random.random()
            if recov >1-gamma:
                classList[i].Recover()
                sickNumber -=1
                recoverNumber +=1


    time.sleep(delay)

    for i in range(200):
        #sends all students to the first element on their timetable 
        classListTimtable = classList[i].timetable[currentPeriod]
        classList[i].Goto(schoolRooms[classListTimtable].xlocation,schoolRooms[classListTimtable].ylocation)
        classList[i].Move(random.randint(-40,40),random.randint(-40,40))


    currentSubPeriod += 1
    if currentSubPeriod == NumOfSubPeriods:
        currentPeriod +=1
        currentSubPeriod =0
        if currentPeriod == NumOfPeriods:
            currentPeriod = 0 # it becomes a new day



wn.mainloop() #keeps the window open the whole simulation
