stock h_CreateObject(modelid, Float:X, Float:Y, Float:Z, Float:rX, Float:rY, Float:rZ, Float:DrawDistance = 0.0) {
    new objectid = CreateDynamicObject(modelid, X, Y, Z, rX, rY, rZ, .drawdistance = DrawDistance);
    if(objectid == 0) {
        return INVALID_OBJECT_ID;
    }
    if(objectid != INVALID_OBJECT_ID) {
        if( GetModelName(modelid, g_CommentString, sizeof g_CommentString) ) {
            strpack(g_ObjectData[objectid-1][OBJECT_DATA_COMMENT], g_CommentString, sizeof g_CommentString);
        }

        g_ObjectData[objectid-1][OBJECT_DATA_ATTACH_IDTYPE] = ID_TYPE_NONE;
        g_ObjectData[objectid-1][OBJECT_DATA_ATTACH_X]  = 0.0;
        g_ObjectData[objectid-1][OBJECT_DATA_ATTACH_Y]  = 0.0;
        g_ObjectData[objectid-1][OBJECT_DATA_ATTACH_Z]  = 0.0;
        g_ObjectData[objectid-1][OBJECT_DATA_ATTACH_RX] = 0.0;
        g_ObjectData[objectid-1][OBJECT_DATA_ATTACH_RY] = 0.0;
        g_ObjectData[objectid-1][OBJECT_DATA_ATTACH_RZ] = 0.0;

        g_ObjectData[objectid-1][OBJECT_DATA_MATINDEX_MODCOUNT] = 0;
        for(new materialindex; materialindex < MAX_OBJECT_INDEX; materialindex ++) {
            g_ObjectData[objectid-1][OBJECT_DATA_MATINDEX_TYPE][materialindex] = MATERIALINDEX_TYPE_NONE;
        }

        for(new p = 0, max_playerid = GetPlayerPoolSize(); p <= max_playerid; p++) {
            if(IsPlayerConnected(p)) {
                Streamer_Update(p);
            }
        }
    }
    return objectid;
}
#if defined _ALS_CreateObject
    #undef CreateObject
#else
    #define _ALS_CreateObject
#endif
#define CreateObject h_CreateObject


stock h_CreatePlayerObject(playerid, modelid, Float:X, Float:Y, Float:Z, Float:rX, Float:rY, Float:rZ, Float:DrawDistance = 0.0) {
    return CreatePlayerObject(playerid, modelid, X, Y, Z, rX, rY, rZ, DrawDistance);
}
#if defined _ALS_CreatePlayerObject
    #undef CreatePlayerObject
#else
    #define _ALS_CreatePlayerObject
#endif
#define CreatePlayerObject h_CreatePlayerObject


