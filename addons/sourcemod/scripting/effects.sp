#define ANIM_CHARGER_BOUNCE 76
#define CHARGE_INCAP_TIME 3.0

StringMap g_effect_durations;

ConVar g_short_time_duration;
ConVar g_normal_time_duration;
ConVar g_long_time_duration;

Handle g_game_conf = INVALID_HANDLE;
Handle g_sdk_push_player = INVALID_HANDLE;

float g_dontrush_tele_pos[3];
bool g_dontrush_supported;

void Effects_Initialise()
{
	g_short_time_duration = CreateConVar("chaosmod_short_time_duration", "15", "A short effect will be enabled for this many seconds", FCVAR_NOTIFY, true, 0.1);
	g_normal_time_duration = CreateConVar("chaosmod_normal_time_duration", "30", "A normal effect will be enabled for this many seconds", FCVAR_NOTIFY, true, 0.1);
	g_long_time_duration = CreateConVar("chaosmod_long_time_duration", "60", "A long effect will be enabled for this many seconds", FCVAR_NOTIFY, true, 0.1);
	
	g_effect_durations = new StringMap();
	g_effect_durations.SetValue("none", g_normal_time_duration);
	g_effect_durations.SetValue("short", g_short_time_duration);
	g_effect_durations.SetValue("normal", g_normal_time_duration);
	g_effect_durations.SetValue("long", g_long_time_duration);
	
	RegAdminCmd("sm_charge", Command_Charge, ADMFLAG_GENERIC, "Will launch a survivor far away");
	RegAdminCmd("sm_dontrush", Command_DontRush, ADMFLAG_GENERIC, "Forces a player to re-appear in the starting safe zone");
	
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
		SetFailState("Unable to find the \"CTerrorPlayer_Fling\" signature, check the file version!");
	}
}

ArrayList Effects_Load(const char[] path)
{
	char effects_path[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, effects_path, sizeof(effects_path), path);
	
	KeyValues kv = new KeyValues("effects");
	kv.SetEscapeSequences(true);
	
	if (!kv.ImportFromFile(effects_path))
	{
		delete kv;
		SetFailState("Could not open %s", effects_path);
	}
	if (!kv.GotoFirstSubKey())
	{
		delete kv;
		SetFailState("Where the effects at?");
	}
	
	ArrayList effects = new ArrayList();
	do
	{
		StringMap effect = new StringMap();
		char buffer[255];
		
		
		kv.GetSectionName(buffer, sizeof(buffer));
		effect.SetString("name", buffer);
		
		kv.GetString("start", buffer, sizeof(buffer));
		effect.SetString("start", buffer);
		
		kv.GetString("end", buffer, sizeof(buffer));
		effect.SetString("end", buffer);
		
		kv.GetString("active_time", buffer, sizeof(buffer));
		
		float active_time = Effects_ParseActiveTime(buffer);
		if (active_time < 0)
		{
			effect.GetString("name", buffer, sizeof(buffer));
			SetFailState("Invalid active time for effect: %s", buffer);
		}
		effect.SetString("active_time", buffer);
		
		effects.Push(effect);
	} while (kv.GotoNextKey());
	delete kv;

	#if defined DEBUG
		PrintToServer("Number of effects: %d", effects.Length);
		for (int i = 0; i < effects.Length; i++)
		{
			char effect_name[255];
			StringMap effect = view_as<StringMap>(effects.Get(i));
			effect.GetString("name", effect_name, sizeof(effect_name));
			PrintToServer(effect_name);
		}
	#endif
	
	return effects;
}

