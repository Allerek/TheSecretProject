#define DIALOG_LOGIN 1
#define DIALOG_LASTPOS 2
#define DIALOG_ADMINPASS 3

public OnPlayerConnect(playerid){
    if(!IsRpNickname(ReturnPlayerName(playerid)))
    {
        SendPlayerError(playerid, "Z³y format nicku, nick powinien mieæ format: Imiê_Nazwisko !!!");
        SetTimerEx("DelayedKick", 100, false, "i", playerid);
        return 1;
    }else{

        inline const OnCheckForCharacter()
        {
            if(cache_num_rows() < 1){
                SendPlayerError(playerid, "Nie znaleziono postaci, za³ó¿ j¹ na forum!");
                SetTimerEx("DelayedKick", 100, false, "i", playerid);
            }else{
                inline const OnAccountFound()
                {
                    new title[128];
                    format(title, sizeof(title), "Znaleziono postaæ %s wpisz has³o do konta na forum by siê zalogowaæ!\nJeœli nie znasz has³a do tego konta, wejdŸ pod innym nickiem.", ReturnPlayerName(playerid));
                    ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Logowanie do konta", title, "Zaloguj", "WyjdŸ");
                    new login[256];
                    new gid;
                    new pass[256];
                    cache_get_value_name(0, "name", login);
                    cache_get_value_int(0, "member_id", gid);
                    cache_get_value_name(0, "members_pass_hash", pass);
                    SetPVarString(playerid, "Login", login);
                    SetPVarInt(playerid, "GID", gid);
                    SetPVarString(playerid, "Password", pass);
                }

                new ownerid;
                new charid;
                new skinid;
                new gender;
                new age;
                new money;
                new origin[10];
                new lastPos[256];
                cache_get_value_int(0, "ownerid", ownerid);
                cache_get_value_int(0, "id", charid);
                cache_get_value_int(0, "skin", skinid);
                cache_get_value_int(0, "gender", gender);
                cache_get_value_int(0, "age", age);
                cache_get_value_int(0, "money", money);
                cache_get_value_name(0, "origin", origin);
                cache_get_value_name(0, "lastpos", lastPos);
                SetPVarInt(playerid, "ID", charid);
                SetPVarInt(playerid, "Skin", skinid);
                SetPVarInt(playerid, "Gender", gender);
                SetPVarInt(playerid, "Age", age);
                SetPVarInt(playerid, "Money", money);
                SetPVarString(playerid, "Origin", origin);
                SetPVarString(playerid, "LastPos", lastPos);
                MySQL_PQueryInline(MySQL, using inline OnAccountFound, "SELECT * FROM `ips_core_members` WHERE `member_id` = '%i' ", ownerid);
            }
        }
        MySQL_PQueryInline(MySQL, using inline OnCheckForCharacter,"SELECT * FROM `samp_characters` WHERE `name` = '%s' ",ReturnPlayerName(playerid));
        SetPVarInt(playerid, "PasswordTries", 0);
    }
    SetTimerEx("DelayedWelcome", 500, false, "i", playerid);

    return 1;
}

forward DelayedWelcome(playerid);
public DelayedWelcome(playerid)
{
    ClearPlayerChat(playerid);
    new message[128];
    format(message, sizeof(message), "Witaj na serwerze %s! Zaloguj siê aby rozpocz¹æ grê.", SERVER_NAME);
    SendClientMessage(playerid, X11_YELLOW, message);
}

