public OnFilterScriptInit() {
    CreateGenericSelectList();

    for(new playerid, max_playerid = GetPlayerPoolSize(); playerid <= max_playerid; playerid ++) {
        if( IsPlayerConnected(playerid) ) {
            DefaultSelectListData(playerid);
        }
    }

    #if defined sl_OnFilterScriptInit
        sl_OnFilterScriptInit();
    #endif
}
#if defined _ALS_OnFilterScriptInit
    #undef OnFilterScriptInit
#else
    #define _ALS_OnFilterScriptInit
#endif
#define OnFilterScriptInit sl_OnFilterScriptInit
#if defined sl_OnFilterScriptInit
    forward sl_OnFilterScriptInit();
#endif


public OnFilterScriptExit() {
    DestroyGenericSelectList();

    #if defined sl_OnFilterScriptExit
        sl_OnFilterScriptExit();
    #endif
}
#if defined _ALS_OnFilterScriptExit
    #undef OnFilterScriptExit
#else
    #define _ALS_OnFilterScriptExit
#endif
#define OnFilterScriptExit sl_OnFilterScriptExit
#if defined sl_OnFilterScriptExit
    forward sl_OnFilterScriptExit();
#endif


public OnPlayerConnect(playerid) {
    DefaultSelectListData(playerid);

    #if defined sl_OnPlayerConnect
        return sl_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect sl_OnPlayerConnect
#if defined sl_OnPlayerConnect
    forward sl_OnPlayerConnect(playerid);
#endif


public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    switch(dialogid) {
        case DIALOGID_SELECTLIST_PAGE: {
            if( !response ) {
                return 1;
            }

            new page;

            if( sscanf(inputtext, "i", page) ) {
                SendClientMessage(playerid, RGBA_RED, "ERROR: You did not enter a valid page number!");
                ShowSelectListDialog(playerid, dialogid);
                return 1;
            }

            page --;

            if( page < MIN_SELECTLIST_PAGE || page > GetSelectListMaxPage(playerid) ) {
                SendClientMessage(playerid, RGBA_RED, "ERROR: You did not enter a valid page number!");
                ShowSelectListDialog(playerid, dialogid);
                return 1;
            }

            SetSelectListPage(playerid, page);
            LoadSelectListRowData(playerid);

            ApplySelectListPage(playerid);
            for(new row; row < MAX_SELECTLIST_ROWS; row ++) {
                ApplySelectListRowData(playerid, row);
            }
            return 1;
        }
        case DIALOGID_SELECTLIST_SEARCH: {
            if( !response ) {
                return 1;
            }

            SetSelectListPage(playerid, MIN_SELECTLIST_PAGE);
            SetSelectListSearch(playerid, inputtext);
            LoadSelectListRowData(playerid);

            ApplySelectListPage(playerid);
            ApplySelectListSearch(playerid);
            for(new row; row < MAX_SELECTLIST_ROWS; row ++) {
                ApplySelectListRowData(playerid, row);
            }
            return 1;
        }
    }

    #if defined sl_OnDialogResponse
        return sl_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 0;
    #endif
}
#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse sl_OnDialogResponse
#if defined sl_OnDialogResponse
    forward sl_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif


