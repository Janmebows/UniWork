#ifndef ENTITY_H
#define ENTITY_H
#include <string>

class Entity
{
	public:
        void loseHealth(Entity*);
		int uniqueid; 	//this allows to give each Entity a turn and makes them more easily identified (duh)
		Entity();	//constructor -> gives maxhp=100, currenthp=maxhp, damage=10, defence=10, and sets coordinates based on id
		~Entity();	//destructor
		virtual void movement(Entity*); //virtual function -> different to player movement.
										//npc will move towards player, and if adjacent, will attack
		virtual void printCoords();		//virtual function with slightly different output "NPC (id) is at [x, y]"
		int returnHP();					//prints out the entity's current HP
		int returnDamage();				//allows other functions to use the damage of the npc
		int coordinates[2];			//[x,y] coordinates of the entity
	protected:
	    int maxhp;				//hit points - starts at 100 
        int currenthp;			//current hp - always equal to or lower than max hp -> entity dies when currenthp<=0
		int damage;				//damage dealt -> is reduced by enemy defence and then reduces the enemies currenthp
		int defence;			//damage reduction -> reduces damage taken
	private:
		static int id;			//used to make sure npcs do not spawn on top of each other and to separate their IDs

};

#endif
