#include "NPC.h"

static int id = 0;
NPC::NPC()
{
	uniqueid=id;
	id++;
	hp = 10; //sets the base stats so that an enemy doesn't rock up with 0 hp, 0 attack, etc.
	attack = 1;
	defence = 1;
	initsetcoords(coordptr);
	isplayer = false;
}

int NPC::totalstat()
{
	return (hp+attack+defence);
}

void NPC::initsetcoords(int *coordptr )
{
	if (isplayer)
	{
		*(coordptr) = 1;
		*(coordptr + 1) = 1;
	}
}

