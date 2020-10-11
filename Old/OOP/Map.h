#ifndef MAP_H
#define MAP_H
#include <iostream>
#include <string>
#include "Tile.h"
class Map:
{
	public:
		Map(int,int);
	protected:
		int width;
		int height;
	private:
		Tile **mapptrarray;
		void printMap(); //prints the map array which is an array of tiles
		
};

#endif