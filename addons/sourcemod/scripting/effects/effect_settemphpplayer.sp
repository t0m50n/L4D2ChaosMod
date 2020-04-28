public Action Command_SetTempHpPlayer(int client, int args)
{
	int target_list[MAXPLAYERS];
			
	int target_count = CommandHandler(
			client, args, "[SM] Usage: chaosmod_settemphpplayer <#userid|name> <amount>",
			2, target_list, MAXPLAYERS);
	
	if (target_count < 0)
	{
		return Plugin_Handled;
	}
	
	char s_health[255];
	float health;
	GetCmdArg(2, s_health, sizeof(s_health));
	health = StringToFloat(s_health);
	
	for (int i = 0; i < target_count; i++)
	{
		SetTempHpPlayer(target_list[i], health);
	}
	
	return Plugin_Handled;
}

void SetTempHpPlayer(int target, float health)
{
	if (!IsClientInGame(target) || !IsPlayerAlive(target))
	{
		return;
	}
	SDKCall(g_sdk_set_temp_hp, target, health);
}