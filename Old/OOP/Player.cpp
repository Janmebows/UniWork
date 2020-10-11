#include "Player.h"
#include "NPC.h"

Player::Player():NPC()
{
	isplayer = true;
}


void gainexperience() //gains experience based on a function of the NPC's total stat
{				//This function should also vary based on player level (less exp if you are higher level)
	experience++;
	if (experience >= 5)
	{
		levelup();
	}
}
void levelup() //randomly increases stats (integers from 1-3 or something)
{
	hp+=2;
	attack++;
	def++;
}