public OnPlayerClickTextDraw(playerid, Text:clickedid) {
    switch( g_PlayerData[playerid][PLAYER_DATA_TDMODE] ) {
        case TDMODE_SELECTLIST_OBJECT, TDMODE_SELECTLIST_VEHICLE, TDMODE_SELECTLIST_ACTOR, TDMODE_SELECTLIST_PICKUP: {
            if( clickedid == g_SelectListGTD[SELECTLIST_GTD_CLOSE] || clickedid == Text: INVALID_TEXT_DRAW ) {
                if( g_PlayerData[playerid][PLAYER_DATA_POS_SAVED] ) {
                    if( g_CamModeData[playerid][CAMMODE_DATA_TOGGLE] ) {
                        SetPlayerObjectPos(playerid, g_CamModeData[playerid][CAMMODE_DATA_POID], g_PlayerData[playerid][PLAYER_DATA_POS_X], g_PlayerData[playerid][PLAYER_DATA_POS_Y], g_PlayerData[playerid][PLAYER_DATA_POS_Z]);
                    } else {
                        SetPlayerPos(playerid, g_PlayerData[playerid][PLAYER_DATA_POS_X], g_PlayerData[playerid][PLAYER_DATA_POS_Y], g_PlayerData[playerid][PLAYER_DATA_POS_Z]);
                    }
                    g_PlayerData[playerid][PLAYER_DATA_POS_SAVED] = false;
                }

                SetSelectListEditViewed(playerid, false);

                HidePlayerTextdrawMode(playerid);

                if( clickedid == g_SelectListGTD[SELECTLIST_GTD_CLOSE] ) {
                    return 1; // ESCAPE key was not used, return 1
                }
            }
        }
    }

    if( clickedid == g_SelectListGTD[SELECTLIST_GTD_PAGE_F] ) {
        if( GetSelectListPage(playerid) == MIN_SELECTLIST_PAGE ) {
            return 1;
        }

        SetSelectListPage(playerid, MIN_SELECTLIST_PAGE);
        LoadSelectListRowData(playerid);

        ApplySelectListPage(playerid);
        for(new row; row < MAX_SELECTLIST_ROWS; row ++) {
            ApplySelectListRowData(playerid, row);
        }
        return 1;
    }
    if( clickedid == g_SelectListGTD[SELECTLIST_GTD_PAGE_P] ) {
        new page = GetSelectListPage(playerid);

        if( page == MIN_SELECTLIST_PAGE ) {
            return 1;
        }

        if( -- page < MIN_SELECTLIST_PAGE ) {
            page = MIN_SELECTLIST_PAGE;
        }

        SetSelectListPage(playerid, page);
        LoadSelectListRowData(playerid);

        ApplySelectListPage(playerid);
        for(new row; row < MAX_SELECTLIST_ROWS; row ++) {
            ApplySelectListRowData(playerid, row);
        }
        return 1;
    }
    if( clickedid == g_SelectListGTD[SELECTLIST_GTD_PAGE_N] ) {
        new
            page  = GetSelectListPage(playerid),
            maxpage = GetSelectListMaxPage(playerid)
        ;

        if( page == maxpage ) {
            return 1;
        }

        if( ++ page > maxpage ) {
            page = maxpage;
        }

        SetSelectListPage(playerid, page);
        LoadSelectListRowData(playerid);

        ApplySelectListPage(playerid);
        for(new row; row < MAX_SELECTLIST_ROWS; row ++) {
            ApplySelectListRowData(playerid, row);
        }
        return 1;
    }
    if( clickedid == g_SelectListGTD[SELECTLIST_GTD_PAGE_L] ) {
        new maxpage = GetSelectListMaxPage(playerid);

        if( GetSelectListPage(playerid) == maxpage ) {
            return 1;
        }

        SetSelectListPage(playerid, maxpage);
        LoadSelectListRowData(playerid);

        ApplySelectListPage(playerid);
        for(new row; row < MAX_SELECTLIST_ROWS; row ++) {
            ApplySelectListRowData(playerid, row);
        }
        return 1;
    }

    #if defined sl_OnPlayerClickTextDraw
        return sl_OnPlayerClickTextDraw(playerid, Text:clickedid);
    #else
        return 0;
    #endif
}
#if defined _ALS_OnPlayerClickTextDraw
    #undef OnPlayerClickTextDraw
#else
    #define _ALS_OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw sl_OnPlayerClickTextDraw
#if defined sl_OnPlayerClickTextDraw
    forward sl_OnPlayerClickTextDraw(playerid, Text:clickedid);
#endif


