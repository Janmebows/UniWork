#ifndef PLAYER_H
#define PLAYER_H
#include "NPC.h"
#include <iostream>
#include <string>

class Player: protected NPC 
{
	public:
		Player();
	protected:
		int experience;
		int level;

	private:
		void gainexperience(); //gains experience based on a function of the NPC's total stat
										//This function should also vary based on player level (less exp if you are higher level)
		void levelup(); //randomly increases stats (integers from 1-3 or something)

};

#endif