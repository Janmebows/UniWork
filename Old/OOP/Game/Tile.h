#ifndef TILE_H
#define TILE_H
#include <iostream>
#include <string>
#include "Entity.h"
class Tile: 
{
	public:
		char symbol; //this needs to temporarily change if a player is on it
		bool passable; //passable/impassable
		Tile(char); //will use symbol to deduce type
		Entity * occupier;
	protected:

	
	private:
		
		char getSymbol();
};

#endif