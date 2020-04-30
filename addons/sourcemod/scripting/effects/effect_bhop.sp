public void Effect_Bhop_OnPlayerRunCmd(int client, int& buttons)
{
	if (g_bhop.BoolValue &&
		IsPlayerAlive(client) &&
		(buttons & IN_JUMP) &&
		!(GetEntityFlags(client) & FL_ONGROUND) &&
		!(GetEntityMoveType(client) & MOVETYPE_LADDER) &&
		GetEntProp(client, Prop_Data, "m_nWaterLevel") < 2)
	{
		buttons &= ~IN_JUMP;
	}
}