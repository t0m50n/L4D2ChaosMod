public Action Command_Cheat(int client, int args)
{
	if(args < 2)
	{
		ReplyToCommand(client, "[SM] Usage: chaosmod_cheat <target> <command> [args]");
		return Plugin_Handled;
	}

	char target_string[255];
	int len = GetCmdArg(1, target_string, sizeof(target_string));
	int target_list[MAXPLAYERS];
	char target_name[MAX_TARGET_LENGTH];
	bool tn_is_ml;

	// Putting 0 as target string overrides default behaviour
	// and executes the cheat as a non-specific client
	bool server = (len == 1 && target_string[0] == '0');

	int target_count = ProcessTargetString(
			server ? "@all" : target_string,
			client,
			target_list,
			server ? 1 : MAXPLAYERS,
			server ? 0 : COMMAND_FILTER_ALIVE,
			target_name,
			sizeof(target_name),
			tn_is_ml);
	
	if (target_count < 1)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}

	// Get the full cheat command including args
	// eg "give pain_pills" or "z_add 1 2 3"
	char full_command[512];
	GetCmdArgString(full_command, sizeof(full_command));
	int cheat_start = FindCharInString(full_command, ' ') + 1;

	// Get flags for cheat command
	char command[128];
	GetCmdArg(2, command, sizeof(command));
	int flags = GetCommandFlags(command);
	if (flags == INVALID_FCVAR_FLAGS)
	{
		ReplyToCommand(client, "Cheat command not found");
		return Plugin_Handled;
	}

	// Execute the cheat command
	SetCommandFlags(command, flags & ~FCVAR_CHEAT);
	for (int i = 0; i < target_count; i++)
	{
		FakeClientCommand(target_list[i], full_command[cheat_start]);
	}
	SetCommandFlags(command, flags);
	
	return Plugin_Handled;
}