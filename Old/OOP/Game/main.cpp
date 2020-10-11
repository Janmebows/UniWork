#include "Entity.h"
#include "Player.h"
//#include "Tile.h"
//#include "map.h"
#include <iostream>
#include <string>

extern void help(); //external functions - help just prints out controls
extern bool humaninput(Player*,Entity**); //human input takes an input and turns it into a command 1-9,q,h

int main()
{
	char input; 


	//init I/O (starting game etc.)
	std::cout<<"Rip u"<<std::endl;
	std::cout<<"Input q to quit, h for help, and anything else to start the game"<<std::endl;
	std::cin>>input;
	switch (input)
	{
		case 'q': return -1; //allows to exit game
		case 'h': help(); break; //if not sure of controls can call help to learn
		default: break;
	}
		//generates player and a few NPCs
	Player *human = new Player(); 
	Entity *npc1 = new Entity();
	Entity *npc2 = new Entity();
	//Array containing pointers to all the Entities such that they can be passed to functions and the coords can be printed
	Entity *npcarray[2]={npc1,npc2};

	bool play=true; //when play is false the game will close

	for (int i = 0; i<2; i++)
	{
		npcarray[i]->printCoords(); //prints the npcs coordinates so you know where to run from/to
	}
	human->printCoords(); //gives you your initial coordinates
	while(play)
	{

		play=humaninput(human,npcarray); //human input to determine movement/quit/help
		for(int i=0;i<2;i++)
		{
			npcarray[i]->movement(human); //npcs just move 1 square towards human -> attack when adjacent
		}
		if ((human->returnHP()) <= 0)
		play = false;
	}
	for(int i=0;i<2;i++)
	{
		delete *(npcarray+i); //freeing heap memory for all created npcs
	}
	delete human; //freeing human memory
	return 0; //ends game
}


