#include "NPC.h"
#include "Player.h"
#include "Tile.h"
#include "map.h"
#include <iostream>
#include <string>

extern void save();
extern void help();
extern void humaninput();
extern void printcoords(NPC *);

int main()
{
	char input;


	//init input (starting game etc.)
	std::cout<<"Rip u"<<std::endl;
	std::cout<<"Input q to quit, h for help, and anything else to start the game"<<std::endl;
	std::cin<<input<<std::endl;
	switch input
	{
		case "q": save(); break;
		case "h": help(); break;
		default: break;
	}
		//character creation
	Player *human = new Player();
		NPC *npc1 = new NPC();
		NPC *npc2 = new NPC();
		//determine factors of game? number of npcs

		//Array containing pointers to all the NPCS and the player such that the coords can be printed
		
		NPC *npcarray[2]={npc1,npc2}
		


		while(true)
		{

			//temporarily only prints coordinates of you and an enemy
			printcoords(npcarray);

			humaninput();
						//npc movement - mad ai
			npcmovement();
			//calculations

	}
	return 0;
}



//Whenever returning 0, use some save function