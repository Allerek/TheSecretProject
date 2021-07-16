#define COLOR_ME 0xC2A2DAFF
#define COLOR_DO 0x9D94E1FF

YCMD:do(playerid, params[], help)
{
	if (isnull(params))
		return SendPlayerError(playerid, "Musisz uwzgl�dni� jak�� akcj�.");

	new str[256];
	format(str, sizeof(str), "* %s (( %s )).", params, ReturnPlayerName(playerid));
	#if defined DEBUG_SERVER
		new dstr[256];
		format(dstr, sizeof(dstr), "[DEBUG-DO] %s", str);
		print(dstr);
	#endif

	return SendClientMessageToAll(COLOR_DO, str);
}

YCMD:me(playerid, params[], help)
{
	if (isnull(params))
		return SendPlayerError(playerid, "Musisz uwzgl�dni� jak�� akcj�.");

	new str[256];
	format(str, sizeof (str), "* %s %s.", ReturnPlayerName(playerid), params);
	#if defined DEBUG_SERVER
		new dstr[256];
		format(dstr, sizeof(dstr), "[DEBUG-ME] %s", str);
		print(dstr);
	#endif

	return SendClientMessageToAll(COLOR_ME, str);
}

YCMD:sprobuj(playerid, params[], help)
{
	if (isnull(params))
		return SendPlayerError(playerid, "Musisz uwzgl�dni� jak�� akcj�.");

	new str[256];
	new rand = random(2);
	switch(rand)
	{
		case 0: format(str, sizeof(str), "*** %s spr�bowa� %s i uda�o mu si� ***", ReturnPlayerName(playerid), params);
		case 1: format(str, sizeof(str), "*** %s spr�bowa� %s i nie uda�o mu si� ***", ReturnPlayerName(playerid), params);
	}
	
	#if defined DEBUG_SERVER
		new dstr[256];
		format(dstr, sizeof(dstr), "[DEBUG-SPROBUJ] %s", str);
		print(dstr);
	#endif

	return SendClientMessageToAll(COLOR_ME, str);
}

