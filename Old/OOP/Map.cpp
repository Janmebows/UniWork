#include"Tile.h"
#include "Map.h"
#include <fstream>

Map::Map(int wide, int high,Tile * tilearr)	//uses ifstream to read txt file and store everything in tilearr
{
	width = wide;
	hight = high;
	std::ifstream is("map.txt");
	char store;
	int i=0
	while (is.get(store))
	{
		*(tilearray + i) = Tile(store);
		
		i++;
	}
	//need to store values in tilearr which will be size width*height

}


Map::printMap()
{
	for (int currentheight=0;currentheight<height;currentheight++)
	{
		for (int currentwidth = 0; currentwidth<width; currentwidth++)
		{
			std::cout << (*((*mapptrarray)+(currentheight * width + currentheight)))->getSymbol; //dereferences the memory of the array, finds the element, adds i*10 and j and then dereferences - to use the getSymbol function
		}
		std::endl;
	}

}

