#include"Tile.h"
#include "Map.h"
#include <fstream>
#include <iostream>

Tile::Tile(char symb)
{
	symbol = symb;
	if (symbol == '#')
	{
		passable = false;
	}
}
Tile::~Tile()
{
}
