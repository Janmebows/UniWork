#include "Player.h"
#include "Entity.h"
#include <iostream>
#include <cstdlib>
Player::Player():Entity() //calls the entity constructor and gives slightly different coordinates
{
	experience = 0;
}

void Player::movement(int dir,Entity ** npcarray) //function which based on single number input will move the player in that direction in respect to 5 on the numpad - if space is occupied, player will instead attack
{
	
	int x, y = 0; //x and y are just a conversion from the input to a direction
	switch (dir)			
	{
		case 1:
			x = -1;
			y = -1;
			break;
		case 2:
			y = -1;
			
			break;
		case 3:
			x = 1;
			y = -1;
			break;
		case 4:
			x = -1;
			break;
		case 5:
			std::cout<<"waiting/10"<<std::endl;
			break;
		case 6:
			x = 1;
			break;
		case 7:
			x = -1;
			y = 1;
			break;
		case 8:
			y = 1;
			break;
		case 9:
			x = 1;
			y = 1;
			break;
		default:
			std::cout << "SOMETHING WENT HORRIBLY WRONG" << std::endl;
		
	}
	bool move = true; //assumes that space will be empty 
	for (int i = 0; i<2; i++) //hardcoded lengths for number of npcs
	{
		int coordx=(*(npcarray + i))->coordinates[0]; //shortening the if statement -> storing coordinate in a temporary int and then checking if the movement will send the player to the coordinate of an entity
		int coordy = (*(npcarray + i))->coordinates[1];
		if ((((*coordinates)+x) == coordx && ((*(coordinates + 1)) + y == coordy))) //if it does do the above, instead of moving, the player attacks the npc
		{
			attack(*(npcarray + i)); //attacks the npc on the occupied space
			move = false; //disallows the player to move to the occupied space
		}
	}
	if (move == true) //if space was empty player will move to it
	{
		(*(coordinates)) += x;
		(*(coordinates + 1)) += y;
		if (currenthp < maxhp) //player will heal 1hp when not attacking, until they reach maxhp
		{
			currenthp++;
		}
	}
	printCoords();
}

void Player::printCoords() //prints coordinates of the player in a readable way "You are at [x, y]
{
    std::cout<<"You are at "<<'['<<*(coordinates)<<", "<<*(coordinates+1)<<']'<<std::endl;
}

void Player::addExp() //gains experience based on a function of the Entity's total stat
{					  //This function should also vary based on player level (less exp if you are higher level)
	experience+=rand()%25+26; //gains 25-50 exp on kill
	if (experience >= 100)
	{
	    experience-=100; //removes 100 exp and levels up the player if exp >=100 (exp will never go below 0)
		levelUp();
	}
	printExp();
}

void Player::printExp()
{
	std::cout << experience << std::endl;
}
void Player::levelUp() //randomly increases stats (integers from 1-3 or something)
{
	std::cout << "You levelled up!" << std::endl;
    maxhp+=rand()%5+2; //will gain 2 to 6 hp, 1 to 3 damage, 1 to 3 defence on level up
    damage+=rand()%3+1; //1-3 damage gain
    defence+=rand()%3+1; //1-3 def gain
}


Player::~Player()
{
}


void Player::attack(Entity*target) //to attack it calls the losehealth function and then adds exp to the player
{
	target->loseHealth(this);

	addExp();
}




