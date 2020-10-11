#ifndef NPC_H
#define NPC_H
#include <string>

class NPC
{
	public:
		static int id;
		int uniqueid; 	//this allows to give each NPC a turn and makes them more easily identified (duh)
		NPC(int playerlevel);
		std::string name;
		~NPC();
	protected:
		int hp;
		int attack;
		int defence;
		char symbol;
		int coordinates[2];
		char currenttile;
		bool isplayer;
		int * coordptr = &coordinates;
	private:
		std::string interaction;
		int hostility;
		void movement(std::string); //NB this coordinate is the player's
		void stat_allocate(int);
		int totalstat();
		void initsetcoords(int *); //make sure to call this with &coordinates
		
		
};

#endif