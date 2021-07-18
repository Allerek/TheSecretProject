//Enumeratory

//Stocki
stock IsRpNickname(const nickname[])
{
    new Regex:r = Regex_New("[A-Z][a-z]+_[A-Z][a-z]+");

    new check = Regex_Check(nickname, r);

    Regex_Delete(r);

    return check;
}

stock SendPlayerError(playerid, const message[])
{
    new formatted[128];
    format(formatted,sizeof(formatted),"[%s] %s",SERVER_S_NAME,message);
    SendClientMessage(playerid, X11_RED, formatted);
    return 1;
}

stock SendPlayerSuccess(playerid, const message[])
{
    new formatted[128];
    format(formatted,sizeof(formatted),"* %s",message);
    SendClientMessage(playerid, X11_GREEN, formatted);
    return 1;
}

stock SendPlayerInfo(playerid, const message[])
{
    new formatted[128];
    format(formatted,sizeof(formatted),"* %s",message);
    SendClientMessage(playerid, X11_BLUE, formatted);
    return 1;
}

stock ClearPlayerChat(playerid)
{
    for(new i; i<15;i++){
        SendClientMessage(playerid, -1,"");
    }
}

stock IsPlayerLoggedIn(playerid)
{
    if(IsPlayerConnected(playerid))
    {
        new loggedin = GetPVarInt(playerid, "LoggedIn");
        if(loggedin)
            return 1;
        return 0;
    }
    return 0;
}