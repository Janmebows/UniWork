#include <iostream>
#include <string>

void help()
{
	std::cout<<"WELL YOU'RE IN TOO DEEP BOY, GOOD LUCK"<<std::endl;
}

void save()
{
	std::cout<<"yes... we totally saved your progress"<<std::endl;
}

void humaninput()
{
	do
			{	std::cout<<"Your turn"<<std::endl;
				std::cin<<input<<std::endl;
				switch input
				{
					case "q":
						save();
						return 0;
					case "h":
						help();
						break;
					case "1":
						movement('downleft');
						break;
					case "2":
						movement('down');
						break;
					case "3":
						movement('downright');
						break;
					case "4":
						movement('left');
						break;
					case "5":
						movement('wait');
						break;
					case "6":
						movement('right');
						break;
					case "7":
						movement('upleft');
						break;
					case "8":
						movement('up');
						break;
					case "9":
						movement('upright');
						break;
					case "a":
						attack();
						break;
					default:
						std::cout<<"Numbers for directional movement, a to attack, q to quit and h for help"<<std::endl;
						break;
				}
			}while(input!="a"||"1"||"2"||"3"||"4"||"5"||"6"||"7"||"8"||"9");
	return 0;
}
void prcoords(NPC *npcarray ,int length)
{
	for (int i; i < length; i++)
	{
		*(npcarray + i);
	}
}