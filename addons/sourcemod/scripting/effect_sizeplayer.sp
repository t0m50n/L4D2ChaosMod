public Action Command_SizePlayer(int client, int args)
{
	int target_list[MAXPLAYERS];
			
	int target_count = CommandHandler(
			client, args, "[SM] Usage: sm_sizeplayer <#userid|name> <scale>",
			2, target_list, MAXPLAYERS);
	
	if (target_count < 0)
	{
		return Plugin_Handled;
	}
	
	char s_scale[255];
	GetCmdArg(2, s_scale, sizeof(s_scale));
	float f_scale = StringToFloat(s_velocity);
	
	for (int i = 0; i < target_count; i++)
	{
		SetEntPropFloat(target_list[i], Prop_Send, "m_flModelScale", f_scale);
	}
	
	return Plugin_Handled;
}