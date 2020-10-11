#include <iostream>
#include <string>
#include "Entity.h"
#include "Player.h"
void help() //help function 
{
    std::cout<<"Give a single number input to move (1-9), input q to quit, and h for this message"<<std::endl;
}

bool humaninput(Player * human,Entity ** npcarray) //human input - takes char input and calls a function
{
    bool turn=true;
    char input;

	while(turn==true) //this way if you input h it doesn't end your turn
		std::cin >> input;
		std::cin.ignore(256, '\n'); //only takes in first character from input and removes the rest
		switch (input) //case 1-9\5 will move you in that direction from 5. 5 is neutral (stand still) q to quit h for help
		{
		    case '1':
				human->movement(1,npcarray);
				turn=false;
				break;
		    case '2':
				human->movement(2,npcarray);
				turn=false;
				break;
			case '3':
				human->movement(3,npcarray);
				turn=false;
				break;
			case '4':
				human->movement(4,npcarray);
				turn=false;
				break;
			case '5': //5 is neutral so this is waiting
			    std::cout<<"waiting/10"<<std::endl;
			    turn=false;
			    break;
			case '6':
			    human->movement(6,npcarray);
			    turn=false;
				break;
			case '7':
				human->movement(7,npcarray);
			    turn=false;
				break;
			case '8':
				human->movement(8,npcarray);
				turn=false;
				break;
			case '9':
				human->movement(9,npcarray);
				turn=false;
				break;
			case 'q':
				turn = false;
				return false;
			case 'h':
				help();
			default: //in case a non-expected input is given the player can move again
                std::cout<<"Numbers for directional movement, a to attack, q to quit and h for help"<<std::endl;
            }
    return true; //this tells the game to keep running
}



