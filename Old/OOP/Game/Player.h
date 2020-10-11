#ifndef PLAYER_H
#define PLAYER_H
#include "Entity.h"
#include <iostream>
#include <string>

class Player: public Entity
{
	public:
	    void levelUp(); //when exp>=100 stats increase and exp is reduced by 100
	    void addExp(); //called when attacking -> adds 25-50 exp
	    void printExp(); //gives current exp
	    void printCoords(); //prints out [x,y] of your coordinates
		Player(); //constructor -> comes from entity constructor mostly
		~Player(); //destructor
		void movement(int,Entity**); //takes input from humaninput function and moves you in that direction. 
									 //if occupied by an npc, you attack that npc
		void attack(Entity*); //called when the space you move to is occupied
	protected:
		int experience; //value for levelups


};

#endif
