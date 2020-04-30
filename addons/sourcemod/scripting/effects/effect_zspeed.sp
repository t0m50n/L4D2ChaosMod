public Action Command_ZSpeed(int client, int args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: chaosmod_zspeed <speed>");
		return Plugin_Handled;
	}
	char s_speed[255];
	GetCmdArg(1, s_speed, sizeof(s_speed));
	float f_speed = StringToFloat(s_speed);
	
	ZSpeed(f_speed);

	return Plugin_Handled;
}

void ZSpeed(float speed)
{
	ConVar cvar = FindConVar("z_speed");
	cvar.SetFloat(speed);

	ArrayList entities = new ArrayList();

	int entity = -1;
	do
	{
		entity = FindEntityByClassname(entity, "infected");
		if (entity > 0)
		{
			entities.Push(entity);
		}
	} while (entity > 0);

	for (int i = 0; i < entities.Length; i++)
	{
		entity = entities.Get(i);

		float position[3];
		float rotation[3];
		char model[255];
		GetEntPropVector(entity, Prop_Send, "m_vecOrigin", position);
		GetEntPropVector(entity, Prop_Send, "m_angRotation", rotation);
		GetEntPropString(entity, Prop_Data, "m_ModelName", model, sizeof(model));
		RemoveEntity(entity);

		entity = CreateEntityByName("infected");
		SetEntPropFloat(entity, Prop_Data, "m_flSpeed", speed);
		SetEntityModel(entity, model);
		DispatchSpawn(entity);
		ActivateEntity(entity);
		TeleportEntity(entity, position, rotation, NULL_VECTOR);
	}
	delete entities;
}