#ifndef TILE_H
#define TILE_H
#include <iostream>
#include <string>

class Tile: 
{
	public:
		char symbol; //this needs to temporarily change if a player is on it
		int type; /*value between 0-4 ->
					0= default
					1=increases defence
					2=increases attack
					3=decreases defence
					4=decreases attack
					*/

	protected:
		bool isoccupied;

	
	private:
		Tile(symbol); //will use symbol to deduce type
		void changetile(char currenttile);
		char getSymbol();
};

#endif