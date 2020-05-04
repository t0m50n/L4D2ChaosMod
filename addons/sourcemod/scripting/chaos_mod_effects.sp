#pragma semicolon 1
#pragma newdecls required

#define PLUGIN_AUTHOR "T0M50N"
#define PLUGIN_VERSION "1.0.2"

#include <sourcemod>
#include <sdktools>
#include <weaponhandling>

public Plugin myinfo = 
{
	name = "L4D2 Chaos Mod Effects",
	author = PLUGIN_AUTHOR,
	description = "Provides some commands used by chaos mod",
	version = PLUGIN_VERSION,
	url = "https://github.com/t0m50n/L4D2ChaosMod"
};

char SDK_CALL_ERROR_MSG[] = "Unable to find the %s signature, check the gamedata file version!";

Handle g_game_conf = INVALID_HANDLE;
Handle g_sdk_push_player = INVALID_HANDLE;
Handle g_sdk_vomit_survivor = INVALID_HANDLE;
Handle g_sdk_vomit_infected = INVALID_HANDLE;
Handle g_sdk_set_temp_hp = INVALID_HANDLE;

ConVar g_bhop;
ConVar g_firerate;
ConVar g_reloadspeed;

#include "effects\effect_charge.sp"
#include "effects\effect_dontrush.sp"
#include "effects\effect_sethpplayer.sp"
#include "effects\effect_settemphpplayer.sp"
#include "effects\effect_vomitplayer.sp"
#include "effects\effect_sizeplayer.sp"
#include "effects\effect_entityrain.sp"
#include "effects\effect_cheat.sp"
#include "effects\effect_cvarsilent.sp"
#include "effects\effect_zspeed.sp"
#include "effects\effect_bhop.sp"
#include "effects\effect_firerate.sp"
#include "effects\effect_reloadspeed.sp"
#include "effects\effect_timescale.sp"

public void OnPluginStart()
{
	CreateConVar("chaosmod_version", PLUGIN_VERSION, " Version of Chaos Mod on this server ", FCVAR_SPONLY|FCVAR_DONTRECORD);
	g_bhop = CreateConVar("chaosmod_bhop_enabled", "0", "Enable/Disable automatic bunny hopping", FCVAR_NOTIFY);
	g_firerate = CreateConVar("chaosmod_firerate", "1", "Weapon firing rate modifier", FCVAR_NOTIFY, true, 0.1);
	g_reloadspeed = CreateConVar("chaosmod_reloadspeed", "1", "Weapon reload speed modifier", FCVAR_NOTIFY, true, 0.1);

	RegAdminCmd("chaosmod_charge", Command_Charge, ADMFLAG_ROOT, "Will launch a survivor far away");
	RegAdminCmd("chaosmod_dontrush", Command_DontRush, ADMFLAG_ROOT, "Forces a player to re-appear in the starting safe zone");
	RegAdminCmd("chaosmod_sethpplayer", Command_SetHpPlayer, ADMFLAG_ROOT, "Set a player's health");
	RegAdminCmd("chaosmod_settemphpplayer", Command_SetTempHpPlayer, ADMFLAG_ROOT, "Set a player's temporary health");
	RegAdminCmd("chaosmod_vomitplayer", Command_VomitPlayer, ADMFLAG_ROOT, "Vomits the desired player");
	RegAdminCmd("chaosmod_sizeplayer", Command_SizePlayer, ADMFLAG_ROOT, "Resize a player's model (Most likely, their pants)");
	RegAdminCmd("chaosmod_entityrain", Command_EntityRain, ADMFLAG_ROOT, "Will rain the specified entity");
	RegAdminCmd("chaosmod_cheat", Command_Cheat, ADMFLAG_ROOT, "Runs cheat commands with sv_cheats 0");
	RegAdminCmd("chaosmod_cvar", Command_CvarSilent, ADMFLAG_ROOT, "Changes cvar without notifying clients");
	RegAdminCmd("chaosmod_zspeed", Command_ZSpeed, ADMFLAG_ROOT, "Changes speed of the infected");
	RegAdminCmd("chaosmod_timescale", Command_TimeScale, ADMFLAG_ROOT, "Set game speed of host and client");

	LoadTranslations("common.phrases.txt");
	
	g_game_conf = LoadGameConfigFile("l4d2_custom_commands");
	if(g_game_conf == INVALID_HANDLE)
	{
		SetFailState("Couldn't find the offsets and signatures file. Please, check that it is installed correctly.");
	}
	
	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(g_game_conf, SDKConf_Signature, "CTerrorPlayer_Fling");
	PrepSDKCall_AddParameter(SDKType_Vector, SDKPass_ByRef);
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
	PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
	PrepSDKCall_AddParameter(SDKType_Float, SDKPass_Plain);
	g_sdk_push_player = EndPrepSDKCall();
	if(g_sdk_push_player == INVALID_HANDLE)
	{
		SetFailState(SDK_CALL_ERROR_MSG, "CTerrorPlayer_Fling");
	}
	
	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(g_game_conf, SDKConf_Signature, "CTerrorPlayer_OnVomitedUpon");
	PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
	g_sdk_vomit_survivor = EndPrepSDKCall();
	if(g_sdk_vomit_survivor == INVALID_HANDLE)
	{
		SetFailState(SDK_CALL_ERROR_MSG, "CTerrorPlayer_OnVomitedUpon");
	}
	
	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(g_game_conf, SDKConf_Signature, "CTerrorPlayer_OnHitByVomitJar");
	PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);
	PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
	g_sdk_vomit_infected = EndPrepSDKCall();
	if(g_sdk_vomit_infected == INVALID_HANDLE)
	{
		SetFailState(SDK_CALL_ERROR_MSG, "CTerrorPlayer_OnHitByVomitJar");
	}

	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(g_game_conf, SDKConf_Signature, "CTerrorPlayer_SetHealthBuffer");
	PrepSDKCall_AddParameter(SDKType_Float, SDKPass_Plain);
	g_sdk_set_temp_hp = EndPrepSDKCall();
	if(g_sdk_set_temp_hp == INVALID_HANDLE)
	{
		SetFailState(SDK_CALL_ERROR_MSG, "CTerrorPlayer_SetHealthBuffer");
	}
}

public void OnMapStart()
{
	Effect_DontRush_OnMapStart();
}

public Action OnPlayerRunCmd(int client, int& buttons)
{
	Effect_Bhop_OnPlayerRunCmd(client, buttons);
	return Plugin_Continue;
}

int CommandHandler(int client, int args, const char[] usage, int no_args, int[] target_list, int max_targets)
{
	if(args < no_args)
	{
		ReplyToCommand(client, usage);
		return -1;
	}
	
	char target_string[255];
	char target_name[MAX_TARGET_LENGTH];
	bool tn_is_ml;
	
	GetCmdArg(1, target_string, sizeof(target_string));
	int target_count = ProcessTargetString(
			target_string,
			client,
			target_list,
			max_targets,
			COMMAND_FILTER_ALIVE,
			target_name,
			sizeof(target_name),
			tn_is_ml);
	
	if (target_count < 1)
	{
		ReplyToTargetError(client, target_count);
		return -1;
	}
	
	return target_count;
}