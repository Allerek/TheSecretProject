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

stock ClearPlayerChat(playerid){
    for(new i; i<15;i++){
        SendClientMessage(playerid, -1,"");
    }
}
