public Action Command_CvarSilent(int client, int args)
{
	if(args < 2)
	{
		ReplyToCommand(client, "[SM] Usage: chaosmod_cvar <cvar> <value>");
		return Plugin_Handled;
	}
	
	char s_cvar[255];
	GetCmdArg(1, s_cvar, sizeof(s_cvar));
	ConVar cvar = FindConVar(s_cvar);
	if (cvar == null)
	{
		ReplyToCommand(client, "[SM] Cvar not found");
	}
	
	char value[255];
	GetCmdArg(2, value, sizeof(value));

	SetConVarString(cvar, value);

	char client_name[255];
	GetClientName(client, client_name, sizeof(client_name));
	LogMessage("\"%s\" changed cvar (cvar \"%s\") (value \"%s\")", client_name, s_cvar, value);
	
	return Plugin_Handled;
}