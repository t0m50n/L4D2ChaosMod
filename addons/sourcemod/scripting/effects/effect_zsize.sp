float g_zscale = 1.0;
Handle g_zsizetimer = INVALID_HANDLE;

public Action Command_ZSize(int client, int args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: chaosmod_zsize <scale>");
		return Plugin_Handled;
	}

	char s_scale[255];
	GetCmdArg(1, s_scale, sizeof(s_scale));
	float f_scale = StringToFloat(s_scale);
	
	g_zscale = f_scale;
	ZSize(g_zscale);
	delete g_zsizetimer;
	if (FloatAbs(g_zscale - 1.0) > 0.01)
	{
		g_zsizetimer = CreateTimer(1.0, Timer_ZSize, _, TIMER_REPEAT);
	}

	return Plugin_Handled;
}

public Action Timer_ZSize(Handle timer, any entity)
{
	ZSize(g_zscale);
}


void ZSize(float scale)
{
	int entity = -1;
	do
	{
		entity = FindEntityByClassname(entity, "infected");
		if (entity > 0)
		{
			SetEntPropFloat(entity, Prop_Send, "m_flModelScale", scale);
		}
	} while (entity > 0);
}