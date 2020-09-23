float g_dontrush_tele_pos[3];
int g_saferoom_door_ent;
bool g_dontrush_supported;

public void Effect_DontRush_OnRoundStart()
{
	g_dontrush_supported = true;
	int tel_ent = -1;
	g_saferoom_door_ent = -1;
	
	do
	{
		tel_ent = FindEntityByClassname(tel_ent, "prop_door_rotating_checkpoint");
	} while (tel_ent >= 0 && GetEntProp(tel_ent, Prop_Send, "m_bLocked") != 1);
	
	if (tel_ent >= 0)
	{
		g_saferoom_door_ent = tel_ent;

		float door_ent_pos[3];
		GetEntPropVector(tel_ent, Prop_Send, "m_vecOrigin", door_ent_pos);
		
		float door_ent_ang[3];
		GetEntPropVector(tel_ent, Prop_Data, "m_angAbsRotation", door_ent_ang);
		
		// https://en.wikipedia.org/wiki/Rotation_matrix
		float sin_theta = Sine(DegToRad(360.0 - door_ent_ang[1]));
		float cos_theta = Cosine(DegToRad(360.0 - door_ent_ang[1]));
		g_dontrush_tele_pos[0] = door_ent_pos[0] + 50.0 * cos_theta;
		g_dontrush_tele_pos[1] = door_ent_pos[1] + 50.0 * sin_theta;
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

void Effect_DontRush_OnMapEnd()
{
	g_dontrush_supported = false;
}

public Action Command_DontRush(int client, int args)
{
	if (!g_dontrush_supported)
	{
		ReplyToCommand(client, "[SM] dontrush: Map not supported.");
		return Plugin_Handled;
	}
	
	int target_list[MAXPLAYERS];
			
	int target_count = CommandHandler(
			client, args, "[SM] Usage: chaosmod_dontrush <#userid|name>",
			1, target_list, MAXPLAYERS);
	
	if (target_count < 0)
	{
		return Plugin_Handled;
	}
	
	for (int i = 0; i < target_count; i++)
	{
		DontRush(target_list[i]);
	}
	
	return Plugin_Handled;
}

void DontRush(int target)
{
	if (!IsClientInGame(target) || !IsPlayerAlive(target))
	{
		return;
	}
	if (g_saferoom_door_ent > 0)
	{
		RemoveEntity(g_saferoom_door_ent);
		g_saferoom_door_ent = -1;
	}
	TeleportEntity(target, g_dontrush_tele_pos, NULL_VECTOR, NULL_VECTOR);
}