public Action Command_Cheat(int client, int args)
{
	if(args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_cheat <command>");
		return Plugin_Handled;
	}
	
	char command[255];
	GetCmdArg(1, command, sizeof(command));
	
	int flags = GetCommandFlags(command);
	if (flags == INVALID_FCVAR_FLAGS)
	{
		ReplyToCommand(client, "Cheat command not found");
	}
	SetCommandFlags(command, flags & ~FCVAR_CHEAT);
	FakeClientCommand(client, command);
	SetCommandFlags(command, flags);

	LogMessage("Cheat command %s activated", command);
	
	return Plugin_Handled;
}