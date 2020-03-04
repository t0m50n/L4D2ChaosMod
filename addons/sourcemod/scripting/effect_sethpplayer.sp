public Action Command_SetHpPlayer(int client, int args)
{
	int target_list[MAXPLAYERS];
			
	int target_count = CommandHandler(
			client, args, "[SM] Usage: sm_sethpplayer <#userid|name> [amount]",
			2, target_list, MAXPLAYERS);
	
	if (target_count < 0)
	{
		return Plugin_Handled;
	}
	
	char s_health[255];
	int health;
	GetCmdArg(2, s_health, sizeof(s_health));
	health = StringToInt(s_health);
	
	for (int i = 0; i < target_count; i++)
	{
		SetEntityHealth(target_list[i], health);
	}
	
	return Plugin_Handled;
}