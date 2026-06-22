CMD:cmds(playerid, params[])
{
    SendClientMessage(playerid, -1, "** CMDS **: /gotoco");
    return 1;
}
alias:cmds("commands", "help")

CMD:gotoco(playerid, params[])
{
    new Float: pos[3], int, vw;
    if(sscanf(params, "p<,>fffD(0)D(0)", pos[0], pos[1], pos[2], int, vw)) return SendClientMessage(playerid, -1, "USAGE: /gotoco [x coordinate] [y coordinate] [z coordinate] [interior] [vw]");

    SendClientMessage(playerid, -1, "You have been teleported to the coordinates specified.");
    SetPlayerPos(playerid, pos[0], pos[1], pos[2]);
    SetPlayerInterior(playerid, int);
    SetPlayerVirtualWorld(playerid, vw);

    return 1;
}
