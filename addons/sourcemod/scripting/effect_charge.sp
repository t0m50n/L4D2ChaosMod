#define ANIM_CHARGER_BOUNCE 76
#define CHARGE_INCAP_TIME 3.0

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
	
	for (int i = 0; i < target_count; i++)
	{
		Charge(target_list[i], f_velocity);
	}
	
	return Plugin_Handled;
}

void Charge(int target, float velocity)
{
	float tpos[3];
	float spos[3];
	
	float distance[3];
	float ratio[3];
	float addVel[3];
	
	GetClientAbsOrigin(target, tpos);
	
	// Throw in random direction
	spos[0] = tpos[0] + GetRandomFloat(-1.0, 1.0);
	spos[1] = tpos[1] + GetRandomFloat(-1.0, 1.0);
	spos[2] = tpos[2] + GetRandomFloat(-1.0, 1.0);
	
	distance[0] = (spos[0] - tpos[0]);
	distance[1] = (spos[1] - tpos[1]);
	distance[2] = (spos[2] - tpos[2]);

	ratio[0] =  distance[0] / SquareRoot(distance[1]*distance[1] + distance[0]*distance[0]); // Ratio x/hypo
	ratio[1] =  distance[1] / SquareRoot(distance[1]*distance[1] + distance[0]*distance[0]); // Ratio y/hypo
	
	addVel[0] = ratio[0] * -1 * velocity;
	addVel[1] = ratio[1] * -1 * velocity;
	addVel[2] = velocity;
	SDKCall(g_sdk_push_player, target, addVel, ANIM_CHARGER_BOUNCE, target, CHARGE_INCAP_TIME);
}