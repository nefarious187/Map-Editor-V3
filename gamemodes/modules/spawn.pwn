#include <YSI_Coding\y_hooks>

forward LoginSpawnPlayer(playerid);
public LoginSpawnPlayer(playerid)
{
    TogglePlayerSpectating(playerid, false);
}

new g_SkinID[MAX_PLAYERS];

stock SetPlayerSpawn(playerid)
{
    SetPlayerPos(playerid, 1715.2172, -1900.2367, 13.5665);
    SetPlayerFacingAngle(playerid, 0);
    SetCameraBehindPlayer(playerid);
}

hook OnGameModeInit()
{
    AddPlayerClass(0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
    return 1;
}

hook OnPlayerConnect(playerid)
{
    g_SkinID[playerid] = random(312);
    TogglePlayerSpectating(playerid, true);
    SetSpawnInfo(playerid, 1, g_SkinID[playerid], 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
    SetTimerEx("LoginSpawnPlayer", 100, false, "i", playerid);
    return 1;
}

hook OnPlayerSpawn(playerid)
{
    SetPlayerSpawn(playerid);
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    SpawnPlayer(playerid);
    return 1;
}
