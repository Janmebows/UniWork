#include "Entity.h"
#include <iostream>
#include <cmath>
#include "Player.h"
int Entity::id = 0; //initialises id to zero
Entity::Entity() //initialises stats and id
{
	uniqueid = id;
	id++; 
	maxhp = 100; //sets the base stats so that an enemy doesn't rock up with 0 hp, 0 attack, etc.
	currenthp=100;
	damage = 10;
	defence = 10;
	*(coordinates)=10*uniqueid; //every character spawns in a different place based on id
	*(coordinates+1)=10*uniqueid;
}



void Entity::printCoords() //virtual function which gives npc coordinates
{
    std::cout<<"npc "<<uniqueid<<" is at";
	std::cout<<'['<<*(coordinates)<<", "<<*(coordinates+1)<<']'<<std::endl;
}

void Entity::movement(Entity * human) //virtual movement function -> moves towards the player and attacks when adjacent
{
	int coorddif[2];
    for (int i=0;i<2;i++)
    {
        
        coorddif[i]=(*(coordinates+i))-human->coordinates[i];

        if (coorddif[i]<1)  //if gap between npc and human is more than 1 tile the npc will move towards the human -> this still only allows for one movement by the npc even though it is in a for loop, as it changes x in first run and y in second
        {
            (*(coordinates+i))+=1;
        }
        else if(coorddif[i]>-1)
        {
            (*(coordinates+i))-=1;
        }

    }
	if (abs(coorddif[0]==1)) //not in for loop as both must be true to attack
	{
		if (abs(coorddif[1]==1))
		{
		    human->loseHealth(this);
		}
	}
	printCoords(); //prints the npcs coordinates
}
void Entity::loseHealth(Entity * attacker) //function to TAKE damage -> when player attacks entity, entity calls this function.
{
	int attackerDamage = (attacker->returnDamage()); //finds the attackers damage and stores it 
    if ((defence/2)>(attackerDamage)) //if the defence of the target is at least twice as high as the attacker's attack, the target will still take 1 damage
    {
        currenthp-=1; 
    }
    else
    {
        int damagetaken=((attackerDamage)-ceil(defence/2)+1); //attack take half the defence (rounded up) and then add one so damage is always dealt -> always an integer
        currenthp-=damagetaken;
    }
	std::cout << returnHP() << std::endl; //when taking damage, HP is printed
    if (currenthp<=0)
    {
        delete this; //when hp is below zero, they are freed from memory -> a new one may be made some day
    }

}
int Entity::returnHP() //just prints current hp
{
	return currenthp;
}
int Entity::returnDamage() //returns the damage -> used for the loseHealth function
{
	return damage;
}


Entity::~Entity()
{
}