stock h_DestroyObject(objectid) {
    new isvalid = IsValidDynamicObject(objectid);

    DestroyDynamicObject(objectid);
    
    if( isvalid ) {
        for(new playerid, max_playerid = GetPlayerPoolSize(); playerid <= max_playerid; playerid ++) {
            if( !IsPlayerConnected(playerid) ) {
                continue;
            }

            if( GetPlayerEditObject(playerid) == objectid ) {
                g_PlayerData[playerid][PLAYER_DATA_EDIT_IDTYPE] = ID_TYPE_NONE;
            }

            if( g_PlayerData[playerid][PLAYER_DATA_EDIT_ATTACHOBJECT] == objectid ) {
                g_PlayerData[playerid][PLAYER_DATA_EDIT_ATTACHOBJECT] = INVALID_OBJECT_ID;
            }

            if( g_PlayerData[playerid][PLAYER_DATA_EDIT_MATERIALOBJ] == objectid ) {
                g_PlayerData[playerid][PLAYER_DATA_EDIT_MATERIALOBJ] = INVALID_OBJECT_ID;
            }

            new edit_row = g_SelectObjListData[playerid][SELECTLIST_DATA_EDIT_ROW];
            if( edit_row != INVALID_ROW ) {
                new edit_objectid = g_SelectObjListData[playerid][SELECTLIST_DATA_ROW_ID][edit_row];

                if( objectid == edit_objectid ) {
                    g_SelectObjListData[playerid][SELECTLIST_DATA_EDIT_ROW] = INVALID_ROW;
                }
            }

            for(new row; row < MAX_SELECTLIST_ROWS; row ++) {
                if( objectid != g_SelectObjListData[playerid][SELECTLIST_DATA_ROW_ID][row] ) {
                    continue;
                }

                g_SelectObjListData[playerid][SELECTLIST_DATA_ROW_ID][row] = INVALID_OBJECT_ID;

                if( g_PlayerData[playerid][PLAYER_DATA_TDMODE] != TDMODE_SELECTLIST_OBJECT ) {
                    continue;
                }

                PlayerTextDrawHide(playerid, g_SelectListPTD[playerid][SELECTLIST_PTD_ID_ROW][row]);
                PlayerTextDrawHide(playerid, g_SelectListPTD[playerid][SELECTLIST_PTD_COMMENT_ROW][row]);
            }
        }


        for(new loop_objectid = 1; loop_objectid <= MAX_OBJECTS; loop_objectid ++) {
            if( IsValidObject(loop_objectid) && GetObjectAttachObject(loop_objectid) == objectid ) {
                DestroyObject(loop_objectid);
            }
        }
    }
}
#if defined _ALS_DestroyObject
    #undef DestroyObject
#else
    #define _ALS_DestroyObject
#endif
#define DestroyObject h_DestroyObject


stock h_DestroyPlayerObject(playerid, objectid) {
    new isvalid = IsValidPlayerObject(playerid, objectid);

    DestroyPlayerObject(playerid, objectid);

    if( isvalid ) {
        if( g_PlayerData[playerid][PLAYER_DATA_CLICKDRAG_POID] == objectid ) {
            g_PlayerData[playerid][PLAYER_DATA_CLICKDRAG_POID] = INVALID_OBJECT_ID;
        }
    }
}
#if defined _ALS_DestroyPlayerObject
    #undef DestroyPlayerObject
#else
    #define _ALS_DestroyPlayerObject
#endif
#define DestroyPlayerObject h_DestroyPlayerObject


stock h_SetObjectMaterial(objectid, materialindex, modelid, txdname[], texturename[], materialcolor) {
    new success = SetDynamicObjectMaterial(objectid, materialindex, modelid, txdname, texturename, materialcolor);
    if( success ) {
        g_ObjectData[objectid-1][OBJECT_DATA_MATINDEX_MODCOUNT] ++;
        for(new p = 0, max_playerid = GetPlayerPoolSize(); p <= max_playerid; p++) {
            if(IsPlayerConnected(p)) {
                Streamer_Update(p);
            }
        }
    }
    return success;
}
#if defined _ALS_SetObjectMaterial
    #undef SetObjectMaterial
#else
    #define _ALS_SetObjectMaterial
#endif
#define SetObjectMaterial h_SetObjectMaterial


stock h_SetPlayerObjectMaterial(playerid, objectid, materialindex, modelid, txdname[], texturename[], materialcolor) {
    return SetPlayerObjectMaterial(playerid, objectid, materialindex, modelid, txdname, texturename, materialcolor);
}
#if defined _ALS_SetPlayerObjectMaterial
    #undef SetPlayerObjectMaterial
#else
    #define _ALS_SetPlayerObjectMaterial
#endif
#define SetPlayerObjectMaterial h_SetPlayerObjectMaterial


stock h_SetObjectMaterialText(objectid, text[], materialindex = 0, materialsize = OBJECT_MATERIAL_SIZE_256x128, fontface[] = "Arial", fontsize = 24, bold = 1, fontcolor = 0xFFFFFFFF, backcolor = 0, textalignment = 0) {
    new success = SetDynamicObjectMaterialText(objectid, materialindex, text, materialsize, fontface, fontsize, bold, fontcolor, backcolor, textalignment);
    if( success ) {
        g_ObjectData[objectid-1][OBJECT_DATA_MATINDEX_MODCOUNT] ++;
        for(new p = 0, max_playerid = GetPlayerPoolSize(); p <= max_playerid; p++) {
            if(IsPlayerConnected(p)) {
                Streamer_Update(p);
            }
        }
    }
    return success;
}
#if defined _ALS_SetObjectMaterialText
    #undef SetObjectMaterialText
