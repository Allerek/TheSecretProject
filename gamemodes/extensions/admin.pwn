

stock ReturnAdminLevel(playerid)
{
    new adminlvl =  GetPVarInt(playerid, "AdminLvl");
    if(adminlvl)
        return adminlvl;
    return 0;
}

YCMD:dajadmina(playerid, params[], help)
{
    new targetid,adminlvl;
	if (sscanf(params, "ui", targetid, adminlvl))
		return SendPlayerError(playerid, "U¿ycie /dajadmina [ID Gracza] [Level 1-5]");
    if(ReturnAdminLevel(playerid) == 6)
    {
       if(IsPlayerLoggedIn(targetid)){
            if(adminlvl > 0 && adminlvl <= 5){
                SetPVarInt(targetid, "AdminLvl", adminlvl);
                new msg[128];
                format(msg,sizeof(msg), "Nadano %s poziom administratora %i.", ReturnPlayerName(targetid), adminlvl);
                SendPlayerSuccess(playerid, msg);
                format(msg,sizeof(msg), "Administrator %s nada³ ci poziom administratora %i.", ReturnPlayerName(playerid), adminlvl);
                SendPlayerInfo(targetid, msg);
            }else if(adminlvl == 0){
                DeletePVar(targetid, "AdminLvl");
                new msg[128];
                format(msg,sizeof(msg), "Zabrano %s uprawnienia administratora.", ReturnPlayerName(targetid));
                SendPlayerSuccess(playerid, msg);
                format(msg,sizeof(msg), "Administrator %s zabra³ ci uprawnienia administratora.", ReturnPlayerName(playerid));
                SendPlayerInfo(targetid, msg);
            }else{
                SendPlayerError(playerid,"Wprowadzono za wysoki level administratora!");        
            }
       }else{
           SendPlayerError(playerid, "Tego gracza nie ma na serwerze, lub nie jest zalogowany.");
       }
    }else{
         SendPlayerError(playerid,"Nie masz uprawnieñ! :("); 
    }
    return 1;
}