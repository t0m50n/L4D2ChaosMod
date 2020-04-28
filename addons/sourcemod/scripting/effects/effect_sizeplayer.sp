public Action Command_SizePlayer(int client, int args)
{
	int target_list[MAXPLAYERS];
			
	int target_count = CommandHandler(
			client, args, "[SM] Usage: chaosmod_sizeplayer <#userid|name> <scale>",
			2, target_list, MAXPLAYERS);
	
	if (target_count < 0)
	{
		return Plugin_Handled;
	}
	
	char s_scale[255];
	GetCmdArg(2, s_scale, sizeof(s_scale));
	float f_scale = StringToFloat(s_scale);
	
	for (int i = 0; i < target_count; i++)
	{
		SizePlayer(target_list[i], f_scale);
	}
	
	return Plugin_Handled;
}

void SizePlayer(int target, float scale)
{
	if (!IsClientInGame(target) || !IsPlayerAlive(target))
	{
		return;
	}
	SetEntPropFloat(target, Prop_Send, "m_flModelScale", scale);
}