forward DelayedKick(playerid);
public DelayedKick(playerid)
{
    Kick(playerid);
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]){
    switch(dialogid){
        case DIALOG_LOGIN:{
            if(response){
                inline const OnPasswordVerify(bool:success)
                {
                    if(success){
                        #if defined DEBUG_SERVER
                            ShowPlayerDialog(playerid, DIALOG_LASTPOS, DIALOG_STYLE_MSGBOX, "Ostatnia pozycja", "Znaleziono twoj¹ ostatni¹ pozycjê\nCzy chcesz j¹ przywróciæ?", "Tak", "Nie"); // Co by nie wkurwia³o przy tworzeniu serwera, pomijamy has³o admina na DEBUG Build
                        #else
                            inline const OnCheckForAdmin()
                            {
                                if(cache_num_rows() > 0 )
                                {
                                    new adminpass[256];
                                    cache_get_value_name(0,"securitypass", adminpass);
                                    SetPVarString(playerid, "AdminPass", adminpass);
                                    ShowPlayerDialog(playerid, DIALOG_ADMINPASS, DIALOG_STYLE_PASSWORD, "Logowanie jako administrator","Logujesz siê jako cz³onek administracji. Zostajesz poproszony o wpisanie w\nponi¿sze pole has³a weryfikacyjnego. Pamiêtaj, aby nie podawaæ go nikomu!", "Akceptuj", "WyjdŸ");
                                }else{
                                    ShowPlayerDialog(playerid, DIALOG_LASTPOS, DIALOG_STYLE_MSGBOX, "Ostatnia pozycja", "Znaleziono twoj¹ ostatni¹ pozycjê\nCzy chcesz j¹ przywróciæ?", "Tak", "Nie");
                                }
                            }
                            MySQL_PQueryInline(MySQL, using inline OnCheckForAdmin,"SELECT * FROM `samp_admins` WHERE `charid` = '%i' AND `active` = '1' ",GetPVarInt(playerid,"ID"));
                        #endif
                    }else{
                        SetPVarInt(playerid, "PasswordTries", GetPVarInt(playerid, "PasswordTries")+1);
                        if(GetPVarInt(playerid, "PasswordTries") == 3){
                            SendPlayerError(playerid, "Za du¿o prób wpisania has³a.");
                            SetTimerEx("DelayedKick", 100, false, "i", playerid);
                        }else{
                            new message[128];
                            format(message, sizeof(message), "Has³o nieprawid³owe, spróbuj ponownie[%i/3].", GetPVarInt(playerid, "PasswordTries"));
                            SendPlayerError(playerid, message);
                            new title[128];
                            format(title, sizeof(title), "Znaleziono postaæ %s wpisz has³o do konta na forum by siê zalogowaæ!\nJeœli nie znasz has³a do tego konta, wejdŸ pod innym nickiem.", ReturnPlayerName(playerid));
                            ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Logowanie do konta", title, "Zaloguj", "WyjdŸ");
                        }
                    }
                }
                new password[256];
                GetPVarString(playerid, "Password", password, sizeof(password));
                BCrypt_CheckInline(inputtext,password, using inline OnPasswordVerify);
            }else{
                SendPlayerError(playerid, "Wyszed³eœ z serwera, zosta³eœ roz³¹czony. Zapraszamy ponownie!");
                SetTimerEx("DelayedKick", 100, false, "i", playerid);
            }
        }
        case DIALOG_LASTPOS:{
            ClearPlayerChat(playerid);
            new message[128];
            format(message, sizeof(message), "Witaj na serwerze %s, %s!", SERVER_NAME, ReturnPlayerName(playerid));
            TogglePlayerSpectating(playerid,false);
            if(response){    
                new lastPos[256];
                GetPVarString(playerid, "LastPos", lastPos, sizeof(lastPos));
                new Node:node = JSON_Object(lastPos);
                new Float:x, Float:y, Float:z;
                JSON_GetFloat(node,"x",x);
                JSON_GetFloat(node,"y",y);
                JSON_GetFloat(node,"z",z);
                SetSpawnInfo(playerid, NO_TEAM, GetPVarInt(playerid, "Skin"), x,y,z,0.0, 0, 0, 0, 0, 0, 0);
            }else{
                SetSpawnInfo(playerid, NO_TEAM, GetPVarInt(playerid, "Skin"), 142.7582, -81.7688, 1.5781,0.0, 0, 0, 0, 0, 0, 0);
            }
            GivePlayerMoney(playerid, GetPVarInt(playerid, "Money"));
            SpawnPlayer(playerid);
            SendClientMessage(playerid, X11_WHITE, message);
            new log[256];
            new login[256];
            new plrIP[16];
            GetPlayerIp(playerid, plrIP, sizeof(plrIP));
            GetPVarString(playerid, "Login", login, sizeof(login));
            format(log, sizeof(log), "[LOG-LOGIN] Gracz %s zalogowa³ siê na postaæ %s || IP: %s", login, ReturnPlayerName(playerid), plrIP);
            print(log);
        }
        case DIALOG_ADMINPASS:{
            if(response){
                new adminpass[256];
                GetPVarString(playerid, "AdminPass", adminpass, sizeof(adminpass));
                inline const OnAdminPasswordVerify(bool:success){
                    if(success)
                    {
                        ShowPlayerDialog(playerid, DIALOG_LASTPOS, DIALOG_STYLE_MSGBOX, "Ostatnia pozycja", "Znaleziono twoj¹ ostatni¹ pozycjê\nCzy chcesz j¹ przywróciæ?", "Tak", "Nie");
                    }else{
                        new log[256];
                        new login[256];
                        new plrIP[16];
                        GetPlayerIp(playerid, plrIP, sizeof(plrIP));
                        GetPVarString(playerid, "Login", login, sizeof(login));
                        format(log, sizeof(log), "[LOG-ALOGIN] NIEUDANE LOGOWANIE ADMINISTRATORA %s NA POSTAÆ %s || IP: %s", login, ReturnPlayerName(playerid), plrIP);
                        print(log); 
                        SendPlayerError(playerid, "Nieprawid³owe has³o, zosta³eœ roz³¹czony, administracja dosta³a informacje o nieudanym logowaniu. Zapraszamy ponownie!");
                        SetTimerEx("DelayedKick", 100, false, "i", playerid);
                    }
                }

                BCrypt_CheckInline(inputtext,adminpass, using inline OnAdminPasswordVerify);
            }else{
                new log[256];
                new login[256];
                new plrIP[16];
                GetPlayerIp(playerid, plrIP, sizeof(plrIP));
                GetPVarString(playerid, "Login", login, sizeof(login));
                format(log, sizeof(log), "[LOG-ALOGIN] NIEUDANE LOGOWANIE ADMINISTRATORA %s NA POSTAÆ %s || IP: %s", login, ReturnPlayerName(playerid), plrIP);
                print(log); 
                SendPlayerError(playerid, "Wyszed³eœ z serwera, zosta³eœ roz³¹czony. Zapraszamy ponownie!");
                SetTimerEx("DelayedKick", 100, false, "i", playerid);
            }
        }
    }
    return 1;
}


public OnPlayerDisconnect(playerid, reason)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    new Node:node = JSON_Object(
        "x", JSON_Float(x),
        "y", JSON_Float(y),
        "z", JSON_Float(z)
    );
    new jsonbuf[256];
    JSON_Stringify(node, jsonbuf, sizeof(jsonbuf));
    inline const OnLastPosSaved()
    {
        return 1;
    }

    MySQL_PQueryInline(MySQL, using inline OnLastPosSaved,"UPDATE `samp_characters` SET `lastpos` = '%s' WHERE `id` = '%i'",jsonbuf,GetPVarInt(playerid, "ID"));
    return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    SetSpawnInfo(playerid, NO_TEAM, 0, 0, 0, 0, 0.0, 0, 0, 0, 0, 0, 0);

    TogglePlayerSpectating(playerid, true);
    return 1;
}