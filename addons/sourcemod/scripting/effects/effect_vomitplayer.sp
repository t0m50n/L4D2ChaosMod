#define ANIM_CHARGER_BOUNCE 76
#define CHARGE_INCAP_TIME 3.0

public Action Command_VomitPlayer(int client, int args)
{
	int target_list[MAXPLAYERS];
			
	int target_count = CommandHandler(
			client, args, "[SM] Usage: sm_vomitplayer <#userid|name>",
			1, target_list, MAXPLAYERS);
	
	if (target_count < 0)
	{
		return Plugin_Handled;
	}
	
	for (int i = 0; i < target_count; i++)
	{
		VomitPlayer(target_list[i]);
	}
	
	return Plugin_Handled;
}

void VomitPlayer(int target)
{
	if (!IsClientInGame(target) || !IsPlayerAlive(target))
	{
		return;
	}

	Handle sdk_call = INVALID_HANDLE;
	
	switch (GetClientTeam(target))
	{
		case 2:
		{
			sdk_call = g_sdk_vomit_survivor;
		}
		case 3:
		{
			sdk_call = g_sdk_vomit_infected;
		}
		default:
		{
			return;
		}
	}
	
	SDKCall(sdk_call, target, target, true);
}