float Effects_ParseActiveTime(char[] active_time)
{
	StringMapSnapshot durations = g_effect_durations.Snapshot();
	for (int i = 0; i < durations.Length; i++)
	{
		char duration_name[255];
		durations.GetKey(i, duration_name, sizeof(duration_name));
		if (StrEqual(active_time, duration_name, false))
		{
			CloseHandle(durations);
			ConVar c;
			g_effect_durations.GetValue(duration_name, c);
			return c.FloatValue;
		}
	}
	CloseHandle(durations);
	
	float f = StringToFloat(active_time);
	if (f < 0.01)
	{
		return -1.0;
	}
	return f;
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

public Action Command_Charge(int client, int args)
{
	int target_list[MAXPLAYERS];
			
	int target_count = CommandHandler(
			client, args, "[SM] Usage: sm_charge <#userid|name> <velocity>",
			2, target_list, MAXPLAYERS);
	
	if (target_count < 0)
	{
		return Plugin_Handled;
	}
	
	char s_velocity[255];
	GetCmdArg(2, s_velocity, sizeof(s_velocity));
	float f_velocity = StringToFloat(s_velocity);
	
	for (new i = 0; i < target_count; i++)
	{
		Charge(target_list[i], f_velocity);
	}
	
	return Plugin_Handled;
}

public Action Command_DontRush(int client, int args)
{
	int target_list[MAXPLAYERS];
			
	int target_count = CommandHandler(
			client, args, "[SM] Usage: sm_dontrush <#userid|name>",
			1, target_list, MAXPLAYERS);
	
	if (target_count < 0)
	{
		return Plugin_Handled;
	}
	
	for (int i = 0; i < target_count; i++)
	{
		TeleportBack(target_list[i], client);
	}
	
	return Plugin_Handled;
}

public void OnMapStart()
{
	g_dontrush_supported = true;
	int tel_ent = -1;
	
	do
	{
		tel_ent = FindEntityByClassname(tel_ent, "prop_door_rotating_checkpoint");
	} while (tel_ent >= 0 && GetEntProp(tel_ent, Prop_Send, "m_bLocked") != 1);
	
	if (tel_ent >= 0)
	{
		float door_ent_pos[3];
		GetEntPropVector(tel_ent, Prop_Send, "m_vecOrigin", door_ent_pos);
		
		float door_ent_ang[3];
		GetEntPropVector(tel_ent, Prop_Data, "m_angAbsRotation", door_ent_ang);
		
		g_dontrush_tele_pos[0] = door_ent_pos[0] + 50.0 * Cosine(DegToRad(door_ent_ang[1]));
		g_dontrush_tele_pos[1] = door_ent_pos[1] + 50.0 * Sine(DegToRad(door_ent_ang[1]));
		g_dontrush_tele_pos[2] = door_ent_pos[2] - 25.0;
		return;
	}
	
	tel_ent = FindEntityByClassname(-1, "info_survivor_position");	
	if (tel_ent >= 0)
	{
		GetEntPropVector(tel_ent, Prop_Send, "m_vecOrigin", g_dontrush_tele_pos);
		return;	
	}
	
	g_dontrush_supported = false;
}

void Charge(int target, float velocity)
{
	float tpos[3];
	float spos[3];
	
	float distance[3];
	float ratio[3];
	float addVel[3];
	float tvec[3];
	
	GetClientAbsOrigin(target, tpos);
	
	// Throw in random direction
	spos[0] = tpos[0] + GetRandomFloat(-1.0, 1.0);
	spos[1] = tpos[1] + GetRandomFloat(-1.0, 1.0);
	spos[2] = tpos[2] + GetRandomFloat(-1.0, 1.0);
	
	distance[0] = (spos[0] - tpos[0]);
	distance[1] = (spos[1] - tpos[1]);
	distance[2] = (spos[2] - tpos[2]);
	GetEntPropVector(target, Prop_Data, "m_vecVelocity", tvec);
	ratio[0] =  FloatDiv(distance[0], SquareRoot(distance[1]*distance[1] + distance[0]*distance[0])); // Ratio x/hypo
	ratio[1] =  FloatDiv(distance[1], SquareRoot(distance[1]*distance[1] + distance[0]*distance[0])); // Ratio y/hypo
	
	addVel[0] = FloatMul(ratio[0]*-1, velocity);
	addVel[1] = FloatMul(ratio[1]*-1, velocity);
	addVel[2] = velocity;
	SDKCall(g_sdk_push_player, target, addVel, ANIM_CHARGER_BOUNCE, target, CHARGE_INCAP_TIME);
}

void TeleportBack(target, sender)
{
	if (!IsClientInGame(target) ||
		!IsPlayerAlive(target) ||
		GetClientTeam(target) == 1)
	{
		return;
	}
	
	if (!g_dontrush_supported)
	{
		ReplyToCommand(sender, "Map not supported %b", g_dontrush_supported);
	}
	
	TeleportEntity(target, g_dontrush_tele_pos, NULL_VECTOR, NULL_VECTOR);
}