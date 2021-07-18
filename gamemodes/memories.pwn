#include <a_samp>
#include <fixes> 

#include <a_mysql>
#include <core>
#include <float>
#include <Pawn.Regex>
#include <samp_bcrypt>
#include <YSI_Coding\y_inline>
#include <YSI_Extra\y_inline_bcrypt>
#include <YSI_Extra\y_inline_mysql>
#include <YSI_Visual\y_commands>
#include <json>
#include <sscanf2>


//Lista kolorów https://github.com/YSI-Server/y_colours/blob/dev/YSI-Server/y_colours/y_colours_x11def.inc
#include <YSI_Server\y_colours>

#define SERVER_NAME "The Secret Project"
#define SERVER_S_NAME "TSP"
#define SERVER_VERSION "0.0.1a"
#define DEBUG_SERVER
#if defined DEBUG_SERVER
	#include "extensions/debug.pwn"
#endif
#pragma warning disable 239, 214, 217 //Te warningi nie maja znaczenia, wina kompilatora https://www.burgershot.gg/showthread.php?tid=1556

new MySQL:MySQL;

#include "extensions/utils.pwn"
#include "extensions/login.pwn"
#include "extensions/medo.pwn"
#include "extensions/admin.pwn"

main(){}

public OnGameModeInit()
{
	#if defined DEBUG_SERVER
		OnDebugInit();
	#endif
    print("  ");
	print(" ____    ____  ________  ____    ____   ___   _______     _____  ________   ______  ");
	print("|_   \\  /   _||_   __  ||_   \\  /   _|.'   `.|_   __ \\   |_   _||_   __  |.' ____ \\  ");
	print("  |   \\/   |    | |_ \\_|  |   \\/   | /  .-.  \\ | |__) |    | |    | |_ \\_|| (___ \\_| ");
	print("  | |\\  /| |    |  _| _   | |\\  /| | | |   | | |  __ /     | |    |  _| _  _.____`.  ");
	print(" _| |_\\/_| |_  _| |__/ | _| |_\\/_| |_\\  `-'  /_| |  \\ \\_  _| |_  _| |__/ || \\____) | ");
	print("|_____||_____||________||_____||_____|`.___.'|____| |___||_____||________| \\______.' ");
	print("  ");

	MySQL = mysql_connect_file("mysql.ini");
	print("[MYSQL-LOG] Trwa ³¹czenie z baz¹...");
	if(MySQL == MYSQL_INVALID_HANDLE || mysql_errno(MySQL) != 0){
		//Prawdopodobnie i tak nigdy siê nie wyœwietli bo serwer sie wyjebie po paru próbach
		print("[MYSQL-LOG] Nie po³¹czono z baz¹ danych.");
		SendRconCommand("exit");
		return 0;
	}
	print("[MYSQL-LOG] Po³¹czono z baz¹ danych...");
	new title[128];
	format(title, sizeof(title), "%s v%s",SERVER_NAME, SERVER_VERSION);
	SetGameModeText(title);

	return 1;
}