public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid) {
    if( playertextid == g_SelectListPTD[playerid][SELECTLIST_PTD_PAGE] ) {
        ShowSelectListDialog(playerid, DIALOGID_SELECTLIST_PAGE);
        return 1;
    }
    if( playertextid == g_SelectListPTD[playerid][SELECTLIST_PTD_SEARCH] ) {
        ShowSelectListDialog(playerid, DIALOGID_SELECTLIST_SEARCH);
        return 1;
    }
    for(new row; row < MAX_SELECTLIST_ROWS; row ++) {
        if( playertextid == g_SelectListPTD[playerid][SELECTLIST_PTD_ID_ROW][row] || playertextid == g_SelectListPTD[playerid][SELECTLIST_PTD_MODELID_ROW][row] || playertextid == g_SelectListPTD[playerid][SELECTLIST_PTD_COMMENT_ROW][row] ) {
            new
                objectid = INVALID_OBJECT_ID,
                vehicleid = INVALID_VEHICLE_ID,
                pickupid = INVALID_PICKUP_ID,
                actorid = INVALID_ACTOR_ID
            ;

            switch( g_PlayerData[playerid][PLAYER_DATA_TDMODE] ) {
                case TDMODE_SELECTLIST_OBJECT: {
                    objectid = g_SelectObjListData[playerid][SELECTLIST_DATA_ROW_ID][row];
                    if( !IsValidObject(objectid) ) {
                        return 1;
                    }
                }
                case TDMODE_SELECTLIST_VEHICLE: {
                    vehicleid = g_SelectVehListData[playerid][SELECTLIST_DATA_ROW_ID][row];
                    if( !IsValidVehicle(vehicleid) ) {
                        return 1;
                    }
                }
                case TDMODE_SELECTLIST_PICKUP: {
                    pickupid = g_SelectPickListData[playerid][SELECTLIST_DATA_ROW_ID][row];
                    if( !IsValidPickup(pickupid) ) {
                        return 1;
                    }
                }
                case TDMODE_SELECTLIST_ACTOR: {
                    actorid = g_SelectActListData[playerid][SELECTLIST_DATA_ROW_ID][row];
                    if( !IsValidActor(actorid) ) {
                        return 1;
                    }
                }
                default: {
                    return 1;
                }
            }

            new prev_row = GetSelectListEditRow(playerid);
            if( row != prev_row) {
                switch( g_PlayerData[playerid][PLAYER_DATA_TDMODE] ) {
                    case TDMODE_SELECTLIST_OBJECT: {
                        g_PlayerData[playerid][PLAYER_DATA_EDIT_ID] = objectid;
                        g_PlayerData[playerid][PLAYER_DATA_EDIT_IDTYPE] = ID_TYPE_OBJECT;
                    }
                    case TDMODE_SELECTLIST_VEHICLE: {
                        g_PlayerData[playerid][PLAYER_DATA_EDIT_ID] = vehicleid;
                        g_PlayerData[playerid][PLAYER_DATA_EDIT_IDTYPE] = ID_TYPE_VEHICLE;
                    }
                    case TDMODE_SELECTLIST_PICKUP: {
                        g_PlayerData[playerid][PLAYER_DATA_EDIT_ID] = pickupid;
                        g_PlayerData[playerid][PLAYER_DATA_EDIT_IDTYPE] = ID_TYPE_PICKUP;
                    }
                    case TDMODE_SELECTLIST_ACTOR: {
                        g_PlayerData[playerid][PLAYER_DATA_EDIT_ID] = actorid;
                        g_PlayerData[playerid][PLAYER_DATA_EDIT_IDTYPE] = ID_TYPE_ACTOR;
                    }
                    default: {
                        return 0;
                    }
                }
            }

            new bool:prev_is_viewed = IsSelectListEditViewed(playerid);
            if( row == prev_row && prev_is_viewed ) {
                switch( g_PlayerData[playerid][PLAYER_DATA_TDMODE] ) {
                    case TDMODE_SELECTLIST_OBJECT: {
                        ShowObjectDialog(playerid, DIALOGID_OBJECT_MAIN);
                    }
                    case TDMODE_SELECTLIST_VEHICLE: {
                        ShowVehicleDialog(playerid, DIALOGID_VEHICLE_MAIN);
                    }
                    case TDMODE_SELECTLIST_PICKUP: {
                        ShowPickupDialog(playerid, DIALOGID_PICKUP_MAIN);
                    }
                    case TDMODE_SELECTLIST_ACTOR: {
                        ShowActorDialog(playerid, DIALOGID_ACTOR_MAIN);
                    }
                    default: {
                        return 1;
                    }
                }

                g_PlayerData[playerid][PLAYER_DATA_POS_SAVED] = false;

                SetSelectListEditViewed(playerid, false);

                HidePlayerTextdrawMode(playerid);
                return 1;
            }

            if( !prev_is_viewed || row != prev_row ) {
                SetSelectListEditViewed(playerid, true);

                SetSelectListEditRow(playerid, row);

                ApplySelectListRowColor(playerid, row);

                if( prev_row != INVALID_ROW ) {
                    ApplySelectListRowColor(playerid, prev_row);
                }
            }
            return 1;
        }
    }

    #if defined sl_OnPlayerClickPlayerTD
        return sl_OnPlayerClickPlayerTD(playerid, PlayerText:playertextid);
    #else
        return 0;
    #endif
}
#if defined _ALS_OnPlayerClickPlayerTD
    #undef OnPlayerClickPlayerTextDraw
#else
    #define _ALS_OnPlayerClickPlayerTD
#endif
#define OnPlayerClickPlayerTextDraw sl_OnPlayerClickPlayerTD
#if defined sl_OnPlayerClickPlayerTD
    forward sl_OnPlayerClickPlayerTD(playerid, PlayerText:playertextid);
#endif