#else
    #define _ALS_SetObjectMaterialText
#endif
#define SetObjectMaterialText h_SetObjectMaterialText


stock h_SetPlayerObjectMaterialText(playerid, objectid, text[], materialindex = 0, materialsize = OBJECT_MATERIAL_SIZE_256x128, fontface[] = "Arial", fontsize = 24, bold = 1, fontcolor = 0xFFFFFFFF, backcolor = 0, textalignment = 0) {
    return SetPlayerObjectMaterialText(playerid, objectid, text, materialindex, materialsize, fontface, fontsize, bold, fontcolor, backcolor, textalignment);
}
#if defined _ALS_SetPlayerObjMaterialText
    #undef SetPlayerObjectMaterialText
#else
    #define _ALS_SetPlayerObjMaterialText
#endif
#define SetPlayerObjectMaterialText h_SetPlayerObjectMaterialText


stock h_SetObjectPos(objectid, Float:x, Float:y, Float:z) {
    new success = SetDynamicObjectPos(objectid, x, y, z);
    for(new p = 0, max_playerid = GetPlayerPoolSize(); p <= max_playerid; p++) {
        if(IsPlayerConnected(p)) {
            Streamer_Update(p);
        }
    }
    return success;
}
#if defined _ALS_SetObjectPos
    #undef SetObjectPos
#else
    #define _ALS_SetObjectPos
#endif
#define SetObjectPos h_SetObjectPos


stock h_SetObjectRot(objectid, Float:rx, Float:ry, Float:rz) {
    new success = SetDynamicObjectRot(objectid, rx, ry, rz);
    for(new p = 0, max_playerid = GetPlayerPoolSize(); p <= max_playerid; p++) {
        if(IsPlayerConnected(p)) {
            Streamer_Update(p);
        }
    }
    return success;
}
#if defined _ALS_SetObjectRot
    #undef SetObjectRot
#else
    #define _ALS_SetObjectRot
#endif
#define SetObjectRot h_SetObjectRot


stock h_AttachObjectToObject(objectid, attachtoid, Float:OffsetX, Float:OffsetY, Float:OffsetZ, Float:RotX, Float:RotY, Float:RotZ, SyncRotation = 1) {
    new success = AttachDynamicObjectToObject(objectid, attachtoid, OffsetX, OffsetY, OffsetZ, RotX, RotY, RotZ, SyncRotation);
    for(new p = 0, max_playerid = GetPlayerPoolSize(); p <= max_playerid; p++) {
        if(IsPlayerConnected(p)) {
            Streamer_Update(p);
        }
    }
    return success;
}
#if defined _ALS_AttachObjectToObject
    #undef AttachObjectToObject
#else
    #define _ALS_AttachObjectToObject
#endif
#define AttachObjectToObject h_AttachObjectToObject


stock h_AttachObjectToVehicle(objectid, vehicleid, Float:OffsetX, Float:OffsetY, Float:OffsetZ, Float:RotX, Float:RotY, Float:RotZ) {
    new success = AttachDynamicObjectToVehicle(objectid, vehicleid, OffsetX, OffsetY, OffsetZ, RotX, RotY, RotZ);
    for(new p = 0, max_playerid = GetPlayerPoolSize(); p <= max_playerid; p++) {
        if(IsPlayerConnected(p)) {
            Streamer_Update(p);
        }
    }
    return success;
}
#if defined _ALS_AttachObjectToVehicle
    #undef AttachObjectToVehicle
#else
    #define _ALS_AttachObjectToVehicle
#endif
#define AttachObjectToVehicle h_AttachObjectToVehicle

